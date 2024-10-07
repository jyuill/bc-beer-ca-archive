<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="iso-8859-1"  Culture="en-CA" Debug="true" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<%@ import Namespace="System.Globalization" %>
<%@ import Namespace="System.Globalization.CultureInfo" %>

<Script runat="server">
Dim strConn as String

Sub Page_Load(sender as Object, e as EventArgs)
		
    If Not Page.IsPostBack
		 BindData()
	End If
End Sub

Sub BindData()

       '------- Making the connection ------
	    'Using strings from web.config in combination with Request.PhysicalApplicationPath
		strConn = ConfigurationSettings.AppSettings("strConfig1")
		strConn+= Request.PhysicalApplicationPath 
		strConn+= ConfigurationSettings.AppSettings("strConfig2")
		Dim objConn as New OleDbConnection(strConn)   
        '--------Connection made ---------
	
	objConn.Open()
	
	Const strSQL as String = "SELECT * FROM tblLinks ORDER BY LName"

 	Dim objAdapter as New OledbDataAdapter(strSQL, objConn)
              
    '3---New Data Set created for main brewery information section
    Dim objDataSet as New DataSet()
    objAdapter.Fill(objDataSet, "tblLnk")
          
   '---Datalist for main brewery information
   dlLinks.DataSource=objDataSet.Tables("tblLnk")
   dlLinks.DataBind()

End Sub
	
Private Sub dlLinks_Edit(Source As Object, E As DataListCommandEventArgs)
        'Set EditItemIndex property to the index of the record raising the event
        dlLinks.EditItemIndex = E.Item.ItemIndex
        BindData()
End Sub

Sub dlLinks_Update(Source As Object, E As DataListCommandEventArgs)
		'Based on method in breweryedit.aspx
		
		Dim _LName, _LRate, _Url, _Description as TextBox
		Dim _Cat as DropDownList
		Dim _Stat as DropDownList
		Dim LDateUp As Date
		Dim LN, Url, Cat, Des, St as String
		Dim LR as Integer
		
		_LName=CType(E.Item.FindControl("txtLName"), TextBox)
		LN=_LName.Text
		_LRate=CType(E.Item.FindControl("txtLRating"), TextBox)
		LR=_LRate.Text
		_Url=CType(E.Item.FindControl("txtUrl"), TextBox)
		Url=_Url.Text
		_Cat=CType(E.Item.FindControl("ddlCategory"), DropDownList)
		Cat=_Cat.SelectedItem.Value
		_Description=CType(E.Item.FindControl("txtDescription"),TextBox)
		Des=_Description.Text
		_Stat=CType(E.Item.FindControl("ddlStatus"), DropDownList)
		St=_Stat.SelectedItem.Value
		LDateUp=Now.Date()
		
		Dim strUp As String
		strUp = "Update tblLinks Set " & _
		" LName='" & LN & "'" & _
		", LRating='" & LR & "'" & _
		", URL='" & Url & "'" & _
		", Category='" & Cat & "'" & _
		", Description='" & Des & "'" & _
		", Status='" & St & "'" & _
		" WHERE LName='" & LN & "'"
				
		'------- Making the connection ------
        Dim strConnectionU as String = "Provider=Microsoft.Jet.OLEDB.4.0;"           
            strConnectionU += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionU as New OLEDBConnection(strConnectionU)
      	Dim objCommandU as New OledbCommand(strUp, objConnectionU)
  
		objConnectionU.Open()
        objCommandU.ExecuteNonQuery
    	objConnectionU.Close()
		
        'Switch off the Edit mode
        dlLinks.EditItemIndex = -1
        BindData()
End Sub




Sub dlLinks_Cancel(ByVal sender As Object, ByVal e As DataListCommandEventArgs)
		dlLinks.EditItemIndex = -1
		BindData()
End Sub

