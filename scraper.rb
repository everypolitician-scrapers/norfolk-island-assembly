#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'

require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

class String
  def tidy
    self.gsub(/[[:space:]]+/, ' ').strip
  end
end

def noko_for(url)
  Nokogiri::HTML(open(url).read)
  # Nokogiri::HTML(open(url).read, nil, 'utf-8')
end

def scrape_list(url)
  noko = noko_for(url)
  noko.xpath('//h3[contains(.,"Administrative Arrangements")]/following-sibling::table[1]/tr[2]/td').each do |td|
    data = { 
      name: td.text,
      party: "Independent",
      term: 14,
      source: url,
    }
    ScraperWiki.save_sqlite([:name, :term], data)
  end
end

scrape_list('http://www.norfolkisland.gov.nf/legislativeassembly/legislativeassembly.html')
