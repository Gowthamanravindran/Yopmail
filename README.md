# YOPMAIL
Yopmail is a Lightweight Gem to fetch mail directly from API without having to navigate and look through yopmail via UI.

#### Installation
Add this line to your application's Gemfile:

gem 'Yopmail'
And then execute:

> bundle install

Or install it yourself as:

> gem install Yopmail

## Usage

#### Create the client 
inbox is the yopmail inbox that you want to access

> yop = YopmailHelper::Yopmail.new(inbox)

#### Get all mails 
Get all the mails from the first page (To be expanded to other pages)

> yop.all_mails

returns an array of hash containing the mail containing the subject, from and time of the mail

#### Get Mail based on Subject and From

> yop.filtered_mail(condition)

condition - optional - can include subject and from as hash - need not contain the full string value
If left empty returns all mails in the first page.
Example 

> yop.filtered_mail({:subject => 'Sample Subject'})

returns an array of hash containing the matching mail containing the subject, from and time of the mail

#### Get Mail Content
Get all mail content - Subject, From, Date, Attachments, Links, MailBody etc as an array of hash

> yop.find_store_mail_content(condition)

condition - optional - can include subject and from as hash - need not contain the full string value
If left empty returns all mails in the first page.
Example 

> yop.find_store_mail_content({:subject => 'Sample Subject'})
