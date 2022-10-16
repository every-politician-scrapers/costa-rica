#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      node.xpath('.//p[not(strong)]').first.text.tidy
    end

    field :position do
      node.css('strong').map(&:text).map(&:tidy).first
    end

    private

    def node
      noko.xpath('.//following-sibling::div[1]')
    end
  end

  class Members
    def member_container
      noko.css('.block-wrap-image')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
