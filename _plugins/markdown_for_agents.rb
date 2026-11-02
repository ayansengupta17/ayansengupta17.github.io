# frozen_string_literal: true
#
# Writes a Markdown twin next to every rendered HTML page (index.html -> index.md).
# The Cloudflare Worker in worker/index.js serves these when a client sends
# `Accept: text/markdown`, so agents get clean text instead of themed HTML.
#
# Runs after the whole site is written, so it sees the final HTML including layouts.

require "nokogiri"
require "reverse_markdown"

module MarkdownForAgents
  STRIP = [
    ".sidebar", ".page__share", ".pagination", ".page__meta", ".page__date",
    ".author__urls-wrapper", ".page__taxonomy", ".page__comments", ".masthead",
    ".page__footer", ".search-content", ".page__hero", "nav", "script", "style",
    "noscript", "button", ".page__hero-image", ".toc", ".breadcrumbs"
  ].freeze

  def self.markdown_for(site, doc)
    html = Nokogiri::HTML(doc.output)
    main = html.at_css("#main") || html.at_css("main") || html.at_css("body")
    return nil unless main

    main.css(STRIP.join(", ")).each(&:remove)
    # Absolute URLs so the Markdown stands alone outside the site
    base = site.config["url"].to_s
    main.css("a[href^='/'], img[src^='/']").each do |el|
      attr = el.name == "a" ? "href" : "src"
      el[attr] = base + el[attr] unless el[attr].start_with?("//")
    end
    # Drop the inline <br>/<img> that older project titles carried, keep the rest
    body = ReverseMarkdown.convert(main.inner_html, unknown_tags: :bypass, github_flavored: true)
    body = body.gsub(/\n{3,}/, "\n\n").strip

    title = doc.data["title"].to_s.gsub(/<[^>]+>/, "").strip
    title = site.config["title"].to_s if title.empty?
    url = "#{site.config["url"]}#{doc.url}"
    desc = doc.data["excerpt"].to_s.gsub(/<[^>]+>/, "").strip
    desc = doc.data["description"].to_s if desc.empty?

    front = +"---\n"
    front << "title: #{title.to_json}\n"
    front << "url: #{url}\n"
    front << "description: #{desc.to_json}\n" unless desc.empty?
    front << "author: #{site.config["author"]["name"].to_json}\n" if site.config["author"]
    front << "---\n\n"
    front + body + "\n"
  end

  def self.target_path(site, doc)
    dest = doc.destination(site.dest)
    return nil unless dest.end_with?(".html")
    dest.sub(/\.html\z/, ".md")
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  docs = site.pages + site.documents
  written = 0
  docs.each do |doc|
    next if doc.class.name.include?("RedirectPage") || doc.data["redirect_to"]
    next unless doc.output && doc.output_ext == ".html"
    next if doc.data["sitemap"] == false
    path = MarkdownForAgents.target_path(site, doc)
    next unless path
    md = MarkdownForAgents.markdown_for(site, doc)
    next unless md
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, md)
    written += 1
  end
  Jekyll.logger.info "Markdown for agents:", "#{written} files written"
end
