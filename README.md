# Test assignment: Type A

Invoice upload feature is implemented and basically fulfill requested scenario.
However, there are some points to improve, such as:
  - specs (never used minitest before, so they could be improved, both in style and coverage)
  - more sophisticated errors handling on invoice report processing
  - expand report upload summary with happy case info
  - allow users to view/download copy of original report csv (its stored in db now)
  - minor code improvements (`TODO:`s left in the code)


Made by Dmitry K.
-----------------------------------------

# Simplified setup

```
sudo docker build .

docker-compose run --rm app bundle

docker-compose run --rm app rails db:setup

docker-compose run --rm app rake db:test:prepare

docker-compose up -d
```

--------------------------------------------

# Feature: Invoice upload

As a customer, I would like to upload files and get converted them into Invoices with precalculation.

1. A customer prepares CSV file with invoices: the first column is internal invoice id, the second is invoice amount and "due on" date

```
1,100,2019-05-20
2,200.5,2019-05-10
B,300,2019-05-01
```

The real-life file includes five thousand rows and includes invalid rows.

2. Customer can upload invoice CSV to the system
3. System processes file so that every invoice gets the selling price according to the next logic:
> Invoice sell price depends on amount and days to the due date. The formula is `amount * coefficient`. The coefficient is 0.5 when the invoice uploaded more than 30 days before the due date and 0.3 when less or equal to 30 days.

3. Customer can check invoices uploaded to the system and check their selling price.
4. Customer can get upload report and understand errors related to CSV file row processing.
