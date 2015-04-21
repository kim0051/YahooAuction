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

    out.puts(item.sub(",", "").encode("cp932",  :invalid => :replace, :undef => :replace, :replace => "?") + "," + nowPrices[i].to_s.sub(",", "").encode("cp932",  :invalid => :replace, :undef => :replace, :replace => "?") + "," + bids[i].to_s.encode("cp932",  :invalid => :replace, :undef => :replace, :replace => "?") + "," + remains[i].to_s.encode("cp932",  :invalid => :replace, :undef => :replace, :replace => "?") + "," + url )
    i += 1
  end


  #Get Next Link
  #doc.css('span').each do |item|
  #doc.xpath('//span[@class="next"]/a').each do |item|
  item = doc.xpath('//span[@class="next"]/a')

  if item.length == 2 then

    #puts item[0]

    suburl = item[0][:href]
    puts "Next  " + suburl

    count = count + 1
    puts  count

    analyze(suburl, count, start_time, out)
  else
    end_time = Time.now
    puts "Processing Time: " + (end_time - start_time).to_s + " Second"
    return
  end

end#EndofFunction


#base_url = "http://aucfan.com/search1/s-ya/c-ya_2084050403/?vmode=1&sellertype=i"

#条件 一般
urls  = Array.new
names = Array.new
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084055697/?vmode=1&sellertype=i")#非常食
#names.push("非常食")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_24034/?vmode=1&sellertype=i")#卵、乳製品
#names.push("卵、乳製品")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_24042/?vmode=1&sellertype=i")#調味料、スパイス
#names.push("調味料、スパイス")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084006748/?vmode=1&sellertype=i")#米、穀類、シリアル
#names.push("米、穀類、シリアル")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_24054/?vmode=1&sellertype=i")#健康食品
#names.push("健康食品")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084006750/?vmode=1&sellertype=i")#パスタ、麺類
#names.push("パスタ、麺類")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084006751/?vmode=1&sellertype=i")#野菜、果物
#names.push("野菜、果物")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084042479/?vmode=1&sellertype=i")#加工食品
#names.push("加工食品")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084008374/?vmode=1&sellertype=i")#ミルク、ベビーフード
#names.push("ミルク、ベビーフード")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084049724/?vmode=1&sellertype=i")#パン
#names.push("パン")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_2084006888/?vmode=1&sellertype=i")#ダイエット食品
#names.push("ダイエット食品")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_23982/?vmode=1&sellertype=i")#菓子、デザート
#names.push("菓子、デザート")
#urls.push("http://aucfan.com/search1/s-ya/c-ya_42164/?vmode=1&sellertype=i")#飲料
#names.push("飲料")
urls.push("http://aucfan.com/search1/q-~bfa9c9ca/s-ya/c-24/t-201503/?o=t1")#
names.push("３月")
urls.push("http://aucfan.com/search1/q-~bfa9c9ca/s-ya/c-24/t-201502/?o=t1")#
names.push("２月")
urls.push("http://aucfan.com/search1/q-~bfa9c9ca/s-ya/c-24/t-201501/?o=t1")#
names.push("１月")

#urls.push("")#
#names.push("")


p "===start==="
start_time = Time.now
p start_time
# PUSH DATA
j = 0
urls.each do |base_url|
	File.open(start_time.strftime('%Y%m%d%H%M%S').to_s + '_' + names[j] + '_aucfan.csv', 'w', encoding: 'cp932') do |out|
	  out.puts("商品名,落札価格,入札数,終了日時,URL")
	  analyze(base_url, count, start_time, out)
	  j += 1
	end
end
p "=== end ==="
