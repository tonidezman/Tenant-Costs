Run
```bash
bundle exec rake tenant:scraper_start
```
Visit `localhost:3000` to see the current months expenses






# How to

## Scrape data
```bash
bundle exec rake tenant:scraper_start \
  MY_TENANTS_NAME=$MY_TENANTS_NAME \
  MY_BANK_URL=$MY_BANK_URL \
  MY_BANK_USERNAME=$MY_BANK_USERNAME
```

## Send email
```bash
$ TENANT_EMAIL=mail@example.com bundle exec rake tenant:email_send
```

## check data
```bash
# expenses and tenant payments for the last three months
$ bundle exec rake tenant:show_tenant_costs
```
