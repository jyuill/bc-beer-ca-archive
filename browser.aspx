<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" Title="Untitled Page" %>
<script runat="server"  >
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Label1.Text = "Type = " & Request.Browser.Type
        Label2.Text = "Name = " & Request.Browser.Browser
        Label3.Text = "Version = " & Request.Browser.Version
        Label4.Text = "Major Version = " & Request.Browser.MajorVersion
        Label5.Text = "Platform = " & Request.Browser.Platform
    End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label><br />
    <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label><br />
    <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label><br />
    <asp:Label ID="Label4" runat="server" Text="Label"></asp:Label><br />
    <asp:Label ID="Label5" runat="server" Text="Label"></asp:Label>
</asp:Content>

