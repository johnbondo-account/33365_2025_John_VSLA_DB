# Phase III – Logical Database Design

## 1. Overview

The logical database design for the Village Savings and Loan Association (VSLA) Management System defines the structure of the Oracle database used to manage members, savings groups, financial transactions, and administrative activities. The design organizes data into related tables with clearly defined primary keys and foreign keys to ensure data integrity, minimize redundancy, and support efficient querying.

The database has been normalized to Third Normal Form (3NF), ensuring that each table stores data about a single entity while relationships between entities are maintained through foreign keys.

---

## 2. Database Tables

The Village Savings and Loan Association (VSLA) Management System is implemented using twelve (12) relational tables. Each table represents a specific business entity and is linked to other tables through primary key and foreign key relationships.

| Table Name | Purpose |
|------------|---------|
| SAVINGS_GROUPS | Stores information about each savings group. |
| MEMBERS | Stores personal information about members belonging to savings groups. |
| APP_USERS | Stores user accounts that access the system. |
| CONTRIBUTIONS | Records members' savings contributions. |
| LOAN_APPLICATIONS | Stores loan applications submitted by members. |
| LOANS | Stores approved loan information. |
| LOAN_REPAYMENTS | Records loan repayment transactions. |
| PENALTIES | Stores penalties issued to members. |
| MEETINGS | Stores scheduled savings group meetings. |
| SHARE_OUTS | Records the distribution of savings at the end of a savings cycle. |
| PUBLIC_HOLIDAYS | Stores public holiday information used by the system. |
| AUDIT_LOG | Stores audit records of important database activities. |

---

## 3. Primary Keys and Foreign Keys

The VSLA Management System uses primary keys to uniquely identify records in each table and foreign keys to establish relationships between related tables. These relationships ensure referential integrity and support efficient data retrieval.

| Table | Primary Key | Foreign Key(s) |
|--------|-------------|----------------|
| SAVINGS_GROUPS | group_id | — |
| MEMBERS | member_id | group_id |
| APP_USERS | user_id | member_id |
| CONTRIBUTIONS | contribution_id | member_id, group_id |
| LOAN_APPLICATIONS | application_id | member_id, group_id, approved_by_user_id |
| LOANS | loan_id | application_id |
| LOAN_REPAYMENTS | repayment_id | loan_id |
| PENALTIES | penalty_id | member_id |
| MEETINGS | meeting_id | group_id |
| SHARE_OUTS | share_out_id | member_id, group_id |
| PUBLIC_HOLIDAYS | holiday_id | — |
| AUDIT_LOG | audit_id | user_id |

---

## 4. Entity Relationships

The tables in the VSLA Management System are connected through foreign key relationships that maintain consistency and prevent invalid data entries.

The major relationships are:

- One savings group can have many members.
- One member can make many savings contributions.
- One member can submit many loan applications.
- One approved loan application results in one loan.
- One loan can have many repayment records.
- One member can receive many penalties.
- One savings group can organize many meetings.
- One member can receive one or more share-out records.
- One member can have one user account.
- One system user can generate many audit log records.

These relationships ensure that all financial and administrative records remain linked to the correct members and savings groups while maintaining referential integrity throughout the database.

---

## 5. Database Normalization

The VSLA Management System database has been designed and normalized to **Third Normal Form (3NF)** to reduce data redundancy, improve consistency, and maintain data integrity.

### First Normal Form (1NF)

The database satisfies First Normal Form because:
- Each table has a primary key.
- Each column contains a single (atomic) value.
- There are no repeating groups or multi-valued attributes.

### Second Normal Form (2NF)

The database satisfies Second Normal Form because:
- All non-key attributes are fully dependent on their respective primary keys.
- Since each table uses a single-column primary key, there are no partial dependencies.

### Third Normal Form (3NF)

The database satisfies Third Normal Form because:
- Non-key attributes depend only on the primary key.
- There are no transitive dependencies between non-key attributes.
- Each table represents a single business entity, such as Members, Contributions, Loans, Meetings, or Share-Outs.

Normalization improves data integrity, minimizes redundancy, and ensures that updates, insertions, and deletions can be performed efficiently without introducing inconsistencies.

---

## 6. Entity Relationship Diagram (ERD)

![VSLA ER Diagram](../diagrams/VSLA_ER_Diagram.png)
