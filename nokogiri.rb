# encoding: UTF-8
require 'anemone'
require 'nokogiri'
require 'open-uri'
require 'json'

count = 0


def analyze(url, count, start_time, out)

  html = open(url)
  doc = Nokogiri::HTML(html)


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
  doc.css('h3').each do |item|
    #puts item.child.text
    items.push(item.child.text)
  end


  #Get Now Price
  doc.css('td').each do |item|
    if /pr1/ =~ item[:class] then
      #puts item.text[0..item.text.index("円")]
      nowPrices.push(item.text[0..item.text.index("円")])
    end
  end


  #Get Sokketu Price
  doc.css('td').each do |item|
    if /pr2/ =~ item[:class] then
      #puts item.child.text
      sokketuPrices.push(item.child.text)
    end
  end


  #Get Nyusatu
  doc.css('td').each do |item|
    if /bi/ =~ item[:class] then
      #puts item.child.text
      bids.push(item.child.text)
    end
  end


  #Get Remain
  doc.css('td').each do |item|
    if /ti/ =~ item[:class] then
      #puts item.child.text
      remains.push(item.child.text)
    end
  end


  #Get Category
  doc.css('p').each do |item|
    if /com_slider/ =~ item[:class] then
      #puts item.text
      categories.push(item.text)
    end
  end


  #Get Owner
  doc.css('a').each do |item|
    if /sellinglist.auctions.yahoo.co.jp\/user/ =~ item[:href] then
      #puts item.text
      owners.push(item.text)
    end
  end

 #====== Extract Data End ======

  #Output Data
  i = 0
  items.each do |item|
    out.puts(item + "," + nowPrices[i].to_s.sub(",", "") + "," + bids[i].to_s + "," + remains[i].to_s + "," + owners[i].to_s)# + "," + categories[i].to_s.sub(" ", "").chomp)
    i += 1
  end


  #Get Next Link
  doc.css('p').each do |item|

    if /non next/ =~ item[:class] then
      end_time = Time.now
      puts "Processing Time: " + (end_time - start_time).to_s + " Second"
      return

    elsif /next/ =~ item[:class] then

      suburl = item.child[:href]
      puts suburl

      count = count + 1
      puts  count
      
      
      analyze(suburl, count, start_time, out)
    end
  end
end

base_url = "http://auctions.search.yahoo.co.jp/search?ei=UTF-8&p=%E6%9C%AA%E9%96%8B%E5%B0%81&oq=&slider=0&n=100&tab_ex=commerce&auccat=23976"

p "===start==="
start_time = Time.now
p start_time
# PUSH DATA
File.open(start_time.strftime('%Y%m%d%H%M%S').to_s + '_Yahoo_auctions.csv', 'w') do |out|
  analyze(base_url, count, start_time, out)
end
p "=== end ==="
