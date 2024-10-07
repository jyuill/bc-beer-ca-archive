<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="CSSselect" Src="css_select.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>

<%@ import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<script runat="server">

    Dim Sortfield as String
    
    Sub Page_Load()
        If Not Page.IsPostBack
          BindData()
        End If
    End Sub
    
    Function BindData() As Object
    
        '------- Making the connection ------
        
        '---- connecting via connection string in web.config for central location
        Dim strConnection As String = ConfigurationManager.ConnectionStrings("strConnection1").ToString
            
        Dim objConnection As New SqlConnection(strConnection)
    
        '--------Connection made ---------
    
        '1---Information retrieved from tblBrewery in Brewery database
        Dim strSQL As String
    
        If (Request.Params("City") Is Nothing) Then
            If (Request.Params("Region") Is Nothing) Then
                strSQL = "SELECT Number, BName, BType, City, Region FROM tblBrewery ORDER BY BName"
                lblFilter.Text = "All"
            Else
                strSQL = "SELECT Number, BName, BType, City, Region FROM tblBrewery WHERE Region =" + Request.Params("Region") + " ORDER BY BName"
                lblFilter.Text = Request.Params("Region")
            End If
        Else
            strSQL = "SELECT Number, BName, BType, City, Region FROM tblBrewery WHERE City =" + Request.Params("City") + " ORDER BY BName"
            lblFilter.Text = Request.Params("City")
        End If
    
        Dim objAdapter As New SqlDataAdapter(strSQL, objConnection)
        Dim objDataSet As New DataSet()
        objAdapter.Fill(objDataSet, "tblBrewery")
    
        'Leftover code from original datareader style datagrid
        'Dim objCommand as New OledbCommand(strSQL, objConnection)
        'Dim objDataReader as OledbDataReader
        'objConnection.Open()
        'dgBrewery.DataSource=objCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        'To facilitate sorting of brewery list at top of page
        Dim dv As New DataView(objDataSet.Tables("tblBrewery"))
        dv.Sort = Sortfield
    
        '2---Datagrid for brewery list at top of page using dataset created in 1 above
        dgBrewery.DataSource = objDataSet.Tables("tblBrewery")
        dgBrewery.DataBind()
    
    End Function
    
    Sub dgBrewery_Page(sender As Object, e As DataGridPageChangedEventArgs)
            dgBrewery.CurrentPageIndex = e.NewPageIndex
            BindGrid
    End Sub
    
    Sub BindGrid()
            dgBrewery.DataSource = BindData()
    End Sub
    
    
    'For sorting datagrid listing breweries at top of page - doesn't seem to work (23/10/02)
    Private Sub dg_SortCommand(ByVal source As Object, _
    ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) _
    
       Dim dgSort As DataGrid = source
       Dim strSort = dgSort.Attributes("SortExpression")
       Dim strASC = dgSort.Attributes("SortASC")
       dgSort.Attributes("SortExpression") = e.SortExpression
       dgSort.Attributes("SortASC") = "yes"
    
       If e.SortExpression = strSort Then
         If strASC = "yes" Then
           dgSort.Attributes("SortASC") = "no"
         Else
           dgSort.Attributes("SortASC") = "yes"
         End If
       End If
    
    '------- Making the connection ------
        '    Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
        '    strConnection += "Data Source = "& Server.MapPath("_private/breweries.mdb")
    
        'Dim objConnection As New OLEDBConnection(strConnection)
        
        '---- connecting via connection string in web.config for central location
        Dim strConnection As String = ConfigurationManager.ConnectionStrings("strConnection1").ToString
            
        Dim objConnection As New SqlConnection(strConnection)
    
    '--------Connection made ---------
    
            Dim strSQL as string = "SELECT * FROM tblBrewery"
        Dim objAdapter As New SqlDataAdapter(strSQL, objConnection)
            Dim objDataSet as New DataSet()
            ObjAdapter.Fill(objDataSet, "tblBrewery")
    
       Dim dv as New DataView(objDataSet.Tables("tblBrewery"))
       'Dim dt As DataTable = GetAuthors()
       'Dim dv As DataView = New DataView(dt)
       dv.Sort = dgSort.Attributes("SortExpression")
    
       If dgSort.Attributes("SortASC") = "no" Then
         dv.Sort &= " DESC"
       End If
    
       dgSort.DataSource = dv
       dgSort.DataBind()
    
    End Sub

</script>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>BC Beer Guide - Breweries</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Phillips, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" />
   
</head>
<body> 
<UserCtrl:GoogleTagMgr ID="UserCtrlGTM" runat="server" />

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
      <h1 class="old">B.C. Craft Breweries and their Products </h1>
      <span> These breweries brew beer in <strong>small batches, using natural 
      processes and ingredients,</strong> with the intention of providing unique 
      and flavourful alternatives to mass-produced products of large regional 
      and national breweries. </span> 
      <p class="mid"><em>Select a brewery for background info and comments on 
        its products: </em> </p>
      <!--<div class="tblcenter">-->
      <div class="filter">Filtered by: <span style="font-weight: bold"> 
        <asp:label id="lblFilter" runat="server" />
        </span> </div>
      
      <ASP:DATAGRID id="dgBrewery"  CssClass="tblcenter" 
	  	AutoGenerateColumns="False" OnSortCommand="dg_SortCommand" 
		AllowSorting="True" Gridlines="None" 
		HeaderStyle-ForeColor="#FF9900" HeaderStyle-BackColor="#800000" 
		Cellpadding="3" RUNAT="server">
        <HeaderStyle forecolor="#FF9900" backcolor="Maroon"></HeaderStyle>           
        <Columns>
          <asp:HyperLinkColumn DataNavigateUrlField="Number" DataNavigateUrlFormatString="breweryselect.aspx?Number={0}" DataTextField="BName" SortExpression="BName" HeaderText="Brewery"></asp:HyperLinkColumn>
          <asp:BoundColumn DataField="BType" SortExpression="BType" HeaderText="Type"></asp:BoundColumn>
          <asp:BoundColumn DataField="City" SortExpression="City" HeaderText="City"></asp:BoundColumn>
          <asp:BoundColumn DataField="Region" SortExpression="Region" HeaderText="Region"></asp:BoundColumn>
          </Columns>
      </ASP:DATAGRID> 
     </div>
     <!--footer outside main box identifying website builder-->
    <UserControl:Foot id="UserControl4f" runat="server" />
  </div><!--end of outer box-->
  <!-- spacer div to make room for the page to scroll down to footer-->
    <!-- <div>&nbsp;</div>-->
    
</form>         
</body>
</html>