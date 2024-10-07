<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="iso-8859-1"  %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>

<script runat="server">
Sub Submit_OnClick(sender as Object, e as EventArgs)
    If FormsAuthentication.Authenticate (txtUserName.Text, txtPassword.Text) Then
         FormsAuthentication.RedirectFromLoginPage (txtUserName.Text, False)
    Else
         'Invalid credentials supplied, display message
         Message.Text = "Incorrect username or password - return to public pages"
    End If
End Sub
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>BCBG - Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
    
</head>

<body>
<!-- DIV for outer shell to set width of page -->
 <!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV>
    <div id="belowNavbar"> &nbsp;</div>
  </div> 
  <div class="mainbox" > 
    
  <h1>Restricted Section Login</h1>
  <form runat="server">
    <table>
      <tr> 
        <td>Username:</td>
        <td><ASP:TEXTBOX id="txtUserName" RUNAT="server" SIZE="20" /></td>
      </tr>
      <td>Password:</td>
      <td> <ASP:TEXTBOX id="txtPassword" RUNAT="server" SIZE="20" TEXTMODE="Password" /></td>
      <tr>
        <td>&nbsp;</td>
        <td><ASP:BUTTON id="btnSubmit" onclick="Submit_OnClick" RUNAT="server" Text="Login"></ASP:BUTTON></td>
      </tr>
    </table>
  </form>
  <p>
    <asp:Label id="message" runat="server"></asp:Label>
  </p>
  </div>
   <UserControl:Foot id="UserControl4" runat="server" />
</div>
</body>
</html>
