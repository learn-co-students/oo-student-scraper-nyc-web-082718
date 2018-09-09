require 'open-uri'
require 'pry'

class Scraper

  def self.doc(url)
    html = File.read(url)
    Nokogiri::HTML(html)
  end

  def self.scrape_index_page(index_url)
    doc = doc(index_url)
    students_array = doc.css(".student-card")

    students = []
    students_array.each do |s|
      info = {}
      info[:name] = s.css(".student-name").text
      info[:location] = s.css(".student-location").text
      info[:profile_url] = s.css("a").attribute("href").value
      students << info
      # binding.pry
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    details = doc(profile_url)#.css(".details-container")

    info = {}

    social = details.css(".social-icon-container").css("a")
    social.each do |s|
      url = s.attribute("href").value
      icon_url = s.css("img").attribute("src").value
      social_media = icon_url.sub("../assets/img/", "").sub("-icon.png", "").to_sym
      info[social_media] = url
    end

    info[:profile_quote] = details.css(".profile-quote").text
    info[:bio] = details.css(".bio-block").css(".description-holder").text.strip

    if info[:rss]
      info[:blog] = info[:rss]
      info.delete(:rss)
    end

    info
  end

end
