# Phase VI – PL/SQL Programming

## 1. Overview

The VSLA Management System uses Oracle PL/SQL to automate selected database operations and improve data integrity. PL/SQL program units were implemented to support business processes and reduce manual database operations.

## 2. Trigger Implementation

The project implements an audit trigger named `trg_audit_repayments`.

The trigger executes automatically whenever records in the `LOAN_REPAYMENTS` table are inserted, updated, or deleted. It records the affected transaction in the `AUDIT_LOG` table, allowing the system to maintain an audit trail of repayment activities.

## 3. Benefits of PL/SQL

The PL/SQL implementation provides several advantages:

- Automatic execution of business rules.
- Improved database security.
- Reduced manual processing.
- Consistent audit logging.
- Improved data integrity.

## 4. Summary

The use of PL/SQL improves the reliability of the VSLA Management System by automating important database operations and maintaining an accurate audit history of repayment transactions.
