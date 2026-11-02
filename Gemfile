source "https://rubygems.org"

# The site is built in GitHub Actions and deployed to Cloudflare Workers
# (see .github/workflows/deploy.yml), so it no longer needs the github-pages gem.
gem "jekyll", "~> 4.4"

group :jekyll_plugins do
  gem "jekyll-remote-theme"
  gem "jekyll-include-cache"
  gem "jekyll-sitemap"
  gem "jekyll-feed"
  gem "jekyll-redirect-from"
  gem "jekyll-paginate"
  gem "jekyll-gist"
  gem "jemoji"
end

gem "kramdown-parser-gfm"
gem "webrick"

# Build-time HTML -> Markdown for the agent-facing text/markdown variants (see _plugins/markdown_for_agents.rb)
gem "reverse_markdown", "~> 3.0"
