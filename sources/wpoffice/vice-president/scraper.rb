#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Período'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ name dates].freeze
    end

    def name_node
      name_cell.css('a').last
    end

    def raw_combo_date
      super.split('.').first
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
