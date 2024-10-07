<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ import Namespace="System.Data" %>
<%--<%@ import Namespace="System.Data.OLEDB" %>--%>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<Script runat="server">
Public lastCat as String

Sub Page_Load()
         If Not IsPostback Then
    
            '------- Making the connection ------
            '-- original Access connection
            'Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
            'strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
    
            '-- new SQL test connection
            '-- works with local SQL Server Express:
            '---- should be able to use '.', (local), or localhost in place of server name to specify local computer
            'Dim strConnection As String = "Data Source=.\SQLSERVER;Initial Catalog=Breweries2;Integrated Security=True;MultipleActiveResultSets=True;"
            '-- works with local SQL Server Express (login):
            'Dim strConnection As String = "Data Source=.\SQLSERVER;Initial Catalog=Breweries2;Integrated Security=False; User Id=sa;Password=curlew;MultipleActiveResultSets=True;"
            '-- try to connect with SQL Server on LFS
            '---- sqlserver8.loosefoot.com
            '---- breweries2
            '---- u: bcbeertest
            '---- p: curlew
            '-- works perfectly but requires using string on each page
            'Dim strConnection As String = "Data Source=sqlserver8.loosefoot.com;Initial Catalog=Breweries2;Integrated Security=False; User Id=bcbeertest;Password=curlew;MultipleActiveResultSets=True;"
            '-- Web config
            '---- connecting via connection string in web.config for central location
            Dim strConnection As String = ConfigurationManager.ConnectionStrings("strConnection1").ToString
            Dim objConnection As New SqlConnection(strConnection)
            'objConnection.Open()
    
                '--------Connection made ---------
    			'---Information retrieved for Categories listed at top
                Dim strSqlC as string = "SELECT Category, CatNum, Bmark FROM dbo.tblLinkCategory ORDER BY CatNum"
                Dim objAdapterC as New SqlDataAdapter(strSQLC, objConnection)
                Dim objDataSetC as New DataSet()
                ObjAdapterC.Fill(objDataSetC, "tblCat")
    
                '---Datalist for categories
                dlCat.DataSource=objDataSetC.Tables("tblCat")
                dlCat.DataBind()
	
	
                '---Information retrieved for Links
                Dim strSqlL as string = "SELECT tblLinks.LName, tblLinks.Url, tblLinks.Category, tblLinks.LRating, "
				strSqlL+= "tblLinks.Description, tblLinks.Status, tblLinks.LDate, "
				strSqlL+= "tblLinkCategory.Category, tblLinkCategory.CatNum, tblLinkCategory.Bmark "
				strSqlL+= "FROM tblLinks, tblLinkCategory "
				strSqlL+= "WHERE tblLinks.Category=tblLinkCategory.Category AND tblLinks.Status='Active' ORDER BY tblLinkCategory.CatNum, tblLinks.LRating DESC, tblLinks.LName"
                Dim objAdapterL as New SqlDataAdapter(strSQLL, objConnection)
                Dim objDataSetL as New DataSet()
                ObjAdapterL.Fill(objDataSetL, "tblLnk")
    
                '---Datalist for events
                dlLinks.DataSource=objDataSetL.Tables("tblLnk")
                dlLinks.DataBind()
    
         End If
      End Sub

	Function DisplayCatIfNeeded(category as String) as String
      Dim output as String = String.Empty
       
      'Determine if this category has yet to be displayed
      If category <> lastCat then
         'Set that the lastCat is the current category value
         lastCat = category
         'Display the category
         output =  "<h2>" & category & "</h2><br />" 
      End If

      Return output         
   End Function

</Script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>BC Beer Guide: Links</title>
    
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <link href="bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>
<body><form id="form1" runat="server">
    <!-- DIV for outer shell to set width of page -->
    
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"> <USERCONTROL:LOGO id="UserControl1" runat="server"></USERCONTROL:LOGO> 
  </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <USERCONTROL:MAIL id="UserControl3" runat="server"></USERCONTROL:MAIL> </div>
  </div>
  <div class="mainbox mainboxL"> 
    <h1 class="old">Beer Links</h1>
    <h2 style="background-color: white; color: black; padding-left: 0px">Link 
      Categories On This Page</h2>
    
    <asp:DataList id="dlCat" repeatdirection="Horizontal" runat="server">
			<ItemTemplate>
            <asp:HyperLink id="HyperLink4" NavigateURL='<%# "#" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Bmark")) %>' runat="server">
                              <%# DataBinder.Eval(Container.DataItem, "Category") %> 
                </asp:HyperLink>
            &nbsp;&nbsp; </ItemTemplate>
		</asp:DataList> 
    <asp:DataList id="dlLinks" runat="server">
         <ItemTemplate>
            <a name= '<%#DataBinder.Eval(Container.DataItem, "Bmark") %>' runat="server"> 
            <%--<%# DisplayCatIfNeeded(Container.DataItem("tblLinks.Category"))%>--%>
            <%# DisplayCatIfNeeded(Container.DataItem("Category"))%>
            </a> 
            <h3><a href='<%#DataBinder.Eval(Container.DataItem, "URL") %>' runat="server"> 
              <%# DataBinder.Eval(Container.DataItem, "LName") %>
              </a>&nbsp;
			  <span style="font-weight: normal; font-style: normal; color: #666">
              (<%# DataBinder.Eval(Container.DataItem, "URL") %>)</span>
			</h3>
            <%# DataBinder.Eval(Container.DataItem, "Description") %>&nbsp;
			<span class="softdate">(<%# DataBinder.Eval(Container.DataItem, "LDate", "{0:dd/MM/yyyy}") %>)</span>
            <p></p>
            </ItemTemplate>
      	</asp:DataList> </div>
  <USERCONTROL:FOOT id="UserControl4f" runat="server" /> </div>
  </form>
</body>
</html>
