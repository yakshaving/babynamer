require 'rubygems'
require 'mongoid'
require 'nokogiri'
require 'open-uri'

namespace :load_data do

  desc "loads and scrubs data from babycenter.com"
  task :babycenter => :environment do

    # number of entries
    numentries = 200

    (10601..170022).step(numentries).each do |startIndex|
      # select imports
      url = "http://www.babycenter.com/babyNamerSearch.htm?startIndex=" + startIndex.to_s + "&search=true&batchSize=" + numentries.to_s + "&simplesearch=true"

      doc = Nokogiri::HTML(open(url))

      puts "//////////////////    Opened babycenter main link  ////////////////////////"

      for i in (1..numentries*5).step(5)
        # create a master hash for all names

        babyname = {}

        # baby name
        babyname["name"] = doc.css('table')[8].css('tr td')[i].text.chomp('"').reverse.chomp('"').reverse

        # grabbing the URL
        innerURL = doc.css('table')[8].css('tr td')[i].css('a')[0]["href"]

        begin
          nameHTML = Nokogiri::HTML(open(innerURL)).css('.babyNameBasicInfo').text.gsub("\n","")
        rescue OpenURI::HTTPError => ex
          puts "Error fetching page: " + innerURL.to_s + " // Exception: " + ex.message
          next # iterate through the next element
        end

        gender = nameHTML[/Gender:(\s)*((.)*)(;)*Origin:(\s)*((.)*)(;)*Meaning:((.)*)/,2].downcase.gsub("\u00A0", "").chomp(";").chomp("!")

        babyname["gender"] = gender.include?("have information") ? "" : gender

        origin = nameHTML[/Gender:(\s)*((.)*)(;)*Origin:(\s)*((.)*)(;)*Meaning:((.)*)/,6].downcase.gsub("\u00A0", "").chomp(";").chomp("!")
        babyname["origin"] = origin.include?("have information") ? "" : origin

        meaning = nameHTML[/Gender:(\s)*((.)*)(;)*Origin:(\s)*((.)*)(;)*Meaning:((.)*)/,9].downcase.gsub("\u00A0", "").chomp(";").chomp("!")
        babyname["meaning"] = meaning.include?("have information") ? "" : meaning

        # debug
        puts "[   index ] " + startIndex.to_s + " // " + i.to_s
        puts "[    name ] " + babyname["name"]
        puts "[  gender ] " + babyname["gender"]
        puts "[  origin ] " + babyname["origin"]
        puts "[ meaning ] " + babyname["meaning"]
        puts "-----------------------------------------------"
        puts "\n"

        # add the item to the db
        Babyname.create(name: babyname["name"], gender: babyname["gender"], origin: babyname["origin"], meaning: babyname["meaning"])

      end

    end

  end

  desc "loads and scrubs data from babynameguide.com"
  task :babynameguide => :environment do

    url = "http://babynameguide.com/"
    doc = Nokogiri::HTML(open(url))

    doc.css('.MenuBarText').each do |element|
      innerURL = element.css('a')[0]["href"]

      begin
        innerHTML_page = Nokogiri::HTML(open(innerURL))
      rescue OpenURI::HTTPError => ex
        puts "fetch error, 404" + ex.message.to_s
        next
      end

      # innerHTML_page.css


    end

  end

end