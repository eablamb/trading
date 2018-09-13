require 'HTTParty'
require 'nokogiri'

class SerenitySearch

  BASE_URL = 'https://www.serenitystocks.com/stock/us'

  def initialize symbol:
    @symbol = symbol
  end

  def graded?
    ['Defensive', 'Enterprising', 'NCAV (Net-Net)'].include? grade
  end

  def output separator = '|'
    [
      symbol,
      grade,
      intrinsic_value,
      previous_close,
      intrinsic_percent,
      sales_rating,
      liabilities_rating,
      debt_rating,
      earnings_stability_rating,
      dividend_record_rating,
      earnings_growth_rating,
      graham_number,
      ncav_or_net_net,
      debt_to_equity,
      annual_sales,
      current_assets,
      intangibles,
      goodwill,
      total_assets,
      current_liabilities,
      long_term_debt,
      total_liabilities,
      shares_outstanding,
      book_value_per_share,
      tangible_book_value_per_share,
      *earnings_per_share_history,
      earnings_per_share_currency,
      *dividend_history
    ].join(separator)
  end

  private

  attr_accessor :symbol

  def doc
    @doc ||= HTTParty.get "#{BASE_URL}/#{search_formatted_symbol}"
  end

  def page
    @page ||= Nokogiri::HTML doc
  end

  def search_formatted_symbol
    @search_formatted_symbol ||= symbol.gsub('.','').downcase
  end

  def grade
    @grade ||= page.css('.field-name-field-issuetype').css('.even').text
  end

  def intrinsic_value
    @intrinsic_value ||= page.css('.field-name-field-optimumpricedec').css('.even').text
  end

  def previous_close
    @previous_close ||= page.css('.field-name-field-currpricedec').css('.even').text
  end

  def intrinsic_percent
    @intrinsic_percent ||= page.css('.field-name-field-quantitative-result').css('.even').text
  end

  def sales_rating
    @sales_rating ||= page.css('.field-name-field-annualsalesrating').css('.even').text
  end

  def liabilities_rating
    @liabilities_rating ||= page.css('.field-name-field-liabilitiesrating').css('.even').text
  end

  def debt_rating
    @debt_rating ||= page.css('.field-name-field-debtrating').css('.even').text
  end

  def earnings_stability_rating
    @earnings_stability_rating ||= page.css('.field-name-field-earningsstabilityrating').css('.even').text
  end

  def dividend_record_rating
    @dividend_record_rating ||= page.css('.field-name-field-dividendrecordrating').css('.even').text
  end

  def earnings_growth_rating
    @earnings_growth_rating ||= page.css('.field-name-field-earningsgrowthrating').css('.even').text
  end

  def graham_number
    @graham_number ||= page.css('.field-name-field-grahamnumber').css('.even').text
  end

  def ncav_or_net_net
    @ncav_or_net_net ||= page.css('.field-name-field-ncav-net-net-').css('.even').text
  end

  def debt_to_equity
    @debt_to_equity ||= page.css('.field-name-field-debt-equity').css('.even').text
  end

  def annual_sales
    @annual_sales ||= page.css('.field-name-field-annualsales').css('.even').text
  end

  def current_assets
    @current_assets ||= page.css('.field-name-field-currentassets').css('.even').text
  end

  def intangibles
    @intangibles ||= page.css('.field-name-field-intangibles').css('.even').text
  end

  def goodwill
    @goodwill ||= page.css('.field-name-field-goodwill').css('.even').text
  end

  def total_assets
    @total_assets ||= page.css('.field-name-field-totalassets').css('.even').text
  end

  def current_liabilities
    @current_liabilities ||= page.css('.field-name-field-currentliabilities').css('.even').text
  end

  def long_term_debt
    @long_term_debt ||= page.css('.field-name-field-longtermdebt').css('.even').text
  end

  def total_liabilities
    @total_liabilities ||= page.css('.field-name-field-totalliabilities').css('.even').text
  end

  def shares_outstanding
    @shares_outstanding ||= page.css('.field-name-field-sharesoutstanding').css('.even').text
  end

  def book_value_per_share
    @book_value_per_share ||= page.css('.field-name-field-reported-book-value').css('.even').text
  end

  def tangible_book_value_per_share
    @tangible_book_value_per_share ||= page.css('.field-name-field-bvps').css('.even').text
  end

  def earnings_per_share_history
    @earnings_per_share ||= extract_eps_history
  end

  def earnings_per_share_currency
    @earnings_per_share_currency ||= page.css('.field-name-field-eps-currency').css('.even').text
  end

  def dividend_history
    @dividend_history ||= extract_dividend_history
  end

  def extract_eps_history
    [
      page.css('.field-name-field-eps2011').css('.even').text,
      page.css('.field-name-field-eps2010').css('.even').text,
      page.css('.field-name-field-eps2009').css('.even').text,
      page.css('.field-name-field-eps2008').css('.even').text,
      page.css('.field-name-field-eps2007').css('.even').text,
      page.css('.field-name-field-eps2006').css('.even').text,
      page.css('.field-name-field-eps2005').css('.even').text,
      page.css('.field-name-field-eps2004').css('.even').text,
      page.css('.field-name-field-eps2003').css('.even').text,
      page.css('.field-name-field-eps2002').css('.even').text
    ]
  end

  def extract_dividend_history
    [
      page.css('.field-name-field-2011').css('.even').text,
      page.css('.field-name-field-2010').css('.even').text,
      page.css('.field-name-field-2009').css('.even').text,
      page.css('.field-name-field-2008').css('.even').text,
      page.css('.field-name-field-2007').css('.even').text,
      page.css('.field-name-field-2006').css('.even').text,
      page.css('.field-name-field-2005').css('.even').text,
      page.css('.field-name-field-2004').css('.even').text,
      page.css('.field-name-field-2003').css('.even').text,
      page.css('.field-name-field-2002').css('.even').text,
      page.css('.field-name-field-2001').css('.even').text,
      page.css('.field-name-field-2000').css('.even').text,
      page.css('.field-name-field-1999').css('.even').text,
      page.css('.field-name-field-1998').css('.even').text,
      page.css('.field-name-field-1997').css('.even').text,
      page.css('.field-name-field-1996').css('.even').text,
      page.css('.field-name-field-1995').css('.even').text,
      page.css('.field-name-field-1994').css('.even').text,
      page.css('.field-name-field-1993').css('.even').text,
      page.css('.field-name-field-1992').css('.even').text
    ]
  end

end
