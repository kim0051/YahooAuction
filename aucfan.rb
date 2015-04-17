# encoding: UTF-8
require 'anemone'
require 'nokogiri'
require 'open-uri'
require 'json'

count = 0


def analyze(url, count, start_time, out)

  #html = open(url)
  #charset = nil
  #html = open(url) do |f|
  #  charset = f.charset
  #  f.read
  #end
  #doc = Nokogiri::HTML(html)
  #doc = Nokogiri::HTML.parse(html, nil, charset)
  doc = Nokogiri::HTML.parse(open(url, "r:euc-jp").read.encode("utf-8",  :invalid => :replace, :undef => :replace, :replace => "?"))



 #====== Extract Data Start ======

  #Variable
  items = Array.new
  nowPrices = Array.new
  sokketuPrices = Array.new
  bids = Array.new
  remains = Array.new
  categories = Array.new
  owners = Array.new

  #Get Item Name
  #doc.css('a').each do |item|
  doc.xpath('//a[@class="item_title"]').each do |item|
    #if /item_title/ =~ item[:class] then
      puts item.text.gsub(/(\s)/,"")
      items.push(item.text.gsub(/(\s)/,""))
    #end
  end


  #Get Now Price
  doc.css('a').each do |item|
    if /item_price/ =~ item[:class] then
      #puts item.text[0..item.text.index("円")]
      nowPrices.push(item.text[0..item.text.index("円")])
    end
  end



  #Get Nyusatu
  doc.css('td').each do |item|
    if /results-bid/ =~ item[:class] then
      #puts item.text
      bids.push(item.text)
    end
  end


  #Get End Date
  doc.css('td').each do |item|
    if /results-limit/ =~ item[:class] then
      #puts item.text.gsub(/(\s)/,"")
      remains.push(item.text.gsub(/(\s)/,""))
    end
  end


 #====== Extract Data End ======

  #Output Data
  i = 0
  items.each do |item|

    out.puts(item + "," + nowPrices[i].to_s.sub(",", "") + "," + bids[i].to_s + "," + remains[i].to_s )
    i += 1
  end


  #Get Next Link
  #doc.css('span').each do |item|
  doc.xpath('//span[@class="next"]/a').each do |item|

#   if /next/ =~ item[:class] then
puts item

      #suburl = item[0].child[:href]
      suburl = item[:href]
      puts suburl

      count = count + 1
      puts  count
      
      
      analyze(suburl, count, start_time, out)

#    else
#    end
  end
  end_time = Time.now
  puts "Processing Time: " + (end_time - start_time).to_s + " Second"
  return
end#EndofFunction

base_url = "http://aucfan.com/search1/s-ya/c-ya_2084050403/?vmode=1&sellertype=i"


p "===start==="
start_time = Time.now
p start_time
# PUSH DATA
File.open(start_time.strftime('%Y%m%d%H%M%S').to_s + '_aucfan.csv', 'w') do |out|
  out.puts("商品名,落札価格,入札数,終了日時")
  analyze(base_url, count, start_time, out)
end
p "=== end ==="
