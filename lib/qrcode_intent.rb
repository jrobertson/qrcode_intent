#!/usr/bin/env ruby

# file: qrcode_intent.rb

require 'rqrcode'
require 'simplevpim'


# # Intents covered
# 
# ## Cryptocurrency
# 
# * type
# * receiver
# * amount
# * msg (optional)
# 
# ## Email
# 
# * subject
# * body
# 
# ## Location
# 
# * longitude
# * latitude
# 
# # Phone
# 
# * number
# 
# ## SMS
# 
# * number
# * msg
# 
# ## Twitter
# 
# * username
# * msg
# 
# ## WiFi
# 
# * ssid
# * type; options: none, wep, wpa/wpa2
# * password
# 
# ## Zoom
# 
# * meetingid
# * password


class QRCodeIntent
  
  attr_reader :to_s
    
  Cryptocurrency = Struct.new(*%i(type receiver amount msg))
  Email = Struct.new(*%i(to subject body))
  Sms = Struct.new(*%i(number msg))
  Twitter = Struct.new(*%i(username msg))
  WiFi = Struct.new(*%i(ssid type password))
  Zoom = Struct.new(*%i(meetingid password))
  
  def initialize(obj=nil, event: nil, contact: nil, website: nil, 
                 wifi: nil, location: nil, sms: nil, phone: nil, 
                 email: nil, bitcoin: nil, twitter: nil, 
                 zoom: nil, debug: false)
    
    @debug = debug
    
    if website then
    
      add_website website
    
    elsif location
      
      add_location location
      
    elsif email
      
      add_email email
      
    elsif event 
      
      add_event event
      
    elsif contact
      
      add_contact contact

    elsif wifi
      
      add_wifi wifi
      
    elsif sms
      
      add_sms sms
      
    elsif phone
      
      add_tel phone

    elsif bitcoin
      
      add_cryptocurrency bitcoin            
      
    elsif twitter
      
      add_twitter twitter
      
    elsif zoom
      
      add_zoom zoom
            
    else
      
      if obj.is_a? String then
        obj
      elsif obj.is_a? Hash
        obj[:start] ? add_event(obj) : add_contact(obj)
      end
      
    end
    
  end
  
  def add_contact(obj=nil, &blk)
    
    @to_s = if block_given? then
      
      SimpleVpim.new(:contact, &blk).to_vcard.to_s
      
    elsif obj
      
      SimpleVpim.new(obj).to_vcard.to_s
      
    end
    
  end
  
  def add_cryptocurrency(obj=nil, &blk)
    
    h = if block_given? then
      
      c = Cryptocurrency.new
      yield c
      c.to_h

      
    elsif obj.is_a? Hash
      
      obj
      
    end
    
    # a type can be bitcoin, bitcoincash, ethereum, litecoin, dash etc.
    #
    type = h[:type] || 'bitcoin'
    
    s = "%s:%s?%s" % [type, h[:receiver], h[:amount]]
    s += "&message=%s" % h[:msg] if h[:msg]
    
    @to_s = s
    
  end  

  def add_email(obj=nil, &blk)
    
    h = if block_given? then
      
      email = Email.new
      yield email
      email.to_h

      
    elsif obj.is_a? Hash
      
      obj
      
    end
    
    @to_s = "MATMSG:TO:%s;SUB:%s;BODY:%s;;" % [h[:to], h[:subject], h[:body]]
    
  end    
  
  def add_event(obj=nil, &blk)
    
    @to_s = if block_given? then
      
      SimpleVpim.new(:event, &blk).to_vevent
      
    elsif obj
      
      SimpleVpim.new(obj).to_vevent
      
    end
    
  end
  
  # e.g. add_location '55.8835644,-3.2312978'
  #
  def add_location(s)
    @to_s = 'geo:' + s
  end
  
  # e.g. add_website 'https://news.bbc.co.uk/'
  #
  def add_website(s)
    @to_s = s
  end
  
  def add_sms(obj=nil, &blk)
    
    h = if block_given? then
      
      sms = Sms.new
      yield sms
      sms.to_h

      
    elsif obj.is_a? Hash
      
      obj
      
    end
    
    @to_s = "SMSTO:%s:%s" % [h[:number], h[:msg]]
    
  end  
  
  # e.g. add_tel '0131 542 4923'
  #
  def add_tel(s=nil, number: s)
    @to_s = 'tel:' + number
  end  
  
  def add_twitter(obj=nil, &blk)
    
    h = if block_given? then
      
      c = Twitter.new
      yield c
      c.to_h

      
    elsif obj.is_a? Hash
      
      obj
      
    end
    
    @to_s = if h[:msg] then
      "https://twitter.com/intent/tweet?text=" % URI.encode(h[:msg])
    elsif h[:username]
      "https://twitter.com/%s" % h[:username]
    end
    
    @to_s = s
    
  end  
  
  def add_zoom(obj=nil, &blk)
    
    h = if block_given? then
      
      c = Zoom.new
      yield c
      c.to_h

      
    elsif obj.is_a? Hash
      
      obj
      
    end
    
    @to_s = "https://zoom.us/j/%s?pwd=%s" % [h[:meetingid], h[:password]]
    
  end  
  
  def add_wifi(obj=nil, &blk)
    
    h = if block_given? then
      
      wifi = WiFi.new(nil, 'WPA', nil)
      yield wifi
      wifi.to_h

      
    elsif obj.is_a? Hash
      
      obj
      
    end
    
    @to_s = "WIFI:S:%s;T:%s;P:%s;;" % [h[:ssid], h[:type], h[:password]]
    
  end
  
  def to_svg()
    RQRCode::QRCode.new(@to_s).as_svg viewbox: true
  end
  
end
