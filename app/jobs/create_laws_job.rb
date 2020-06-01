require "nokogiri"
require "open-uri"

class CreateLawsJob < ApplicationJob
  queue_as :default

  laws = [['https://vie-publique.fr/loi/268070-loi-avia-lutte-contre-les-contenus-haineux-sur-internet',2039,'Adoptée',2019,7,9],
  ['https://www.vie-publique.fr/loi/20774-moralisation-de-la-vie-publique-loi-retablissant-la-confiance-dans-lac',119,'Adoptée',2017,8,9]]
  def perform(laws)
    # Do something later
    laws.each do |law|
      createLaw(law)
    end
  end

  def nokogiriDocument(link)
    html_file = open(link)
    Nokogiri::HTML(html_file)
  end

  def getTitle(link)
    title = ""
    nokogiriDocument(link).search("h1 span").each do |element|
      title = element.text.strip
    end
    return title
  end

  def getContent(link)
    content = ""
    nokogiriDocument(link).search(".chapo span").each do |element|
      content = element.text.strip
    end
    return content
  end

  def getTags(link)
    tags = []
    document.search(".tagsBox a").each do |element|
      tag = element.text.strip
      tags << tag
    end
    return tags
  end

  def createLaw(law)
    link = law[0]
    newLaw = Law.create!(
      {
        title: getTitle(link),
        content: getContent(link),
        ressource_link: link,
        current_status: law[2],
        last_status_update: Date.new(law[3], law[4], law[5]),
        scrutin_id: law[1]
      }
    )
    getTags(link).each do |tag|
      aviaLaw.tag_list.add(tag)
    end
    law.save
  end

end