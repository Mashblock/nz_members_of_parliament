# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'
#
agent = Mechanize.new
#
# # Read in a page
page = agent.get("http://parliament.govt.nz/en-nz/mpp/mps/current?Criteria.ViewAll=1")
links = page.links_with(href: /\/en-nz\/mpp\/mps\/current\/51MP/)
links.each do |link|
  mp_page = link.click
  seat, party = mp_page.at('div.copy h2').text.split(',').map(&:strip)
  email = mp_page.links_with(href:/mailto\:/).first.href.gsub('mailto:', '') rescue ''
  twitter = mp_page.links_with(href:/twitter.com/).first.href rescue ''
  facebook = mp_page.links_with(href:/facebook.com/).first.href rescue ''

  details = {
    name: mp_page.at('div.copy h1').text,
    seat: seat,
    party: party,
    email: email,
    twitter: twitter,
    facebook: facebook
  }

  ScraperWiki.save_sqlite([:name], details)
end

#
# # Find somehing on the page using css selectors
# p page.at('div.content')
#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
