# frozen_string_literal: true
#
# Writes a Markdown twin next to every rendered HTML page (index.html -> index.md),
# plus /llms.txt (an index of the site) and /llms-full.txt (every page's Markdown
# in one file) for agents that look for those before crawling.
#
# The Cloudflare Worker in worker/index.js serves the twins when a client sends
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

  Entry = Struct.new(:title, :url, :description, :markdown, :collection)

  def self.clean(text)
    text.to_s.gsub(/<[^>]+>/, "").gsub(/\s+/, " ").strip
  end

  def self.entry_for(site, doc)
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
    body = ReverseMarkdown.convert(main.inner_html, unknown_tags: :bypass, github_flavored: true)
    body = body.gsub(/\n{3,}/, "\n\n").strip

    title = clean(doc.data["title"])
    title = site.config["title"].to_s if title.empty?
    url = "#{site.config["url"]}#{doc.url}"
    desc = clean(doc.data["description"])
    desc = clean(doc.data["excerpt"]) if desc.empty?

    front = +"---\n"
    front << "title: #{title.to_json}\n"
    front << "url: #{url}\n"
    front << "description: #{desc.to_json}\n" unless desc.empty?
    front << "author: #{site.config["author"]["name"].to_json}\n" if site.config["author"]
    front << "---\n\n"
    collection = doc.respond_to?(:collection) && doc.collection ? doc.collection.label : "pages"
    Entry.new(title, url, desc, front + body + "\n", collection)
  end

  def self.target_path(site, doc)
    dest = doc.destination(site.dest)
    return nil unless dest.end_with?(".html")
    dest.sub(/\.html\z/, ".md")
  end

  # /llms.txt: short index following the llmstxt.org layout
  def self.llms_index(site, entries)
    author = site.config["author"] || {}
    out = +"# #{site.config["title"]}\n\n"
    out << "> #{clean(site.config["description"])}\n\n" unless clean(site.config["description"]).empty?
    out << "Personal site of #{author["name"]}. Every page is also available as Markdown: " \
           "request it with `Accept: text/markdown` or append `index.md` to the page URL.\n"
    out << "Contact: #{author["email"]}\n" if author["email"]
    out << "\n"
    sections = entries.group_by(&:collection)
    order = ["pages"] + (sections.keys - ["pages"]).sort
    order.each do |label|
      next unless sections[label]
      heading = label == "pages" ? "Pages" : label.capitalize
      out << "## #{heading}\n\n"
      sections[label].each do |e|
        md_url = e.url.end_with?("/") ? "#{e.url}index.md" : e.url.sub(/\.html\z/, ".md")
        line = "- [#{e.title}](#{md_url})"
        line << ": #{e.description}" unless e.description.empty?
        out << line << "\n"
      end
      out << "\n"
    end
    out << "## Optional\n\n"
    out << "- [Sitemap](#{site.config["url"]}/sitemap.xml)\n"
    out << "- [Full content](#{site.config["url"]}/llms-full.txt): all pages in one Markdown file\n"
    out
  end

  def self.llms_full(site, entries)
    out = +"# #{site.config["title"]}\n\n"
    entries.each do |e|
      out << "\n\n---\n\n" << e.markdown
    end
    out
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  docs = site.pages + site.documents
  entries = []
  docs.each do |doc|
    next if doc.class.name.include?("RedirectPage") || doc.data["redirect_to"]
    next unless doc.output && doc.output_ext == ".html"
    next if doc.data["sitemap"] == false
    next if doc.url == "/404.html"
    path = MarkdownForAgents.target_path(site, doc)
    next unless path
    entry = MarkdownForAgents.entry_for(site, doc)
    next unless entry
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, entry.markdown)
    entries << entry
  end
  # Pages first in a sensible reading order (home, then shallow URLs), then collections by order/title
  entries.sort_by! { |e| [e.collection == "pages" ? 0 : 1, e.url.count("/"), e.url] }
  File.write(File.join(site.dest, "llms.txt"), MarkdownForAgents.llms_index(site, entries))
  File.write(File.join(site.dest, "llms-full.txt"), MarkdownForAgents.llms_full(site, entries))
  Jekyll.logger.info "Markdown for agents:", "#{entries.size} files written, plus llms.txt and llms-full.txt"
end
