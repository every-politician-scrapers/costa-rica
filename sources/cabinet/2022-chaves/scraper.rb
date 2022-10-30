#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    # decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath("//table[.//th[contains(.,'Inicio')]]").first.xpath(".//tr[td]")
    end

    def member_items
      super.reject(&:skip?)
    end
  end

  class Member
    field :id do
      name_node.css('a/@wikidata').first
    end

    field :name do
      name_node.text.tidy
    end

    field :positionID do
    end

    field :position do
      tds[0].text.tidy
    end

    field :startDate do
      WikipediaDate::Spanish.new(raw_start).to_s
    end

    field :endDate do
      WikipediaDate::Spanish.new(raw_end).to_s
    end

    def skip?
      (tds[2].text == tds[3].text) || tds[2].text.to_s.tidy.empty?
    end

    private

    def tds
      noko.css('th,td')
    end

    def name_node
      tds[2]
    end

    def raw_start
      tds[3].text.tidy
    end

    def raw_end
      tds[4].text.tidy.gsub(' del ', ' de ')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
