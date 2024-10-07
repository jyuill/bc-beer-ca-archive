<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB"  MaintainScrollPositionOnPostback="true" ContentType="text/html" Debug="false" ResponseEncoding="windows-1252" %>

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
                
        If Not IsPostBack Then
    
            '--Manual procedure discarded in favour of auto datasource setup
            '------- Making the connection ------
            'Dim strConnection As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
            'strConnection += "Data Source = " & Request.PhysicalApplicationPath & ("_private\breweries.mdb")
    
            'Dim objConnection As New OleDbConnection(strConnection)
    
            '--------Connection made ---------
            
            '---Info for all features
            'objConnection.Open()
            'Dim strSQLfa As String = "Select * FROM tblFeature WHERE fshow = true ORDER BY fDate DESC"
            'Dim objAdapterFa As New OleDbDataAdapter(strSQLfa, objConnection)
            'Dim objDataSetFa As New DataSet()
            'objAdapterFa.Fill(objDataSetFa, "FeatureList")
            
            'objConnection.Close()
       
        End If
    End Sub

    Function Truncate(ByVal strDescrip As String)
        Dim intLength As Integer
        intLength = 400
        If strDescrip.Length < intLength Then
            Return strDescrip
        Else
            Return strDescrip.Substring(0, intLength) & "..."
        End If
    End Function
    
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>BC Beer Guide: Features</title> 
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
      <h1 class="old">On Tap Features</h1>
       
       <!--DataSource for Features -->
          <asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/_private/Breweries.mdb"
              SelectCommand="SELECT [fnum], [fdate], [fsub], [ftitle], [fcontent], [flink], [fimage], [fshow] FROM [tblFeature] WHERE [fshow]= true ORDER BY [fdate] DESC">
          </asp:AccessDataSource>
        <!--DataList for Features using above DataSource -->
       <asp:DataList ID="DataList1" runat="server" DataKeyField="fnum" DataSourceID="AccessDataSource1"
           ShowFooter="False" ShowHeader="False">
           <ItemTemplate>
               <asp:Label ID="fnumLabel" runat="server" Text='<%# Eval("fnum") %>' Visible="false"></asp:Label><br />
               <h2><asp:Label ID="fsubLabel" runat="server" Text='<%# Eval("fsub") %>'></asp:Label></h2>
               <h3 class="nonital"><asp:HyperLink ID="HyperLink4" NavigateURL='<%# "featureselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"fnum")) %>' runat="server">
               <asp:Label ID="ftitleLabel" runat="server" Text='<%# Eval("ftitle") %>'></asp:Label>
               </asp:HyperLink></h3>
               <span class="softdate"><asp:Label ID="fdateLabel" runat="server" Text='<%# Eval("fdate", "{0:dd/MM/yyyy}") %>'></asp:Label></span>
               <p><asp:Image CssClass="fimage" ID="FeatImage2" ImageUrl='<%# "images\features\" + Container.DataItem("fimage") %>' AlternateText="no image" runat="server" />
               <asp:Label ID="fcontentLabel" runat="server" Text='<%# Truncate(Eval("fcontent")) %>'></asp:Label>
               <asp:HyperLink ID="HyperLink9" NavigateURL='<%# "featureselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"fnum")) %>' runat="server" Text="more" />
               </p>
                <p>
               <asp:Label ID="Label1" runat="server" Text="More info: " />
               <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# Bind("flink") %>'>
                    <asp:Label ID="flinkLabel" runat="server" Text='<%# Bind("flink") %>' />
               </asp:HyperLink>
               </p>
           </ItemTemplate>
       </asp:DataList>
  </div>
  <UserControl:Foot id="UserControl4f" runat="server" /> 
</div></form>  
        
</body>
</html>