-- Run while connected as VSLA_33365_2025_JOHN_DB in XEPDB1.
-- Demonstration data only. Do not use real personal or financial information.

INSERT INTO savings_groups (
    group_id, group_name, location, formation_date, cycle_start_date, cycle_end_date, group_status
) VALUES (
    1, 'Twizigamire Savings Group', 'Kigali, Gasabo', DATE '2026-01-10',
    DATE '2026-01-10', DATE '2026-12-31', 'ACTIVE'
);

INSERT INTO members (member_id, group_id, member_number, first_name, last_name, phone_number, national_id, join_date, membership_status)
VALUES (1, 1, 'M001', 'Aline', 'Uwase', '0788000001', 'DEMO-NID-001', DATE '2026-01-10', 'ACTIVE');

INSERT INTO members (member_id, group_id, member_number, first_name, last_name, phone_number, national_id, join_date, membership_status)
VALUES (2, 1, 'M002', 'Eric', 'Niyonzima', '0788000002', 'DEMO-NID-002', DATE '2026-01-10', 'ACTIVE');

INSERT INTO members (member_id, group_id, member_number, first_name, last_name, phone_number, national_id, join_date, membership_status)
VALUES (3, 1, 'M003', 'Claudine', 'Mukamana', '0788000003', 'DEMO-NID-003', DATE '2026-01-10', 'ACTIVE');

INSERT INTO members (member_id, group_id, member_number, first_name, last_name, phone_number, national_id, join_date, membership_status)
VALUES (4, 1, 'M004', 'Patrick', 'Habimana', '0788000004', 'DEMO-NID-004', DATE '2026-01-10', 'ACTIVE');

INSERT INTO app_users (user_id, member_id, username, full_name, user_role, user_status)
VALUES (1, NULL, 'vsla_admin', 'VSLA Administrator', 'ADMINISTRATOR', 'ACTIVE');

INSERT INTO app_users (user_id, member_id, username, full_name, user_role, user_status)
VALUES (2, 1, 'aline_leader', 'Aline Uwase', 'GROUP_LEADER', 'ACTIVE');

INSERT INTO app_users (user_id, member_id, username, full_name, user_role, user_status)
VALUES (3, 2, 'eric_treasurer', 'Eric Niyonzima', 'TREASURER', 'ACTIVE');

INSERT INTO meetings (meeting_id, group_id, meeting_date, venue, meeting_status, notes)
VALUES (1, 1, DATE '2026-02-07', 'Gasabo Community Hall', 'COMPLETED', 'First monthly savings meeting.');

INSERT INTO meetings (meeting_id, group_id, meeting_date, venue, meeting_status, notes)
VALUES (2, 1, DATE '2026-03-07', 'Gasabo Community Hall', 'COMPLETED', 'Second monthly savings meeting.');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (1, 1, 1, 10000, 'MOBILE_MONEY', 3, DATE '2026-02-07');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (2, 1, 2, 10000, 'CASH', 3, DATE '2026-02-07');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (3, 1, 3, 12000, 'MOBILE_MONEY', 3, DATE '2026-02-07');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (4, 1, 4, 10000, 'CASH', 3, DATE '2026-02-07');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (5, 2, 1, 10000, 'MOBILE_MONEY', 3, DATE '2026-03-07');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (6, 2, 2, 10000, 'CASH', 3, DATE '2026-03-07');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (7, 2, 3, 12000, 'MOBILE_MONEY', 3, DATE '2026-03-07');

INSERT INTO contributions (contribution_id, meeting_id, member_id, contribution_amount, payment_method, received_by_user_id, contribution_date)
VALUES (8, 2, 4, 10000, 'CASH', 3, DATE '2026-03-07');

INSERT INTO loan_applications (
    application_id, member_id, application_date, requested_amount, loan_purpose,
    application_status, approved_amount, approved_by_user_id, approval_date
) VALUES (
    1, 3, DATE '2026-03-07', 30000, 'Purchase stock for a small business.',
    'APPROVED', 30000, 2, DATE '2026-03-07'
);

INSERT INTO loans (
    loan_id, application_id, member_id, principal_amount, interest_rate,
    disbursement_date, due_date, loan_status
) VALUES (
    1, 1, 3, 30000, 5, DATE '2026-03-08', DATE '2026-06-08', 'ACTIVE'
);

INSERT INTO loan_repayments (
    repayment_id, loan_id, repayment_date, repayment_amount, payment_method,
    received_by_user_id, receipt_number, remarks
) VALUES (
    1, 1, DATE '2026-04-08', 10000, 'MOBILE_MONEY', 3, 'RCP-0001', 'First loan repayment.'
);

INSERT INTO penalties (penalty_id, loan_id, penalty_type, penalty_amount, penalty_date, penalty_status, remarks)
VALUES (1, 1, 'LATE_REPAYMENT', 1000, DATE '2026-05-10', 'UNPAID', 'Late repayment penalty for demonstration.');

INSERT INTO share_outs (share_out_id, group_id, member_id, cycle_end_date, share_amount, payment_status, paid_date, paid_by_user_id)
VALUES (1, 1, 4, DATE '2026-12-31', 45000, 'PENDING', NULL, NULL);

INSERT INTO public_holidays (holiday_id, holiday_date, holiday_name, description)
VALUES (1, DATE '2026-01-01', 'New Year''s Day', 'Demonstration public holiday.');

INSERT INTO public_holidays (holiday_id, holiday_date, holiday_name, description)
VALUES (2, DATE '2026-07-01', 'Independence Day', 'Demonstration public holiday.');

COMMIT;

-- The explicit IDs above make the demo easier to read. Align each identity
-- generator with the largest inserted ID so later inserts generate new IDs.
ALTER TABLE savings_groups MODIFY group_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE members MODIFY member_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE app_users MODIFY user_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE meetings MODIFY meeting_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE contributions MODIFY contribution_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE loan_applications MODIFY application_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE loans MODIFY loan_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE loan_repayments MODIFY repayment_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE penalties MODIFY penalty_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE share_outs MODIFY share_out_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);
ALTER TABLE public_holidays MODIFY holiday_id GENERATED BY DEFAULT AS IDENTITY (START WITH LIMIT VALUE);

SELECT 'SAVINGS_GROUPS' AS item, COUNT(*) AS record_count FROM savings_groups
UNION ALL SELECT 'MEMBERS', COUNT(*) FROM members
UNION ALL SELECT 'MEETINGS', COUNT(*) FROM meetings
UNION ALL SELECT 'CONTRIBUTIONS', COUNT(*) FROM contributions
UNION ALL SELECT 'LOANS', COUNT(*) FROM loans
UNION ALL SELECT 'LOAN_REPAYMENTS', COUNT(*) FROM loan_repayments
UNION ALL SELECT 'PUBLIC_HOLIDAYS', COUNT(*) FROM public_holidays;
