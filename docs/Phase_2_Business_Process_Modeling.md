# Phase II – Business Process Modeling

## 1. System Scope

The Village Savings and Loan Association (VSLA) Management System is designed to automate the management of savings groups and their financial activities using Oracle Database. The system manages member registration, savings contributions, loan applications, loan approvals, loan repayments, meetings, penalties, share-out transactions, audit logging, and user management. It provides secure storage of financial records, enforces business rules through SQL and PL/SQL, and supports reporting for decision-making.

The system focuses on internal VSLA operations and does not include online banking services, mobile money integration, or external payment gateways.

---

## 2. Actors and Business Processes

The Village Savings and Loan Association (VSLA) Management System involves four main actors who interact with the system to perform different business activities.

### 1. Member

The member participates in the savings group by registering, making savings contributions, applying for loans, repaying loans, attending meetings, and receiving share-out payments at the end of the savings cycle.

### 2. Group Leader

The Group Leader supervises the activities of the savings group, reviews loan applications, oversees meetings, and monitors the overall performance of the group.

### 3. Treasurer

The Treasurer records savings contributions, processes approved loans, records loan repayments, manages penalties, records share-out transactions, and maintains accurate financial records.

### 4. Oracle Database System

The Oracle Database System stores and processes all business transactions. It validates data, updates records, enforces business rules using SQL and PL/SQL, records audit information, and generates reports for decision-making.
