<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="SaveDate" Src="SaveDate.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Sub Page_Load()
         If Not IsPostback Then
    
                '------- Making the connection ------
                Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
                strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
    
                Dim objConnection as New OLEDBConnection(strConnection)
    
                '--------Connection made ---------
    
                '---Information retrieved for EVents
                Dim strSQLE as string = "SELECT Subject, Eventitem, Bmark, Description, EntryDate, EventDate, "
            strSQLE += "Link, ExpiryDate FROM tblNewsEvents WHERE Eventitem=True AND ExpiryDate < Date() ORDER BY EventDate DESC"
                Dim objAdapterE as New OledbDataAdapter(strSQLE, objConnection)
                Dim objDataSetE as New DataSet()
                ObjAdapterE.Fill(objDataSetE, "tblEvents")
    
                '---Datalist for events
                dlEvents.DataSource=objDataSetE.Tables("tblEvents")
                dlEvents.DataBind()
    
                '---Information retrieved for News
                Dim strSQLN as string = "SELECT Subject, Eventitem, Bmark, Description, EntryDate, EventDate, "
            strSQLN += "Link, ExpiryDate FROM tblNewsEvents WHERE Eventitem=False AND ExpiryDate < Date() ORDER BY EntryDate DESC"
                Dim objAdapterN as New OledbDataAdapter(strSQLN, objConnection)
                Dim objDataSetN as New DataSet()
                ObjAdapterN.Fill(objDataSetN, "tblNews")
    
                '---Datalist for events
                dlNews.DataSource=objDataSetN.Tables("tblNews")
                dlNews.DataBind()
    
         End If
      End Sub

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>BC Beer Guide - News and Events</title> 
    <meta content="beer, brewing, breweries, British Columbia, microbreweries, B.C., craft breweries, BC, Canada, beer, micro-breweries, breweries, ale, cottage breweries, &#13;&#10;real ale, real beer, lager" name="keywords" />
    <meta content="Beer news and events in B.C. beer, brewing, brewery, micro-brewery, brewpubs" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
<UserCtrl:GoogleTagMgr ID="UserCtrlGTM" runat="server" />

<form id="form1" runat="server">
<!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo>    
  </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> 
      <div id="subNav">  </div>
    </div>
  </div>
  <div class="mainbox" > 
        <div style="position: absolute; width: 98%; top: 20px; text-align: right"><a href="news.aspx" class="mail">Current News / Events</a></div>
      <h1 class="old">News and Events Archive</h1>
      <div class="lft"> 
        <h2>Old B.C. Beer News </h2>
         
        <asp:DataList id="dlNews" runat="server">
           <ItemTemplate>
                <h3><a name= '<%#DataBinder.Eval(Container.DataItem, "Bmark") %>' runat="server"> 
                  <%# DataBinder.Eval(Container.DataItem, "Subject") %>
                  </a></h3>
                <span class="softdate">
				(<%# DataBinder.Eval(Container.DataItem, "EntryDate", "{0:dd/MM/yyyy}") %>)
				</span> <br />
                <%# DataBinder.Eval(Container.DataItem, "Description") %>
                <p class="moreinfo"><span class="more">More info:</span> 
                  <asp:hyperlink id="LinkN" Text='<%# DataBinder.Eval(Container.DataItem, "Link") %>' NavigateURL= '<%# "http://" + DataBinder.Eval(Container.DataItem, "Link") %>' runat="server" />
                </p>
                </ItemTemplate>
      </asp:DataList> </div>
      <div class="rht"> 
        <h2>Past Events </h2>
         
        <asp:DataList id="dlEvents" runat="server">
         <ItemTemplate>
                <h3><a name= '<%#DataBinder.Eval(Container.DataItem, "Bmark") %>' runat="server"> 
                  <%# DataBinder.Eval(Container.DataItem, "Subject") %>
                  </a> </h3>
                <span class="softdate">
				(<%# DataBinder.Eval(Container.DataItem, "EntryDate", "{0:dd/MM/yyyy}") %>)
				</span><br />
                <%# DataBinder.Eval(Container.DataItem, "Description") %>
                <p class="moreinfo"><span class="more">More info:</span> 
                  <asp:hyperlink id="LinkE" Text='<%# DataBinder.Eval(Container.DataItem, "Link") %>' NavigateURL= '<%# "http://" + DataBinder.Eval(Container.DataItem, "Link") %>' runat="server" />
                </p>
                </ItemTemplate>
      </asp:DataList> </div>
      <div class="clr">clears the floats so outer div extends down - content hidden</div>
    
  </div>
  <UserControl:Foot id="UserControl4f" runat="server" /> </div>
  </form>                
</body>
</html>