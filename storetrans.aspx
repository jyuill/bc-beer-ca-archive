<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>B.C. Beer Guide Store - Successful Transaction</title> 
    <meta content="beer, poster, microbreweries, British Columbia, B.C., BC, micro-breweries, breweries, craft breweries, beer, beer poster" name="keywords" />
    <meta content="Items related to beer brewed by breweries and micro-breweries in British Columbia, such as posters" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
  <!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"> <UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> </div>
  </div>
  <!--DIV surrounding main content area -->
  <div class="mainbox" > 
    <h1 class="old">Successful Transaction</h1>
    
	<h2>Thank you for your payment!</h2>
	<p>Your transaction has been completed and a receipt for your purchase has been emailed to you.</p>
	<p>We will ship out your item by the end of the next business day.</p>
	
  </div>
</div>      
</body>
</html>