'Populates Category dropdown list for editing
Function GetCategory() as DataSet
		Dim strConn as String = ConfigurationSettings.AppSettings("strConfig1") + Request.PhysicalApplicationPath 
		strConn+= ConfigurationSettings.AppSettings("strConfig2")
		Dim objConnCat as New OleDbConnection(strConn)
        Dim strddlCat As String
        strddlCat = "SELECT Category FROM tblLinkCategory ORDER BY Category"
    
        Dim myDataAdapterCat as OleDbDataAdapter = New OleDbDataAdapter(strddlCat, objConnCat)
    
        Dim ddlDataSetCat As DataSet = New DataSet()
        myDataAdapterCat.Fill(ddlDataSetCat, "Category")
        Return ddlDataSetCat
End Function
'Displays existing Category in ddl 
Function GetSelIndCat(Category as String) as Integer
        Dim iLoop As Integer
		Dim strConn as String = ConfigurationSettings.AppSettings("strConfig1") + Request.PhysicalApplicationPath 
		strConn+= ConfigurationSettings.AppSettings("strConfig2")
		Dim objConnCat2 as New OleDbConnection(strConn)   
		
        Dim strddlCat2 As String
        strddlCat2 = "SELECT Category FROM tblLinkCategory ORDER BY Category"
    
        Dim myDataAdapterCat2 as OleDbDataAdapter = New OleDbDataAdapter(strddlCat2, objConnCat2)
    
        Dim ddlDataSetCat2 As DataSet = New DataSet()
        myDataAdapterCat2.Fill(ddlDataSetCat2, "Category")
        'Return ddlDataSet
    
        Dim dtC2 As DataTable = ddlDataSetCat2.Tables("Category")
        For iLoop = 0 to dtC2.Rows.Count - 1
          If Category = dtC2.Rows(iLoop)("Category") then
            Return iLoop
          End If
        Next iLoop
    End Function

'Populates Status dropdown list for editing
Function GetStatus() as DataSet
		Dim strConn as String = ConfigurationSettings.AppSettings("strConfig1") + Request.PhysicalApplicationPath 
		strConn+= ConfigurationSettings.AppSettings("strConfig2")
		Dim objConnStat as New OleDbConnection(strConn)   
	
        Dim strddlStat As String
        strddlStat = "SELECT Status FROM tblLinkStatus ORDER BY Status"
    
        Dim myDataAdapterStat as OleDbDataAdapter = New OleDbDataAdapter(strddlStat, objConnStat)
    
        Dim ddlDataSetStat As DataSet = New DataSet()
        myDataAdapterStat.Fill(ddlDataSetStat, "Status")
        Return ddlDataSetStat
End Function
'Displays existing Status in ddl 
Function GetSelIndStat(Category as String) as Integer
        Dim iLoop As Integer
    Dim strConn as String = ConfigurationSettings.AppSettings("strConfig1") + Request.PhysicalApplicationPath 
		strConn+= ConfigurationSettings.AppSettings("strConfig2")
		Dim objConnStat2 as New OleDbConnection(strConn)   
	
        Dim strddlStat2 As String
        strddlStat2 = "SELECT Status FROM tblLinkStatus ORDER BY Status"
    
        Dim myDataAdapterStat2 as OleDbDataAdapter = New OleDbDataAdapter(strddlStat2, objConnStat2)
    
        Dim ddlDataSetStat2 As DataSet = New DataSet()
        myDataAdapterStat2.Fill(ddlDataSetStat2, "Status")
        'Return ddlDataSet
    
        Dim dtS2 As DataTable = ddlDataSetStat2.Tables("Status")
        For iLoop = 0 to dtS2.Rows.Count - 1
          If Category = dtS2.Rows(iLoop)("Status") then
            Return iLoop
          End If
        Next iLoop
End Function

</Script>

<head>
<title>BCBG - Edit Links</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>

