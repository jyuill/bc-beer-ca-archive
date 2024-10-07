<%@ Page Language="VB" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        'Demonstrates how to programmatically tie a javascript function to asp button on-click
        btnTest2.Attributes.Add("onclick", _
           "javascript:alert('ALERT ALERT!!!');")
        'Demonstrates how to do above for GA event tracking
        'Note that onclick for btnTest3 is initially set to fire btnClick2 below
        btnTest3.Attributes.Add("onclick", _
           "pageTracker._trackEvent('Links','Button','Home3')")
         
    End Sub

    'On click action tied to btnTest3 - ultimate objective
    'btnTest3.attributes.add above adds javascript onclick event at page load
    'idea is for javascript to fire first, then btnClick2 - not sure the mechanism
    'in page source the onclick is set to javascript 
    Sub btnClick2(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("default.aspx")
        'Response.Write("Javascript:Alert('Alert!')")
    End Sub
    
</script>
<script language="javascript" type="text/javascript">
    function btnClick()
    { window.location = "default.aspx"; }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h1>
            Testing Event Tracking in Google Analytics
        </h1>
        
    </div>
    
    <p>GATC is embedded at bottom of this page.</p>
    <p>
        Started: June 25, 2009</p>
    <p>
        Link set up for event tracking: <a href="default.aspx" onclick="pageTracker._trackEvent('Links','Text','Home1');">Home1 Event</a></p>
    <p>
        Button set up for event tracking:
        <input id="Button1" type="button" value="Click for Home2 Event" onclick="pageTracker._trackEvent('Links','Button','Home2');btnClick();" />
        <!--<input id="Button1" type="button" value="Click for Home2 Event" onclick="btnClick();" />-->
        </p>
<p>
    <asp:Button ID="btnTest2" runat="server" Text="Click Here for ALERT!" />
    <asp:Button ID="btnTest3" runat="server" Text="Click for Home3 Event!" onclick="btnClick2" />
</p>
<!-- GA Tracking Code -->
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-3371059-1");
pageTracker._initData();
pageTracker._trackPageview();
</script>
<!-- End GA Tracking Code -->
</form>
</body>
</html>
