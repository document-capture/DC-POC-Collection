namespace DCPOCCollection.DCPOCCollection;

using Microsoft.Finance.RoleCenters;

pageextension 63100 "DCACOL TempRoleCenter Ext" extends "CDC Document Capture Setup"
{

    actions
    {
        addfirst(Processing)
        {
            action(SendApprovalMail)
            {
                Caption = 'Run DCACOL Test Report';
                ApplicationArea = All;
                Image = SendMail;
                PromotedIsBig = true;
                Promoted = true;
                trigger OnAction()
                var
                    TempEventReg: Record "CDC Event Register";
                    TempEventEntry: Record "CDC Event Entry";
                    EventEntryCmt: Record "CDC Event Entry Comment";
                begin
                    if Confirm('Do you want to run the DCACOL Temp Role Center Extension code?') then begin
                        TempEventReg.DeleteAll();
                        TempEventEntry.DeleteAll();
                        EventEntryCmt.DeleteAll();
                        Commit();
                        Report.Run(6085582);
                    end;
                end;
            }
        }
    }
}
