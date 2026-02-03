-- INSERT DATA TO DB --


-- INSERT new Volunteers

INSERT INTO volunteers(first_name, last_name, dob, status, join_date, background_check, personal_email, personal_phone, volunteer_email)
VALUES
('Alice', 'Johnson', '1995-04-12', 'active', CURRENT_TIMESTAMP, 'complete', 'alice.johnson@gmail.com', '(519) 555-1111', 'alice.johnson@charity.org'),
('Brian', 'Smith', '1988-09-30', 'pending', CURRENT_TIMESTAMP, 'pending', NULL, '(415) 555-2222', 'brian.smith@charity.org'),
('Carla', 'Nguyen', '2000-01-05', 'pause', CURRENT_TIMESTAMP, 'failed', NULL, NULL, 'carla.nguyen@charity.org');


--INSERT new sponsors
INSERT INTO sponsors(first_name, last_name, dob, status, join_date, email, phone)
VALUES
('Michael', 'Anderson', '1972-06-14', 'active', CURRENT_TIMESTAMP, 'michael.anderson@email.com', '(415) 555-1001'),
('Sara', 'Williams', '1985-11-02', 'pause', CURRENT_TIMESTAMP, 'sara.williams@email.com', '(212) 555-1002'),
('David', 'Chen', '1990-03-27', 'inactive', CURRENT_TIMESTAMP, 'david.chen@email.com', '(312) 555-1003');


--INSERT school data
INSERT INTO schools(name, city, contact_email, contact_phone, address)
VALUES
('Central Elementary School', 'San Jose', 'contact@centrales.edu', '(408) 555-2100', '100 Central Ave, San Jose, CA 95112'),
('Riverside Middle School', 'Portland', 'info@riversidems.edu', '(503) 555-3321', '245 River Rd, Portland, OR 97205'),
('Lincoln High School', 'Boston', 'admin@lincolnhs.edu', '(617) 555-4489', '789 Lincoln St, Boston, MA 02108');


-- INSERT new recipients
INSERT INTO recipients(first_name, middle_name, last_name, dob, address, school_id, status, join_date, email, phone)
VALUES
('Emma', NULL, 'Rodriguez', '2015-08-10', '123 Maple St, San Jose, CA', 1, 'active', CURRENT_TIMESTAMP, NULL, '(408) 555-3412'),
('Noah', 'James', 'Thompson', '2008-02-22', NULL, 2, 'pause', CURRENT_TIMESTAMP, 'noah.thompson@email.com', '(503) 555-7789'),
('Liam', NULL, 'OConnor', '2022-11-05', NULL, NULL, 'active', CURRENT_TIMESTAMP, NULL, '(617) 555-9044');


--INSERT guardians
INSERT INTO guardians(first_name, middle_name, last_name, dob, address, join_date, email, phone)
VALUES
('Maria', NULL, 'Rodriguez', '1984-03-18', '123 Maple St, San Jose, CA 95112', CURRENT_TIMESTAMP, 'maria.rodriguez@email.com', '(408) 555-6101'),
('Carlos', 'Antonio', 'Rodriguez', '1980-07-09', '123 Maple St, San Jose, CA 95112', CURRENT_TIMESTAMP, NULL, '(408) 555-6102'),
('David', NULL, 'Thompson', '1976-11-25', '88 Pine Rd, Portland, OR 97205', CURRENT_TIMESTAMP, 'david.thompson@email.com', '(503) 555-7721'),
('Linda', 'Mae', 'Thompson', '1979-02-14', '88 Pine Rd, Portland, OR 97205', CURRENT_TIMESTAMP, NULL, '(503) 555-7722'),
('Sean', NULL, 'OConnor', '1992-06-30', NULL, CURRENT_TIMESTAMP, 'sean.oconnor@email.com', '(617) 555-8844');


-- INSERT media
INSERT INTO "media"("title", "description", "file_path", "media_type", "created_at", "recipient_id")
VALUES
('First Letter - Emma', 'An introductory letter from Emma to her sponsors', '/media/emma_introduction_letter.pdf', 'pdf', CURRENT_TIMESTAMP, 1),
('School Update Photo - Emma', 'Photo from Emma’s school activity day', '/media/emma_school.jpg', 'image', CURRENT_TIMESTAMP, 1),
('Progress Report - Noah', 'Mid-year academic progress report for Noah', '/media/noah_progress.pdf', 'pdf', CURRENT_TIMESTAMP, 2),
('Noah Soccer Video', 'Short video clip from Noah’s soccer practice', '/media/noah_soccer.mp4', 'video', CURRENT_TIMESTAMP, 2),
('School photos- Liam', 'Update and photo for Liam', '/media/liam_school_photo.jpg', 'image', CURRENT_TIMESTAMP, 3),
('Liam Health Report', 'General health check report for Liam', '/media/liam_health.pdf', 'pdf', CURRENT_TIMESTAMP, 3),
('Quarterly Charity Newsletter', 'General quarterly update sent to all sponsors', '/media/newsletter_q1.pdf', 'pdf', CURRENT_TIMESTAMP, NULL),
('Annual Impact Video', 'Overview video highlighting yearly impact', '/media/annual_impact.mp4', 'video', CURRENT_TIMESTAMP, NULL),
('Holiday Greeting Image', 'Holiday greeting card image for all supporters', '/media/holiday_greeting.jpg', 'image', CURRENT_TIMESTAMP, NULL);


