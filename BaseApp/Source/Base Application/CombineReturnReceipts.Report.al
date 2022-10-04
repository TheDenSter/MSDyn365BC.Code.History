report 6653 "Combine Return Receipts"
{
    ApplicationArea = SalesReturnOrder, PurchReturnOrder;
    Caption = 'Combine Return Receipts';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SalesOrderHeader; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "Combine Shipments", "Bill-to Customer No.") WHERE("Document Type" = CONST("Return Order"), "Combine Shipments" = CONST(true));
            RequestFilterFields = "Sell-to Customer No.", "Bill-to Customer No.";
            RequestFilterHeading = 'Sales Return Order';
            dataitem("Return Receipt Header"; "Return Receipt Header")
            {
                DataItemLink = "Return Order No." = FIELD("No.");
                DataItemTableView = SORTING("Return Order No.");
                RequestFilterFields = "Posting Date";
                RequestFilterHeading = 'Posted Return Receipts';
                dataitem("Return Receipt Line"; "Return Receipt Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.") WHERE("Return Qty. Rcd. Not Invd." = FILTER(<> 0));

                    trigger OnAfterGetRecord()
                    var
                        SalesGetReturnReceipts: Codeunit "Sales-Get Return Receipts";
                        IsHandled: Boolean;
                    begin
                        IsHandled := false;
                        OnBeforeReturnReceiptLineOnAfterGetRecord("Return Receipt Line", IsHandled);
                        if IsHandled then
                            CurrReport.Skip();

                        if "Return Qty. Rcd. Not Invd." <> 0 then begin
                            if "Bill-to Customer No." <> Cust."No." then
                                Cust.Get("Bill-to Customer No.");
                            if Cust.Blocked <> Cust.Blocked::All then begin
                                if ShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, "Return Receipt Line") then begin
                                    if SalesHeader."No." <> '' then
                                        FinalizeSalesInvHeader();
                                    InsertSalesInvHeader();
                                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                                    SalesLine."Document Type" := SalesHeader."Document Type";
                                    SalesLine."Document No." := SalesHeader."No.";
                                end;
                                ReturnRcptLine := "Return Receipt Line";
                                ReturnRcptLine.InsertInvLineFromRetRcptLine(SalesLine);
                                if Type = Type::"Charge (Item)" then
                                    SalesGetReturnReceipts.GetItemChargeAssgnt("Return Receipt Line", SalesLine."Qty. to Invoice");
                            end else
                                NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3, "No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                Window.Update(1, "Bill-to Customer No.");
                Window.Update(2, "No.");
            end;

            trigger OnPostDataItem()
            begin
                CurrReport.Language := ReportLanguage;
                Window.Close();
                ShowResult();
            end;

            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);

                Window.Open(
                  Text002 +
                  Text003 +
                  Text004 +
                  Text005);

                OnAfterSalesOrderHeaderOnPreDataItem(SalesOrderHeader);
                ReportLanguage := CurrReport.Language();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDateReq; PostingDateReq)
                    {
                        ApplicationArea = SalesReturnOrder;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the credit memo(s) that the batch job creates.';
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        ApplicationArea = SalesReturnOrder;
                        Caption = 'Document Date';
                        ToolTip = 'Specifies the document date for the credit memo(s) that the batch job creates. This field must be filled in.';
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        ApplicationArea = SalesReturnOrder;
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies if you want the invoice discounts calculated automatically.';

                        trigger OnValidate()
                        begin
                            SalesSetup.Get();
                            SalesSetup.TestField("Calc. Inv. Discount", false);
                        end;
                    }
                    field(PostInv; PostInv)
                    {
                        ApplicationArea = SalesReturnOrder;
                        Caption = 'Post Credit Memos';
                        ToolTip = 'Specifies if you want to have the credit memos posted immediately.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            SalesSetup.Get();
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
        end;
    }

    labels
    {
    }

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        Language: Codeunit Language;
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;
        ReportLanguage: Integer;

        Text000: Label 'Enter the posting date.';
        Text001: Label 'Enter the document date.';
        Text002: Label 'Combining return receipts...\\';
        Text003: Label 'Customer No.        #1##########\';
        Text004: Label 'Return Order No.    #2##########\';
        Text005: Label 'Return Receipt No.  #3##########';
        Text007: Label 'Not all the credit memos were posted. A total of %1 credit memos were not posted.';
        Text008: Label 'There is nothing to combine.';
        Text010: Label 'The return receipts are now combined and the number of credit memos created is %1.';

    protected var
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvDisc: Boolean;
        PostInv: Boolean;

    local procedure FinalizeSalesInvHeader()
    var
        ShouldPostInv: Boolean;
    begin
        OnBeforeFinalizeSalesInvHeader(SalesHeader);

        with SalesHeader do begin
            if CalcInvDisc then
                SalesCalcDisc.Run(SalesLine);
            Find();
            Commit();
            Clear(SalesCalcDisc);
            Clear(SalesPost);
            NoOfSalesInv := NoOfSalesInv + 1;
            ShouldPostInv := PostInv;
            OnFinalizeSalesInvHeaderOnAfterCalcShouldPostInv(SalesHeader, NoOfSalesInv, ShouldPostInv);
            if ShouldPostInv then begin
                Clear(SalesPost);
                if not SalesPost.Run(SalesHeader) then
                    NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
            end;
        end;
    end;

    local procedure InsertSalesInvHeader()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsertSalesInvHeader(SalesHeader, SalesOrderHeader, "Return Receipt Header", "Return Receipt Line", NoOfSalesInv, IsHandled);
        if not IsHandled then
            with SalesHeader do begin
                Init();
                "Document Type" := "Document Type"::"Credit Memo";
                "No." := '';

                OnBeforeSalesCrMemoHeaderInsert(SalesHeader, SalesOrderHeader);

                Insert(true);
                ValidateCustomerNoFromOrder(SalesHeader, SalesOrderHeader);
                Validate("Currency Code", SalesOrderHeader."Currency Code");
                Validate("Posting Date", PostingDateReq);
                Validate("Document Date", DocDateReq);

                "Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
                "Dimension Set ID" := SalesOrderHeader."Dimension Set ID";
                OnBeforeSalesCrMemoHeaderModify(SalesHeader, SalesOrderHeader);

                Modify();
                Commit();
            end;

        OnAfterInsertSalesInvHeader(SalesHeader, "Return Receipt Header");
    end;

    local procedure ValidateCustomerNoFromOrder(var ToSalesHeader: Record "Sales Header"; FromSalesOrderHeader: Record "Sales Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateCustomerNoFromOrder(ToSalesHeader, FromSalesOrderHeader, "Return Receipt Header", "Return Receipt Line", IsHandled);
        if IsHandled then
            exit;

        ToSalesHeader.Validate("Sell-to Customer No.", FromSalesOrderHeader."Bill-to Customer No.");
        if ToSalesHeader."Bill-to Customer No." <> ToSalesHeader."Sell-to Customer No." then
            ToSalesHeader.Validate("Bill-to Customer No.", FromSalesOrderHeader."Bill-to Customer No.");
    end;

    procedure InitializeRequest(NewPostingDate: Date; NewDocumentDate: Date; NewCalcInvDisc: Boolean; NewPostCreditMemo: Boolean)
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocumentDate;
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostCreditMemo;
    end;

    local procedure ShowResult()
    begin
        OnBeforeShowResult(SalesHeader, NoOfSalesInvErrors, PostInv);

        if SalesHeader."No." <> '' then begin // Not the first time
            FinalizeSalesInvHeader();
            OnReturnReceiptHeaderOnAfterFinalizeSalesInvHeader(SalesHeader, NoOfSalesInvErrors, PostInv);
            if NoOfSalesInvErrors = 0 then
                Message(Text010, NoOfSalesInv)
            else
                Message(Text007, NoOfSalesInvErrors)
        end else
            Message(Text008);
    end;

    local procedure ShouldFinalizeSalesInvHeader(SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; ReturnReceiptLine: Record "Return Receipt Line") Finalize: Boolean
    begin
        Finalize :=
          (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
          (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
          (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID");

        OnAfterShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, Finalize, ReturnReceiptLine, "Return Receipt Header");
        exit(Finalize);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertSalesInvHeader(var SalesHeader: Record "Sales Header"; var ReturnReceiptHeader: Record "Return Receipt Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesOrderHeaderOnPreDataItem(var SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShouldFinalizeSalesInvHeader(var SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; var Finalize: Boolean; ReturnReceiptLine: Record "Return Receipt Line"; ReturnReceiptHeader: Record "Return Receipt Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesInvHeader(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header"; ReturnReceiptHeader: Record "Return Receipt Header"; ReturnReceiptLine: Record "Return Receipt Line"; var NoOfSalesInv: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReturnReceiptLineOnAfterGetRecord(var ReturnReceiptLine: Record "Return Receipt Line"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesCrMemoHeaderInsert(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesCrMemoHeaderModify(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowResult(var SalesHeader: Record "Sales Header"; var NoOfSalesInvErrors: Integer; PostInv: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateCustomerNoFromOrder(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header"; ReturnReceiptHeader: Record "Return Receipt Header"; ReturnReceiptLine: Record "Return Receipt Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnAfterCalcShouldPostInv(var SalesHeader: Record "Sales Header"; var NoOfSalesInv: Integer; var ShouldPostInv: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReturnReceiptHeaderOnAfterFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header"; var NoOfSalesCrMemoErrors: Integer; PostInv: Boolean)
    begin
    end;
}

