<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" Title="Send Email Test" %>

<script runat="server">

Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim MailObj As New System.Net.Mail.SmtpClient
        Dim strRecipient As String
        Dim strSender As String
        strSender = "brewery@bcbeer.ca"
        strRecipient = "johnyuill@yahoo.com"
        MailObj.Host = "localhost"    'for testing on local server
        'MailObj.Host = "smtp.bcbeer.ca"  'for deploying on remote server
        MailObj.Send(strSender, strRecipient, TextBox3.Text, TextBox2.Text)
        lblThanks.Text = "Your email has been sent...thanks!"
        TextBox3.Text = ""
        TextBox2.Text = ""
End Sub
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    &nbsp;
    <asp:Label ID="Label3" runat="server" Style="z-index: 106; left: 12px; position: absolute;
        top: 78px" Text="Subject" Width="78px" />
    <asp:TextBox ID="TextBox3" runat="server" Style="z-index: 105; left: 105px; position: absolute;
        top: 76px" Width="343px" />
     <asp:Label ID="Label2" runat="server" Style="z-index: 103; left: 12px; position: absolute;
        top: 101px" Text="Comment" />
    <asp:TextBox ID="TextBox2" runat="server" Style="z-index: 102; left: 105px; position: absolute;
        top: 101px" Rows="2" TextMode="MultiLine" Width="439px" />
    <asp:Button ID="Button1" runat="server" Style="z-index: 104; left: 105px; position: absolute;
        top: 148px" Text="Send" OnClick="Button1_Click" />
    <asp:label id="lblThanks" style="position: absolute; top: 175px; left: 105px" runat="server" />
    
    
    &nbsp;
</asp:Content>

