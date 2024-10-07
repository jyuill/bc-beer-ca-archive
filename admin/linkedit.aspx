<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="iso-8859-1"  Culture="en-CA" ValidateRequest="false" %>


<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>


<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<%@ import Namespace="System.Globalization" %>
<%@ import Namespace="System.Globalization.CultureInfo" %>

<Script runat="server">
'--Variables used in connection string and passed to subs/functions when conn() called
Dim strConn as String
Dim objConn as OleDbConnection

Sub Page_Load(sender as Object, e as EventArgs)
		
    If Not Page.IsPostBack
		 BindData()
	End If
End Sub

'--Function for connection string so only has to be set up once and called when needed
Function Conn()		
		'Using strings from web.config in combination with Request.PhysicalApplicationPath
		strConn = ConfigurationManager.AppSettings("strConfig1")
		strConn+= Request.PhysicalApplicationPath 
		strConn+= ConfigurationManager.AppSettings("strConfig2")
		objConn = New OleDbConnection(strConn)   
		Return objConn
End Function

Sub BindData()

    '------- Make connection ------
	   Conn()
    
	'--- Open connection	
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
		'Parameterized for simplicity and flexibility - no apostrophe problem etc
				
		Conn()
		
        'Dim strName as String =CType(e.Item.FindControl("txtLName"), TextBox).Text
        Dim strName As String = dlLinks.DataKeys(E.Item.ItemIndex)
        Dim intRating As Integer = CType(E.Item.FindControl("txtLRating"), TextBox).Text
		Dim strUrl as String = CType(e.Item.FindControl("txtUrl"), Textbox).Text
		Dim strCategory as String = CType(e.Item.FindControl("ddlCategory"), DropDownList).SelectedItem.Value
        Dim strDescription As String = CType(E.Item.FindControl("txtDescription"), FreeTextBox).Text
		Dim strStatus as String = CType(e.Item.FindControl("ddlStatus"), DropDownList).SelectedItem.Value
		Dim dtDate as Date=Now.Date()
		
		Dim strSQLupdate as String = "UPDATE tblLinks SET " & _
		"LRating=@LRating" & _
		", URL=@Url" & _
		", Category=@Category" & _
		", Description=@Description" & _
		", Status=@Status" & _
		", LDate=@LDate" & _
		" WHERE LName=@LName"		
		 
		Dim cmdUpdate as OleDbCommand = new OleDbCommand(strSQLupdate, objConn)
		
		'Parameters must be added in same order as in SQL update stmt 
		cmdUpdate.Parameters.Add( "@LRating", OleDbType.Integer ).Value = intRating
        cmdUpdate.Parameters.AddWithValue("@Url", strUrl)
        cmdUpdate.Parameters.AddWithValue("@Category", strCategory)
        cmdUpdate.Parameters.AddWithValue("@Description", strDescription)
        cmdUpdate.Parameters.AddWithValue("@Status", strStatus)
        cmdUpdate.Parameters.AddWithValue("@LDate", dtDate)
        cmdUpdate.Parameters.AddWithValue("@LName", strName)
		
		objConn.Open()
		cmdUpdate.ExecuteNonQuery()
		objConn.Close()
		
        'Switch off the Edit mode
        dlLinks.EditItemIndex = -1
        BindData()
End Sub

    Sub dlLinks_Delete(ByVal sender As Object, ByVal e As DataListCommandEventArgs)
        'Based on ASP.NET Unleashed  p.534
        Dim strDelete As String
        Dim cmdDelete As OleDbCommand
        Dim strLinkName As String
        'Dim intNnumber As Integer
		
        'Datakey is primary key in table - must be declared in Datalist
        strLinkName = dlLinks.DataKeys(e.Item.ItemIndex)
        Conn()
        strDelete = "DELETE FROM tblLinks WHERE LName=@LName"
        cmdDelete = New OleDbCommand(strDelete, objConn)
        cmdDelete.Parameters.AddWithValue("@LName", strLinkName)
        objConn.Open()
        cmdDelete.ExecuteNonQuery()
        objConn.Close()
        dlLinks.EditItemIndex = -1
        BindData()
    End Sub

Sub dlLinks_Cancel(ByVal sender As Object, ByVal e As DataListCommandEventArgs)
		dlLinks.EditItemIndex = -1
		BindData()
End Sub

