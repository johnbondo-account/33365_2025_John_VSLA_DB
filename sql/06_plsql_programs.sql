-- Run while connected as VSLA_33365_2025_JOHN_DB in XEPDB1.
-- Functions, procedures, cursor reporting, exception handling, and package.

CREATE OR REPLACE FUNCTION fn_member_savings_balance (
    p_member_id IN members.member_id%TYPE
) RETURN NUMBER
IS
    v_total NUMBER(12,2);
BEGIN
    SELECT NVL(SUM(contribution_amount), 0)
    INTO v_total
    FROM contributions
    WHERE member_id = p_member_id;

    RETURN v_total;
END;
/

CREATE OR REPLACE FUNCTION fn_loan_outstanding_balance (
    p_loan_id IN loans.loan_id%TYPE
) RETURN NUMBER
IS
    v_total_due       NUMBER(12,2);
    v_total_repaid    NUMBER(12,2);
    v_unpaid_penalty  NUMBER(12,2);
BEGIN
    SELECT principal_amount * (1 + interest_rate / 100)
    INTO v_total_due
    FROM loans
    WHERE loan_id = p_loan_id;

    SELECT NVL(SUM(repayment_amount), 0)
    INTO v_total_repaid
    FROM loan_repayments
    WHERE loan_id = p_loan_id;

    SELECT NVL(SUM(penalty_amount), 0)
    INTO v_unpaid_penalty
    FROM penalties
    WHERE loan_id = p_loan_id
      AND penalty_status = 'UNPAID';

    RETURN ROUND(v_total_due + v_unpaid_penalty - v_total_repaid, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'Loan ID ' || p_loan_id || ' does not exist.');
END;
/

CREATE OR REPLACE PROCEDURE pr_register_contribution (
    p_meeting_id          IN contributions.meeting_id%TYPE,
    p_member_id           IN contributions.member_id%TYPE,
    p_contribution_amount IN contributions.contribution_amount%TYPE,
    p_payment_method      IN contributions.payment_method%TYPE,
    p_received_by_user_id IN contributions.received_by_user_id%TYPE
)
IS
    v_member_status members.membership_status%TYPE;
BEGIN
    SELECT membership_status
    INTO v_member_status
    FROM members
    WHERE member_id = p_member_id;

    IF v_member_status <> 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20011, 'Only an active member can make a contribution.');
    END IF;

    IF p_contribution_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Contribution amount must be greater than zero.');
    END IF;

    INSERT INTO contributions (
        meeting_id, member_id, contribution_amount, payment_method, received_by_user_id
    ) VALUES (
        p_meeting_id, p_member_id, p_contribution_amount, p_payment_method, p_received_by_user_id
    );

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20013, 'The supplied member does not exist.');
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20014, 'This member already has a contribution for this meeting.');
END;
/

CREATE OR REPLACE PROCEDURE pr_record_loan_repayment (
    p_loan_id              IN loan_repayments.loan_id%TYPE,
    p_repayment_amount     IN loan_repayments.repayment_amount%TYPE,
    p_payment_method       IN loan_repayments.payment_method%TYPE,
    p_received_by_user_id  IN loan_repayments.received_by_user_id%TYPE,
    p_receipt_number       IN loan_repayments.receipt_number%TYPE
)
IS
    v_outstanding_balance NUMBER(12,2);
BEGIN
    v_outstanding_balance := fn_loan_outstanding_balance(p_loan_id);

    IF p_repayment_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20015, 'Repayment amount must be greater than zero.');
    ELSIF p_repayment_amount > v_outstanding_balance THEN
        RAISE_APPLICATION_ERROR(-20016, 'Repayment cannot exceed the outstanding loan balance.');
    END IF;

    INSERT INTO loan_repayments (
        loan_id, repayment_amount, payment_method, received_by_user_id, receipt_number
    ) VALUES (
        p_loan_id, p_repayment_amount, p_payment_method, p_received_by_user_id, p_receipt_number
    );

    IF fn_loan_outstanding_balance(p_loan_id) = 0 THEN
        UPDATE loans
        SET loan_status = 'PAID'
        WHERE loan_id = p_loan_id;
    END IF;

    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE pr_member_financial_summary
IS
    CURSOR c_member_summary IS
        SELECT m.member_number,
               m.first_name || ' ' || m.last_name AS member_name,
               fn_member_savings_balance(m.member_id) AS savings_total,
               NVL((SELECT SUM(fn_loan_outstanding_balance(l.loan_id))
                    FROM loans l
                    WHERE l.member_id = m.member_id
                      AND l.loan_status IN ('ACTIVE', 'OVERDUE')), 0) AS loan_balance
        FROM members m
        ORDER BY m.member_number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('MEMBER FINANCIAL SUMMARY');
    DBMS_OUTPUT.PUT_LINE('------------------------');

    FOR r_member IN c_member_summary LOOP
        DBMS_OUTPUT.PUT_LINE(
            r_member.member_number || ' | ' || r_member.member_name ||
            ' | Savings: ' || r_member.savings_total ||
            ' | Loan balance: ' || r_member.loan_balance
        );
    END LOOP;
END;
/

CREATE OR REPLACE PACKAGE vsla_finance_pkg AS
    FUNCTION total_group_savings (
        p_group_id IN savings_groups.group_id%TYPE
    ) RETURN NUMBER;

    PROCEDURE apply_late_penalty (
        p_loan_id        IN penalties.loan_id%TYPE,
        p_penalty_amount IN penalties.penalty_amount%TYPE,
        p_remarks        IN penalties.remarks%TYPE
    );
END vsla_finance_pkg;
/

CREATE OR REPLACE PACKAGE BODY vsla_finance_pkg AS
    FUNCTION total_group_savings (
        p_group_id IN savings_groups.group_id%TYPE
    ) RETURN NUMBER
    IS
        v_total NUMBER(12,2);
    BEGIN
        SELECT NVL(SUM(c.contribution_amount), 0)
        INTO v_total
        FROM contributions c
        JOIN members m ON m.member_id = c.member_id
        WHERE m.group_id = p_group_id;

        RETURN v_total;
    END total_group_savings;

    PROCEDURE apply_late_penalty (
        p_loan_id        IN penalties.loan_id%TYPE,
        p_penalty_amount IN penalties.penalty_amount%TYPE,
        p_remarks        IN penalties.remarks%TYPE
    )
    IS
    BEGIN
        IF p_penalty_amount <= 0 THEN
            RAISE_APPLICATION_ERROR(-20017, 'Penalty amount must be greater than zero.');
        END IF;

        INSERT INTO penalties (loan_id, penalty_type, penalty_amount, remarks)
        VALUES (p_loan_id, 'LATE_REPAYMENT', p_penalty_amount, p_remarks);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20018, 'A duplicate penalty could not be created.');
    END apply_late_penalty;
END vsla_finance_pkg;
/

-- Test queries for presentation evidence.
SELECT fn_member_savings_balance(1) AS member_1_savings FROM dual;
SELECT fn_loan_outstanding_balance(1) AS loan_1_outstanding_balance FROM dual;
SELECT vsla_finance_pkg.total_group_savings(1) AS total_group_savings FROM dual;
