-- Run while connected as VSLA_33365_2025_JOHN_DB in XEPDB1.
-- Run this on a Saturday/Sunday that is not listed in PUBLIC_HOLIDAYS.
-- It creates one demonstration contribution and proves that the audit trigger works.

SET SERVEROUTPUT ON;

DECLARE
    v_meeting_id NUMBER;
BEGIN
    INSERT INTO meetings (group_id, meeting_date, venue, meeting_status, notes)
    VALUES (
        1,
        SYSDATE,
        'Gasabo Community Hall',
        'COMPLETED',
        'Audit demonstration meeting.'
    )
    RETURNING meeting_id INTO v_meeting_id;

    pr_register_contribution(
        p_meeting_id          => v_meeting_id,
        p_member_id           => 1,
        p_contribution_amount => 5000,
        p_payment_method      => 'CASH',
        p_received_by_user_id => 3
    );

    DBMS_OUTPUT.PUT_LINE('Audit demonstration contribution created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected security or validation message: ' || SQLERRM);
        ROLLBACK;
END;
/

SELECT audit_id,
       table_name,
       action_type,
       record_key,
       new_values,
       changed_by,
       changed_at
FROM audit_log
WHERE table_name = 'CONTRIBUTIONS'
ORDER BY audit_id DESC;