'Populates Category dropdown list for editing
Function GetCategory() as DataSet
        Conn()
		Dim strddlCat As String
        strddlCat = "SELECT Category FROM tblLinkCategory ORDER BY Category"
    
        Dim myDataAdapterCat as OleDbDataAdapter = New OleDbDataAdapter(strddlCat, objConn)
    
        Dim ddlDataSetCat As DataSet = New DataSet()
        myDataAdapterCat.Fill(ddlDataSetCat, "Category")
        Return ddlDataSetCat
End Function
'Displays existing Category in ddl 
Function GetSelIndCat(Category as String) as Integer
        Dim iLoop As Integer  
		Conn()
		
        Dim strddlCat2 As String
        strddlCat2 = "SELECT Category FROM tblLinkCategory ORDER BY Category"
    
        Dim myDataAdapterCat2 as OleDbDataAdapter = New OleDbDataAdapter(strddlCat2, objConn)
    
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
		Conn()
        Dim strddlStat As String
        strddlStat = "SELECT Status FROM tblLinkStatus ORDER BY Status"
    
        Dim myDataAdapterStat as OleDbDataAdapter = New OleDbDataAdapter(strddlStat, objConn)
    
        Dim ddlDataSetStat As DataSet = New DataSet()
        myDataAdapterStat.Fill(ddlDataSetStat, "Status")
        Return ddlDataSetStat
End Function
'Displays existing Status in ddl 
Function GetSelIndStat(Category as String) as Integer
        Dim iLoop As Integer
		Conn()
        Dim strddlStat2 As String
        strddlStat2 = "SELECT Status FROM tblLinkStatus ORDER BY Status"
    
        Dim myDataAdapterStat2 as OleDbDataAdapter = New OleDbDataAdapter(strddlStat2, objConn)
    
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
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>BCBG - Edit Links</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>

<body>
<!-- DIV for outer shell to set width of page -->
<div id="outeradmin"> 
  <!-- Div for topsection including logo and title -->
  <div class="top"><img alt="BC Beer Guide" src="../images/bcbg_logo2.jpg" /> 
    <div style="margin-bottom: 6px"> <a href="../default.aspx">Home</a>&nbsp; 
      <a href="../brewery.aspx">Breweries</a>&nbsp; <a href="../brands.aspx">Beers</a> 
      &nbsp; </div>
    <h1><a href="default.aspx">Add Brewery, Add Brand</a>&nbsp; 
	  <a href="NewsEvents.aspx">Add News</a>&nbsp; 
	  <a href="newsedit.aspx">Edit News</a>&nbsp;
	  <a href="linkadd.aspx">Add Link</a>&nbsp; 
	  Edit Links&nbsp; 
      <a href="../_private/breweries.mdb">Download database</a></h1>
  </div>

<h2>Edit Links</h2>
<form id="form1" runat="server">

<asp:Datalist id="dlLinks" 
    DataKeyField="LName"
	onEditCommand="dlLinks_Edit" onUpdateCommand="dlLinks_Update" 
	onDeleteCommand="dlLinks_Delete"
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
				<td><%# Container.DataItem("LName") %>&nbsp;(Link name can't be changed)</td></tr>
			<tr><td><asp:Button ID="Button1" CommandName="Delete" Text="Delete" runat="server" /></td>
				<td>Rating:</td>
				<td><asp:Textbox id="txtLRating" runat="server" Text='<%# Container.DataItem("LRating") %>' Columns="3" /></td></tr>
			<tr><td><asp:Button ID="Button2" CommandName="Cancel" Text="Cancel" runat="server" /></td>
				<td>Url:</td>
				<td><asp:Textbox id="txtUrl" runat="server" Text='<%# Container.DataItem("Url") %>' Columns="50" /></td></tr>
			<tr><td></td>
				<td>Category:</td>
				<td><asp:DropDownList runat="server" id="ddlCategory" DataValueField="Category" DataTextField="Category" DataSource="<%# GetCategory() %>" SelectedIndex='<%# GetSelIndCat(Container.DataItem("Category")) %>' ></asp:DropDownList></td></tr>
			<tr><td></td>
				<td>Description:</td>
				<td>
				<FTB:FreeTextBox ID="txtDescription" Text='<%# Container.DataItem("Description") %>'
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" runat="Server" ToolbarStyleConfiguration="NotSet" Height="80" />
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
    <UserControl:Footadmin id="UserControl1" runat="server" />

</body>
</html>
