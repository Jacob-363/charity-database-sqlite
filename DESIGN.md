# Design Document

Charity Database

This document describes the design decisions, scope, and limitations of a fictional charity database project.


Video overview: <https://www.youtube.com/watch?v=eS5xVrZ816w>


## Scope

# Purpose
The purpose of this database is to keep track of data for a fictional charity. This database was inspired by my wife's work with the very real and very awesome charity "Circle of Love" (Krug ljubavi) https://krugljubavi.hr/. It is a charity based out of Croatia which is dedicated to supporting children and youth in Kenya. Their mission is to provide education, healthcare, safe shelter, nutrition, and emotional support to those facing extreme poverty, illness, and violence. Although my Database is inspired by this charity, all the entities that you find are completely fictionalized.


The database I have created tracks realstic data that, as a starting point, I believe maps well to what a real charity would need to track. It includes: donors, volunteers, recipients (i.e. the children), the recipients' guardians (including primary caregivers), The school attended by each recipient, donations that have been made, a record of charity payments (past and future), and media, such as photos, pdfs, videos or other media related to the recipients (for example, the charity may want to send a sponsor updates about the child they are sponsoring, and would include photos, videos, etc).


The database does not track things such as keeping record of the comunications between the charity and certain entities. For example, a real charity would probably have records of any communications between themselves and donors, families, schools ... etc. It also does not track things such as which media has be shared with which donors. Furthermore, a real charity Database would likely have logins for volunteers and donors. My databse does not track any sort of hierarchy between volunteers, such as which volunteers are supervisors of other volunteers. Furthermore, a real charity may have employees, but my database is for a charity that only has volunteers. The database also does not include login data such as hashed passwords.Also, in a real DB, there would restrictions for which users have access to which data. Furthermore, most charities allow donors to set an amount that they will donate each month, but my database does not include a way to track this type of automatic billing.Lastly, it is realisitc that certain recipient are related to eachother, for example siblings. This may have been good to keep track of by the current database does not keep track of this.


## Functional Requirements

* What should a user be able to do with your database?

With this database, users at an admin level are able to do the following:
1) Look up donors, recipients, volunteers, guardians, schools, donations, or uploaded media.
2)  look up the relationships between the above entities. For example:
* Which school does a recipient (child) attend?
* Who is the primary guardian for a recipient?
* Which donors are associated with which recipients?
* Which volunteers are responsible for which recipients (children).
3) All past donations made to the charity, including th date and amounts donated by each donor.
4) All past and future payments made by the Charity, including which volunteer executed the payment, and which recipient a payment is associated with.
5) users can edit, updated, delete, or insert entities/data as needed.


* What's beyond the scope of what a user should be able to do with your database?

The following are beyond the scope of my database:
1) There is currently no way to track different volunteer's roles within the organization. For example, which volunteers report to which senior level volunteers.
2) When uploading media, it is either associated with one recipient, or no recipients. In a more robust database, there would likely be a way to associated media with multiple, specific recipients.
3) The database only tracks a recipient's current school. In a more robust database, it would be beneficial to to keep track of a recipient's past school(s).

In this section you should answer the following questions:


## Representation

### Entities

* Which entities will you choose to represent in your database?
As mentioned, the following are the main entities are represented in my database:


1. **Volunteers:**
- ID (primary key)
- first name
- last name
- date of birth
- status ('pending', 'active', 'pause', 'terminate')
- join date
- Background Check status ('pending', 'complete', 'failed')
- personal email
- personal phone number
- volunteer email

2. **Sponsors:**
- ID (primary key)
- first name
- last name
- date of birth
- status ('active', 'pause', 'inactive')
- join date
- email
- phone number

3. **Schools:**
- ID (primary key)
- name
- city
- contact email
- contact phone number
- address

4. **Recipients:**
- ID (primary key)
- first name
- middle name
- last name
- date of birth
- home address
- school ID (references 'schools' table)
- status ('active', 'pause', 'inactive')
- join date
- email
- phone number

5. **Donations:**
- ID (primary key)
- sponsor ID (references 'sponsors' table; can be NULL for anonymous donations)
- recipient ID (references 'recipients' table; can be NULL for general donations)
- donation amount
- donation timestamp

6. **Guardians:**
- ID (primary key)
- first name
- middle name
- last name
- date of birth
- address
- join date
- email
- phone number

7. **Media:**
- ID (primary key)
- title
- description
- file path
- media type ('pdf', 'image', 'video', 'other')
- created at (timestamp)
- recipient ID (references 'recipients' table; can be NULL for general media)

8. **Outgoing Payments:**
- ID (primary key)
- title
- description
- recipient ID (references 'recipients' table; can be NULL for general expenses)
- paid at (timestamp; can be NULL if unpaid)
- executed by (references 'volunteers' table)
- receipt (file path)
- due date
- status ('overdue', 'paid', 'upcoming')

