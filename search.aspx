<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="CSSselect" Src="css_select.ascx" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

   

</script>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>BC Beer Guide: Search</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body> 
<form id="form1" runat="server">
  <!-- DIV for outer shell to set width of page -->
  
  <div id="outer"> 
    <!-- Div for topsection including logo and slogan -->
    <div class="top"> <UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo>
    </div>
    <!--DIV surrounding navbar embedded in usercontrols -->
    <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
      <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> </div>
    </div>
    <div class="mainbox mainboxC" > 
      <h1 class="old">Search Page</h1>
      <p style="text-align: center">Search for information on the B.C. Beer Guide...or the entire web...</p>
      <iframe src="search.htm"  frameborder="0" scrolling="no" width="66%" >
        <!-- link to search.htm page for browsers that don't understand
        iframe -->
        <a href="search.htm">Search</a>
      </iframe>
     </div>
     <!--footer outside main box identifying website builder-->
    <UserControl:Foot id="UserControl4f" runat="server" />
  </div><!--end of outer box-->
  <!--stupid spacer div to make room for the page to scroll down to footer-->
<div>&nbsp;</div>
</form>         
</body>
</html>