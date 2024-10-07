<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">


</script>
<html>
<head>
    <title>B.C. Beer Guide - Template</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <link href="bcbgstyle.css" type="text/css" rel="stylesheet" />
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
  	<form runat="server">
    <h1 class="old">Heading 1</h1>
    
	<h2>Heading 2</h2>
	<p>Page content here</p>
      
   
    </form>
  </div>
</div>      
</body>
</html>