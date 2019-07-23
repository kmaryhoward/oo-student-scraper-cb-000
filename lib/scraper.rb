require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    scraped_students = []
    doc.css(".student-card").each do |post|
      name = post.css("h4.student-name").text
      location = post.css("p.student-location").text
      profile_url = post.css("a")[0]["href"]
      scraped_student = {:name => name, :location => location, :profile_url => profile_url}
      scraped_students << scraped_student
    end

    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    scraped_student = {}
    doc.css(".social-icon-container a").each do |post|
      url = post.attribute("href").value
      scraped_student[:twitter] = url if url.include?("twitter")
      scraped_student[:linkedin] = url if url.include?("linkedin")
      scraped_student[:github] = url if url.include?("github")
      scraped_student[:blog] = url if post.css("img").attribute("src").text.include?("rss-icon")
     end
      scraped_student[:profile_quote] = doc.css(".profile-quote").text
      scraped_student[:bio] = doc.css(".bio-content p").text
      name = doc.css(".profile-name").text.split(" ")[0]
    scraped_student
  
  end


end
