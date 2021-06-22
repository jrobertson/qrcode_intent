# Introducing the qrcode_intent gem

    require 'qrcode_intent'

    # -- Adding an event -----------

    h = {
      title: 'Book Festival', start: 'june 24', end: 'june 25', 
      location: 'Edinburgh', description: 'Refreshments included'
    }
    qci = QRCodeIntent.new(event: h)
    s = qci.to_svg

    # ... or in block form

    qci = QRCodeIntent.new
    qci.add_event do |e|
      e.title = 'Book Festival'
      e.start = 'june 24'
      e.end   = 'june 25'
      e.location    = 'Edinburgh'
      e.description =  'Refreshments included'
    end

    s = qci.to_s

Output:
<pre>
BEGIN:VEVENT
SUMMARY:Book Festival
DTSTART;VALUE=DATE:20210624
DTEND;VALUE=DATE:20210625
LOCATION:Edinburgh
DESCRIPTION:Refreshments included
END:VEVENT
</pre>

    s = qci.to_svg


    # -- Adding a contact ---------------

    h = {
      firstname: 'James',
      lastname: 'Robertson',
      tel: '0131 511 1610',
      addr: '45 High Street',
      email: 'james@example.com'
    }


    qci = QRCodeIntent.new(contact: h)
    s = qci.to_svg

    # .. or in block form

    qci = QRCodeIntent.new
    qci.add_contact do |c|
      c.firstname = 'James'
      c.lastname = 'Robertson'
      c.tel = '0131 511 1610'
      c.addr = '45 High Street'
      c.email = 'james@example.com'
    end

    s = qci.to_s

output:
<pre>
BEGIN:VCARD
VERSION:3.0
N:Robertson;James;;;
FN:James Robertson
EMAIL:james@example.com
ADR:;;45 High Street;;;;
TEL:0131 511 1610
END:VCARD
</pre>

    s = qci.to_svg

    # -- Adding Wi-Fi settings -----------------

    qci = QRCodeIntent.new
    qci.add_wifi do |wifi|
      wifi.ssid = 'Lucky2'
      wifi.type = 'WPA'
      wifi.password = 'foo123465'
    end

    # note: apply type 'WPA' when WPA or WPA2

    s = qci.to_s #=> "WIFI:SLucky2;T:WPA;P:foo123465;;" 
    s = qci.to_svg

    # -- Adding a website ------------------------

    qci = QRCodeIntent.new(website: 'http://news.bbc.co.uk')
    qci.to_s #=> http://news.bbc.co.uk
    s = qci.to_svg


    # -- Adding a location ------------------------

    qci = QRCodeIntent.new(location: '55.8835644,-3.2312978')
    qci.to_s #=> geo:55.8835644,-3.2312978
    s = qci.to_svg


## Resources

* qrcode_intent https://rubygems.org/gems/qrcode_intent
* vCard Maker - Free electronic business card generator https://vcardmaker.com/
* geo URI scheme https://en.wikipedia.org/wiki/Geo_URI_scheme
* rfc5545 https://datatracker.ietf.org/doc/html/rfc5545

qrcode_intent qrcode rqrcode vcard event vevent website url contact
