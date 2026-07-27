CREATE OR REPLACE PROCEDURE pr_enforce_dml_window
IS
    v_holiday_count NUMBER;
    v_day_name      VARCHAR2(10);
BEGIN
    v_day_name := TRIM(TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'));

    IF v_day_name IN ('MON', 'TUE', 'WED', 'THU', 'FRI') THEN
        RAISE_APPLICATION_ERROR(
            -20030,
            'Financial changes are blocked on weekdays. Please try on a permitted day.'
        );
    END IF;

    SELECT COUNT(*)
    INTO v_holiday_count
    FROM public_holidays
    WHERE holiday_date = TRUNC(SYSDATE);

    IF v_holiday_count > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20031,
            'Financial changes are blocked on public holidays.'
        );
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_update_loan_status
FOR INSERT OR UPDATE OR DELETE ON loan_repayments
COMPOUND TRIGGER
    TYPE t_loan_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    g_loan_ids   t_loan_ids;
    g_count      PLS_INTEGER := 0;

    PROCEDURE remember_loan (p_loan_id IN NUMBER) IS
    BEGIN
        IF p_loan_id IS NOT NULL THEN
            g_count := g_count + 1;
            g_loan_ids(g_count) := p_loan_id;
        END IF;
    END remember_loan;

    AFTER EACH ROW IS
    BEGIN
        IF INSERTING OR UPDATING THEN
            remember_loan(:NEW.loan_id);
        END IF;

        IF DELETING OR UPDATING THEN
            remember_loan(:OLD.loan_id);
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. g_count LOOP
            UPDATE loans
            SET loan_status = CASE
                WHEN fn_loan_outstanding_balance(g_loan_ids(i)) <= 0 THEN 'PAID'
                WHEN due_date < TRUNC(SYSDATE) THEN 'OVERDUE'
                ELSE 'ACTIVE'
            END
            WHERE loan_id = g_loan_ids(i);
        END LOOP;
    END AFTER STATEMENT;
END trg_update_loan_status;
/

CREATE OR REPLACE TRIGGER trg_audit_contributions
AFTER INSERT OR UPDATE OR DELETE ON contributions
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO audit_log (table_name, action_type, record_key, new_values)
        VALUES ('CONTRIBUTIONS', 'INSERT', :NEW.contribution_id,
                'Member=' || :NEW.member_id || '; Amount=' || :NEW.contribution_amount);
    ELSIF UPDATING THEN
        INSERT INTO audit_log (table_name, action_type, record_key, old_values, new_values)
        VALUES ('CONTRIBUTIONS', 'UPDATE', :NEW.contribution_id,
                'Amount=' || :OLD.contribution_amount,
                'Amount=' || :NEW.contribution_amount);
    ELSE
        INSERT INTO audit_log (table_name, action_type, record_key, old_values)
        VALUES ('CONTRIBUTIONS', 'DELETE', :OLD.contribution_id,
                'Member=' || :OLD.member_id || '; Amount=' || :OLD.contribution_amount);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_audit_repayments
AFTER INSERT ON loan_repayments
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_key, new_values)
    VALUES ('LOAN_REPAYMENTS', 'INSERT', :NEW.repayment_id,
            'Loan=' || :NEW.loan_id || '; Amount=' || :NEW.repayment_amount || '; Receipt=' || :NEW.receipt_number);
END;
/

CREATE OR REPLACE TRIGGER trg_audit_loans
AFTER INSERT OR UPDATE OR DELETE ON loans
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO audit_log (table_name, action_type, record_key, new_values)
        VALUES ('LOANS', 'INSERT', :NEW.loan_id,
                'Member=' || :NEW.member_id || '; Principal=' || :NEW.principal_amount || '; Status=' || :NEW.loan_status);
    ELSIF UPDATING THEN
        INSERT INTO audit_log (table_name, action_type, record_key, old_values, new_values)
        VALUES ('LOANS', 'UPDATE', :NEW.loan_id,
                'Status=' || :OLD.loan_status,
                'Status=' || :NEW.loan_status);
    ELSE
        INSERT INTO audit_log (table_name, action_type, record_key, old_values)
        VALUES ('LOANS', 'DELETE', :OLD.loan_id,
                'Member=' || :OLD.member_id || '; Principal=' || :OLD.principal_amount);
    END IF;
END;
/

-- Required DML restriction: financial tables cannot be changed on weekdays
-- or on dates recorded in PUBLIC_HOLIDAYS.
CREATE OR REPLACE TRIGGER trg_restrict_contribution_dml
BEFORE INSERT OR UPDATE OR DELETE ON contributions
BEGIN
    pr_enforce_dml_window;
END;
/

CREATE OR REPLACE TRIGGER trg_restrict_loan_application_dml
BEFORE INSERT OR UPDATE OR DELETE ON loan_applications
BEGIN
    pr_enforce_dml_window;
END;
/

CREATE OR REPLACE TRIGGER trg_restrict_loans_dml
BEFORE INSERT OR UPDATE OR DELETE ON loans
BEGIN
    pr_enforce_dml_window;
END;
/

CREATE OR REPLACE TRIGGER trg_restrict_repayments_dml
BEFORE INSERT OR UPDATE OR DELETE ON loan_repayments
BEGIN
    pr_enforce_dml_window;
END;
/

CREATE OR REPLACE TRIGGER trg_restrict_penalties_dml
BEFORE INSERT OR UPDATE OR DELETE ON penalties
BEGIN
    pr_enforce_dml_window;
END;
/

CREATE OR REPLACE TRIGGER trg_restrict_share_outs_dml
BEFORE INSERT OR UPDATE OR DELETE ON share_outs
BEGIN
    pr_enforce_dml_window;
END;
/

SELECT trigger_name, triggering_event, status
FROM user_triggers
WHERE trigger_name LIKE 'TRG_%'
ORDER BY trigger_name;
