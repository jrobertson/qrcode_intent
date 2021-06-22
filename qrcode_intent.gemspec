Gem::Specification.new do |s|
  s.name = 'qrcode_intent'
  s.version = '0.1.1'
  s.summary = 'An rqrcode wrapper for adding a website, a contact, ' + 
      'wi-fi settings, location, or event.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/qrcode_intent.rb']
  s.add_runtime_dependency('simplevpim', '~> 0.5', '>=0.5.2')
  s.signing_key = '../privatekeys/qrcode_intent.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/qrcode_intent'
end
