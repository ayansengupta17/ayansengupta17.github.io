/**
 * ayansengupta.dev edge worker.
 *
 * - Serves the Jekyll build in _site/ as static assets.
 * - Content negotiation: `Accept: text/markdown` returns the Markdown twin that
 *   _plugins/markdown_for_agents.rb writes next to each page (index.html -> index.md).
 * - Advertises the Markdown twin with a `Link: <...>; rel="alternate"` header on HTML.
 * - Adds Content-Signal and security headers to every response.
 * - Long cache lifetimes for static assets; HTML and Markdown always revalidate.
 * - Redirects www to the apex.
 */

const CONTENT_SIGNAL = "search=yes, ai-input=yes, ai-train=no";
const APEX = "ayansengupta.dev";
const STATIC_ASSET = /\.(png|jpe?g|gif|svg|webp|avif|ico|pdf|mp4|webm|woff2?|ttf|otf)$/i;
const CODE_ASSET = /\.(css|js|mjs)$/i; // not fingerprinted, so keep these short
const ASSET_CACHE = "public, max-age=604800, stale-while-revalidate=86400";
const CODE_CACHE = "public, max-age=3600, stale-while-revalidate=600";
const PAGE_CACHE = "public, max-age=0, must-revalidate";

/** Parse an Accept header into [{type, q}] */
function parseAccept(accept) {
  return accept
    .split(",")
    .map((part) => {
      const [type, ...params] = part.trim().split(";");
      let q = 1;
      for (const p of params) {
        const [k, v] = p.trim().split("=");
        if (k === "q") q = parseFloat(v);
      }
      return { type: type.trim().toLowerCase(), q: Number.isFinite(q) ? q : 0 };
    })
    .filter((e) => e.type);
}

/** Follow the Cloudflare "Markdown for Agents" negotiation rules. */
function prefersMarkdown(accept) {
  if (!accept) return false;
  const entries = parseAccept(accept);
  const q = (type) => entries.find((e) => e.type === type)?.q;
  const qMd = q("text/markdown") ?? q("text/*") ?? 0;
  const qHtml = q("text/html") ?? q("text/*") ?? q("*/*") ?? 0;
  const explicit = entries.some((e) => e.type === "text/markdown" || e.type === "text/*");
  return explicit && qMd > 0 && qMd >= qHtml;
}

function markdownPath(pathname) {
  if (pathname.endsWith("/")) return pathname + "index.md";
  if (pathname.endsWith(".html")) return pathname.replace(/\.html$/, ".md");
  if (pathname.endsWith(".md")) return pathname;
  if (/\.[a-z0-9]+$/i.test(pathname)) return null; // other files: no markdown twin
  return pathname + "/index.md";
}

function withHeaders(res, extra = {}) {
  const out = new Response(res.body, res);
  const h = out.headers;
  h.set("Content-Signal", CONTENT_SIGNAL);
  h.set("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload");
  h.set("X-Content-Type-Options", "nosniff");
  h.set("X-Frame-Options", "SAMEORIGIN");
  h.set("Referrer-Policy", "strict-origin-when-cross-origin");
  h.set("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
  for (const [k, v] of Object.entries(extra)) h.set(k, v);
  return out;
}

function appendVary(headers, value) {
  const cur = headers.get("Vary");
  if (!cur) return headers.set("Vary", value);
  if (!cur.toLowerCase().split(",").map((s) => s.trim()).includes(value.toLowerCase())) {
    headers.set("Vary", `${cur}, ${value}`);
  }
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.hostname === `www.${APEX}`) {
      url.hostname = APEX;
      return Response.redirect(url.toString(), 301);
    }

    const method = request.method;
    if (method === "GET" || method === "HEAD") {
      const accept = request.headers.get("Accept") || "";
      const mdPath = prefersMarkdown(accept) ? markdownPath(url.pathname) : null;
      if (mdPath) {
        const mdUrl = new URL(mdPath, url);
        const mdRes = await env.ASSETS.fetch(new Request(mdUrl.toString(), { method, headers: request.headers }));
        if (mdRes.ok) {
          const out = withHeaders(mdRes, {
            "Content-Type": "text/markdown; charset=utf-8",
            "Cache-Control": PAGE_CACHE,
            Link: `<${url.origin}${url.pathname}>; rel="canonical"; type="text/html"`,
          });
          appendVary(out.headers, "Accept");
          return out;
        }
      }
    }

    const res = await env.ASSETS.fetch(request);
    const out = withHeaders(res);
    const ct = out.headers.get("Content-Type") || "";
    const path = url.pathname;

    if (ct.includes("text/html")) {
      appendVary(out.headers, "Accept");
      out.headers.set("Cache-Control", PAGE_CACHE);
      const mdPath = res.ok ? markdownPath(path) : null;
      if (mdPath) out.headers.set("Link", `<${url.origin}${mdPath}>; rel="alternate"; type="text/markdown"`);
    } else if (path.endsWith(".md")) {
      out.headers.set("Content-Type", "text/markdown; charset=utf-8");
      out.headers.set("Cache-Control", PAGE_CACHE);
    } else if (res.ok && CODE_ASSET.test(path)) {
      out.headers.set("Cache-Control", CODE_CACHE);
    } else if (res.ok && STATIC_ASSET.test(path)) {
      out.headers.set("Cache-Control", ASSET_CACHE);
    }
    return out;
  },
};
