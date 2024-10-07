<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">


</script>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>BC Beer Guide Store</title> 
    <meta content="beer, poster, microbreweries, British Columbia, B.C., BC, micro-breweries, breweries, craft breweries, beer, beer poster" name="keywords" />
    <meta content="Posters and other items related to micro-breweries in British Columbia" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
<UserCtrl:GoogleTagMgr ID="UserCtrlGTM" runat="server" />
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
    <h1 class="old">Beer Items For Sale</h1>
    <h2>British Columbia Beer Poster - <i>No longer available</i></h2>
    <p> 
    <div class="poster"> 
      <!--<a href="images/store/BCbeerposter_lg.jpg" target="blank">-->
      <asp:HyperLink id="HyperLink1" NavigateURL="viewpicture.aspx?Img=images/store/BCbeerposter_lg.jpg" runat="server">       
      		<img name="beerposter" src="images/store/BCbeerposter_sm.jpg" width="120" height="180" alt="BC Beer Poster" /> 
      	</asp:HyperLink>
      <!--</a>-->
      <br>
      Click photo for larger view </div>
    <!--The British Columbia Beer Guide is proud to offer for sale this stylish 
        poster celebrating the great beers of B.C.-->
    Here is a cool item for any beer lover: a great-looking poster celebrating 
    the classic beers of BC! Some old favourites no longer with us, mixed in with 
    some standard-bearers that are still going strong, making this a unique collection. 
    Looks great on its own, in a frame, or plaque-mounted. 
    <p>Sorry, no longer available. Size: 24"x36". </p>
    <table style="margin-top: 5px; font-family: Verdana, Arial">
      <tr> 
        <td style="font-weight: bold">Price:</td>
        <td style="text-align: right; font-weight: bold; color: #990000">-</td>
      </tr>
      <tr> 
        <td style="font-weight: bold">Shipping/Handling:</td>
        <td style="text-align: right; font-weight: bold; color: #990000">-</td>
      </tr>
      <!--<tr> 
          <td style="font-weight: bold">Total: (tax incl.)</td>
          <td style="text-align: right; font-weight: bold; color: #990000">$21.00</td>
        </tr>-->
    </table>
    <%--<p style="font-size: 11px; font-style: italic">All prices Canadian dollars. 
      No additional taxes apply. Shipping to Canada or US. We aim to ship next 
      business day via regular post.</p>
    <br>--%>
    
    <%--<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
        <input type="hidden" name="cmd" value="_s-xclick">
        <input type="image" src="https://www.paypal.com/en_US/i/btn/x-click-butcc.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!">
        <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
        <input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----MIIHwQYJKoZIhvcNAQcEoIIHsjCCB64CAQExggEwMIIBLAIBADCBlDCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20CAQAwDQYJKoZIhvcNAQEBBQAEgYCJecYXaJvMoQ16zkYeiSzQU+I5SgAAgOzLvLUp0djtRtxN11k2ALU5T9Kug/MOcGnQ3cd+77sOrAWCkH0q4WxxJVjP6JPcXS/lizNtCUR1IdgI+fvvi3Hf8wtwEiD0pbmmqoPwSp7em7qf2HgmTrO8F8CoXTkm1qFbN2Zrz3xx1jELMAkGBSsOAwIaBQAwggE9BgkqhkiG9w0BBwEwFAYIKoZIhvcNAwcECPEfGElWby4ygIIBGMphhsHsf7Bpx4TK9UXA8JLsBhNmiACNhiXMb9eloTMJkdF4pUXq9L/6yfFnDRsINdB0FhM4L8/LEOVfz8hEtA1qwEM/U+dNOB57pPKYxHV19ZcHJq5YjxH1eqOLWWn73GkYRoGwQyxHijZnG46fVdpMxSxV+6IJWk4Xuf/k1z4w89fW+M2/4SEDrct9cvfElKGf/hZGo6LBFDwMNP70Ym3SWB27L4kCJK+to4L2XL2153VWz2g9GbTv3GiZLyB0G2C7zUK7dL2l4fsot2Eg4i/2MlcWGd8902i9O0/O8YqHfSl58R2SZGq3gSWVFSCNiAbC+SzdLxzELNU35EyhhB6G9Sp5lR+Et8maHoPxoE2t6tXvBQGvp/OgggOHMIIDgzCCAuygAwIBAgIBADANBgkqhkiG9w0BAQUFADCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20wHhcNMDQwMjEzMTAxMzE1WhcNMzUwMjEzMTAxMzE1WjCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMFHTt38RMxLXJyO2SmS+Ndl72T7oKJ4u4uw+6awntALWh03PewmIJuzbALScsTS4sZoS1fKciBGoh11gIfHzylvkdNe/hJl66/RGqrj5rFb08sAABNTzDTiqqNpJeBsYs/c2aiGozptX2RlnBktH+SUNpAajW724Nv2Wvhif6sFAgMBAAGjge4wgeswHQYDVR0OBBYEFJaffLvGbxe9WT9S1wob7BDWZJRrMIG7BgNVHSMEgbMwgbCAFJaffLvGbxe9WT9S1wob7BDWZJRroYGUpIGRMIGOMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC1BheVBhbCBJbmMuMRMwEQYDVQQLFApsaXZlX2NlcnRzMREwDwYDVQQDFAhsaXZlX2FwaTEcMBoGCSqGSIb3DQEJARYNcmVAcGF5cGFsLmNvbYIBADAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4GBAIFfOlaagFrl71+jq6OKidbWFSE+Q4FqROvdgIONth+8kSK//Y/4ihuE4Ymvzn5ceE3S/iBSQQMjyvb+s2TWbQYDwcp129OPIbD9epdr4tJOUNiSojw7BHwYRiPh58S1xGlFgHFXwrEBb3dgNbMUa+u4qectsMAXpVHnD9wIyfmHMYIBmjCCAZYCAQEwgZQwgY4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLUGF5UGFsIEluYy4xEzARBgNVBAsUCmxpdmVfY2VydHMxETAPBgNVBAMUCGxpdmVfYXBpMRwwGgYJKoZIhvcNAQkBFg1yZUBwYXlwYWwuY29tAgEAMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNjA5MTAwNzQwMzVaMCMGCSqGSIb3DQEJBDEWBBR5nkgqvklW3bjfGvUp5xVQ8o93MTANBgkqhkiG9w0BAQEFAASBgGpov+aQlbeOeKP+xblVrWufQYXctRQ6qMH4qx+k8TJswJVzY0134ppkaN2pjhQgvb8gpGy236rhZVsFNbRPi9NYQLFnLx5WS2IM8RNwwdxrvp+2lfCqCH9/ZpnE24kKT0T288yo9/l72QNvWBljlgyjMQrDNxB2oNLNdl3SyhuI-----END PKCS7-----
">
    </form>--%>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
  </div>
  <UserControl:Foot id="UserControl4f" runat="server" /> 
</div>  

</body>
</html>