9. **Volunteer–Recipient (relationship table):**
- volunteer ID (references 'volunteers' table)
- recipient ID (references 'recipients' table)

10. **Sponsor–Recipient (relationship table):**
- sponsor ID (references 'sponsors' table)
- recipient ID (references 'recipients' table)

11. **Guardian–Recipient (relationship table):**
- guardian ID (references 'guardians' table)
- recipient ID (references 'recipients' table)
- relation (e.g., Mother/Father/Uncle/Caregiver/etc.)
- is primary (0 or 1)


* Why did you choose the types you did?
I chose data types based on the kind of data being stored and how it would be queried/validated.

- INTEGER was used for ID fields because that is the most common practice and an easy, simple way to ensure IDs within each table are unique.

- TEXT was used for any entities that would require characters other than numbers, such addresses, file paths, descriptive fields, and even phone numbers.

- TEXT was also used for status/type fields such as volunteer status, background_check, media_type. I restricted the acccepted values by using CHECK constraints. This was most reasonable because it will make it easier to query for users who fall within a certain status.

- NUMERIC was used for date/timestamp fields (dob, join_date, donation_timestamp, created_at, due_date, paid_at) because they store date/time values consistently and allow comparisons (before/after) when filtering records.

- NUMERIC was used for donation amounts because it supports decimal values and make validation possible, such as (amount > 0). NUMERIC also always for operations such as summing totals.

- INTEGER (0/1) was used for is_primary in the guardian/recipient relational table. Since sqlite does not support Boolean values, 0/1 was the best, valid option.


* Why did you choose the constraints you did?
The constraints I included were based on trying to make my database realistic and easier to query. For eaxmple, constraints on exact values like "status" within tables will make it easier to determine things like the status of a volunteer's background check, as well as whether volunteers, recipients, or sponsors are still active without removing their history or data. Similarily, certain fields were required for volunteers and sponsors like email. However, for recipients they may not always have access to a computer, therefore their email was optional.


In the **outgoing_payments** table, there were checks to ensure that the inputs made logical sense. For example, someone cannot input a "paid" status where the paid_at date is null, or where the volunteer_id is left blank. Similarly, someone cannot input an "upcoming" status for a payment with a due_date in the past; this would instead need to be input as "overdue".


### Relationships

![Charity Database](Mermaid Chart - Create complex, visual diagrams with text.-2026-01-22-195632.svg)

## Optimizations

**Views**
I created the following views, because they each represented the types of searches that I believe would be frequently made by users of this databas.


1. volunteers_recipients
-- Users will likely need to determine which volunteers are responsible for which recpients. This data is available in the relational table "volunteer_recipient", but this table only holds the IDs. Therefore the "volunteers_recipients" view will make it much easier to query for which volunteers/recipients are connected to each other.


2. sponsors_recipients
-- Users will likely need to determine which sponsors are associated with which recpients. This data is available in the relational table "sponsor_recipient", but this table only holds the IDs. Therefore the "sponsors_recipients" view will make it much easier to query for which sponsors/recipients are connected to each other.


3. guardians_recipients
-- Users will likely need to determine which guardians are associated with which recpients, including which guardian is the primary caregiver. This data is available in the relational table "guardian_recipient", but this table only holds the IDs. Therefore the "guardians_recipients" view will make it much easier to query for which guardians/recipients are connected to each other.


4. s_r_donations
-- The 'donations' table holds recipient and donors IDs. Therefore the s_r_dontations view makes it faster and easier to determine which donor and/or recipients a specific donation is for.


5. sponsor_totals/recipients_totals
-- These views are similar to the s_r_donations view, but they each serve the purpose of showing the total amount a sponsor has donated, or the total amount of donations a specific recipient has recieved. These views just show totals, meaning if a user wants totals over a certain timeframe, they would need to use s_r_donations.


**Indexes**
Since user's will likely search for volunteers, sponsors, recipients, and guardians based on last name then first name, I created 4 seperate indexs.


## Limitations

One limitation with the current design is with the 'outgoing_payments' table. There are checks in place when data is being input, but currently there is no way to update the table automatically. For example, once a date passes, certain payments should be changed to "overdue" if they have not been paid yet. Since this is not done automatically, it means the db may raise an error or certain rows of data will incorrectly have a status of 'upcoming' even though the date has passed.

As mentioned my database does not currently include user login information, such as hashed passwords. It also cannot track if an uploaded media is meant for multiple, specific recipients. Currently, uploaded media is either associated with one specific recipeint, or it is generalized, meaning it has no association with any specific recipients.

The 'recipients' table includes a foreign key to 'school' ID. However, if a recipient changes schools, there is currently no way to track their past school history. In other words, the table can only track their current school, but not any past schools they may have atteneded.

There is currently not a way to show positions or relationships between volunteers. For example, a supervisor may be in charge of several other volunteers, or volunteers may have different roles, positions or responsibilities. The current database only tracks volunteers generally, but does not track any of these more specific details.



