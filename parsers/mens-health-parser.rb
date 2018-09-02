require 'nokogiri'
require 'net/http'
require 'mini_magick'

fitness = "https://www.menshealth.com/ajax/infiniteload/?id=141bd6a9-6a2f-4f06-90d8-b81b0768340f&class=CoreModels%5Csections%5CSectionModel&viewset=section&page=2&cachebuster=1fe28f77-0c81-46d4-9cb5-848037d21b4b"
def doc(n)
	Nokogiri::HTML(Net::HTTP.get(URI("https://www.menshealth.com/ajax/infiniteload/?id=f07c83cb-d962-4ab0-882e-98cd878698c8&class=CoreModels%5Csections%5CSectionModel&viewset=section&page=#{n}&cachebuster=0c161148-47bc-4b0f-9256-2d40c702a583")))
end

# puts doc(1)

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
		content: content,
		heading: heading,
		subheading: subheading,
		images: images
	}
	puts x
	break
# puts heading.to_s + subheading.to_s + content.inner_html.gsub(/\s{2,}/, "")
words = heading.inner_text
lines = words.split.each_slice(4).map {|e| e.join(" ")}

end
