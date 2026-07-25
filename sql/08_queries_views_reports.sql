-- Run while connected as VSLA_33365_2025_JOHN_DB in XEPDB1.
-- Views and reporting queries for documentation, presentation, and APEX.

CREATE OR REPLACE VIEW vw_member_financial_summary AS
SELECT m.member_id,
       m.member_number,
       m.first_name || ' ' || m.last_name AS member_name,
       g.group_name,
       m.membership_status,
       NVL((SELECT SUM(c.contribution_amount)
            FROM contributions c
            WHERE c.member_id = m.member_id), 0) AS total_contributions,
       NVL((SELECT SUM(l.principal_amount * (1 + l.interest_rate / 100))
            FROM loans l
            WHERE l.member_id = m.member_id), 0) AS total_loan_due,
       NVL((SELECT SUM(r.repayment_amount)
            FROM loan_repayments r
            JOIN loans l ON l.loan_id = r.loan_id
            WHERE l.member_id = m.member_id), 0) AS total_repayments
FROM members m
JOIN savings_groups g ON g.group_id = m.group_id;

-- 1. Member register
SELECT member_number,
       first_name || ' ' || last_name AS member_name,
       phone_number,
       membership_status
FROM members
ORDER BY member_number;

-- 2. Contribution totals per member
SELECT member_number,
       member_name,
       total_contributions
FROM vw_member_financial_summary
ORDER BY total_contributions DESC;

-- 3. Group savings by payment method
SELECT payment_method,
       COUNT(*) AS transaction_count,
       SUM(contribution_amount) AS total_collected
FROM contributions
GROUP BY payment_method
ORDER BY total_collected DESC;

-- 4. Loan and repayment status
SELECT l.loan_id,
       m.first_name || ' ' || m.last_name AS member_name,
       l.principal_amount,
       l.interest_rate,
       l.loan_status,
       fn_loan_outstanding_balance(l.loan_id) AS outstanding_balance
FROM loans l
JOIN members m ON m.member_id = l.member_id
ORDER BY l.loan_id;

-- 5. Pending or unpaid penalties
SELECT p.penalty_id,
       m.first_name || ' ' || m.last_name AS member_name,
       p.penalty_type,
       p.penalty_amount,
       p.penalty_status
FROM penalties p
JOIN loans l ON l.loan_id = p.loan_id
JOIN members m ON m.member_id = l.member_id
WHERE p.penalty_status = 'UNPAID'
ORDER BY p.penalty_date;

-- 6. Loan applications awaiting a decision
SELECT la.application_id,
       m.first_name || ' ' || m.last_name AS member_name,
       la.requested_amount,
       la.loan_purpose,
       la.application_status
FROM loan_applications la
JOIN members m ON m.member_id = la.member_id
WHERE la.application_status = 'PENDING';

-- 7. Financial dashboard KPIs
SELECT
    (SELECT NVL(SUM(contribution_amount), 0) FROM contributions) AS total_savings,
    (SELECT NVL(SUM(principal_amount), 0) FROM loans) AS total_principal_disbursed,
    (SELECT NVL(SUM(repayment_amount), 0) FROM loan_repayments) AS total_repayments,
    (SELECT NVL(SUM(penalty_amount), 0) FROM penalties WHERE penalty_status = 'UNPAID') AS unpaid_penalties
FROM dual;

-- 8. Public-holiday reference data used by the security rule
SELECT holiday_date, holiday_name, description
FROM public_holidays
ORDER BY holiday_date;

-- 9. Audit trail
SELECT audit_id, table_name, action_type, record_key, changed_by, changed_at
FROM audit_log
ORDER BY changed_at DESC;

-- 10. Members whose savings exceed the group average (subquery example)
SELECT member_number, member_name, total_contributions
FROM vw_member_financial_summary
WHERE total_contributions > (
    SELECT AVG(total_contributions)
    FROM vw_member_financial_summary
)
ORDER BY total_contributions DESC;
