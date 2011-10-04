# coding: utf-8

class TagsParser
  def self.get_tags(html_doc,tags_to_collect)
    millivis_addr = html_doc.xpath("/html/body/table/tr[2]/td/table/tr/td[2]/div/p/a[1]")[0]['href']
    html_doc = Nokogiri::HTML(open(URI.encode("http://www.althingi.is#{millivis_addr}")))
    (html_doc/"div.AlmTexti").each do |top|
      if top.text.index("Efnisorð")
        (top/"li/a").each do |tag_link|
          tags_to_collect << tag_link.text.gsub(", "," og ")
        end
      end
    end
    puts tags_to_collect.inspect
    tags_to_collect.join(", ")
  end
end
