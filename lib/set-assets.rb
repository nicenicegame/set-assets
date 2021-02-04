# Tatpol Samakpong
# 6210546668
#
# Usage:
#     SETAssets::run
#          or
#     SETAssets.run

require 'open-uri'
require 'nokogiri'

class SETAssets

    @@feed_url = 'https://www.set.or.th/set/commonslookup.do'
    @@base_url_site = 'https://www.set.or.th'
    
    def self.run
        doc = get_page_doc(@@feed_url)
        links = get_prefix_links(doc)
        links.each do |link|
        link_doc = get_page_doc("#{@@base_url_site}#{link}")
        table_rows = link_doc.css('table tr')
        table_rows.each do |row|
            a_tags = row.css('td:first-child a')
            a_tags.each do |tag|
                stock_url = tag['href']
                stock_url['profile'] = 'highlight'
                stock_info = get_stock_info("#{@@base_url_site}#{stock_url}")
                puts "#{stock_info.first} : #{stock_info.last}"
                end
            end
        end
    end

    private

    def self.get_page_doc(url)
        source = URI.open(url)
        doc = Nokogiri::HTML(source)
    end

    def self.get_stock_info(stock_url)
        doc = get_page_doc(stock_url)
        stock_name = doc.css('h3').text
        last_assets_text = doc.css('table tbody tr:nth-child(2) td')[-2].text
        # remove HTML non-breaking space (&nbsp;)
        last_assets = last_assets_text.gsub("\u00A0", "")
        [stock_name, last_assets]
    end
    
    def self.get_prefix_links(doc)
        links_container = doc.css('div.col-xs-12.padding-top-10.text-center.capital-letter a')
        all_links = links_container.map {|a_tag| a_tag['href']}
    end

end
