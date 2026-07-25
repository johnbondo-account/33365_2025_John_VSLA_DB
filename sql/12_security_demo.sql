-- Run while connected as VSLA_33365_2025_JOHN_DB in XEPDB1.
-- Demonstrates the public-holiday DML restriction without leaving test data behind.

SET SERVEROUTPUT ON;

DECLARE
    v_meeting_id        NUMBER;
    v_holiday_exists    NUMBER;
    v_test_holiday_name CONSTANT VARCHAR2(100) := 'TEMPORARY SECURITY DEMO - REMOVE';
    v_added_test_holiday BOOLEAN := FALSE;
BEGIN
    INSERT INTO meetings (group_id, meeting_date, venue, meeting_status, notes)
    VALUES (
        1,
        SYSDATE + (1 / 86400),
        'Gasabo Community Hall',
        'SCHEDULED',
        'Security demonstration meeting.'
    )
    RETURNING meeting_id INTO v_meeting_id;

    SELECT COUNT(*)
    INTO v_holiday_exists
    FROM public_holidays
    WHERE holiday_date = TRUNC(SYSDATE);

    IF v_holiday_exists = 0 THEN
        INSERT INTO public_holidays (holiday_date, holiday_name, description)
        VALUES (TRUNC(SYSDATE), v_test_holiday_name, 'Temporary row for trigger demonstration.');
        v_added_test_holiday := TRUE;
    END IF;

    BEGIN
        pr_register_contribution(
            p_meeting_id          => v_meeting_id,
            p_member_id           => 2,
            p_contribution_amount => 1000,
            p_payment_method      => 'CASH',
            p_received_by_user_id => 3
        );
        DBMS_OUTPUT.PUT_LINE('Unexpected result: the security rule did not block the transaction.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Security rule worked: ' || SQLERRM);
    END;

    IF v_added_test_holiday THEN
        DELETE FROM public_holidays
        WHERE holiday_name = v_test_holiday_name
          AND holiday_date = TRUNC(SYSDATE);
    END IF;

    COMMIT;
END;
/

SELECT holiday_date, holiday_name
FROM public_holidays
WHERE holiday_name = 'TEMPORARY SECURITY DEMO - REMOVE';
