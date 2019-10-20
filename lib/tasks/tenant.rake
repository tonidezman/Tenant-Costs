namespace :tenant do
  desc 'Starts Scraper'
  task scraper_start: :environment do
  end

  desc "sends the email to ENV['TENANT_EMAIL']"
  task email_send: :environment do
  end

  desc 'prints out TenantCost data for the last three months'
  task show_tenant_costs: :environment do
  end
end
