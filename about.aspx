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
    <title>BC Beer Guide - About It</title> 
    <meta content="john yuill, beer, microbreweries, British Columbia, B.C., BC, micro-breweries, breweries, craft breweries, beer, ale, Okanagan Spring, Granville Island, Shaftebury, Bear Brewing, Nelson Brewing, Mt. Begbie, Sleeman, Tree Brewing, Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Information on the B.C. Beer Guide hosted by John Yuill" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
<UserCtrl:GoogleTagMgr ID="UserCtrlGTM" runat="server" />
   <!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> </div>
  </div>
  <div class="mainbox" > 
    <h1 class="old">About the B.C. Beer Guide</h1>
    <br />
	<div>
		<div class="poster">
			<img src="images/johnbeercropbrown2.jpg" alt="JY" width="161" height="124"> <br />
			Your Host: John Yuill
          <p ></p>
		</div>
		<p>I started the B.C. Beer Guide in 1997 
            as a way to learn how to develop websites, while creating something 
            that I thought might be of interest to fellow beer enthusiasts. This 
            is purely a <span class="strong">'hobby' </span>venture, which explains why it 
            is not kept as up to date as it would be in an ideal world.</p>
          <p>In April, 2005, I finally got my act together and re-designed the 
            site to use <span class="strong">database</span> information, which is more efficient 
            to maintain, more accessible, and <span class="strong">enables visitors to post 
            their own thoughts</span> on breweries or specific brands of beer. 
          </p>
          <p>As for myself, I live in Kelowna, B.C. but came of legal drinking 
            age in Alberta around 1980, at which time I mostly drank cheap, watery 
            beer parlour draft without complaint. When this new thing called the 
            &quot;<span class="strong">microbrewery</span>&quot; came along, I knew there was no turning 
            back. Since moving to B.C., I have been able to enjoy even more great 
            beers - many of which are produced right here in this wilderness wonderland, 
            recreational playground, and beer paradise. I like it! </p>
          <p>Hope you find the site interesting. Don't hesitate to 
		  <a href="default.aspx" onmouseover="this.href='mai' + 'lto:' + 'john' + '@' + 'bcbeer.ca'"> 
            send me a note</a> if you have any comments, suggestions, questions, or criticisms [constructive 
            or otherwise]. </p>
		  <p>If you are interested in my professional work, check out the website for 
		  <!-- Testing cross-domain tracking in GA. Commented out link is original - restore when test is done. -->
		  <!--<a href="http://www.fig4.com" onclick="pageTracker._trackEvent('ExitLinks','Exit','Fig4.com');" title="Figure 4 Enterprises">-->
		  <a href="http://www.fig4.com" onclick="pageTracker._link('http://www.fig4.com');return false;" title="Figure 4 Enterprises">
		  Figure 4 Enterprises Inc.</a>
		  I also write a blog on the fascinating field of web analytics called 
              <a href="http://catbirdanalytics.wordpress.com" onclick="pageTracker._trackEvent('ExitLinks','Exit','Catbird');">Catbird Analytics</a>.</p>
          <p>Cheers, </p>
          <p>John Yuill</p>
          <p><a href="http://www.twitter.com/bcbeerguide" onclick="pageTracker._trackPageview('/virtual-pv/twitter-bcbg.com');">
              <img alt="twitter" src="/images/twitter-50.jpg" /></a>
              <a href="http://www.twitter.com/bcbeerguide" onclick="pageTracker._trackPageview('/virtual-pv/twitter-bcbg.com');">@BCBeerGuide</a>
          
                  </p>
	</div>
  </div>
  <UserControl:Foot id="UserControl4" runat="server" />
  </div>
</body>
</html>