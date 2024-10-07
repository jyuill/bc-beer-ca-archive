<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="CSSselect" Src="css_select.ascx" %>


<script runat="server">
    Sub Page_Load()
        Dim strRefer = Request.UrlReferrer.ToString()
        '**Sends email to me notifying of error**
        Dim objMail2 As New System.Net.Mail.SmtpClient
        Dim objMailMessage2 As New System.Net.Mail.MailMessage
        Dim adrSender2 As New System.Net.Mail.MailAddress("error@bcbeer.ca")
        objMailMessage2.From = adrSender2
        objMailMessage2.To.Add("john@bcbeer.ca")
        objMailMessage2.Subject = "Error Page Message - BCBG"
        objMailMessage2.IsBodyHtml = True
        objMailMessage2.Body = "<html><head></head><body>" & _
            DateTime.Now & "<p>Someone has encountered an error on BC Beer Guide, " & _
            "causing the error page to display.  The error comes from: " & _
            strRefer & _
            ".</p><p><i>Note: You may have received another message " & _
            "regarding this error if it originates from " & _
            "beer or brewery comments pages.<i></p></body></html>"
            
        '-For testing on local:
        'objMail2.Host = "localhost"
        '-For remote server:
        objMail2.Host = "smtp.bcbeer.ca"
        objMail2.Send(objMailMessage2)
        '**End of email to me section **
    End Sub
</script>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>B.C. Beer Guide - Breweries</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body><form id="form1" runat="server">
<!-- DIV for outer shell to set width of page -->
<div id="outer">
    <!-- Div for topsection including logo and slogan -->
    <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo>
	</div>
	<!--DIV surrounding navbar embedded in usercontrols -->
	<div class="navsection">
			<USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV>
	 		<div id="belowNavbar">
				<UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> 	
			</div>   
		</div>
         
  <div class="mainbox" >                  
   <h1>Error</h1><br />
   <h3>Sorry...you have encountered a problem with the BC Beer Guide.  </h3>
   <p>We would appreciate it if you would  
   <a href="default.aspx" onmouseover="this.href='mai' + 'lto:' + 'john' + '@' + 'bcbeer.ca'">email us</a>
   to let us know what went wrong
   so that we can fix the problem and improve the website for you and others!</p>
 </div>
 <!-- End of Mainbox -->
 <UserControl:Foot id="UserControl4" runat="server" />
</div>
 <!-- End of Outer --></form>
</body>
</html>
