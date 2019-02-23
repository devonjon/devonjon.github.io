# encoding: UTF-8
head = 
"<head>
   
</head>"

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

data = nil
File.open("/Users/devonjon/Code/devonjon.github.io/parsers/data/mens-health.json","r") do |f|
	data = eval f.read
end

data[:data].each do |d|
	file_name = title(d[:heading])
	pre = frontmatter(d[:heading], d[:original_link], d[:lede], d[:images][0]).strip
	a = "<i>This article was originally posted at</i> <a href='#{d[:original_link]}'>menshealth.com</a><br><br>\n"
	b = "<p>#{d[:content]}</p>\n"
	File.open("/Users/devonjon/Code/devonjon.github.io/_posts/#{file_name}.html", 'w') do |f|
		f.puts pre + "\n" + a + b
	end
end