head = 
"<head>
   
</head>"

def title(t)
	"#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{t.gsub(' ', '-')}"
end

def frontmatter(t)
	"---\nlayout: medium_post\ntitle:  #{t}\ndate:   2018-08-25\ncategories: fitness workouts infographic darebee\npermalink: #{t.gsub(' ', '-')}\nauthor: jonmackie\n---"
end

data = nil
File.open("./darebee.json","r") do |f|
	data = eval f.read
end

data[:data].each do |d|
	file_name = title(d[:name])
	pre = frontmatter(d[:name]).strip
	a = "<i>This article was originally posted at</i> <a href='#{d[:original_link]}'>darebee.com</a><br><br>\n"
	b = "<p>#{d[:text]}</p>\n"
	c = "<img class='img-fluid' src='#{d[:image]}''>"
	File.open("/Users/devonjon/Code/devonjon.github.io/_posts/#{file_name}.html", 'w') do |f|
		f.puts pre + "\n" + a + b + c
	end
end