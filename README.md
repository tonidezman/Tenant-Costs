# How to

## Scrape data
```bash
$ bundle exec rake scraper:start
```

## Send email
```bash
$ TENANT_EMAIL=mail@example.com bundle exec rake email:send
```

## check data
```bash
# expenses and tenant payments for the last three months
$ bundle exec rake show:tenant_costs
```
