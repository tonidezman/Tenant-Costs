class Scraper
  def self.get_expenses
    capybara_configuration
    url = ENV['MY_BANK_URL']
    browser = Capybara.current_session
    browser.visit(url)

    browser.find('#username').set(ENV['MY_BANK_USERNAME'])
    browser.find('#vstopi').click

    sleep 30
    browser.click_link('Pregled prometa').click

    doc = Nokogiri::HTML.parse(browser.html)

    expenses = []
    doc.css('#table_pregled_placil tr').each do |row|
      next if row.blank? || row.text.include?('Reklamacija transakcije')
      expenses << row.text.split(/\n/).reject(&:blank?).map(&:strip)
    end
    expenses.reject(&:blank?)
    expenses.shift
    expenses # this is the header row
  end

  def self.logout
    Capybara.current_session.driver.quit
  end

  private

  def self.capybara_configuration
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.javascript_driver = :chrome
    Capybara.configure do |config|
      config.default_max_wait_time = 300 # seconds
      config.default_driver = :selenium
    end
  end
end
