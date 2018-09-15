require 'open-uri'
require 'pry'
require 'nokogiri'
class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    students = Nokogiri::HTML(html).css('div.student-card')

    result = []
    students.each do |student|
      name = student.css('h4.student-name').text
      location = student.css('p.student-location').text
      profile_url = student.css('a').attribute('href').value
      result << {
        name: name,
        location: location,
        profile_url: profile_url
      }
    end
    result
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    doc = Nokogiri::HTML(html)
    result = {}

    social = doc.css('div.social-icon-container')
    social.css('a').each do |platform|
      link = platform.attribute('href').value
      if link.include? 'twitter'
        result[:twitter] = link
      elsif link.include? 'linkedin'
        result[:linkedin] = link
      elsif link.include? 'github'
        result[:github] = link
      else
        result[:blog] = link
      end
    end
    result[:profile_quote] = doc.css('div.profile-quote').text
    result[:bio] = doc.css('div.description-holder p').text

    result
  end

end
Scraper.scrape_index_page('./fixtures/student-site/index.html')

# all students = doc.css('div.student-card')
# student name = student.css('h4.student-name').text
# student location = student.css('p.student-location').text
# student profile url = student.css('a').attribute('href').value
