# VSLA Logical Entity-Relationship Diagram

```mermaid
erDiagram
    SAVINGS_GROUPS ||--o{ MEMBERS : contains
    SAVINGS_GROUPS ||--o{ MEETINGS : schedules
    SAVINGS_GROUPS ||--o{ SHARE_OUTS : manages
    MEMBERS ||--o| APP_USERS : may_have
    MEMBERS ||--o{ CONTRIBUTIONS : makes
    MEMBERS ||--o{ LOAN_APPLICATIONS : submits
    MEMBERS ||--o{ LOANS : borrows
    MEMBERS ||--o{ SHARE_OUTS : receives
    MEETINGS ||--o{ CONTRIBUTIONS : collects
    APP_USERS ||--o{ CONTRIBUTIONS : receives
    APP_USERS ||--o{ LOAN_APPLICATIONS : reviews
    APP_USERS ||--o{ LOAN_REPAYMENTS : receives
    APP_USERS ||--o{ SHARE_OUTS : pays
    LOAN_APPLICATIONS ||--o| LOANS : becomes
    LOANS ||--o{ LOAN_REPAYMENTS : has
    LOANS ||--o{ PENALTIES : incurs

    SAVINGS_GROUPS {
        NUMBER group_id PK
        VARCHAR2 group_name UK
        VARCHAR2 location
        DATE cycle_start_date
        DATE cycle_end_date
        VARCHAR2 group_status
    }
    MEMBERS {
        NUMBER member_id PK
        NUMBER group_id FK
        VARCHAR2 member_number
        VARCHAR2 first_name
        VARCHAR2 last_name
        VARCHAR2 membership_status
    }
    APP_USERS {
        NUMBER user_id PK
        NUMBER member_id FK
        VARCHAR2 username UK
        VARCHAR2 user_role
        VARCHAR2 user_status
    }
    MEETINGS {
        NUMBER meeting_id PK
        NUMBER group_id FK
        DATE meeting_date
        VARCHAR2 meeting_status
    }
    CONTRIBUTIONS {
        NUMBER contribution_id PK
        NUMBER meeting_id FK
        NUMBER member_id FK
        NUMBER received_by_user_id FK
        NUMBER contribution_amount
        DATE contribution_date
    }
    LOAN_APPLICATIONS {
        NUMBER application_id PK
        NUMBER member_id FK
        NUMBER approved_by_user_id FK
        NUMBER requested_amount
        NUMBER approved_amount
        VARCHAR2 application_status
    }
    LOANS {
        NUMBER loan_id PK
        NUMBER application_id FK
        NUMBER member_id FK
        NUMBER principal_amount
        NUMBER interest_rate
        DATE due_date
        VARCHAR2 loan_status
    }
    LOAN_REPAYMENTS {
        NUMBER repayment_id PK
        NUMBER loan_id FK
        NUMBER received_by_user_id FK
        NUMBER repayment_amount
        DATE repayment_date
        VARCHAR2 receipt_number UK
    }
    PENALTIES {
        NUMBER penalty_id PK
        NUMBER loan_id FK
        VARCHAR2 penalty_type
        NUMBER penalty_amount
        VARCHAR2 penalty_status
    }
    SHARE_OUTS {
        NUMBER share_out_id PK
        NUMBER group_id FK
        NUMBER member_id FK
        NUMBER paid_by_user_id FK
        NUMBER share_amount
        VARCHAR2 payment_status
    }
    PUBLIC_HOLIDAYS {
        NUMBER holiday_id PK
        DATE holiday_date UK
        VARCHAR2 holiday_name
    }
    AUDIT_LOG {
        NUMBER audit_id PK
        VARCHAR2 table_name
        VARCHAR2 action_type
        VARCHAR2 record_key
        VARCHAR2 changed_by
        TIMESTAMP changed_at
    }
```

`PUBLIC_HOLIDAYS` and `AUDIT_LOG` are independent control tables. They support the DML restriction and auditing requirements rather than forming ordinary transactional relationships.
