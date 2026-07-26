# Phase III: Normalization to Third Normal Form (3NF)

## First Normal Form (1NF)

Each table has a primary key, each column stores one value only, and there are no repeating groups. For example, a member's contribution records are held as separate rows in `CONTRIBUTIONS`; they are not stored as a list inside the `MEMBERS` table. Loan repayments are likewise held in `LOAN_REPAYMENTS` as individual transactions.

## Second Normal Form (2NF)

All non-key attributes depend on the whole primary key. The design uses single-column surrogate primary keys for its transaction tables, such as `contribution_id`, `application_id`, `loan_id`, and `repayment_id`. Attributes describe the corresponding transaction, rather than a related entity. For example, `repayment_amount` depends on the repayment record, while member details remain in `MEMBERS`.

## Third Normal Form (3NF)

Non-key attributes depend only on the key and not on other non-key attributes. Group details are stored in `SAVINGS_GROUPS`, member details in `MEMBERS`, user details in `APP_USERS`, and meeting details in `MEETINGS`. Financial facts are separated into `CONTRIBUTIONS`, `LOAN_APPLICATIONS`, `LOANS`, `LOAN_REPAYMENTS`, `PENALTIES`, and `SHARE_OUTS`. Public-holiday information is held independently in `PUBLIC_HOLIDAYS`, while audit events are recorded in `AUDIT_LOG`.

For example, `LOANS` references an approved application and the borrowing member by foreign key instead of duplicating the member name or application purpose. `LOAN_REPAYMENTS` references the loan and the receiving user rather than repeating loan or staff details. This reduces update anomalies, avoids redundant data, and maintains referential integrity.

## Design decisions

| Entity | Reason for separation |
|---|---|
| `SAVINGS_GROUPS` and `MEMBERS` | A group has many members; group information is stored once. |
| `MEETINGS` and `CONTRIBUTIONS` | One meeting can receive contributions from many members. |
| `LOAN_APPLICATIONS` and `LOANS` | An application can be reviewed before an approved loan is created. |
| `LOANS` and `LOAN_REPAYMENTS` | One loan can have many repayment transactions. |
| `PUBLIC_HOLIDAYS` and financial tables | The security rule can reuse a central holiday reference table. |
| `AUDIT_LOG` and business tables | Audit history is retained without mixing it into operational records. |
