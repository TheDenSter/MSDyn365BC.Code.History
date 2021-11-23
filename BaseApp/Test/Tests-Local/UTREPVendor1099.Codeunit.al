codeunit 142055 "UT REP Vendor 1099"
{
    // Validate feature Vendor 1099.
    //  1. Verify Vendor 1099 Div report value.
    //  2. Verify Vendor 1099 Information report value.
    //  3. Verify Vendor 1099 Int report value.
    //  4. Verify Vendor 1099 Misc report value.
    // 
    //  Covers Test Cases for WI - 336173
    //  ----------------------------------------------------------------------------------------------
    //  Test Function Name                                                                      TFS ID
    //  ----------------------------------------------------------------------------------------------
    //  OnAfterGetRecordVendor1099Div                                                           171172
    //  OnAfterGetRecordVendor1099Information                                                   171171
    //  OnAfterGetRecordVendor1099Int                                                           171170
    //  OnAfterGetRecordVendor1099Misc                                                          171169

    Permissions = TableData "Vendor Ledger Entry" = imd,
                  TableData "Detailed Vendor Ledg. Entry" = imd;
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [UT] [Vendor 1099]
    end;

    var
        LibraryReportDataset: Codeunit "Library - Report Dataset";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryUTUtility: Codeunit "Library UT Utility";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibraryTextFileValidation: Codeunit "Library - Text File Validation";
        LibraryRandom: Codeunit "Library - Random";
        Amounts: Label 'Amounts';
        GetAmtINT01: Label 'GetAmtINT01';
        GetAmtMISC02: Label 'GetAmtMISC02';
        GetAmtNEC01Tok: Label 'GetAmtNEC01';
        GetAmtCombinedDivCodeAB: Label 'GetAmtCombinedDivCodeAB';
        IRS1099CodeDiv: Label 'DIV-01-A';
        IRS1099CodeDiv02ETok: Label 'DIV-02-E';
        IRS1099CodeDiv02FTok: Label 'DIV-02-F';
        IRS1099CodeInt: Label 'INT-01';
        IRS1099CodeMisc: Label 'MISC-02';
        Assert: Codeunit Assert;
        LineSequenceNoErr: Label 'Wrong line Sequence No. value';
        IRS1099CodeMisc01Tok: Label 'MISC-01', Comment = 'MISC - miscellaneous';
        IRS1099CodeMisc05Tok: Label 'MISC-05', Comment = 'MISC - miscellaneous';
        IRS1099CodeMisc07Tok: Label 'MISC-07', Comment = 'MISC - miscellaneous';
        IRS1099CodeMisc09Tok: Label 'MISC-09', Comment = 'MISC - miscellaneous';
        IRS1099CodeMisc10Tok: Label 'MISC-10', Comment = 'MISC - miscellaneous';
        IRS1099CodeMisc11Tok: Label 'MISC-11', Comment = 'MISC - miscellaneous';
        IRS1099CodeMisc12Tok: Label 'MISC-12', Comment = 'MISC - miscellaneous';
        IRS1099CodeMisc13Tok: Label 'MISC-13', Comment = 'MISC - miscellaneous';
        IRS1099CodeNec01Tok: Label 'NEC-01';
        AmountCodeErr: Label 'Wrong value of Amount code.';
        LibraryLocalFunctionality: Codeunit "Library - Local Functionality";
        AmountErr: Label 'Wrong value of Amount.';
        UnkownCodeErr: Label 'Invoice %1 for vendor %2 has unknown 1099 code %3.', Comment = '%1 = document number;%2 = vendor number;%3 = IRS 1099 code.';

    [HandlerFunctions('Vendor1099DivRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordVendor1099Div()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        // Purpose of the test is to validate trigger Vendor - OnAfterGetRecord of Report 10109.

        // Setup: Create Vendor and Detailed Leger Entry.
        Initialize;
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, LibraryRandom.RandIntInRange(100, 1000));

        // Exercise.
        REPORT.Run(REPORT::"Vendor 1099 Div");

        // Verify: Verify Vendor 1099 Div report value.
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(GetAmtCombinedDivCodeAB, -VendorLedgerEntry.Amount);
    end;

    [Test]
    [HandlerFunctions('Vendor1099InformationRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordVendor1099Information()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        // Purpose of the test is to validate trigger Vendor - OnAfterGetRecord of Report 10109.

        // Setup: Create Vendor and Detailed Leger Entry.
        Initialize;
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, LibraryRandom.RandIntInRange(100, 1000));

        // Exercise.
        REPORT.Run(REPORT::"Vendor 1099 Information");

        // Verify: Verify Vendor 1099 Information report value.
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(Amounts, -VendorLedgerEntry.Amount);
    end;

    [HandlerFunctions('Vendor1099IntRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordVendor1099Int()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        // Purpose of the test is to validate trigger Vendor - OnAfterGetRecord of Report 10109.

        // Setup: Create Vendor and Detailed Leger Entry.
        Initialize;
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeInt, LibraryRandom.RandIntInRange(100, 1000));

        // Exercise.
        REPORT.Run(REPORT::"Vendor 1099 Int");

        // Verify: Verify Vendor 1099 Int report value.
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(GetAmtINT01, -VendorLedgerEntry.Amount);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MiscRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure OnAfterGetRecordVendor1099Misc()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        // Purpose of the test is to validate trigger Vendor - OnAfterGetRecord of Report 10109.

        // Setup: Create Vendor and Detailed Leger Entry.
        Initialize;
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc, LibraryRandom.RandIntInRange(100, 1000));

        // Exercise.
        REPORT.Run(REPORT::"Vendor 1099 Misc");

        // Verify: Verify Vendor 1099 Misc report value.
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(GetAmtMISC02, -VendorLedgerEntry.Amount);
    end;

    [HandlerFunctions('Vendor1099DivRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099DivAppliedPaymentToThreeInvoices()
    var
        DocAmountSum: Decimal;
    begin
        // [SCENARIO 123991] Report 1099 Div when multiple  documents applied in a single transaction

        // [GIVEN] 2 vendors "A", "B"
        // [GIVEN] 3 invoices per vendor posted in different transactions.
        // [GIVEN] One payment per vendor applied to all 3 invoices and closed them within a single transaction
        Initialize;
        DocAmountSum := SetupMultipleDocScenario(IRS1099CodeDiv);

        // [WHEN] Run Report 1099 Div
        REPORT.Run(REPORT::"Vendor 1099 Div");

        // [THEN] Exported amount for vendor "A" equal to sum of invoices for "A"
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(GetAmtCombinedDivCodeAB, DocAmountSum);
    end;

    [Test]
    [HandlerFunctions('Vendor1099InformationRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099InformationAppliedPaymentThreeInvoices()
    var
        DocAmountSum: Decimal;
    begin
        // [SCENARIO 123991] Report 1099 Information when multiple  documents applied in a single transaction

        // [GIVEN] 2 vendors "A", "B"
        // [GIVEN] 3 invoices per vendor posted in different transactions.
        // [GIVEN] One payment per vendor applied to all 3 invoices and closed them within a single transaction
        Initialize;
        DocAmountSum := SetupMultipleDocScenario(IRS1099CodeDiv);

        // [WHEN] Run Report 1099 Information
        REPORT.Run(REPORT::"Vendor 1099 Information");

        // [THEN] Exported amount for vendor "A" equal to sum of invoices for "A"
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(Amounts, DocAmountSum);
    end;

    [HandlerFunctions('Vendor1099IntRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099IntAppliedPaymentToThreeInvoices()
    var
        DocAmountSum: Decimal;
    begin
        // [SCENARIO 123991] Report 1099 Int when multiple  documents applied in a single transaction

        // [GIVEN] 2 vendors "A", "B"
        // [GIVEN] 3 invoices per vendor posted in different transactions.
        // [GIVEN] One payment per vendor applied to all 3 invoices and closed them within a single transaction
        Initialize;
        DocAmountSum := SetupMultipleDocScenario(IRS1099CodeInt);

        // [WHEN] Run Report 1099 Int
        REPORT.Run(REPORT::"Vendor 1099 Int");

        // [THEN] Exported amount for vendor "A" equal to sum of invoices for "A"
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(GetAmtINT01, DocAmountSum);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MiscRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MiscAppliedPaymentToThreeInvoices()
    var
        DocAmountSum: Decimal;
    begin
        // [SCENARIO 123991] Report 1099 Misc when multiple  documents applied in a single transaction

        // [GIVEN] 2 vendors "A", "B"
        // [GIVEN] 3 invoices per vendor posted in different transactions.
        // [GIVEN] One payment per vendor applied to all 3 invoices and closed them within a single transaction
        Initialize;
        DocAmountSum := SetupMultipleDocScenario(IRS1099CodeMisc);

        // [WHEN] Run Report 1099 Misc
        REPORT.Run(REPORT::"Vendor 1099 Misc");

        // [THEN] Exported amount for vendor "A" equal to sum of invoices for "A"
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(GetAmtMISC02, DocAmountSum);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaDivCRecLineSequenceNo()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 364351] Vendor 1099 Magnetic Media "DivCRec" line has "Sequence No." element in position 500 with length 8
        Initialize;

        // [GIVEN] Vendor with "DivCRec" source data
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, LibraryRandom.RandIntInRange(100, 1000));

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] "DivCRec" line has "Sequence No." element in position 500 with length 8
        Assert.AreEqual(
          '00000004',
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 500, 8),
          LineSequenceNoErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaIntCRecLineSequenceNo()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 364351] Vendor 1099 Magnetic Media "IntCRec" line has "Sequence No." element in position 500 with length 8
        Initialize;

        // [GIVEN] Vendor with "IntCRec" source data
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeInt, LibraryRandom.RandIntInRange(100, 1000));

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] "DivCRec" line has "Sequence No." element in position 500 with length 8
        Assert.AreEqual(
          '00000004',
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 500, 8),
          LineSequenceNoErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaMiscCRecLineSequenceNo()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 364351] Vendor 1099 Magnetic Media "MiscCRec" line has "Sequence No." element in position 500 with length 8
        Initialize;

        // [GIVEN] Vendor with "MiscCRec" source data
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc, LibraryRandom.RandIntInRange(100, 1000));

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] "DivCRec" line has "Sequence No." element in position 500 with length 8
        Assert.AreEqual(
          '00000004',
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 500, 8),
          LineSequenceNoErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaDivFATCAIsSet()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO] The Div B record contains a flag, corresponding to the value of FATCA set on the vendor (true)
        Initialize;

        // [GIVEN] A Vendor which is marked as FACTA
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, LibraryRandom.RandIntInRange(100, 1000));
        Vendor.Get(VendorLedgerEntry."Vendor No.");
        Vendor."FATCA filing requirement" := true;
        Vendor.Modify();

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] The B record has value 1 at position 587
        Assert.AreEqual(
          '1',
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 587, 1),
          LineSequenceNoErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaDivFATCAIsNotSet()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO] The Div B record contains a flag, corresponding to the value of FATCA set on the vendor (false)
        Initialize;

        // [GIVEN] A Vendor which is not marked as FACTA
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, LibraryRandom.RandIntInRange(100, 1000));

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] The B record has value 0 at position 587
        Assert.AreEqual(
          '0',
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 587, 1),
          LineSequenceNoErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaIntFATCAIsSet()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO] The Int B record contains a flag, corresponding to the value of FATCA set on the vendor (true)
        Initialize;

        // [GIVEN] A Vendor which is marked as FACTA
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeInt, LibraryRandom.RandIntInRange(100, 1000));
        Vendor.Get(VendorLedgerEntry."Vendor No.");
        Vendor."FATCA filing requirement" := true;
        Vendor.Modify();

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] The B record has value 1 at position 600
        Assert.AreEqual(
          '1',
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 600, 1),
          LineSequenceNoErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaMiscFATCAIsSet()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO] The Misc B record contains a flag, corresponding to the value of FATCA set on the vendor (true)
        Initialize;

        // [GIVEN] A Vendor which is marked as FACTA
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc, LibraryRandom.RandIntInRange(100, 1000));
        Vendor.Get(VendorLedgerEntry."Vendor No.");
        Vendor."FATCA filing requirement" := true;
        Vendor.Modify();

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] The B record has value 1 at position 548
        Assert.AreEqual(
          '1',
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 548, 1),
          LineSequenceNoErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaMisc07AmountCode()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 280534] The Misc A record have to contain Amount Code = 1 when Record B contains Direct Sales indicator and "IRS 1099 Code" = "MISC-07"
        Initialize;

        // [GIVEN] Vendor with "MiscARec" source data and MISC-07 code
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc07Tok, LibraryRandom.RandIntInRange(5000, 10000)); // Amount have to be greater than 5000 For MISC-07
        Commit();

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] "MiscARec" line has "Amount Code" element in position 28 = '1'
        Assert.AreEqual('1', LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 2, 28, 1), AmountCodeErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099DivRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099DivReportShowAmountWithAdjustment()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        SecondVendorLedgerEntry: Record "Vendor Ledger Entry";
        IRS1099Adjustment: Record "IRS 1099 Adjustment";
        Vendor: Record Vendor;
    begin
        // [SCENARIO 332661] A "Vendor 1099 Div" report shows the amount with adjustment

        Initialize;

        // [GIVEN] Vendor ledger entry for vendor "A" with "DIV-01-A" code, "Posting Date" = 01.01.2022 and total amount = 100
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, LibraryRandom.RandIntInRange(100, 1000));

        // [GIVEN] Vendor ledger entry for vendor "A" with "DIV-01-A" code, "Posting Date" = 01.01.2022 and total amount = 150
        // BUG 384664: Adjustment with multiple vendor ledger entries
        SetupToCreateLedgerEntriesForExistingVendor(
          SecondVendorLedgerEntry, VendorLedgerEntry."Vendor No.", IRS1099CodeDiv, LibraryRandom.RandIntInRange(1000, 2000));

        // [GIVEN] Adjustment amount equals 50 for vendor "A", code "DIV-01-A", Year = 2023
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeDiv,
          Date2DMY(VendorLedgerEntry."Posting Date", 3) + 1, LibraryRandom.RandDec(10, 2));

        // [GIVEN] Adjustment amount equals 30 for vendor "A", code "DIV-01-A", Year = 2022
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeDiv,
          Date2DMY(VendorLedgerEntry."Posting Date", 3), LibraryRandom.RandDec(10, 2));

        // [THEN] Run "Vendor 1099 Div" report
        Vendor.SetRange("No.", VendorLedgerEntry."Vendor No.");
        REPORT.Run(REPORT::"Vendor 1099 Div", true, false, Vendor);

        // [THEN] Report has amount 280
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(
          GetAmtCombinedDivCodeAB, -VendorLedgerEntry.Amount - SecondVendorLedgerEntry.Amount + IRS1099Adjustment.Amount);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MiscRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MiscReportShowAmountWithAdjustment()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        SecondVendorLedgerEntry: Record "Vendor Ledger Entry";
        IRS1099Adjustment: Record "IRS 1099 Adjustment";
        Vendor: Record Vendor;
    begin
        // [SCENARIO 332661] A "Vendor 1099 Misc" report shows the amount with adjustment

        Initialize;
        // [GIVEN] Vendor ledger entries for vendor "A" with "MISC-02" code, "Posting Date" = 01.01.2022 and total amount = 100
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc, LibraryRandom.RandIntInRange(100, 1000));

        // [GIVEN] Vendor ledger entry for vendor "A" with "MISC-02" code, "Posting Date" = 01.01.2022 and total amount = 150
        // BUG 384664: Adjustment with multiple vendor ledger entries
        SetupToCreateLedgerEntriesForExistingVendor(
          SecondVendorLedgerEntry, VendorLedgerEntry."Vendor No.", IRS1099CodeMisc, LibraryRandom.RandIntInRange(1000, 2000));

        // [GIVEN] Adjustment amount equals 50 for vendor "A", code "MISC-02", Year = 2023
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeMisc,
          Date2DMY(VendorLedgerEntry."Posting Date", 3) + 1, LibraryRandom.RandDec(10, 2));

        // [GIVEN] Adjustment amount equals 30 for vendor "A", code "MISC-02", Year = 2022
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeMisc,
          Date2DMY(VendorLedgerEntry."Posting Date", 3), LibraryRandom.RandDec(10, 2));

        // [THEN] Run "Vendor 1099 Misc" report
        Vendor.SetRange("No.", VendorLedgerEntry."Vendor No.");
        REPORT.Run(REPORT::"Vendor 1099 Misc", true, false, Vendor);

        // [THEN] Report has amount 280
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists(
          GetAmtMISC02, -VendorLedgerEntry.Amount - SecondVendorLedgerEntry.Amount + IRS1099Adjustment.Amount);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaShowAmountWithAdjustment()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        SecondVendorLedgerEntry: Record "Vendor Ledger Entry";
        IRS1099Adjustment: Record "IRS 1099 Adjustment";
        AMagneticMediaMgt: Codeunit "A/P Magnetic Media Management";
        FileManagement: Codeunit "File Management";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 332661] A "Vendor 1099 Magnetic Media" report shows the amount with adjustment
        Initialize;

        // [GIVEN] Vendor ledger entries for vendor "A" with "MISC-02" code, "Posting Date" = 01.01.2022 and total amount = 100
        // BUG 384664: Adjustment with multiple vendor ledger entries
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc, LibraryRandom.RandIntInRange(5000, 10000));

        // [GIVEN] Vendor ledger entry for vendor "A" with "MISC-02" code, "Posting Date" = 01.01.2022 and total amount = 150
        // BUG 384664: Adjustment with multiple vendor ledger entries
        SetupToCreateLedgerEntriesForExistingVendor(
          SecondVendorLedgerEntry, VendorLedgerEntry."Vendor No.", IRS1099CodeMisc, LibraryRandom.RandIntInRange(1000, 2000));

        // [GIVEN] Adjustment amount equals 50 for vendor "A", code "MISC-02", Year = 2023
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeMisc,
          Date2DMY(VendorLedgerEntry."Posting Date", 3) + 1, LibraryRandom.RandDec(10, 2));

        // [GIVEN] Adjustment amount equals 30 for vendor "A", code "MISC-02", Year = 2022
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeMisc,
          Date2DMY(VendorLedgerEntry."Posting Date", 3), LibraryRandom.RandDec(10, 2));

        Commit();

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReportSingleVendor(FileName, VendorLedgerEntry."Vendor No.");

        // [THEN] Line has amount element with value "00000280 00"
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry.Amount - SecondVendorLedgerEntry.Amount + IRS1099Adjustment.Amount, 12),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 67, 12), AmountErr);

        FileManagement.DeleteServerFile(FileName);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure Calc1099AmountFunctionFailsIfCodeNotFound()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        IRS1099Management: Codeunit "IRS 1099 Management";
        DummyCodes: array[20] of Code[10];
        InvoiceAmount: Decimal;
        Amounts: array[20] of Decimal;
        EntryAmount: Decimal;
        DummyLastLineNo: Integer;
    begin
        // [FEATURE] [UT]
        // [SCENARIO 332661] Calculate1099Amount function of codeunit "IRS 1099 Management" failed on non-existing IRS 1099 code

        Initialize;

        // [GIVEN] Vendor Ledger Entry with IRS 1099 code "DIV-01-A"
        EntryAmount := LibraryRandom.RandIntInRange(100, 1000);
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, EntryAmount);
        // [GIVEN] Codes array does not exists the code from Vendor Ledger Entry

        // [WHEN] Call function Calculate1099Amount and pass Codes array
        asserterror IRS1099Management.Calculate1099Amount(
            InvoiceAmount, Amounts, DummyCodes, DummyLastLineNo, VendorLedgerEntry, Round(EntryAmount / LibraryRandom.RandIntInRange(3, 1)));

        // [THEN] An error message "Unknown code" shown
        Assert.ExpectedError(
          StrSubstNo(UnkownCodeErr, VendorLedgerEntry."Entry No.", VendorLedgerEntry."Vendor No.", VendorLedgerEntry."IRS 1099 Code"));
    end;

    [Test]
    [HandlerFunctions('Vendor1099NecRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099NecReportShowAmountWithAdjustment()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        SecondVendorLedgerEntry: Record "Vendor Ledger Entry";
        IRS1099Adjustment: Record "IRS 1099 Adjustment";
        Vendor: Record Vendor;
    begin
        // [SCENARIO 384664] A "Vendor 1099 Nec" report shows the amount with adjustment

        Initialize();
        // [GIVEN] Vendor ledger entry for vendor "A" with "NEC-01" code, "Posting Date" = 01.01.2022 and total amount = 1000
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeNec01Tok, LibraryRandom.RandIntInRange(1000, 2000));

        // [GIVEN] Vendor ledger entry for vendor "A" with "NEC-01" code, "Posting Date" = 01.01.2022 and total amount = 1500
        SetupToCreateLedgerEntriesForExistingVendor(
          SecondVendorLedgerEntry, VendorLedgerEntry."Vendor No.", IRS1099CodeNec01Tok, LibraryRandom.RandIntInRange(1000, 2000));

        // [GIVEN] Adjustment amount equals 50 for vendor "A", code "NEC-01", Year = 2023
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeNec01Tok,
          Date2DMY(VendorLedgerEntry."Posting Date", 3) + 1, LibraryRandom.RandDec(10, 2));

        // [GIVEN] Adjustment amount equals 30 for vendor "A", code "NEC-01", Year = 2022
        LibraryLocalFunctionality.CreateIRS1099Adjustment(
          IRS1099Adjustment, VendorLedgerEntry."Vendor No.", IRS1099CodeNec01Tok,
          Date2DMY(VendorLedgerEntry."Posting Date", 3), LibraryRandom.RandDec(10, 2));

        // [THEN] Run "Vendor 1099 Nec" report
        Vendor.SetRange("No.", VendorLedgerEntry."Vendor No.");
        REPORT.Run(REPORT::"Vendor 1099 Nec", true, false, Vendor);

        // [THEN] Report has amount 1030
        LibraryReportDataset.LoadDataSetFile();
        LibraryReportDataset.AssertElementWithValueExists(
          GetAmtNEC01Tok, -VendorLedgerEntry.Amount - SecondVendorLedgerEntry.Amount + IRS1099Adjustment.Amount);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaNec07AmountCode()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AMagneticMediaMgt: Codeunit "A/P Magnetic Media Management";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 380761] The magnetic media file contains the information about the NEC-01 code

        Initialize();

        // [GIVEN] Vendor entry with NEC-07 code and amount = "X"
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeNec01Tok, LibraryRandom.RandIntInRange(5000, 10000));
        Commit();

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] A record has "NE1"
        Assert.AreEqual('NE1', LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 2, 26, 3), AmountCodeErr);

        // [THEN] B record has "X"
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry.Amount, 12),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 55, 12), AmountErr);

        // [THEN] C record has "X"
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry.Amount, 18),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 16, 18), AmountErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaOrderOfMultipleMiscCodes()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FileName: Text;
        VendorNo: Code[20];
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 380761] The magnetic media file contains the correct order of the multiple MISC codes

        Initialize();

        // [GIVEN] Vendor entries with codes "MISC-13", "MISC-09", "MISC-10", "MISC-01", "MISC-01", "MISC-05", "MISC-12"
        VendorNo := CreateVendor();
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry, VendorNo, IRS1099CodeMisc13Tok, LibraryRandom.RandIntInRange(5000, 10000));
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry, VendorNo, IRS1099CodeMisc09Tok, LibraryRandom.RandIntInRange(5000, 10000));
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry, VendorNo, IRS1099CodeMisc10Tok, LibraryRandom.RandIntInRange(5000, 10000));
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry, VendorNo, IRS1099CodeMisc01Tok, LibraryRandom.RandIntInRange(5000, 10000));
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry, VendorNo, IRS1099CodeMisc05Tok, LibraryRandom.RandIntInRange(5000, 10000));
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry, VendorNo, IRS1099CodeMisc12Tok, LibraryRandom.RandIntInRange(5000, 10000));
        Commit;

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] A record has "15ABCD"
        Assert.AreEqual('15ABCD', LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 2, 28, 6), AmountCodeErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099InformationRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099InformationReportContainsNecCode()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        // [SCENARIO 386168] Vendor 1099 information reports contains the NEC code

        Initialize();
        // [GIVEN] Vendor Ledger Entry with "NEC-01" code and Amount = "X"
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeNec01Tok, LibraryRandom.RandIntInRange(100, 1000));

        // [WHEN] Run Vendor 1099 information report
        REPORT.Run(REPORT::"Vendor 1099 Information");

        // [THEN] Vendor 1099 Information report Vendor Ledger Entry's amount "X"
        LibraryReportDataset.LoadDataSetFile();
        LibraryReportDataset.AssertElementWithValueExists(Amounts, -VendorLedgerEntry.Amount);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaMisc10CodeHasCorrectPosition()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AMagneticMediaMgt: Codeunit "A/P Magnetic Media Management";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 389780] The magnetic media file contains the information about the MISC-10 code in the correct position in B and C sections

        Initialize;

        // [GIVEN] Vendor entry with MISC-10 code and amount = "X"
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc10Tok, LibraryRandom.RandIntInRange(5000, 10000));
        Commit;

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] B record has "X" amount in position 187 to 198
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry.Amount, 12),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 187, 12), AmountErr);

        // [THEN] C record has "X" amount in position 214 to 231
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry.Amount, 18),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 214, 18), AmountErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099Misc2020ChangeCurrYearRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure ChangeYearInMiscReport()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        OldWorkDate: Date;
    begin
        // [SCENARIO 392599] Stan can change the year on the MISC report's request page to see the actual data

        // [GIVEN] Purchase invoice with MISC-02 code with Date = 01.01.2021
        Initialize();
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc, LibraryRandom.RandIntInRange(100, 1000));

        // [GIVEN] Work date is "01.01.2022"
        OldWorkDate := WorkDate();
        WorkDate := CalcDate('<1Y>', WorkDate());

        // [WHEN] Run Vendor 1099 MISC Report and set year = 2021
        LibraryVariableStorage.Enqueue(Date2DMY(OldWorkDate, 3));
        REPORT.Run(REPORT::"Vendor 1099 Misc 2020");

        // [THEN] "MISC-02" value exists in the Report
        LibraryReportDataset.LoadDataSetFile;
        VendorLedgerEntry.CalcFields(Amount);
        LibraryReportDataset.AssertElementWithValueExists(GetAmtMISC02, -VendorLedgerEntry.Amount);
        LibraryVariableStorage.AssertEmpty();

        // Tear down
        Workdate := OldWorkDate;
    end;

    [Test]
    [HandlerFunctions('Vendor1099DivChangeCurrYearRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure ChangeYearInDivReport()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        OldWorkDate: Date;
    begin
        // [SCENARIO 392599] Stan can change the year on the DIV report's request page to see the actual data

        // [GIVEN] Purchase invoice with DIV-01 code with Date = 01.01.2021
        Initialize();
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeDiv, LibraryRandom.RandIntInRange(100, 1000));

        // [GIVEN] Work date is "01.01.2022"
        OldWorkDate := WorkDate();
        WorkDate := CalcDate('<1Y>', WorkDate());

        // [WHEN] Run Vendor 1099 DIV Report and set year = 2021
        LibraryVariableStorage.Enqueue(Date2DMY(OldWorkDate, 3));
        REPORT.Run(REPORT::"Vendor 1099 Div");

        // [THEN] "DIV-01" value exists in the Report
        LibraryReportDataset.LoadDataSetFile;
        VendorLedgerEntry.CalcFields(Amount);
        LibraryReportDataset.AssertElementWithValueExists(GetAmtCombinedDivCodeAB, -VendorLedgerEntry.Amount);
        LibraryVariableStorage.AssertEmpty();

        // Tear down
        Workdate := OldWorkDate;
    end;

    [Test]
    [HandlerFunctions('Vendor1099IntChangeCurrYearRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure ChangeYearInIntReport()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        OldWorkDate: Date;
    begin
        // [SCENARIO 392599] Stan can change the year on the INT report's request page to see the actual data

        // [GIVEN] Purchase invoice with INT-01 code with Date = 01.01.2021
        Initialize();
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeInt, LibraryRandom.RandIntInRange(100, 1000));

        // [GIVEN] Work date is "01.01.2022"
        OldWorkDate := WorkDate();
        WorkDate := CalcDate('<1Y>', WorkDate());

        // [WHEN] Run Vendor 1099 Int Report and set year = 2021
        LibraryVariableStorage.Enqueue(Date2DMY(OldWorkDate, 3));
        REPORT.Run(REPORT::"Vendor 1099 Int");

        // [THEN] "DIV-01" value exists in the Report
        LibraryReportDataset.LoadDataSetFile;
        VendorLedgerEntry.CalcFields(Amount);
        LibraryReportDataset.AssertElementWithValueExists(GetAmtINT01, -VendorLedgerEntry.Amount);
        LibraryVariableStorage.AssertEmpty();

        // Tear down
        Workdate := OldWorkDate;
    end;

    [Test]
    [HandlerFunctions('Vendor1099Misc2021DoNothingRPH')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('OnPrem')]
    procedure Vendor1099MiscReportRunsFromTheVendorCard()
    var
        VendorCardPage: TestPage "Vendor Card";
    begin
        // [FEATURE] [UI]
        // [SCENARIO 395105] Stan can open the Vendor 1099 Misc 2020 report from the vendor card

        Initialize();
        VendorCardPage.OpenEdit();
        VendorCardPage.Filter.SetFilter("No.", CreateVendor());
        VendorCardPage."Vendor 1099 Misc".Invoke();
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaMisc11CodeHasCorrectPosition()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AMagneticMediaMgt: Codeunit "A/P Magnetic Media Management";
        FileName: Text;
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 41241] The magnetic media file contains the information about the MISC-11 code in the correct position in B and C sections

        Initialize;

        // [GIVEN] Vendor entry with MISC-11 code and amount = "X"
        SetupToCreateLedgerEntriesForVendor(VendorLedgerEntry, IRS1099CodeMisc11Tok, LibraryRandom.RandIntInRange(5000, 10000));
        Commit;

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] B record has "X" amount in position 223 to 234
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry.Amount, 12),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 223, 12), AmountErr);

        // [THEN] C record has "X" amount in position 268 to 285
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry.Amount, 18),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 268, 18), AmountErr);

        FILE.Erase(FileName);
    end;

    [Test]
    [HandlerFunctions('Vendor1099MagneticMediaRPH')]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaDiv02EAndFCodesHasCorrectPosition()
    var
        VendorLedgerEntry: array[2] of Record "Vendor Ledger Entry";
        AMagneticMediaMgt: Codeunit "A/P Magnetic Media Management";
        FileName: Text;
        VendorNo: Code[20];
    begin
        // [FEATURE] [Vendor 1099 Magnetic Media]
        // [SCENARIO 41241] The magnetic media file contains the information about the DIV-02-E and DIV-02-F codes in the correct position in B and C sections

        Initialize;

        VendorNo := CreateVendor;
        // [GIVEN] Vendor entry with DIV-02-E code and amount = "X"
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry[1], VendorNo, IRS1099CodeDiv02ETok, LibraryRandom.RandIntInRange(5000, 10000));
        // [GIVEN] Vendor entry with DIV-02-F code and amount = "Y"
        SetupToCreateLedgerEntriesForExistingVendor(
          VendorLedgerEntry[2], VendorNo, IRS1099CodeDiv02FTok, LibraryRandom.RandIntInRange(5000, 10000));
        Commit;

        // [WHEN] Run Vendor 1099 Magnetic Media report
        RunVendor1099MagneticMediaReport(FileName);

        // [THEN] B record has "X" amount in position 247 to 258
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry[1].Amount, 12),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 247, 12), AmountErr);

        // [THEN] B record has "Y" amount in position 259 to 270
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry[2].Amount, 12),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 3, 259, 12), AmountErr);

        // [THEN] C record has "X" amount in position 304 to 321
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry[1].Amount, 18),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 304, 18), AmountErr);

        // [THEN] C record has "Y" amount in position 322 to 339
        Assert.AreEqual(
          AMagneticMediaMgt.FormatMoneyAmount(-VendorLedgerEntry[2].Amount, 18),
          LibraryTextFileValidation.ReadValueFromLine(CopyStr(FileName, 1, 1024), 4, 322, 18), AmountErr);

        FILE.Erase(FileName);
    end;

    local procedure Initialize()
    begin
        LibraryVariableStorage.Clear;
    end;

    local procedure CreateDetailedVendorLedgerEntry(VendorLedgerEntryNo: Integer; AppliedVendLedgerEntryNo: Integer; EntryType: Option; VendorNo: Code[20]; Amount: Decimal; LedgerEntryAmount: Boolean)
    begin
        InsertDetailedVendorLedgerEntry(
          VendorLedgerEntryNo, AppliedVendLedgerEntryNo, EntryType, VendorNo, 0, Amount, LedgerEntryAmount);
    end;

    local procedure InsertDetailedVendorLedgerEntry(VendorLedgerEntryNo: Integer; AppliedVendLedgerEntryNo: Integer; EntryType: Option; VendorNo: Code[20]; TransactionNo: Integer; NewAmount: Decimal; LedgerEntryAmount: Boolean)
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(DetailedVendorLedgEntry);
        with DetailedVendorLedgEntry do begin
            "Entry No." := LibraryUtility.GetNewLineNo(RecRef, FieldNo("Entry No."));
            "Vendor Ledger Entry No." := VendorLedgerEntryNo;
            "Ledger Entry Amount" := LedgerEntryAmount;
            "Applied Vend. Ledger Entry No." := AppliedVendLedgerEntryNo;
            "Entry Type" := EntryType;
            "Vendor No." := VendorNo;
            Amount := NewAmount;
            "Amount (LCY)" := NewAmount;
            "Transaction No." := TransactionNo;
            Insert;
        end;
    end;

    local procedure CalcSumOfDocs(DocAmount: array[2, 3] of Decimal; VendorIndex: Integer) Result: Decimal
    var
        Index: Integer;
    begin
        for Index := 1 to ArrayLen(DocAmount, 2) do
            Result += DocAmount[VendorIndex, Index];

        exit(Result);
    end;

    local procedure CreateVendor(): Code[20]
    var
        Vendor: Record Vendor;
    begin
        Vendor."No." := LibraryUTUtility.GetNewCode;
        Vendor."Federal ID No." := LibraryUTUtility.GetNewCode10;
        Vendor.Address := LibraryUTUtility.GetNewCode10;
        Vendor."Address 2" := LibraryUTUtility.GetNewCode10;
        Vendor.Insert();
        exit(Vendor."No.");
    end;

    local procedure CreateVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; DocumentType: Option; VendorNo: Code[20]; IRS1099Code: Code[10]; IRSAmount: Decimal)
    begin
        InsertVendorLedgerEntry(VendorLedgerEntry, DocumentType, LibraryUTUtility.GetNewCode10, VendorNo, 0, IRS1099Code, IRSAmount);
    end;

    local procedure InsertVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; DocumentType: Option; DocumentNo: Code[20]; VendorNo: Code[20]; TransactionNo: Integer; IRS1099Code: Code[10]; DocAmount: Decimal)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(VendorLedgerEntry);
        with VendorLedgerEntry do begin
            "Entry No." := LibraryUtility.GetNewLineNo(RecRef, FieldNo("Entry No."));
            "Document No." := DocumentNo;
            "Document Type" := DocumentType;
            "Vendor No." := VendorNo;
            "Posting Date" := WorkDate;
            Open := true;
            "Transaction No." := TransactionNo;
            "IRS 1099 Code" := IRS1099Code;
            "IRS 1099 Amount" := -DocAmount;

            Insert;
        end;
    end;

    local procedure SetupToCreateLedgerEntriesForVendor(var VendorLedgerEntry: Record "Vendor Ledger Entry"; IRS1099Code: Code[10]; VendorLedgerEntryAmount: Decimal)
    begin
        SetupToCreateLedgerEntriesForExistingVendor(VendorLedgerEntry, CreateVendor(), IRS1099Code, VendorLedgerEntryAmount);
    end;

    local procedure SetupToCreateLedgerEntriesForExistingVendor(var VendorLedgerEntry: Record "Vendor Ledger Entry"; VendorNo: Code[20]; IRS1099Code: Code[10]; VendorLedgerEntryAmount: Decimal)
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
    begin
        CreateVendorLedgerEntry(
          VendorLedgerEntry, VendorLedgerEntry."Document Type"::Invoice, VendorNo, IRS1099Code, VendorLedgerEntryAmount);
        CreateVendorLedgerEntry(
          VendorLedgerEntry2, VendorLedgerEntry."Document Type"::Payment, VendorLedgerEntry."Vendor No.", IRS1099Code, 0);  // Using 0 for zero amount.
        CreateDetailedVendorLedgerEntry(
          VendorLedgerEntry."Entry No.", 0, DetailedVendorLedgEntry."Entry Type"::"Initial Entry",
          VendorLedgerEntry."Vendor No.", -VendorLedgerEntryAmount, true);
        CreateDetailedVendorLedgerEntry(
          VendorLedgerEntry2."Entry No.", 0, DetailedVendorLedgEntry."Entry Type"::"Initial Entry",
          VendorLedgerEntry."Vendor No.", VendorLedgerEntryAmount, true);
        CreateDetailedVendorLedgerEntry(
          VendorLedgerEntry."Entry No.", VendorLedgerEntry."Entry No.", DetailedVendorLedgEntry."Entry Type"::Application,
          VendorLedgerEntry."Vendor No.", VendorLedgerEntryAmount, false);
        CreateDetailedVendorLedgerEntry(
          VendorLedgerEntry2."Entry No.", VendorLedgerEntry."Entry No.", DetailedVendorLedgEntry."Entry Type"::Application,
          VendorLedgerEntry."Vendor No.", -VendorLedgerEntryAmount, false);
        VendorLedgerEntry.CalcFields(Amount);
        LibraryVariableStorage.Enqueue(VendorLedgerEntry."Vendor No.");
    end;

    local procedure SetupMultipleDocScenario(IRS1099Code: Code[10]): Decimal
    var
        VendorLedgerEntryInvoice: array[2, 3] of Record "Vendor Ledger Entry";
        VendorLedgerEntryPayment: Record "Vendor Ledger Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendorNo: array[2] of Code[20];
        TransactionNo: Integer;
        Index: Integer;
        DocAmount: array[2, 3] of Decimal;
        VendorIndex: Integer;
        VendorCount: Integer;
    begin
        // Create 2 vendors.
        // Create 3 invoices for each vendor in differenet transactions
        // Create payment and apply it for all invoices in a single transaction for both vendors

        TransactionNo := LibraryUtility.GetLastTransactionNo;

        VendorCount := ArrayLen(VendorNo);

        for VendorIndex := 1 to VendorCount do begin
            VendorNo[VendorIndex] := CreateVendor;
            for Index := 1 to ArrayLen(VendorLedgerEntryInvoice, 2) do begin
                TransactionNo += 1;
                DocAmount[VendorIndex, Index] := LibraryRandom.RandInt(100);
                InsertVendorLedgerEntry(
                  VendorLedgerEntryInvoice[VendorIndex, Index], VendorLedgerEntryInvoice[VendorIndex, Index]."Document Type"::Invoice,
                  LibraryUtility.GenerateGUID, VendorNo[VendorIndex], TransactionNo, IRS1099Code, DocAmount[VendorIndex, Index]);
                InsertDetailedVendorLedgerEntry(
                  VendorLedgerEntryInvoice[VendorIndex, Index]."Entry No.", 0, DetailedVendorLedgEntry."Entry Type"::"Initial Entry",
                  VendorLedgerEntryInvoice[VendorIndex, Index]."Vendor No.", TransactionNo, -DocAmount[VendorIndex, Index], true);
            end;
            LibraryVariableStorage.Enqueue(VendorNo[VendorIndex]);
        end;

        TransactionNo += 1;
        for VendorIndex := 1 to VendorCount do begin
            InsertVendorLedgerEntry(
              VendorLedgerEntryPayment, VendorLedgerEntryPayment."Document Type"::Payment,
              LibraryUtility.GenerateGUID, VendorNo[VendorIndex], TransactionNo, IRS1099Code, 0);

            for Index := 1 to ArrayLen(VendorLedgerEntryInvoice, 2) do begin
                InsertDetailedVendorLedgerEntry(
                  VendorLedgerEntryPayment."Entry No.", 0, DetailedVendorLedgEntry."Entry Type"::"Initial Entry",
                  VendorLedgerEntryPayment."Vendor No.", TransactionNo, DocAmount[VendorIndex, Index], true);
                InsertDetailedVendorLedgerEntry(
                  VendorLedgerEntryInvoice[VendorIndex, Index]."Entry No.", VendorLedgerEntryPayment."Entry No.",
                  DetailedVendorLedgEntry."Entry Type"::Application,
                  VendorLedgerEntryInvoice[VendorIndex, Index]."Vendor No.", TransactionNo, DocAmount[VendorIndex, Index], false);
                InsertDetailedVendorLedgerEntry(
                  VendorLedgerEntryPayment."Entry No.", VendorLedgerEntryInvoice[VendorIndex, Index]."Entry No.",
                  DetailedVendorLedgEntry."Entry Type"::Application,
                  VendorLedgerEntryPayment."Vendor No.", TransactionNo, -DocAmount[VendorIndex, Index], false);
            end;
        end;

        exit(CalcSumOfDocs(DocAmount, 1));
    end;

    local procedure RunVendor1099MagneticMediaReport(var FileName: Text)
    var
        Vendor1099MagneticMedia: Report "Vendor 1099 Magnetic Media";
        FileMgt: Codeunit "File Management";
    begin
        FileName := FileMgt.ServerTempFileName('txt');
        Vendor1099MagneticMedia.InitializeRequest(FileName);
        Vendor1099MagneticMedia.Run;
    end;

    local procedure RunVendor1099MagneticMediaReportSingleVendor(var FileName: Text; VendorNo: Code[20])
    var
        Vendor: Record Vendor;
        Vendor1099MagneticMedia: Report "Vendor 1099 Magnetic Media";
        FileMgt: Codeunit "File Management";
    begin
        FileName := FileMgt.ServerTempFileName('txt');
        Vendor.SetRange("No.", VendorNo);
        Vendor1099MagneticMedia.SetTableView(Vendor);
        Vendor1099MagneticMedia.InitializeRequest(FileName);
        Vendor1099MagneticMedia.Run;
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099DivRPH(var Vendor1099Div: TestRequestPage "Vendor 1099 Div")
    begin
        Vendor1099Div.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099Div.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099DivChangeCurrYearRPH(var Vendor1099Div: TestRequestPage "Vendor 1099 Div")
    begin
        Vendor1099Div.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099Div.Year.SetValue(LibraryVariableStorage.DequeueText());
        Vendor1099Div.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099InformationRPH(var Vendor1099Information: TestRequestPage "Vendor 1099 Information")
    begin
        Vendor1099Information.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099Information.Vendor.SetFilter("Date Filter", Format(WorkDate));
        Vendor1099Information.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099IntRPH(var Vendor1099Int: TestRequestPage "Vendor 1099 Int")
    begin
        Vendor1099Int.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099Int.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099IntChangeCurrYearRPH(var Vendor1099Int: TestRequestPage "Vendor 1099 Int")
    begin
        Vendor1099Int.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099Int.Year.SetValue(LibraryVariableStorage.DequeueText());
        Vendor1099Int.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099MiscRPH(var Vendor1099Misc: TestRequestPage "Vendor 1099 Misc")
    begin
        Vendor1099Misc.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099Misc.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099Misc2020ChangeCurrYearRPH(var Vendor1099Misc2020: TestRequestPage "Vendor 1099 Misc 2020")
    begin
        Vendor1099Misc2020.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099Misc2020.Year.SetValue(LibraryVariableStorage.DequeueText());
        Vendor1099Misc2020.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099Misc2021DoNothingRPH(var Vendor1099Misc2021: TestRequestPage "Vendor 1099 Misc 2021")
    begin
        Vendor1099Misc2021.Cancel().Invoke();
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099NecRPH(var Vendor1099Nec: TestRequestPage "Vendor 1099 Nec")
    begin
        Vendor1099Nec.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText());
        Vendor1099Nec.SaveAsXml(LibraryReportDataset.GetParametersFileName(), LibraryReportDataset.GetFileName());
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure Vendor1099MagneticMediaRPH(var Vendor1099MagneticMedia: TestRequestPage "Vendor 1099 Magnetic Media")
    begin
        Vendor1099MagneticMedia.Year.SetValue(Date2DMY(WorkDate, 3));
        Vendor1099MagneticMedia.TransCode.SetValue(CopyStr(LibraryUTUtility.GetNewCode, 1, 5));
        Vendor1099MagneticMedia.ContactName.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.ContactPhoneNo.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendContactName.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendContactPhoneNo.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendorInfoName.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendorInfoAddress.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendorInfoCity.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendorInfoCounty.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendorInfoPostCode.SetValue(LibraryUTUtility.GetNewCode);
        Vendor1099MagneticMedia.VendorInfoEMail.SetValue(LibraryUTUtility.GetNewCode);

        Vendor1099MagneticMedia.Vendor.SetFilter("No.", LibraryVariableStorage.DequeueText);
        Vendor1099MagneticMedia.OK.Invoke;
    end;
}

