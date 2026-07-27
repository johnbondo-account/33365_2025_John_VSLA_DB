PROMPT === TABLES ===
SELECT table_name
FROM user_tables
ORDER BY table_name;

PROMPT === PL/SQL OBJECTS ===
SELECT object_type, object_name, status
FROM user_objects
WHERE object_type IN ('FUNCTION', 'PROCEDURE', 'PACKAGE', 'PACKAGE BODY')
ORDER BY object_type, object_name;

PROMPT === TRIGGERS ===
SELECT trigger_name, table_name, triggering_event, status
FROM user_triggers
ORDER BY trigger_name;

PROMPT === CORE RECORD COUNTS ===
SELECT 'SAVINGS_GROUPS' AS item, COUNT(*) AS record_count FROM savings_groups
UNION ALL SELECT 'MEMBERS', COUNT(*) FROM members
UNION ALL SELECT 'MEETINGS', COUNT(*) FROM meetings
UNION ALL SELECT 'CONTRIBUTIONS', COUNT(*) FROM contributions
UNION ALL SELECT 'LOAN_APPLICATIONS', COUNT(*) FROM loan_applications
UNION ALL SELECT 'LOANS', COUNT(*) FROM loans
UNION ALL SELECT 'LOAN_REPAYMENTS', COUNT(*) FROM loan_repayments
UNION ALL SELECT 'AUDIT_LOG', COUNT(*) FROM audit_log;

PROMPT === FINAL DASHBOARD KPIs ===
SELECT
    (SELECT NVL(SUM(contribution_amount), 0) FROM contributions) AS total_savings,
    (SELECT NVL(SUM(principal_amount), 0) FROM loans) AS total_principal_disbursed,
    (SELECT NVL(SUM(repayment_amount), 0) FROM loan_repayments) AS total_repayments,
    (SELECT NVL(SUM(penalty_amount), 0) FROM penalties WHERE penalty_status = 'UNPAID') AS unpaid_penalties
FROM dual;
