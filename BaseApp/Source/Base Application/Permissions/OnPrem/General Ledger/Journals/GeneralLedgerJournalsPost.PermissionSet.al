permissionset 2118 "General Ledger Journals - Post"
{
    Access = Public;
    Assignable = false;
    Caption = 'Post G/L journals';

    Permissions = tabledata "Acc. Sched. KPI Web Srv. Line" = RIMD,
                  tabledata "Acc. Sched. KPI Web Srv. Setup" = RIMD,
                  tabledata "Accounting Period" = r,
                  tabledata "Analysis View" = rimd,
                  tabledata "Analysis View Entry" = rim,
                  tabledata "Analysis View Filter" = r,
                  tabledata "Attachment Entity Buffer" = RIMD,
                  tabledata "Bank Account" = m,
                  tabledata "Bank Account Ledger Entry" = rim,
                  tabledata "Bank Statement Matching Buffer" = RIMD,
                  tabledata "Batch Processing Parameter" = Rimd,
                  tabledata "Batch Processing Session Map" = Rimd,
                  tabledata "Check Ledger Entry" = rim,
                  tabledata Currency = r,
                  tabledata "Currency Exchange Rate" = r,
                  tabledata "Date Compr. Register" = r,
                  tabledata "Dimension Combination" = R,
                  tabledata "Dimension Value Combination" = R,
                  tabledata "Dynamic Request Page Entity" = R,
                  tabledata "Dynamic Request Page Field" = R,
                  tabledata "Employee Time Reg Buffer" = RIMD,
                  tabledata "G/L Account" = R,
                  tabledata "G/L Entry - VAT Entry Link" = Ri,
                  tabledata "G/L Entry" = Ri,
                  tabledata "G/L Register" = Rim,
                  tabledata "Gen. Jnl. Allocation" = RIMD,
                  tabledata "Gen. Journal Batch" = RId,
                  tabledata "Gen. Journal Line" = RIMD,
                  tabledata "Gen. Journal Template" = RI,
                  tabledata "General Ledger Setup" = r,
                  tabledata "General Posting Setup" = r,
                  tabledata "Inc. Doc. Attachment Overview" = RIMD,
                  tabledata "Incoming Document" = RIMD,
                  tabledata "Incoming Document Approver" = RIMD,
                  tabledata "Incoming Document Attachment" = RIMD,
                  tabledata "Incoming Documents Setup" = RIMD,
#if not CLEAN20
                  tabledata "Native - Payment" = RIMD,
#endif
                  tabledata "Notification Entry" = Rimd,
                  tabledata "Posted Docs. With No Inc. Buf." = RIMD,
                  tabledata "Restricted Record" = Rimd,
                  tabledata "Reversal Entry" = RIMD,
                  tabledata "Sent Notification Entry" = Rimd,
                  tabledata "Tax Area" = R,
                  tabledata "Tax Area Line" = R,
                  tabledata "Tax Detail" = R,
                  tabledata "Tax Group" = R,
                  tabledata "Tax Jurisdiction" = R,
                  tabledata "Unlinked Attachment" = RIMD,
                  tabledata "User Setup" = r,
                  tabledata "VAT Assisted Setup Bus. Grp." = R,
                  tabledata "VAT Assisted Setup Templates" = R,
                  tabledata "VAT Entry" = Ri,
                  tabledata "VAT Posting Setup" = R,
                  tabledata "VAT Rate Change Log Entry" = Ri,
                  tabledata "VAT Rate Change Setup" = R,
                  tabledata "VAT Reporting Code" = R,
                  tabledata "VAT Setup Posting Groups" = R,
                  tabledata "VAT Setup" = R,
                  tabledata "VAT Posting Parameters" = R,
                  tabledata "Workflow - Record Change" = Rimd,
                  tabledata "Workflow - Table Relation" = R,
                  tabledata Workflow = R,
                  tabledata "Workflow Buffer" = RIMD,
                  tabledata "Workflow Category" = R,
                  tabledata "Workflow Event" = R,
                  tabledata "Workflow Event Queue" = Rimd,
                  tabledata "Workflow Record Change Archive" = Rimd,
                  tabledata "Workflow Response" = R,
                  tabledata "Workflow Rule" = Rimd,
                  tabledata "Workflow Step" = R,
                  tabledata "Workflow Step Argument" = Rimd,
                  tabledata "Workflow Step Argument Archive" = Rimd,
                  tabledata "Workflow Step Instance" = Rimd,
                  tabledata "Workflow Step Instance Archive" = Rimd,
                  tabledata "Workflow Table Relation Value" = Rimd,
                  tabledata "Workflow User Group" = R,
                  tabledata "Workflow User Group Member" = R;
}
