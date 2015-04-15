# encoding: UTF-8
require 'anemone'
require 'nokogiri'
require 'open-uri'
require 'json'

urls = [
  "http://auctions.search.yahoo.co.jp/search?ei=UTF-8&p=%E6%9C%AA%E9%96%8B%E5%B0%81&oq=&slider=0&n=100&tab_ex=commerce&auccat=23976"
]


Anemone.crawl(
  urls, :depth_limit => 20 ) do |anemone|

	anemone.focus_crawl do |page|
	  page.links.keep_if { |link|
	    link.to_s.match(
            /ei=UTF-8%26b=/
          )
	}
	end

	anemone.on_every_page do |page|
	  puts page.url
	end

end
