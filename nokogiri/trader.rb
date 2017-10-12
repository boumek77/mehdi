require 'rubygems'
require 'nokogiri'
require 'open-uri'

COIN_MARKET_URL = "https://coinmarketcap.com/all/views/all/"

def get_rate(url)
	rates = Hash.new()
	page = Nokogiri::HTML(open(url))
	currency = page.xpath('//td[2]/a')
	rate = page.xpath('//td[5]/a[@class="price"]')
	for i in 0...currency.length do
		rates[currency[i].text] = rate[i].text
	end
	rates.each do |x, y|
		puts "#{x}: #{y}"
	end
end

get_rate(COIN_MARKET_URL)