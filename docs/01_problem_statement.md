# Phase I: Problem Statement and Analysis

## Problem definition

Village Savings and Loan Associations (VSLAs) often manage membership, meeting contributions, loan applications, repayments, penalties, and end-of-cycle share-outs manually. Paper-based records make it difficult to calculate each member's savings, follow outstanding loans, prevent duplicate payments, trace financial changes, and produce timely reports. The result is a risk of inaccurate balances, delayed decisions, and weak accountability.

The Community Savings Group (VSLA) Management System is an Oracle Database solution that centralizes these activities. It records each transaction in a structured form, applies data-integrity rules, calculates balances, maintains an audit trail, and supplies reports for group management.

## Context of use

The system supports a community savings group during its savings cycle. At meetings, members contribute money and may submit loan applications. A group leader reviews applications, the treasurer records approved financial transactions, and the system maintains loan and savings information. At the end of a cycle, the system also records share-outs.

## Target users

| User | Main responsibility |
|---|---|
| Member | Attends meetings, contributes, applies for loans, and makes repayments. |
| Group Leader | Reviews and approves or rejects loan applications. |
| Treasurer | Records contributions, loan disbursements, repayments, penalties, and share-outs. |
| Administrator | Maintains user access, public-holiday data, and audit information. |

## Objectives

1. Maintain accurate records for members, meetings, contributions, loans, repayments, penalties, and share-outs.
2. Enforce business rules through constraints, PL/SQL procedures, packages, and triggers.
3. Calculate member savings and loan outstanding balances reliably.
4. Restrict financial changes on weekdays and public holidays, as specified in the examination brief.
5. Provide reports that support operational and financial decision-making.
6. Keep an audit trail for important financial changes.

## Expected benefits

- Reduced duplicate and invalid transactions through database constraints.
- Faster reporting of savings, loans, repayments, penalties, and group totals.
- Improved traceability through audit logs and controlled user roles.
- More consistent loan-status updates after repayments.
- Better transparency for members and group leadership.
