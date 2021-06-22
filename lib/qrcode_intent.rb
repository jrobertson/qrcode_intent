#!/usr/bin/env ruby

# file: qrcode_intent.rb

require 'rqrcode'
require 'simplevpim'


class QRCodeIntent
  
  attr_reader :to_s
  
  WiFi = Struct.new(*%i(ssid type password))
  
  def initialize(obj=nil, event: nil, contact: nil, website: nil, 
                 wifi: nil, location: nil, debug: false)
    
    @debug = debug
    
    if website then
    
      add_website website
    
    elsif location
      
      add_location location
      
    elsif event 
      
      add_event event
      
    elsif contact
      
      add_contact contact

    elsif wifi
      
      add_wifi wifi
      
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
  
  def add_wifi(obj=nil, &blk)
    
    h = if block_given? then
      
      wifi = WiFi.new(nil, 'WPA', nil)
      yield wifi
      wifi.to_h

      
    elsif obj.is_a? Hash
      
      obj
      
    end
    
    @to_s = "WIFI:S%s;T:%s;P:%s;;" % [h[:ssid], h[:type], h[:password]]
    
  end
  
  def to_svg()
    RQRCode::QRCode.new(@to_s).as_svg
  end
  
end
