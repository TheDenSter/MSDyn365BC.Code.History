table 99000786 "Routing Version"
{
    Caption = 'Routing Version';
    DrillDownPageID = "Routing Version List";
    LookupPageID = "Routing Version List";

    fields
    {
        field(1; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            NotBlank = true;
            TableRelation = "Routing Header";
        }
        field(2; "Version Code"; Code[20])
        {
            Caption = 'Version Code';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; Status; Enum "Routing Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            var
                RoutingHeader: Record "Routing Header";
                SkipCommit: Boolean;
            begin
                if (Status <> xRec.Status) and (Status = Status::Certified) then begin
                    RoutingHeader.Get("Routing No.");
                    CheckRouting.Calculate(RoutingHeader, "Version Code");
                end;
                Modify(true);

                SkipCommit := false;
                OnValidateStatusBeforeCommit(Rec, SkipCommit);
                if not SkipCommit then
                    Commit();
            end;
        }
        field(21; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Serial,Parallel';
            OptionMembers = Serial,Parallel;

            trigger OnValidate()
            begin
                if Status = Status::Certified then
                    FieldError(Status);
            end;
        }
        field(22; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(50; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Routing No.", "Version Code")
        {
            Clustered = true;
        }
        key(Key2; "Routing No.", "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        RtngLine: Record "Routing Line";
    begin
        RtngLine.LockTable();
        RtngLine.SetRange("Routing No.", "Routing No.");
        RtngLine.SetRange("Version Code", "Version Code");
        RtngLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if "Version Code" = '' then begin
            RoutingHeader.Get("Routing No.");
            RoutingHeader.TestField("Version Nos.");
            NoSeriesMgt.InitSeries(RoutingHeader."Version Nos.", xRec."No. Series", 0D, VersionCode, "No. Series");
            if StrLen(VersionCode) > MaxStrLen("Version Code") then
                Error(Text000,
                  FieldCaption("Version Code"),
                  NoSeriesLine.FieldCaption("Starting No."),
                  RoutingHeader."Version Nos.",
                  NoSeries.TableCaption(),
                  MaxStrLen("Version Code"));

            "Version Code" := VersionCode;
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        if Status = Status::Certified then
            Error(Text001, TableCaption(), FieldCaption(Status), Format(Status));
    end;

    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        RoutingHeader: Record "Routing Header";
        RtngVersion: Record "Routing Version";
        CheckRouting: Codeunit "Check Routing Lines";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text000: Label 'The new %1 cannot be generated by default\because the %2 for %3 %4 contains more than %5 characters.';
        VersionCode: Code[20];
        Text001: Label 'You cannot rename the %1 when %2 is %3.';

    procedure AssistEdit(OldRoutVersion: Record "Routing Version"): Boolean
    begin
        with RtngVersion do begin
            RtngVersion := Rec;
            RoutingHeader.Get("Routing No.");
            RoutingHeader.TestField("Version Nos.");
            if NoSeriesMgt.SelectSeries(RoutingHeader."Version Nos.", OldRoutVersion."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries(VersionCode);
                if StrLen(VersionCode) > MaxStrLen("Version Code") then
                    Error(Text000,
                      FieldCaption("Version Code"),
                      NoSeriesLine.FieldCaption("Starting No."),
                      RoutingHeader."Version Nos.",
                      NoSeries.TableCaption(),
                      MaxStrLen("Version Code"));

                "Version Code" := VersionCode;
                Rec := RtngVersion;
                exit(true);
            end;
        end;
    end;

    procedure Caption(): Text
    var
        RtngHeader: Record "Routing Header";
    begin
        if GetFilters = '' then
            exit('');

        if "Routing No." = '' then
            exit('');

        RtngHeader.Get("Routing No.");
        exit(
          StrSubstNo(
            '%1 %2 %3', RtngHeader."No.", RtngHeader.Description, "Version Code"));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateStatusBeforeCommit(var RoutingVersion: Record "Routing Version"; var SkipCommit: Boolean)
    begin
    end;
}

