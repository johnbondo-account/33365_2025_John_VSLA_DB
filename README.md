# Community Savings Group (VSLA) Management System

An Oracle Database project developed to manage the operations of a Village Savings and Loan Association (VSLA). The system automates member management, savings contributions, loans, repayments, penalties, share-outs, and audit logging using SQL and PL/SQL.

## Project Information

| Item | Details |
|------|---------|
| Project Name | 33365_2025_JOHN_VSLA_DB |
| Database | Oracle Database XE 21c |
| Schema | VSLA_33365_2025_JOHN_DB |
| Language | SQL & PL/SQL |
| Developer | John Bondo |

---

## Features

- Member Management
- Savings Contributions
- Loan Applications
- Loan Disbursement
- Loan Repayments
- Penalty Management
- Share-Out Management
- Audit Logging
- Security Controls
- Stored Procedures
- Functions
- Packages
- Triggers
- Reports and Views

---

## Technologies Used

- Oracle Database XE 21c
- Oracle SQL Developer
- SQL
- PL/SQL
- GitHub

---

## Project Structure

```
vsla-management-system/
│
├── README.md
├── sql/
│   ├── 01_create_project_user.sql
│   ├── 02_create_core_tables.sql
│   ├── 03_create_financial_tables.sql
│   ├── 04_create_control_tables.sql
│   ├── 05_insert_sample_data.sql
│   ├── 06_plsql_programs.sql
│   ├── 07_triggers_audit_security.sql
│   ├── 08_queries_views_reports.sql
│   ├── 09_plsql_demo.sql
│   ├── 10_audit_demo.sql
│   ├── 11_align_identity_columns.sql
│   ├── 12_security_demo.sql
│   └── 13_final_verification.sql
│
├── diagrams/
├── screenshots/
└── docs/
```

## Capstone Documentation

- [Problem statement and analysis](docs/01_problem_statement.md)
- [Business process explanation](docs/02_business_process_explanation.md)
- [Normalization to 3NF](docs/03_normalization_to_3nf.md)
- [Logical ERD](diagrams/vsla_erd.md)
- [Screenshot checklist](screenshots/README.md)

---

## Database Modules

- Savings Groups
- Members
- Meetings
- Contributions
- Loan Applications
- Loans
- Loan Repayments
- Penalties
- Share-Outs
- Public Holidays
- Audit Log

---

## Installation

1. Create the Oracle user.
2. Connect to the project schema.
3. Execute the SQL scripts in numerical order.
4. Run the verification script.
5. Review the generated reports.

---

## Learning Outcomes

This project demonstrates:

- Relational Database Design
- Primary and Foreign Keys
- Constraints
- Views
- Stored Procedures
- Functions
- Packages
- Triggers
- Exception Handling
- Audit Logging
- Database Security
- SQL Reporting

---

## Future Improvements

- Oracle APEX Web Interface
- Mobile Money Integration
- SMS Notifications
- Dashboard Analytics
- Multi-Group Support

---

## License

This project was developed for academic purposes.
