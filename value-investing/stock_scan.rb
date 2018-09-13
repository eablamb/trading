#!/usr/bin/env ruby

require 'open-uri'
require 'csv'
require_relative './serenity_search'

## S&P 500 Search
input_uri, col_sep, search_type, output_filename = [
  'https://raw.githubusercontent.com/datasets/s-and-p-500-companies/master/data/constituents.csv',
  ',',
  'sp500',
  '../output/sp_500.csv'
]

## Russell 2000 Search
# input_uri, col_sep, search_type, output_filename = [
#   'https://raw.githubusercontent.com/PartnerInnovationCenter/Russell2000/master/russell_2000_components.csv',
#   ',',
#   'russell2000',
#   '../output/russell_2000.csv'
# ]

## NASDAQ Search
# input_uri, col_sep, search_type, output_filename = [
#   'ftp://ftp.nasdaqtrader.com/SymbolDirectory/nasdaqtraded.txt',
#   '|',
#   'nasdaq',
#   '../output/nasdaq.csv'
# ]

def analyze_symbol output_file, symbol, count
  return count if symbol.nil?

  search_count = count + 1
  if search_count % 1000 == 0
    # Be a polite webscraper
    puts 'Taking a 10 minute break...'
    sleep 10 * 60
    puts "OK, back to work!"
  end

  puts "Searching for #{symbol}"
  search = SerenitySearch.new symbol: symbol
  begin
    output_file.puts( search.output ) if search.graded?
  rescue
    puts "Error while searching for #{symbol}"
  end
  search_count
end

def analyze input_data, output_header, output_file, type='sp500'
  search_count = 0
  output_file.puts output_header
  case type
  when 'sp500'
    input_data.each do |symbol, name, sector|
      search_count = analyze_symbol output_file, symbol, search_count
    end
  when 'russell2000'
    input_data.each do |symbol, name|
      search_count = analyze_symbol output_file, symbol, search_count
    end
  when 'nasdaq'
    input_data.each do |qqq_tr, symbol, name, exch, cat, etf, round_lot_size, test_issue, fin_stat, cqs_sym, qqq_sym, next_shares|
      search_count = analyze_symbol output_file, symbol, search_count
    end
  end
end

input_data = []
open(input_uri) do |input_file|
  input_data = CSV.parse input_file, col_sep: col_sep
end
# Remove the column titles
input_data = input_data.drop 1

output_header = [
  'Symbol',
  'Grade',
  'Intrinsic Value',
  'Previous Close',
  'Intrinsic Percent',
  'Sales Rating',
  'Liabilities Rating',
  'Debt Rating',
  'Earnings Stability Rating',
  'Dividend Record Rating',
  'Earnings Growth Rating',
  'Graham Number',
  'NCAV Or Net-Net',
  'Debt/Equity',
  'Annual Sales',
  'Current Assets',
  'Intangibles',
  'Goodwill',
  'Total Assets',
  'Current Liabilities',
  'Long Term Debt',
  'Total Liabilities',
  'Shares Outstanding',
  'Book Value Per Share',
  'Tangible Book Value Per Share',
  'EPS (Current)',
  'EPS (1 Year Ago)',
  'EPS (2 Years Ago)',
  'EPS (3 Years Ago)',
  'EPS (4 Years Ago)',
  'EPS (5 Years Ago)',
  'EPS (6 Years Ago)',
  'EPS (7 Years Ago)',
  'EPS (8 Years Ago)',
  'EPS (9 Years Ago)',
  'EPS Currency',
  'Dividend (Current)',
  'Dividend (1 Year Ago)',
  'Dividend (2 Years Ago)',
  'Dividend (3 Years Ago)',
  'Dividend (4 Years Ago)',
  'Dividend (5 Years Ago)',
  'Dividend (6 Years Ago)',
  'Dividend (7 Years Ago)',
  'Dividend (8 Years Ago)',
  'Dividend (9 Years Ago)',
  'Dividend (10 Years Ago)',
  'Dividend (11 Years Ago)',
  'Dividend (12 Years Ago)',
  'Dividend (13 Years Ago)',
  'Dividend (14 Years Ago)',
  'Dividend (15 Years Ago)',
  'Dividend (16 Years Ago)',
  'Dividend (17 Years Ago)',
  'Dividend (18 Years Ago)',
  'Dividend (19 Years Ago)'
].join('|')

File.open(output_filename, 'w') do |output_file|
  analyze input_data, output_header, output_file, search_type
end
