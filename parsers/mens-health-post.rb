# encoding: UTF-8
head = 
"<head>
   
</head>"

def title(t)
	"#{2017}-#{Time.now.month}-#{Time.now.day}-#{t.gsub(' ', '-')}"
end

def frontmatter(t)
	"---\nlayout: medium_post\ntitle:  #{t}\ndate:   2017-08-25\ncategories: fitness workouts menshealth\npermalink: #{t.gsub(' ', '-')}\nauthor: jonmackie\n---"
end

data = nil
File.open("./mens-health.json","r") do |f|
	data = eval f.read
end

data[:data].each do |d|
	puts d
	file_name = title(d[:heading])
	pre = frontmatter(d[:heading]).strip
	a = "<i>This article was originally posted at</i> <a href='#{d[:original_link]}'>menshealth.com</a><br><br>\n"
	b = "<p>#{d[:content]}</p>\n"
	c = "<img class='img-fluid' src='#{d[:image]}''>"
	File.open("/Users/devonjon/Code/devonjon.github.io/_posts/#{file_name}.html", 'w') do |f|
		f.puts pre + "\n" + a + b + c
	end
end