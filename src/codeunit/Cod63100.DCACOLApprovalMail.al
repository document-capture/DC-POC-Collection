
namespace DCPOCCollection.DCPOCCollection;

using System.Automation;

codeunit 63100 "DCACOL Approval Mail"
{
    /// <summary>
    /// Event subscriber to replace the standard #APPROVALFORMLINK# placeholder with a custom one that we can replace later in other events
    /// </summary>
    /// <param name="ApprovalHyperlink"></param>
    /// <param name="IsHandled"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDC URL Management", OnBeforeGetApprovalHyperlink, '', false, false)]
    local procedure DCACOLApprovalMailOnBeforeGetApprovalHyperlink(var ApprovalHyperlink: Text[1024]; var IsHandled: Boolean)
    begin
        ApprovalHyperlink := CustomApprovalLink;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDC Purch. Approval E-Mail", 'OnBeforeSetApprovalHTMLBody2', '', false, false)]
    local procedure DCACOLApprovalMailOnBeforeSetApprovalHTMLBody2(var HTML: Text; ContiniaUserSetup: Record "CTS-CBF Continia User Setup")
    begin
        HTML := HTML.Replace(CustomApprovalLink, StrSubstNo(WebApprovalSSOLink, ContiniaUserSetup.GetEmail()))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDC Purch. Approval E-Mail", 'OnBeforeSetSharedReminderHTMLBody2', '', false, false)]
    local procedure DCACOLApprovalMailOnBeforeSetSharedReminderHTMLBody2(var HTML: Text; ApprovalEntry: Record "Approval Entry"; ApprovalSharing: Record "CDC Approval Sharing")
    var
        ContiniaUserSetup: Record "CTS-CBF Continia User Setup";
    begin
        HTML := HTML.Replace(CustomApprovalLink, StrSubstNo(WebApprovalSSOLink, GetContiniaUserEmailFromApprovalEntry(ApprovalEntry)));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDC Purch. Approval E-Mail", 'OnBeforeSetReminderHTMLBody2', '', false, false)]
    local procedure DCACOLApprovalMailOnBeforeSetReminderHTMLBody2(var HTML: Text; ApprovalEntry: Record "Approval Entry")
    begin
        HTML := HTML.Replace(CustomApprovalLink, StrSubstNo(WebApprovalSSOLink, GetContiniaUserEmailFromApprovalEntry(ApprovalEntry)));
    end;

    local procedure GetContiniaUserEmailFromApprovalEntry(ApprovalEntry: Record "Approval Entry"): Text
    var
        ContiniaUserSetup: Record "CTS-CBF Continia User Setup";
    begin
        if ContiniaUserSetup.Get(ApprovalEntry."Approver ID") then
            exit(ContiniaUserSetup.GetEmail());
    end;

    var
        // We need to store the link in a variable as the placeholder is the same for all lines in the email body, but the link can be different based on the approver
        CustomApprovalLink: Label '#CUSTOMAPPROVALFORMLINK#', Comment = 'Custom placeholder for approval link in email body', Locked = true;
        WebApprovalSSOLink: Label 'https://www.continiaonline.com/Account/SSO?%1', Comment = 'Link to Continia Online Web Approval with SSO', Locked = true;

}