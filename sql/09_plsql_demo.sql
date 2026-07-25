-- Run while connected as VSLA_33365_2025_JOHN_DB in XEPDB1.
-- Read-only PL/SQL demonstration for the presentation.

SET SERVEROUTPUT ON;

PROMPT === CURSOR REPORT: MEMBER FINANCIAL SUMMARY ===
BEGIN
    pr_member_financial_summary;
END;
/

PROMPT === FUNCTION: MEMBER SAVINGS BALANCE ===
SELECT fn_member_savings_balance(1) AS member_1_savings_balance
FROM dual;

PROMPT === FUNCTION: LOAN OUTSTANDING BALANCE ===
SELECT fn_loan_outstanding_balance(1) AS loan_1_outstanding_balance
FROM dual;

PROMPT === PACKAGE FUNCTION: TOTAL GROUP SAVINGS ===
SELECT vsla_finance_pkg.total_group_savings(1) AS total_group_savings
FROM dual;

PROMPT === AUDIT-TRAIL STATUS ===
SELECT COUNT(*) AS audit_records_created
FROM audit_log;
