# coding: utf-8
# Copyright (C) 2008,2009,2010 Róbert Viðar Bjarnason
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require './crawler_utils'

class LawChangeDocumentElement < ProcessDocumentElement

  # def self.remove_not_needed_divs(html)
  #   new_html = ""
  #   split_html = html.split("\n")
  #   split_html.each_with_index do |line,i|
  #     if (line.index("<div style") and line.index("text-align:center") and line.index("</div>") and split_html[i-3].index(". gr.</div>")) and not line.index(". gr.")
  #       line=line.gsub("div","span")
  #     end
  #     new_html+=line+"\n"
  #   end
  #   new_html
  # end
  
  def parent
    ProcessDocumentElement.find(self.parent_id) if self.parent_id
  end
  
  def content_type_s
    case self.content_type
      when 1 then "TYPE_HEADER_MAIN"
      when 2 then "TYPE_HEADER_CHAPTER"
      when 3 then "TYPE_HEADER_MAIN_ARTICLE"
      when 4 then "TYPE_HEADER_TEMPORARY_ARTICLE"
      when 5 then "TYPE_HEADER_ESSAY"
      when 6 then "TYPE_HEADER_COMMENTS_MAIN"
      when 7 then "TYPE_HEADER_COMMENTS_ABOUT_CHAPTERS"
      when 8 then "TYPE_HEADER_COMMENTS_ABOUT_MAIN_ARTICLES"
      when 9 then "TYPE_HEADER_COMMENTS_ABOUT_TEMPORARY_ARTICLE"
      when 10 then "TYPE_HEADER_COMMENTS_ABOUT_WHOLE_DOCUMENT"
      when 11 then "TYPE_CHAPTER"
      when 12 then "TYPE_MAIN_ARTICLE"
      when 13 then "TYPE_TEMPORARY_ARTICLE"
      when 14 then "TYPE_COMMENTS_ABOUT_CHAPTERS"
      when 15 then "TYPE_COMMENTS_ABOUT_MAIN_ARTICLES"
      when 16 then "TYPE_COMMENTS_ABOUT_TEMPORARY_ARTICLES"
      when 17 then "TYPE_COMMENTS_ABOUT_WHOLE_DOCUMENT"
      when 18 then "TYPE_HEADER_MAIN_CONTENT"
      when 19 then "TYPE_ESSAY_MAIN_CONTENT"
      when 20 then "TYPE_HEADER_REPORT_ABOUT_LAW"
      when 21 then "TYPE_REPORT_ABOUT_LAW"
      else "UNKNOWN"
    end
  end
  
  def set_content_type_for_header    
    if is_main_header?
      self.content_type = TYPE_HEADER_MAIN
    elsif is_main_article_header? or is_thingsalyktinuar_tillaga?
      self.content_type = TYPE_HEADER_MAIN_ARTICLE
    elsif is_temporary_article_header?
     self.content_type = TYPE_HEADER_TEMPORARY_ARTICLE
    elsif is_chapter_header?
      self.content_type = TYPE_HEADER_CHAPTER
    elsif is_essay_header?
      self.content_type = TYPE_HEADER_ESSAY
    elsif is_comments_main_header?
      self.content_type = TYPE_HEADER_COMMENTS_MAIN
    elsif is_comments_about_chapter_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_CHAPTERS
    elsif is_comments_about_main_article_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_MAIN_ARTICLES
    elsif is_comments_about_temporary_article_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_TEMPORARY_ARTICLE
    elsif is_comments_about_whole_process_document_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_WHOLE_DOCUMENT
    elsif is_report_about_law_header?
      self.content_type = TYPE_HEADER_REPORT_ABOUT_LAW
    else
      puts "Error: Could not find header type for #{self.content}"
    end
  end
      
  def set_content_type_for_main_content
    if parent.content_type == TYPE_HEADER_MAIN_ARTICLE
      self.content_type = TYPE_MAIN_ARTICLE
    elsif parent.content_type == TYPE_HEADER_TEMPORARY_ARTICLE
      self.content_type = TYPE_TEMPORARY_ARTICLE
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_CHAPTERS
      self.content_type = TYPE_COMMENTS_ABOUT_CHAPTERS
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_MAIN_ARTICLES
      self.content_type = TYPE_COMMENTS_ABOUT_MAIN_ARTICLES
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_TEMPORARY_ARTICLE
      self.content_type = TYPE_COMMENTS_ABOUT_TEMPORARY_ARTICLES
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_WHOLE_DOCUMENT
      self.content_type = TYPE_COMMENTS_ABOUT_WHOLE_DOCUMENT
    elsif parent.content_type == TYPE_HEADER_MAIN
      self.content_type = TYPE_HEADER_MAIN_CONTENT
    elsif parent.content_type == TYPE_HEADER_ESSAY
      self.content_type = TYPE_ESSAY_MAIN_CONTENT
    elsif parent.content_type == TYPE_HEADER_REPORT_ABOUT_LAW
      self.content_type = TYPE_REPORT_ABOUT_LAW
    else
      puts "Error: Could not find content type for #{self.content} parent: #{parent.inspect}"
    end
  end

  def is_main_header?
    self.sequence_number==1
  end
 
  def is_chapter_header?
    content.downcase =~ /kafli/
  end
  
  def is_thingsalyktinuar_tillaga?
    content.index("Þingsályktun") or content.index("Tillaga til þingsályktunar")
  end
 
  def is_main_article_header?
    unless is_comments_about_main_article_header?      
      re1='(\\d+)'  # Integer Number 1
      re2='(\\.)' # Any Single Character 1
      re3='(\\s+)'  # White Space 1
      re4='(gr.)' # Word 1
      
      re=(re1+re2+re3+re4)
      m=Regexp.new(re,Regexp::IGNORECASE);
      if m.match(self.content.gsub(/<!-- Tab -->/," ").gsub(/&nbsp;/," "))
        matched_text_only = m.match(self.content_text_only)
        if matched_text_only and matched_text_only.length>1
          self.content_number=matched_text_only[1];
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end
 
  def is_temporary_article_header?
    unless is_comments_about_temporary_article_header?
      compare_to_content_euc("Ákvæði til bráðabirgða.")
    else
      return false
    end
  end
 
  def is_essay_header?
    compare_to_content_euc("greinargerð")
  end
  
  def is_comments_main_header?
    compare_to_content_euc("Athugasemdir við einstakar greinar frumvarpsins")
 end
 
  def is_comments_about_chapter_header?
    txt='Um I. kafla.'
    
    re1='(Um)'  # Word 1
    re2='(\\s+)'  # White Space 1
    re3='((?:[a-z][a-z0-9_]*))' # Variable Name 1
    re4='(\\.)' # Any Single Character 1
    re5='(\\s+)'  # White Space 2
    re6='(kafla)' # Word 2
    
    re=(re1+re2+re3+re4+re5+re6)
    m=Regexp.new(re,Regexp::IGNORECASE);
    if m.match(self.content)
        self.content_number=m.match(self.content)[3];  # Store the chapter number
        return true
    end
  end
 
  def is_comments_about_main_article_header?
    txt='Um 1. gr.'
 
    re1='(Um)'      # Word 1
    re2='(\\s+)'  # White Space 1
    re3='(\\d+)'  # Integer Number 1
    re4='(\\.)'     # Any Single Character 1
    re5='(\\s+)'  # White Space 2
    re6='(gr)'      # Word 2 end
    
    re=(re1+re2+re3+re4+re5+re6)
    m=Regexp.new(re,Regexp::IGNORECASE);
    if m.match(self.content.downcase.gsub(/&nbsp;/,""))
        self.content_number=m.match(self.content)[3]; # Store the article number
        return true
    else
      return false
    end    
  end
 
  def is_comments_about_temporary_article_header?
    compare_to_content_euc("Um ákvæði til bráðabirgða")
  end
 
  def is_comments_about_whole_process_document_header?
    compare_to_content_euc("athugasemdir við lagafrumvarp þetta")
  end
  
  def is_report_about_law_header?
    compare_to_content_euc("umsögn um frumvarp til laga um")
  end
    
  def compare_to_content_euc(string, debug=false)
    input1=string.downcase
    puts "INPUT1: #{input1}" if debug
    input2=self.content.downcase
    puts "INPUT2: #{input2}" if debug
    m=Regexp.new(input1)
    m.match(input2)
  end
 
  def self.skip_tokens(next_sibling)
    next_sibling.inspect[0..3]==" Tab" or
    next_sibling.inspect[0..8]==" WP Style" or 
    next_sibling.inspect[0..7]==" WP Pair" or 
    next_sibling.inspect[0..6]==" Para N" or
    next_sibling.inspect[0..6]=="<script" or
    next_sibling.inspect[0..6]=="<noscri" or
    next_sibling.inspect[0..3]=="<!--"
  end

  def self.line_is_a_new_element(line)
    result = ""
    line.scan(/<!-- Para Num \d \[\d+\] -->(.*?)(<!-- Para Num End -->)/) { |match| result = match[0] }
    result.empty? ? false : result
  end

  def self.create_elements(doc, process_id, process_document_id, url, process_type)
    puts "GET DOCUMENT HTML FOR: #{url} process_document: #{process_document_id} process_type: #{process_type}"
    html_source_doc = CrawlerUtils.fetch_html(url)

    # if html_source_doc.index("Vefskjalið er ekki tilbúið")
    #   puts "ProcessDocument not yet ready"
    #   return nil
    # end

    if ProcessDocument.find_by_external_link(url)
      puts "Found document at: #{url}"
      return nil
    end
    
    doc.priority_process_id = process_id
    doc.process_document_id = process_document_id
    #doc.category_id = 1
    doc.process_document_state_id = 1
    doc.process_document_type_id = 1
    doc.external_link = url
    doc.voting_close_time = Time.now+1.month
    doc.original_version = true
    doc.save

    elements = []
    sequence_number = process_type == PROCESS_TYPE_THINGSALYKTUNARTILLAGA ? 1 : 0

    process_document_id = doc.id
    
    div_skip_count = 0

    puts "*****************************"
    puts "#{html_source_doc.inspect}"
    puts "*****************************"
    puts "\n\n"


    last_element_start = ""
    first_found = false
    # parents = []
    text = ""
    last_title = ""
    title = ""
    partial = ""

    # html_source_doc.string.split(/\n/).each do |line|
    html_source_doc.to_s.split(/\n/).each do |line|
      if element_start = line_is_a_new_element(line)
        first_found = true

        # Add the element
        unless title == ""
          new_parent_header_element = LawChangeDocumentElement.new
          new_parent_header_element.content = title
          new_parent_header_element.content_text_only = title
          new_parent_header_element.sequence_number = title.to_i
          new_parent_header_element.process_document_id = process_document_id
          new_parent_header_element.original_version=true
          new_parent_header_element.set_content_type_for_header
          new_parent_header_element.save
          elements << new_parent_header_element

          new_main_element = LawChangeDocumentElement.new
          new_main_element.content = partial
          new_main_element.content_text_only = partial.gsub(/<\/?[^>]*>/,  "").gsub(/\&nbsp;/,  " ").strip
          new_main_element.sequence_number = 1
          new_main_element.parent_id = new_parent_header_element.id
          new_main_element.process_document_id = process_document_id
          new_main_element.set_content_type_for_main_content
          new_main_element.original_version=true
          new_main_element.save
          elements << new_main_element

          # text += "==========================================================================\n"
          # text += "#{title}\n"
          # text += "==========================================================================\n"
          # text += partial
          # text += "\n"
          # text += "\n"
        end

        # Store the title that we just found
        title = element_start

        # # Indent if the title is "a"
        # parents.push(last_title) if title and title[0].chr == "a"
        # 
        # # Outdent if the ascii value of the title is less or equal than the last title
        # parents.pop if (title[0] and last_title[0]) and ((title[0].chr.to_i == title[0].chr.to_s) or (title[0].chr != "a" and title[0] <= last_title[0]))
        # 
        # # Remove all indentation if the title is an integer
        # parents = [] if title[0].chr.to_i == title[0].chr

        # Store the rest of the line
        partial = "#{line[line.index(element_start)+2..line.length]}\n"

        # Store the title
        last_title = title
      else
        partial += "#{line}\n" if first_found
      end
    end

    # Find the last element in the document
    unless partial.blank?
      partial = partial[0..partial.index("<DL>")-1] if partial.index("<DL>")
      unless title == ""
        new_parent_header_element = LawChangeDocumentElement.new
        new_parent_header_element.content = title
        new_parent_header_element.content_text_only = title
        new_parent_header_element.sequence_number = title.to_i
        new_parent_header_element.process_document_id = process_document_id
        new_parent_header_element.original_version=true
        new_parent_header_element.set_content_type_for_header
        new_parent_header_element.save
        elements << new_parent_header_element

        new_main_element = LawChangeDocumentElement.new
        new_main_element.content = partial
        new_main_element.content_text_only = partial.gsub(/<\/?[^>]*>/,  "").gsub(/\&nbsp;/,  " ").strip
        new_main_element.sequence_number = 1
        new_main_element.parent_id = new_parent_header_element.id
        new_main_element.process_document_id = process_document_id
        new_main_element.set_content_type_for_main_content
        new_main_element.original_version=true
        new_main_element.save
        elements << new_main_element
      end
    end

    # return nil if elements.blank?

    for element in elements
      puts "Element sequence number: #{element.sequence_number}"
      puts "Element content type: #{element.content_type_s} - #{element.content_type}"
      puts "Element content number: #{element.content_number}"
      puts "#{element.content_text_only}"
      puts "---------------------------------------------------------------------------------"
    end
    
    puts "HTML"
    
    for element in elements
      puts "#{element.content}"
    end
    return doc

    # html_source_doc.xpath('//div').each do |paragraph|
    #   if div_skip_count != 0 # and process_type == PROCESS_TYPE_THINGSALYKTUNARTILLAGA
    #     div_skip_count-=1
    #     puts "DIV SKIP"
    #     next
    #   end
    #   new_parent_header_element = LawChangeDocumentElement.new
    #   new_parent_header_element.content = paragraph.inspect
    #   new_parent_header_element.content_text_only = paragraph.text
    #   new_parent_header_element.sequence_number = sequence_number+=1
    #   new_parent_header_element.process_document_id = process_document_id
    #   new_parent_header_element.original_version=true
    #   new_parent_header_element.set_content_type_for_header
    #   new_parent_header_element.save
    #   elements << new_parent_header_element
    # 
    #   next_sibling = paragraph.next_sibling
    #   all_content_until_next_header = ""
    #   all_content_until_next_header_text_only = ""
    #   puts "PROCESSING HEADER TYPE: "+new_parent_header_element.content_type_s
    #   if new_parent_header_element.content_type == TYPE_HEADER_MAIN_ARTICLE and process_type == PROCESS_TYPE_THINGSALYKTUNARTILLAGA
    #     puts "Thingsaliktunartillaga main content"
    #     while next_sibling and not next_sibling.text.index("Greinargerð") and not next_sibling.text.index("Samþykkt á Alþingi") and not
    #            next_sibling.text.index("Athugasemdir við þingsályktunartillögu þessa.")
    #       puts "SIBLING " + next_sibling.inspect
    #       if next_sibling.inspect.index("<div ")
    #         div_skip_count += (next_sibling.inspect.split("<div ").count)-1
    #         puts "ADDIN DIV SKIP #{div_skip_count}"
    #       end
    #       unless skip_tokens(next_sibling)
    #         all_content_until_next_header+= next_sibling.inspect
    #         all_content_until_next_header_text_only+= next_sibling.text
    #       end          
    #       next_sibling = next_sibling.next_sibling
    #     end
    #   else # not process_type == PROCESS_TYPE_THINGSALYKTUNARTILLAGA
    #     while true
    #       puts "NEXT SIBLING " + next_sibling.inspect
    #       puts "NEXT NEXT SIBLING " + next_sibling.next_sibling.inspect if next_sibling and next_sibling.next_sibling
    #       if next_sibling.inspect.index("<div") and next_sibling.inspect.index("center") and next_sibling.inspect.index("<i>")
    #         div_skip_count += 1
    #         puts "ADDING TO DIV COUNT"
    #       elsif next_sibling and (next_sibling.inspect[0..3]=="<div" or next_sibling.inspect[0..7]=="<b> <div")
    #         break
    #       elsif not next_sibling
    #         break
    #       end
    #       first = false
    #       unless skip_tokens(next_sibling)
    #         all_content_until_next_header+= next_sibling.inspect
    #         all_content_until_next_header_text_only+= next_sibling.text
    #       end          
    #       next_sibling = next_sibling.next_sibling
    #     end
    #   end
    #   new_main_element = LawProposalDocumentElement.new
    #   new_main_element.content = all_content_until_next_header
    #   new_main_element.content_text_only = all_content_until_next_header_text_only
    #   new_main_element.sequence_number = sequence_number+=1
    #   new_main_element.parent_id = new_parent_header_element.id
    #   new_main_element.process_document_id = process_document_id
    #   new_main_element.set_content_type_for_main_content
    #   new_main_element.original_version=true
    #   new_main_element.save
    #   elements << new_main_element
    # end
    # 
    # for element in elements
    #   puts "Element sequence number: #{element.sequence_number}"
    #   puts "Element content type: #{element.content_type_s} - #{element.content_type}"
    #   puts "Element content number: #{element.content_number}"
    #   puts "#{element.content_text_only}"
    #   puts "---------------------------------------------------------------------------------"
    # end
    # 
    # puts "HTML"
    # 
    # for element in elements
    #   puts "#{element.content}"
    # end
    # return doc
  end  
end