-- INSERT payment information
INSERT INTO "outgoing_payments"("title", "description", "recipient_id", "paid_at", "executed_by", "receipt", "due_date", "status")
VALUES
('School Supplies for Emma', 'Purchase of school supplies for Emma', 1, '2026-01-09 16:25:10', 1, '/receipts/emma_supplies.jpg', '2026-01-09', 'paid'),
('Tutoring Fees for Noah', 'Monthly tutoring payment for Noah', 2, NULL, NULL, '/receipts/noah_tutoring.jpg', '2026-01-05', 'overdue'),
('Medical Checkup for Liam', 'Routine medical checkup expenses for Liam', 3, NULL, NULL, '/receipts/liam_medical.jpg', '2026-02-10', 'upcoming'),
('Office Utilities', 'General office utility expenses', NULL, '2026-01-09 16:25:10', 3, '/receipts/office_utilities.jpg', '2025-12-28', 'paid');


-- INSERT data to show which volunteer is responsible for which recipients
INSERT INTO "volunteer_recipient"("volunteer_id", "recipient_id")
VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 1),
(3, 3);


--INSERT data to show which sponsors sponosor which recipients
INSERT INTO "sponsor_recipient"("sponsor_id", "recipient_id")
VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2);


-- INSERT data to show which guardians care for which recipients, as well as if the guaridan is primary or not.
INSERT INTO "guardian_recipient"("guardian_id", "recipient_id", "relation", "is_primary")
VALUES
-- Emma Rodriguez
(1, 1, 'Mother', 1),
(2, 1, 'Father', 0),

-- Noah Thompson
(3, 2, 'Father', 1),
(4, 2, 'Aunt', 0),

-- Liam OConnor
(5, 3, 'Legal Caregiver', 1);


--INSERT data to show donations that have been made
INSERT INTO "donations"("sponsor_id", "recipient_id", "amount", "donation_timestamp")
VALUES
-- Sponsor-specific donations
(1, 1, 100.00, '2025-12-15 10:45:00'),
(2, 2, 75.00, '2026-01-03 14:20:00'),
(2, 3, 50.00, '2025-11-28 09:10:00'),
(3, 1, 120.00, CURRENT_TIMESTAMP),
(3, 2, 60.00, CURRENT_TIMESTAMP),

-- Anonymous donations to specific recipients
(NULL, 1, 40.00, '2025-10-05 16:00:00'),
(NULL, 3, 25.00, CURRENT_TIMESTAMP),

-- Anonymous donations with no specified recipients
(1, NULL, 200.00, '2026-01-08 11:30:00'),
(NULL, NULL, 150.00, CURRENT_TIMESTAMP);


-- EXAMPLE QUERIES--


-- Query which volunteers are responsible for a child/recipient.

SELECT "volunteer_id", "volunteer_first_name", "volunteer_last_name"
FROM "volunteers_recipients"
WHERE "recipient_first_name"='Liam' AND "recipient_last_name"='OConnor';


-- Reverse Query for which children/recipients a given volunteer is responsible for.

SELECT "recipient_id", "recipient_first_name", "recipient_last_name"
FROM "volunteers_recipients"
WHERE "volunteer_first_name" = 'Brian' AND "volunteer_last_name" ='Smith';


-- Determine who is/are the primary guardian(s) of a recipient

SELECT "guardian_id", "guardian_first_name", "guardian_last_name", "is_primary", "relation"
FROM "guardians_recipients"
WHERE "is_primary" = 1
AND "recipient_first_name"='Noah'
AND "recipient_middle_name" = 'James'
AND "recipient_last_name" = 'Thompson';


-- Determine who is/are the sponsor(s) of a recipient

SELECT * FROM "sponsors_recipients"
WHERE "recipient_first_name" = 'Liam' AND "recipient_last_name" = 'OConnor';


-- Determine who is/are the recipient(s) of a given sponsor

SELECT * FROM "sponsors_recipients"
WHERE "sponsor_first_name" = 'David' AND "sponsor_last_name" = 'Chen' AND "sponsor_email" = 'david.chen@email.com';


-- Determine all students who attend a certain school

SELECT * FROM "recipients"
WHERE "school_id" IN (
    SELECT "id" FROM "schools"
    WHERE "name" = 'Riverside Middle School' AND "city" = 'Portland'
);


-- Determine the school attended to by a recipient

SELECT * FROM "schools"
WHERE "id" IN (
    SELECT "school_id" FROM "recipients"
    WHERE "first_name" = 'Emma' AND "last_name" = 'Rodriguez'
);


-- Query for the total amount donated by a specific sponsor

SELECT "sponsor_id","sponsor_first_name", "sponsor_last_name", SUM("donation_amount") AS "total_donated"
FROM "s_r_donations"
WHERE "sponsor_id" = 2
GROUP BY sponsor_id, sponsor_first_name, sponsor_last_name;


-- Query for total amount donated to a specific Recipient within a given time frame.
SELECT "recipient_id", "recipient_first_name", "recipient_last_name", SUM("donation_amount")
FROM "s_r_donations"
WHERE "recipient_id" = 1
AND "donation_timestamp" >= '2025-12-01' AND "donation_timestamp" < '2026-01-01';


-- Query for any payments that are past due
SELECT * FROM "outgoing_payments"
WHERE "status" = 'overdue' OR ("status" != 'paid' AND "due_date" <= date('now'));


-- Query to determine which Media should be sent to which Sponsors.
SELECT * FROM "sponsors"
WHERE "sponsors"."id" IN (
    SELECT "sponsor_id" FROM "sponsors_recipients" WHERE
    "recipient_first_name" = 'Liam' AND "recipient_last_name" = 'OConnor'
);









