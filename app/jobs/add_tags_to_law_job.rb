require "nokogiri"
require "open-uri"

class AddTagsToLawJob < ApplicationJob
  queue_as :default

  def perform(law)
    getTags(law).each do |tag|
      law.tag_list.add(tag)
    end
    law.save
  end

  def nokogiriDocument(link)
    html_file = open(link)
    Nokogiri::HTML(html_file)
  end

  def getTags(law)
    link = law.ressource_link
    tags = []
    nokogiriDocument(link).search(".tagsBox a").each do |element|
      tag = element.text.strip
      if (tag != "Justice - Droits fondamentaux" && tag != "Loi")
        tags << tag
      end
    end
    return tags
  end
end
