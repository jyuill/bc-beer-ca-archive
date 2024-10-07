<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

Sub Page_Load()

	If Not Page.IsPostBack Then
		'Ensuress that form is blank first time page is loaded
		txtName.text = ""
		txtEmail.text = ""
		txtMessage.text=""
	End If		
End Sub

Sub btnSendFeedback_Click(sender as Object, e as EventArgs)

  'Create an instance of the MailMessage class
  Dim objMM as New MailMessage()

  'Set the properties - send the email to the person who filled out the
  'feedback form.
  objMM.To = "johnyuill@yahoo.com"
  objMM.From = "user@fig4.com"

  'If you want to CC this email to someone else, uncomment the line below
  'objMM.Cc = "someone@someaddress.com"

  'If you want to BCC this email to someone else, uncomment the line below
  'objMM.Bcc = "someone@someaddress.com"

  'Send the email in text format
  objMM.BodyFormat = MailFormat.Text
  '(to send HTML format, change MailFormat.Text to MailFormat.Html)

  'Set the priority - options are High, Low, and Normal
  objMM.Priority = MailPriority.Normal

  'Set the subject
  objMM.Subject = "BCBG - Feedback"

  'Set the body
  objMM.Body = "At " + DateTime.Now + " feedback was sent from " & _
               txtName.Text & "." & vbCrLf & vbCrLf & _
               "---------------------------------------" & vbCrLf & vbCrLf & _
               txtMessage.Text & vbCrLf

  'Specify the Smtp Server - problems occur without this
  'For local testing:
  'SmtpMail.SmtpServer = "localhost"
  'For live website:
  SmtpMail.SmtpServer = "smtp.fig4.com"
  
  'Now, to send the message, use the Send method of the SmtpMail class
  SmtpMail.Send(objMM)

  panelSendEmail.Visible = false
  panelMailSent.Visible = true
  
  'Clears form for next time
  txtName.text = ""
  txtEmail.text = ""
  txtMessage.text=""
End Sub

Sub Reveal_Form_Click (Sender As Object, E As EventArgs)
  panelSendEmail.Visible = true
  panelMailSent.Visible = false
End Sub

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>B.C. Beer Guide - Feedback</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
   <!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> </div>
  </div>
  <div class="mainbox mainboxL" > 
    <h1 class="old">Feedback on the B.C. Beer Guide</h1>
    <br />
   <form runat="server">
   <asp:panel id="panelSendEmail" runat="server">
    
      <h3>We are interested in your feedback!  Please enter the following
      requested information below to send us your comments.</h3>

      <b>Your Name:</b>
      <asp:textbox id="txtName" runat="server" />
      <br>

      <b>Your Email Address:</b>
      <asp:textbox id="txtEmail" runat="server" />
      <p>

      <b>Your Message:</b><br>
      <asp:textbox id="txtMessage" TextMode="MultiLine"
                      Columns="40" Rows="10" runat="server" />
      <p>

      <asp:button runat="server" id="btnSendFeedback" Text="Send Feedback!"
                  OnClick="btnSendFeedback_Click" />
    
  </asp:panel>

  <asp:panel id="panelMailSent" runat="server" Visible="False">
    Your feedback has been sent to us.  Thanks!
	<asp:button id="Reveal_Form" Text="Leave More Feedback" OnClick="Reveal_Form_Click" RUNAT="server" />		 
  </asp:panel>
  </form>
   
  </div>
</div>
</body>
</html>