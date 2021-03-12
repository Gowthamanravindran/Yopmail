# Yopmail Assistant
module YopmailHelper
  require 'nokogiri'
  # Class for Yopmail
  class Yopmail
    def initialize(inbox)
      @inbox = inbox
      @yp = yp_cookie
      @yj = yj_cookie
    end

    def filtered_mail(condition = [])
      mails = all_mails
      filtered_mail_list = []
      mails.each do |mail|
        flag = condition_match(mail, condition)
        filtered_mail_list.push(mail) if flag
      end
      filtered_mail_list
    end

    def condition_match(mail,condition)
      flag = true
      condition.each do |key, value|
        unless mail[key.to_sym].include?(value)
          flag = false
          next
        end
      end
      flag
    end

    def mailbox_url
      "http://www.yopmail.com/en/inbox.php?login=#{@inbox}&yp=#{@yp}&yj=#{@yj}&v=3.1"
    end

    def all_mails
      url = mailbox_url
      store = %x[curl GET "#{url}"]
      doc = Nokogiri::HTML.parse(store)
      elements = doc.search('a[@class="lm"]')
      mails = []
      elements.each do |elem|
        mail = {}
        mail[:subject] = elem.children.at('span[@class="lms"]').text
        mail[:href] = elem[:href]
        mail[:from] = elem.children.at('span[@class="lmf"]').text
        mail[:time] = elem.children.at('span[@class="lmh"]').text
        mails.push(mail)
      end
      mails
    end

    def find_store_mail_content(condition=[])
      mails = filtered_mail(condition)
      mail_data = []
      mails.each do |mail|
        begin
          url = "http://www.yopmail.com/en/#{mail[:href]}"
          store = %x[curl GET "#{url}" --header 'Cookie: compte=#{@inbox.downcase}']
          doc = Nokogiri::HTML.parse(store)
          data = {}
          data[:subject] = doc.at('//div[@id="mailhaut"]/div').text
          data[:from] = doc.at('//b[contains(text(),"From:")]/parent::div').text.sub('From: ', '').strip
          data[:date] = doc.at('//b[contains(text(),"Date:")]/parent::div').text.sub('Date:', '').strip[1..-1]
          attachments = doc.search('//div[@id="mailhaut"]//a[contains(@class,"mgif")]')
          data[:attachment] = [] if attachments.count.positive?
          attachments.each do |att|
            link_hash = {}
            link_hash[:link] = "http://www.yopmail.com/en/#{att[:href]}"
            link_hash[:title] = att.text.strip
            data[:attachment].push(link_hash)
          end
          data[:mail_content] = doc.at('//div[@id="mailmillieu"]').text.strip.gsub(/\r/,'').gsub(/\n/,'').gsub('  ','')
          mail_body_links = doc.search('//div[@id="mailmillieu"]//a')
          data[:subject_link] = [] if mail_body_links.count.positive?
          mail_body_links.each do |link|
            link_hash = {}
            link_hash[:link] = link[:href]
            link_hash[:title] = link.text.strip
            data[:subject_link].push(link_hash)
          end
          mail_data.push(data)
        rescue => e
          puts '======= YOPMAIL HELPER EXCEPTION ========'
          puts "Mail details => #{mail}"
          puts 'Exception in Mail - Recaptcha happened - Stack Trace'
          puts e
        end
      end
      mail_data
    end

    private

    def yp_cookie
      store = %x[curl POST 'http://www.yopmail.com/en/']
      doc = Nokogiri::HTML.parse(store)
      doc.at('input[@name="yp"]')['value']
    end

    def yj_cookie
      store = %x[curl GET 'http://www.yopmail.com/style/3.1/webmail.js']
      store.scan(/(?<=yj=)(.*?)(?=&v=)/)[0][0]
    end
  end
end
