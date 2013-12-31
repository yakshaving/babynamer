require 'rubygems'
require 'mongoid'
require 'nokogiri'
require 'open-uri'
require 'typhoeus'
require 'byebug'


namespace :load_data do

  desc "loads and scrubs data from babycenter.com"
  task :babycenter => :environment do

    # number of entries
    numentries = 200

    (1..170022).step(numentries).each do |startIndex|
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

        # using https://github.com/typhoeus/typhoeus to manage threading
        # request = Typhoeus::Request.new(innerURL)
        # hydra = Typhoeus::Hydra.hydra
        # hydra.queue(request)

        nameHTML = Nokogiri::HTML(open(innerURL)).css('.babyNameBasicInfo').text.gsub("\n","")

        gender = nameHTML[/Gender:(\s)*((.)*)(;)*Origin:(\s)*((.)*)(;)*Meaning:((.)*)/,2].downcase.gsub("\u00A0", "").chomp(";").chomp("!")

        babyname["gender"] = gender.include?("have information") ? "" : gender

        origin = nameHTML[/Gender:(\s)*((.)*)(;)*Origin:(\s)*((.)*)(;)*Meaning:((.)*)/,6].downcase.gsub("\u00A0", "").chomp(";").chomp("!")
        babyname["origin"] = origin.include?("have information") ? "" : origin

        meaning = nameHTML[/Gender:(\s)*((.)*)(;)*Origin:(\s)*((.)*)(;)*Meaning:((.)*)/,10].downcase.gsub("\u00A0", "").chomp(";").chomp("!")
        babyname["meaning"] = meaning.include?("have information") ? "" : meaning

        new_name = Babyname.create(name: babyname["name"], gender: babyname["gender"], origin: babyname["origin"], meaning: babyname["meaning"])

        # debug
        puts "[   index ] " + startIndex.to_s + " // " + i.to_s
        puts "[    name ] " + babyname["name"]
        puts "[  gender ] " + babyname["gender"]
        puts "[  origin ] " + babyname["origin"]
        puts "[ meaning ] " + babyname["meaning"]
        puts "-----------------------------------------------"
        puts "\n"

        # add the item to the db
        new_name.upsert

      end

    end

  end

end