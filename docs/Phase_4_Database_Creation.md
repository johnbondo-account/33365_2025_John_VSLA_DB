# Phase IV – Database Creation

## 1. Overview

The Village Savings and Loan Association (VSLA) Management System was implemented using Oracle Database. The database was created using SQL Data Definition Language (DDL) statements to define tables, constraints, and relationships. The implementation follows a structured approach to ensure data integrity, consistency, and efficient management of savings group operations.

The database consists of twelve (12) relational tables that support member management, savings contributions, loan processing, repayments, meetings, penalties, share-outs, audit logging, and user management.

---

## 2. Database Objects

The database implementation includes the following major objects:

| Database Object | Description |
|-----------------|-------------|
| Tables | Store business data for the VSLA Management System. |
| Primary Keys | Uniquely identify records in each table. |
| Foreign Keys | Maintain relationships between related tables. |
| Constraints | Enforce business rules and data integrity. |
| Sequences | Generate unique identifiers for database records. |
| Triggers | Automate database operations and auditing. |
| Procedures | Execute predefined business operations. |
| Functions | Return calculated values used by the application. |
| Packages | Group related PL/SQL procedures and functions. |
| Views | Present selected database information for reporting. |

---

## 3. Database Implementation Files

The database was implemented using a collection of SQL and PL/SQL scripts stored in the project's `sql` directory. These scripts were executed in sequence to create the Oracle database structure, insert sample data, and implement business logic.

The implementation includes:

- Database table creation scripts
- Constraint definitions
- Sample data insertion scripts
- Sequences
- Triggers
- Stored procedures
- Functions
- Packages
- Views

  
