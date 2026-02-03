--Schema for Charity Database
-- Note that dates/timestamps are stored in ISO format (YYYY-MM-DD or YYYY-MM-DD HH:MM:SS)

CREATE TABLE "volunteers"(
"id" INTEGER PRIMARY KEY,
"first_name" TEXT NOT NULL,
"last_name" TEXT NOT NULL,
"dob" NUMERIC NOT NULL,
"status" TEXT NOT NULL CHECK("status" IN ('pending', 'active', 'pause', 'terminate')),
"join_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
"background_check" TEXT NOT NULL CHECK("background_check" IN ('pending', 'complete', 'failed')),
"personal_email" TEXT UNIQUE,
"personal_phone" TEXT,
"volunteer_email" TEXT NOT NULL UNIQUE
);


CREATE TABLE "sponsors"(
"id" INTEGER PRIMARY KEY,
"first_name" TEXT NOT NULL,
"last_name" TEXT NOT NULL,
"dob" NUMERIC NOT NULL,
"status" TEXT NOT NULL CHECK("status" IN ('active', 'pause', 'inactive')),
"join_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
"email" TEXT NOT NULL UNIQUE,
"phone" TEXT NOT NULL
);


-- The below table holds data about the children who are being sponsored.
CREATE TABLE "recipients"(
"id" INTEGER PRIMARY KEY,
"first_name" TEXT NOT NULL,
"middle_name" TEXT,
"last_name" TEXT NOT NULL,
"dob" NUMERIC NOT NULL,
"address" TEXT,
"school_id" INTEGER,
"status" TEXT NOT NULL CHECK("status" IN ('active', 'pause', 'inactive')),
"join_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
"email" TEXT,
"phone" TEXT NOT NULL,


FOREIGN KEY("school_id") REFERENCES "schools"("id")
);


CREATE TABLE "schools"(
"id" INTEGER PRIMARY KEY,
"name" TEXT NOT NULL,
"city" TEXT NOT NULL,
"contact_email" TEXT NOT NULL,
"contact_phone" TEXT NOT NULL,
"address" TEXT NOT NULL
);




-- if sponsor_id is NULL, this means the donation was anonymous
-- if recipient_id is NULL, this means the donation was given generall to be used where needed most (not specified to a specific recipient)
CREATE TABLE "donations"(
"id" INTEGER PRIMARY KEY,
"sponsor_id" INTEGER,
"recipient_id" INTEGER,
"amount" NUMERIC NOT NULL CHECK (amount > 0),
"donation_timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,


FOREIGN KEY("sponsor_id") REFERENCES "sponsors"("id"),
FOREIGN KEY("recipient_id") REFERENCES "recipients"("id")
);


CREATE TABLE "guardians"(
"id" INTEGER PRIMARY KEY,
"first_name" TEXT NOT NULL,
"middle_name" TEXT,
"last_name" TEXT NOT NULL,
"dob" NUMERIC NOT NULL,
"address" TEXT,
"join_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
"email" TEXT,
"phone" TEXT,

CHECK (email IS NOT NULL OR phone IS NOT NULL)
);


-- If a recipient ID is given, then we can send media to their specific sponsor
-- IF no specific recipient ID is given (because the media is general or has many recipients included in it),then this means it can be used for general marketing or sent to many sponsors as a generic update.

CREATE TABLE "media"(
"id" INTEGER PRIMARY KEY,
"title" TEXT NOT NULL,
"description" TEXT NOT NULL,
"file_path" TEXT NOT NULL,
"media_type" TEXT NOT NULL CHECK("media_type" IN ('pdf', 'image', 'video', 'other')),
"created_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
"recipient_id" INTEGER,


FOREIGN KEY("recipient_id") REFERENCES "recipients"("id")
);


--Outgoing payments are always either associated with one recipient, or they are general expenses related to no specific recipient(s).
CREATE TABLE "outgoing_payments"(
"id" INTEGER PRIMARY KEY,
"title" TEXT NOT NULL,
"description" TEXT NOT NULL,
"recipient_id" INTEGER,
"paid_at" NUMERIC,
"executed_by" INTEGER,
"receipt" TEXT NOT NULL, -- File path to image of payment receipt
"due_date" NUMERIC,
"status" TEXT NOT NULL CHECK("status" IN ('overdue', 'paid', 'upcoming')),


FOREIGN KEY ("recipient_id") REFERENCES "recipients"("id"),
FOREIGN KEY ("executed_by") REFERENCES "volunteers"("id"),


    CHECK (
        -- paid payments must have paid_at now or in the past, and must include volunteer ID for who made the payment.
        (status = 'paid' AND paid_at IS NOT NULL AND paid_at <= CURRENT_TIMESTAMP AND executed_by IS NOT NULL)


        OR


        -- overdue payments must be unpaid and due date is in the past.
        (status = 'overdue' AND paid_at IS NULL AND due_date IS NOT NULL AND due_date < CURRENT_TIMESTAMP)


        OR


        -- upcoming payments must be unpaid and due_date is in the future.
        (status = 'upcoming' AND paid_at IS NULL AND due_date > CURRENT_TIMESTAMP)
    )
);


-- relational table to track which volunteers are connected to which recipients and vice versa.

CREATE TABLE "volunteer_recipient"(
"volunteer_id" INTEGER NOT NULL,
"recipient_id" INTEGER NOT NULL,


PRIMARY KEY (volunteer_id, recipient_id),
FOREIGN KEY ("volunteer_id") REFERENCES "volunteers"("id") ON DELETE CASCADE,
FOREIGN KEY ("recipient_id") REFERENCES "recipients"("id") ON DELETE CASCADE
);


-- Relational table to track the recipients associated with each sponsor, and the sponsors associated with each recipient
-- One sponspor can sponsor many recipients, and one recipient can have several sponsors

