# Phase II: Business Process Model Explanation

The business process model represents the core savings and lending workflow of the VSLA Management System. It defines the system boundary as the activities performed from a member attending a meeting through contribution collection, loan processing, repayment, and loan closure. The process uses four swimlanes: Member, Group Leader, Treasurer, and System. Each lane identifies the participant responsible for a particular activity.

The process begins when a member attends a meeting. The treasurer verifies that the member has active membership before the member makes a contribution. The treasurer records the contribution and the system updates the member's savings balance. This separation of responsibilities ensures that the contribution is both checked and recorded before it affects the member's financial information.

When a member needs a loan, the member submits a loan application. The group leader reviews the request and decides whether the loan is approved. If the application is rejected, the system records the rejected status and the process ends for that application. If it is approved, the system records the approval, the treasurer disburses the loan, and the system creates an active loan record.

The repayment cycle begins when the member makes a repayment. The treasurer records it, and the system calculates the outstanding balance. The system then decides whether the loan has been fully paid. A fully paid loan is marked as paid and the process ends. Otherwise, the system keeps the loan active or marks it overdue where the due date has passed, after which the member continues making repayments.

The diagram supports accountability because each step is placed in the lane of the actor or component that performs it. It also matches the implemented Oracle schema: contributions are stored in `CONTRIBUTIONS`, applications in `LOAN_APPLICATIONS`, loans in `LOANS`, repayments in `LOAN_REPAYMENTS`, and status changes are supported by PL/SQL and triggers.
