require 'nokogiri'
require 'net/http'
require 'mini_magick'

fitness = "https://www.menshealth.com/ajax/infiniteload/?id=141bd6a9-6a2f-4f06-90d8-b81b0768340f&class=CoreModels%5Csections%5CSectionModel&viewset=section&page=2&cachebuster=1fe28f77-0c81-46d4-9cb5-848037d21b4b"
def doc(n)
	Nokogiri::HTML(Net::HTTP.get(URI("https://www.menshealth.com/ajax/infiniteload/?id=f07c83cb-d962-4ab0-882e-98cd878698c8&class=CoreModels%5Csections%5CSectionModel&viewset=section&page=#{n}&cachebuster=0c161148-47bc-4b0f-9256-2d40c702a583"))).css('a.full-item-title.item-title')
end

# puts doc(1)
all_data = []
# article      = Nokogiri::HTML(Net::HTTP.get(URI("https://www.menshealth.com/nutrition/a19530409/ketogenic-ketosis-diet-for-beginners/")))
doc(1).css('a').each do |a|
	link = "https://www.menshealth.com#{a['href']}"
	article = Nokogiri::HTML(Net::HTTP.get(URI(link)))
	heading      = article.css("h1.content-hed.standard-hed").inner_text
	subheading   = article.css(".content-header.standard-header p").inner_text

	removed 	 = article.css(".content-info.standard-info").remove
	removed 	+= article.css(".embed-poll").remove
	removed 	+= article.css(".image-credit").remove
	removed 	+= article.css(".breaker-ad.article-breaker-ad.standard-article-breaker-ad.mobile-breaker-ad").remove

	content 	 = article.css("div.standard-body")

	images 		 = []

	content.css("img").each do |img|
		if img['data-src']
			uri = img['data-src'].split('?').first
		else
			uri = img['data-src']
		end
		images << uri
		img.set_attribute("src", uri)
		img.set_attribute("class", "img-fluid")
	end
	content.css(".embed-image-wrap.aspect-ratio-original").each do |div|
		div.set_attribute("style", "padding-bottom:1em; padding-top:1em")
		div.set_attribute("class", "")
	end
	content.css(".content-lede-image-wrap.aspect-ratio-freeform").each do |div|
		div.set_attribute("style", "padding-bottom:1em; padding-top:1em")
		div.set_attribute("class", "")
	end
	x = {
		original_link: link,
		content: content.inner_html.strip,
		lede: subheading,
		heading: heading,
		subheading: subheading,
		images: images
	}
	all_data << x
# puts heading.to_s + subheading.to_s + content.inner_html.gsub(/\s{2,}/, "")
# words = heading.inner_text
# lines = words.split.each_slice(4).map {|e| e.join(" ")}

end

# File.open("/Users/devonjon/Code/devonjon.github.io/parsers/data/mens-health.json","w") do |f|
#   f.write({data: all_data}.to_json)
# end

def title(t)
	"#{2017}-#{Time.now.month}-#{Time.now.day}-#{t.gsub(' ', '-')}"
end

def frontmatter(title, original_link, lede, image)
	split = original_link.split('.com/').last.split('/')
	cat = split.first
	link = split.join('-')
	"---" +
	"\nlayout: medium_post" + 
	"\ntitle:  #{title}" +
	"\ndate:   2017-08-25" +
	"\ncategories: #{cat} menshealth" +
	"\npermalink: #{link}" +
	"\nauthor: jack\n" +
	"\nlede: #{lede}" +
	"\nimage: #{image}" +
	"\n---"
end

# data = nil
# File.open("/Users/devonjon/Code/devonjon.github.io/parsers/data/mens-health.json","r") do |f|
# 	data = eval f.read
# end

all_data.each do |d|
	file_name = title(d[:heading])
	pre = frontmatter(d[:heading], d[:original_link], d[:lede], d[:images][0]).strip
	a = "<i>This article was originally posted at</i> <a href='#{d[:original_link]}'>menshealth.com</a><br><br>\n"
	b = "<p>#{d[:content]}</p>\n"
	File.open("/Users/devonjon/Code/devonjon.github.io/_posts/#{file_name}.html", 'w') do |f|
		f.puts pre + "\n" + a + b
	end
end
