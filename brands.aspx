<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="CSSselect" Src="css_select.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>


<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Dim Sortfield as String
    
    Sub Page_Load()
        If Not Page.IsPostBack
          BindData()
        End If
    End Sub
    
    Function BindData()
    
                '------- Making the connection ------
                Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
                strConnection += "Data Source = "& Server.MapPath("_private/breweries.mdb")
    
                Dim objConnection as New OLEDBConnection(strConnection)
    
                '--------Connection made ---------
    
           '1---Information retrieved from tblBrewery in Brewery database
                Dim strSQL as string
    
                If (Request.Params("Style") Is Nothing) Then
                    strSQL = "SELECT tblBrewery.Number, tblBrewery.BName, tblBrewery.BType, tblBrewery.City, tblBrewery.Region, "
            strSQL += "tblBrand.Brand, tblBrand.BdNumber, tblBrand.Style, tblBrand.Alc, tblBrand.Bdbkmark "
                    strSQL += "FROM tblBrewery, tblBrand WHERE tblBrewery.Number = tblBrand.BName ORDER BY tblBrand.Brand"
                    lblFilter.text= "All brands"
                Else
                    strSQL = "SELECT tblBrewery.Number, tblBrewery.BName, tblBrewery.BType, tblBrewery.City, tblBrewery.Region, "
            strSQL += "tblBrand.Brand, tblBrand.BdNumber, tblBrand.Style, tblBrand.Alc, tblBrand.Bdbkmark "
                    strSQL += "FROM tblBrewery, tblBrand WHERE tblBrewery.Number = tblBrand.BName AND tblBrand.Style=" + Request.Params("Style") + "ORDER BY tblBrand.Brand"
                    lblFilter.text= Request.Params("Style")
                End If
    
                Dim objAdapter as New OledbDataAdapter(strSQL, objConnection)
                Dim objDataSet as New DataSet()
                ObjAdapter.Fill(objDataSet, "tblBrandByBrewery")
    
                objDataSet.Tables(0).Columns.Add(New DataColumn("Alco", GetType(String)))
				objDataSet.Tables(0).Columns.Add(New DataColumn("Bmark", GetType(String)))
    
                Dim zRow as DataRow
                For Each zRow in objDataSet.Tables(0).Rows
                    If zRow.Item("Alc") > 0 Then
                        zRow.Item("Alc") = zRow.Item("Alc") * 100
                        zRow.Item("Alco") = Convert.ToString(zRow.Item("Alc"))
                    Else
                        zRow.Item("Alco") = ""
                    End If
                Next
				
				'Dim zRow as DataRow
				For Each zRow in objDataSet.Tables(0).Rows
            zRow.Item("Bmark") = zRow.Item("Number") & "#" & zRow.Item("BdNumber")
				Next
    
                'Leftover code from original datareader style datagrid
                'Dim objCommand as New OledbCommand(strSQL, objConnection)
                'Dim objDataReader as OledbDataReader
                'objConnection.Open()
                'dgBrewery.DataSource=objCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
                'To facilitate sorting of list
                'Dim dv as New DataView(objDataSet.Tables("tblBrewery"))
                'dv.Sort = SortField
    
           '2---Datagrid for brand list using dataset created in 1 above
                dgBrands.Datasource=objDataSet.Tables("tblBrandByBrewery")
                dgBrands.DataBind()
    
    End Function
    
    Sub dgBrewery_Page(sender As Object, e As DataGridPageChangedEventArgs)
            dgBrands.CurrentPageIndex = e.NewPageIndex
            BindGrid
    End Sub
    
    Sub BindGrid()
            dgBrands.DataSource = BindData()
    End Sub
    
    
    'For sorting datagrid listing  - doesn't seem to work (23/10/02)
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
            Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
            strConnection += "Data Source = "& Server.MapPath("_private/breweries.mdb")
    
            Dim objConnection as New OLEDBConnection(strConnection)
    
    '--------Connection made ---------
    
            Dim strSQL as string = "SELECT * FROM tblBrewery"
            Dim objAdapter as New OledbDataAdapter(strSQL, objConnection)
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
    <title>B.C. Beer Guide - Brands</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 

</head>
<body >
<UserCtrl:GoogleTagMgr ID="UserCtrlGTM" runat="server" />
<form id="form1" runat="server">
<!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> 
  </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> </div>
  </div>
  <div class="mainbox" > 
    <h1 class="old">B.C. Micro-Brewery Brands</h1>
    <span> This is a list of all the brands produced by micro-breweries in B.C. 
    that I am aware of. More information on each of the brands can be found by 
    selecting the relevant brewery link: </span> 
    <div class="filter"> Filtered by: <span class="bld"> 
      <asp:label id="lblFilter" runat="server" />
      </span> </div>
    
      <!-- Originally set up for sorting: each BoundColumn had 'SortExpression' name of datafield, eg SortExpression="Brand" -->
      
      <ASP:DATAGRID id="dgBrands" CssClass="smaller" RUNAT="server" 
	  	Cellpadding="3" BorderWidth="1px" Gridlines="None" 
		HeaderStyle-BackColor="#800000" HeaderStyle-ForeColor="#FF9900" 
		AllowSorting="True" OnSortCommand="dg_SortCommand" 
		AutoGenerateColumns="False" AllowPaging="True" 
		PageSize="20" OnPageIndexChanged="dgBrewery_Page" 
		PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" 
		PagerStyle-HorizontalAlign="Right" PagerStyle-Mode="NumericPages">
        <HeaderStyle forecolor="#FF9900" backcolor="Maroon"></HeaderStyle>
        <PagerStyle nextpagetext="Next" prevpagetext="Prev" horizontalalign="Right" mode="NumericPages">
			</PagerStyle>
        <Columns>
          <asp:HyperLinkColumn DataNavigateUrlField="Bmark" DataNavigateUrlFormatString="breweryselect.aspx?Number={0}" DataTextField="Brand"  HeaderText="Brand"></asp:HyperLinkColumn>
          <asp:BoundColumn DataField="Style"  HeaderText="Style"></asp:BoundColumn>
          <asp:BoundColumn DataField="Alco"  HeaderText="% Alc"></asp:BoundColumn>
          <asp:HyperLinkColumn DataNavigateUrlField="Number" DataNavigateUrlFormatString="breweryselect.aspx?Number={0}" DataTextField="BName"  HeaderText="Brewery"></asp:HyperLinkColumn>
          <asp:BoundColumn DataField="BType"  HeaderText="Type"></asp:BoundColumn>
          <asp:BoundColumn DataField="City"  HeaderText="City"></asp:BoundColumn>
          <asp:BoundColumn DataField="Region"  HeaderText="Region"></asp:BoundColumn>
        </Columns>
     </ASP:DATAGRID> 
    
  </div>
   <!--footer outside main box identifying website builder-->
    <UserControl:Foot id="UserControl4f" runat="server" />
  </div><!--end of outer box-->
  <!--stupid spacer div to make room for the page to scroll down to footer-->
    <!--<div>&nbsp;</div>-->
   
</form>               
</body>
</html>
