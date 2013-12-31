require 'rubygems'
require 'mongoid'
require 'nokogiri'
require 'open-uri'
require 'typhoeus'


namespace :load_data do

  desc "loads and scrubs data from babycenter.com"
  task :babycenter => :environment do

    # number of entries
    numentries = 200

    (674..170022).step(numentries).each do |startIndex|
      # select imports
      url = "http://www.babycenter.com/babyNamerSearch.htm?startIndex=" + startIndex.to_s + "&search=true&batchSize=" + numentries.to_s + "&simplesearch=true"

      doc = Nokogiri::HTML(open(url))

      puts "//////////////////    Opened babycenter main link  ////////////////////////"

      for i in (1..numentries).step(5)
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

        nameHTML = Nokogiri::HTML(open(innerURL))
        nameHTML.css('.babyNameBasicInfo').text.split(';').each do |entry|
          eSplit = entry.split(":")
          e = eSplit[0].strip.gsub("\n",'').gsub("\u00A0", "").downcase

          result = (eSplit[1].strip.downcase.include? "if you have information")? "" : eSplit[1].strip.downcase
          babyname[e] = result
        end

        new_name = Babyname.create(name: babyname["name"], gender: babyname["gender"], origin: babyname["origin"], meaning: babyname["meaning"])

        new_name.upsert

        # debug
        puts "[   index ] " + startIndex.to_s
        puts "[    name ] " + babyname["name"]
        puts "[  gender ] " + babyname["gender"]
        puts "[  origin ] " + babyname["origin"]
        puts "[ meaning ] " + babyname["meaning"]
        puts "-----------------------------------------------"
        puts "\n"

      end

    end

  end

end