<body>
<!-- DIV for outer shell to set width of page -->
<div id="outeradmin"> 
  <!-- Div for topsection including logo and title -->
  <div class="top"><img src="../images/bcbg_logo2.jpg" /> 
    <div style="margin-bottom: 6px"> <a href="../default.aspx">Home</a>&nbsp; 
      <a href="../brewery.aspx">Breweries</a>&nbsp; <a href="../brands.aspx">Beers</a> 
      &nbsp; </div>
    <h1><a href="default.aspx">Add Brewery, Add Brand</a>&nbsp; 
		<a href="NewsEvents.aspx">Add News</a>&nbsp; 
		<a href="linkadd.aspx">Add Link</a>&nbsp;
		Edit Links&nbsp;
	   <a href="../_private/breweries.mdb">Download database</a></h1>
  </div>

<h2>Edit Links</h2>
<form runat="server">

<asp:Datalist id="dlLinks" 
	onEditCommand="dlLinks_Edit" onUpdateCommand="dlLinks_Update" 
	onCancelCommand="dlLinks_Cancel"
	runat="server">
	<itemtemplate>
	
		<table>
			<tr><td><asp:Button id="btnEdit1" Text="Edit Link" CommandName="Edit" runat="server" /></td>
				<td>Name:</td><td><%# Container.DataItem("LName") %></td></tr>
			<tr><td></td><td>Rating:</td><td><%# Container.DataItem("LRating") %></td></tr>
			<tr><td></td><td>Url:</td><td><%# Container.DataItem("Url") %></td></tr>
			<tr><td></td><td>Category:</td><td><%# Container.DataItem("Category") %></td></tr>
			<tr><td></td><td>Description:</td><td><%# Container.DataItem("Description") %></td></tr>
			<tr><td></td><td>Status:</td><td><%# Container.DataItem("Status") %></td></tr>
			<tr><td></td><td>Date:</td><td><%# Container.DataItem("LDate") %></td></tr>
		</table>
	</itemtemplate>
	<EditItemTemplate>		
		<table>
			<tr><td><asp:Button CommandName="Update" Text="Update" runat="server" />&nbsp;</td>
				<td>Name:</td>
				<td><asp:Textbox id="txtLName" size="50" ReadOnly="true" runat="server" Text='<%# Container.DataItem("LName") %>' /></td></tr>
			<tr><td><asp:Button CommandName="Cancel" Text="Cancel" runat="server" /></td>
				<td>Rating:</td>
				<td><asp:Textbox id="txtLRating" size="5" runat="server" Text='<%# Container.DataItem("LRating") %>' /></td></tr>
			<tr><td></td>
				<td>Url:</td>
				<td><asp:Textbox id="txtUrl" size="50" runat="server" Text='<%# Container.DataItem("Url") %>' /></td></tr>
			<tr><td></td>
				<td>Category:</td>
				<td><asp:DropDownList runat="server" id="ddlCategory" DataValueField="Category" DataTextField="Category" DataSource="<%# GetCategory() %>" SelectedIndex='<%# GetSelIndCat(Container.DataItem("Category")) %>' ></asp:DropDownList></td></tr>
			<tr><td></td>
				<td>Description:</td>
				<td><asp:Textbox id="txtDescription" TextMode="MultiLine" Columns="100" Rows="4" runat="server" Text='<%# Container.DataItem("Description") %>' /></td></tr>
			<tr><td></td>
				<td>Status:</td>
				<td><asp:DropDownList runat="server" id="ddlStatus" DataValueField="Status" DataTextField="Status" DataSource="<%# GetStatus() %>" SelectedIndex='<%# GetSelIndStat(Container.DataItem("Status")) %>' ></asp:DropDownList></td></tr>
			<tr><td></td>
				<td>Date:</td>
				<td><%# Container.DataItem("LDate") %></td></tr>
		</table>
	</EditItemTemplate>
</asp:Datalist>




</form>
</div>
</body>
</html>
