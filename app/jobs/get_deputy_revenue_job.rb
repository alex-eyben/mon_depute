require 'nokogiri'
require 'open-uri'


class GetDeputyRevenueJob < ApplicationJob
  queue_as :default

  def perform(url)
    deputy_revenue(get_xml_version(url))
    # get_xml_version(url)
  end

  def get_xml_version(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('#content1 > div > ul > li:nth-child(2) > a').each do |element|
      # puts element.text.strip
      return element.attribute('href').value
    end
  end

  def deputy_revenue(url)
    file      = open(url).read
    document  = Nokogiri::XML(file)
    most_recent_year = 0
    revenue_of_most_recent_year = 0
    revenue_of_three_last_years = 0
    document.root.xpath('//montant/montant').each do |montant|
      # name        = beer.xpath('name').text
      # appearance  = beer.xpath('appearance').text
      # origin      = beer.xpath('origin').text
      most_recent_year = montant.xpath('annee').text.to_i > most_recent_year ? montant.xpath('annee').text.to_i : most_recent_year
      # puts "#{name}, a #{appearance} beer from #{origin}"
    end
    document.root.xpath('//montant/montant').each do |montant|
      # name        = beer.xpath('name').text
      # appearance  = beer.xpath('appearance').text
      # origin      = beer.xpath('origin').text
      revenue_of_three_last_years += montant.xpath('montant').text.to_i if montant.xpath('annee').text.to_i == most_recent_year
      revenue_of_three_last_years += montant.xpath('montant').text.to_i if montant.xpath('annee').text.to_i == most_recent_year-1
      revenue_of_three_last_years += montant.xpath('montant').text.to_i if montant.xpath('annee').text.to_i == most_recent_year-2
      # puts "#{name}, a #{appearance} beer from #{origin}"
    end
    revenue_of_three_last_years / 3
  end
end