CREATE TABLE "sponsor_recipient"(
"sponsor_id" INTEGER NOT NULL,
"recipient_id" INTEGER NOT NULL,


PRIMARY KEY (sponsor_id, recipient_id),
FOREIGN KEY ("sponsor_id") REFERENCES "sponsors"("id") ON DELETE CASCADE,
FOREIGN KEY ("recipient_id") REFERENCES "recipients"("id") ON DELETE CASCADE
);


-- Relational table to show which Guardians are responsible for which Recipients, including if the guardian is the primary caregiver.

CREATE TABLE "guardian_recipient"(
"guardian_id" INTEGER NOT NULL,
"recipient_id" INTEGER NOT NULL,
"relation" TEXT NOT NULL, --example ("Mother", "Father", "Uncle", "Caregiver", ..etc)
"is_primary" INTEGER NOT NULL DEFAULT "0" CHECK (is_primary IN (0, 1)), -- Checks if the guardian is the primary guardian of the recipient. It is allowed that multiple guardians are labelled as primary guardian of one recipient.
-- note that 1 respresents "true" and 0 represents "false"
PRIMARY KEY (guardian_id, recipient_id),
FOREIGN KEY ("guardian_id") REFERENCES "guardians"("id") ON DELETE CASCADE,
FOREIGN KEY ("recipient_id") REFERENCES "recipients"("id") ON DELETE CASCADE
);


--VIEWS--

--A View to show which Volunteers are associated with with Recipients and vice versa.

CREATE VIEW "volunteers_recipients" AS
SELECT
"volunteers"."id" AS "volunteer_id",
"volunteers"."first_name" AS "volunteer_first_name",
"volunteers"."last_name" AS "volunteer_last_name",
"recipients"."id" AS "recipient_id",
"recipients"."first_name" AS "recipient_first_name",
"recipients"."last_name" AS "recipient_last_name"
FROM "volunteers" JOIN "volunteer_recipient" ON "volunteers"."id" = "volunteer_recipient"."volunteer_id"
JOIN "recipients" ON "recipients"."id"="volunteer_recipient"."recipient_id";

-- A view to show which sponsors are associated with which recipients and vice versa.
CREATE VIEW "sponsors_recipients" AS
SELECT
"sponsors"."id" AS "sponsor_id",
"sponsors"."first_name" AS "sponsor_first_name",
"sponsors"."last_name" AS "sponsor_last_name",
"sponsors"."email" AS "sponsor_email",
"recipients"."id" AS "recipient_id",
"recipients"."first_name" AS "recipient_first_name",
"recipients"."last_name" AS "recipient_last_name"
FROM "sponsors" JOIN "sponsor_recipient" ON "sponsors"."id" = "sponsor_recipient"."sponsor_id"
JOIN "recipients" ON "recipients"."id"="sponsor_recipient"."recipient_id";

-- A view to show which Guardians are associated with which recipients, as well as whether they are the primary guardian

CREATE VIEW "guardians_recipients" AS
SELECT
    "guardians"."id" AS "guardian_id",
    "guardians"."first_name" AS "guardian_first_name",
    "guardians"."last_name" AS "guardian_last_name",
    "guardian_recipient"."relation",
    "recipients"."id" AS "recipient_id",
    "recipients"."first_name" AS "recipient_first_name",
    "recipients"."last_name" AS "recipient_last_name",
    "recipients"."middle_name" AS "recipient_middle_name",
    "guardian_recipient"."is_primary"
FROM "guardians"
JOIN "guardian_recipient"
    ON "guardians"."id" = "guardian_recipient"."guardian_id"
JOIN "recipients"
    ON "recipients"."id" = "guardian_recipient"."recipient_id";


-- A view showing donations with Donor and recipient names

CREATE VIEW "s_r_donations" AS
SELECT
"donations"."id" AS "donation_id",
"donations"."sponsor_id" AS "sponsor_id",
"donations"."recipient_id" AS "recipient_id",
"donations"."amount" AS "donation_amount",
"donations"."donation_timestamp",
"sponsors"."first_name" AS "sponsor_first_name",
"sponsors"."last_name" AS "sponsor_last_name",
"recipients"."first_name" AS "recipient_first_name",
"recipients"."last_name" AS "recipient_last_name"
FROM
"donations" LEFT JOIN "sponsors" ON "sponsors"."id" = "donations"."sponsor_id"
LEFT JOIN "recipients" ON "recipients"."id"="donations"."recipient_id";


-- A view showing the totals donations each recipient has recieved

CREATE VIEW "recipient_totals" AS
SELECT "recipients"."id", "recipients"."first_name", "recipients"."last_name", SUM(donations.amount) AS total_donated
FROM "recipients" JOIN "donations" on "recipients"."id" = "donations"."recipient_id"
GROUP BY "recipients"."id", "recipients"."first_name", "recipients"."last_name";


-- A view showing the totals each Sponsor has donated

CREATE VIEW "sponsor_totals" AS
SELECT "sponsors"."id", "sponsors"."first_name", "sponsors"."last_name", SUM(donations.amount) AS total_donated
FROM "sponsors" JOIN "donations" on "sponsors"."id" = "donations"."sponsor_id"
GROUP BY "sponsors"."id", "sponsors"."first_name", "sponsors"."last_name"
;


--INDEX--

--Create indexes for volunteers, sponsors, recipients, and guardians based on last name then first name.
CREATE INDEX "volunteers_index" ON "volunteers" ("last_name","first_name");
CREATE INDEX "sponsors_index" ON "sponsors" ("last_name","first_name");
CREATE INDEX "recipients_index" ON "recipients" ("last_name","first_name");
CREATE INDEX "guardians_index" ON "guardians" ("last_name","first_name");









