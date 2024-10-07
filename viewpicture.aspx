<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">
 
Sub Page_Load()

Image1.ImageUrl=Request.Params("Img")

End Sub

</script>
<html>
<head>
    <title>B.C. Beer Guide - Selected Image</title> 
    <link href="bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>
<body>
  <!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <form runat="server">	
  <div class="top"> <UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> </div>
  <div style="text-align: center; font-style: italic"> (Use 'Back' button to return to previous page)<br>	
	<asp:Image ID="Image1" ImageUrl=
	AlternateText="BCBG Picture" runat="server" />
   
  </div>
  </form>
</div>      
</body>
</html>