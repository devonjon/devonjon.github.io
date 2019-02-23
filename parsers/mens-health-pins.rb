require 'net/http'
require 'nokogiri'
require 'tempfile'
require 'mini_magick'
require 'pinterest-api'

ACCESS_TOKEN = 'AojyYd6HfeGAtpgxWQPWQrBgDO1iFU4n8H4-0-lFL8JF6-Aw4AmvgDAAAZo1RS_Eq4PgMMkAAAAA'

@client = Pinterest::Client.new(ACCESS_TOKEN)

data = nil

File.open("./mens-health.json","r") do |f|
	data = eval f.read
end
start = Time.now
data[:data].each_with_index do |d, i|
	# while Time.now-start < 3600
	# end
	puts d
	d[:images].each_with_index do |img, n|
		a =  Net::HTTP.get(URI(img))
		File.open("./_temp_data/img.jpg", "w") do |f|
			f.write(a)
		end
		image = MiniMagick::Image.open("./_temp_data/img.jpg")
		new_width = image.height/3*2
		new_height = new_width/2*3
		width = image.width
		trim = (width-new_width)/2
		words = d[:heading]
		`convert ./_temp_data/img.jpg -gravity East -crop #{image.width}x#{image.height}+#{trim}-0 ./_temp_data/img-out.jpg`
		`convert ./_temp_data/img-out.jpg -gravity West -crop #{image.width}x#{image.height}+#{trim}-0 ./_temp_data/img-fin.jpg`
		`convert -background '#0006' -fill white -gravity center -size #{new_width/1.2}x#{image.height/1.2} \
		caption:"#{words}" \
		./_temp_data/img-fin.jpg +swap -gravity center -composite  ./_temp_data/img-comp-#{n}.jpg`
		puts i
		success = false
		while not success do 
			puts "hey"
			puts d
			reply = @client.create_pin({
				board: '697917342193270569',
				note: "#{d[:text]}",
				link: "https://enthrone.me/#{d[:heading].gsub(' ','-')}",
				image: Faraday::UploadIO.new("./_temp_data/img-comp-#{n}.jpg", "image/jpg")
			})
			puts i
			puts reply
			puts d[:name]
			puts 
			success = !(reply.keys.include?(:message))
			sleep(360)
		end
	end
	
end