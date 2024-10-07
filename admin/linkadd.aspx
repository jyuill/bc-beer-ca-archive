<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="iso-8859-1"  Culture="en-CA"  ValidateRequest="false" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>


<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<%@ import Namespace="System.Globalization" %>
<%@ import Namespace="System.Globalization.CultureInfo" %>

<Script runat="server">
'This setting along with system.globalization and system.globalization.cultureinfo needed only for local server
Public Dim MyCulture As New CultureInfo("en-CA", False)

 Sub Page_Load(sender as Object, e as EventArgs)
 
    If Not Page.IsPostBack
	
	   '-------Needed to load dropdown lists
       '------- Making the connection ------
     	Dim strConnectionD as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
     	strConnectionD += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
     	Dim objConnectionD as New OleDbConnection(strConnectionD)   
        '--------Connection made ---------
    
         objConnectionD.Open()
    	'---Dropdown list for link category
         'Create Command object for the query
         Dim strCategory as String
         strCategory = "SELECT Category, CatNum FROM tblLinkCategory ORDER BY CatNum"
         Dim objCmd as New OledbCommand(strCategory, objConnectionD)
 
         'Create/Populate DataReader - category list 
         Dim objDR as OledbDataReader
         objDR = objCmd.ExecuteReader()
    
         'Databind DataReader to list control
         lstCategory.DataSource=objDR
         lstCategory.DataBind()
	
		 objConnectionD.Close()
	
		 objConnectionD.Open()
    	'---Dropdown list for status
         'Create Command object for the query
         Dim strStatus as String
         strStatus = "SELECT Status, SNumber FROM tblLinkStatus ORDER BY SNumber"
         Dim objCmdr as New OledbCommand(strStatus, objConnectionD)
 
         'Create/Populate DataReader - type list 
         Dim objDRr as OledbDataReader
         objDRr = objCmdr.ExecuteReader()
    
         'Databind DataReader to list control
         lstStatus.DataSource=objDRr
         lstStatus.DataBind()
	
		 objConnectionD.Close()
		 
	End If
End Sub

'Add new link
Sub Add_Link (s As Object, e As EventArgs)

	   '------- Making the connection ------
     	Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
     	strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
     	Dim objConnection as New OleDbConnection(strConnection)   
        '--------Connection made ---------
		
		Dim strInsert As String
		Dim cmdInsert As OleDbCommand
		
		strInsert = "Insert Into tblLinks (LName, LRating, Url, Category, Description, Status, LDate) "
		strInsert += "Values (@LName, @LRating, @Url, @Category, @Description, @Status, @LDate)"
		cmdInsert = New OleDbCommand(strInsert, objConnection)
        cmdInsert.Parameters.AddWithValue("@LName", txtLName.Text)
		'cmdInsert.Parameters.Add("@LRating", txtRating.Value) will not work because Access field is long integer
		'  Simplest approach to inputting data into long integer field in Access
		cmdInsert.Parameters.Add("@LRating", OleDbType.Integer).Value=txtRating.Text
		'  More complicated if above does not work
		'Dim intRating as Integer
		'intRating = Convert.ToInt32(txtRating.Text)
		'cmdInsert.Parameters.Add("@LRating", OleDbType.Integer).Value=intRating
		'  Next 3 lines could be used to automatically add http:// - abandoned because not all sites start http://
		'Dim fullUrl as String
		'fullUrl="http://" & txtUrl.Text
		'cmdInsert.Parameters.Add("@Url", fullUrl)
        cmdInsert.Parameters.AddWithValue("@Url", txtUrl.Text)
        cmdInsert.Parameters.AddWithValue("@Category", lstCategory.SelectedItem.Text)
		cmdInsert.Parameters.AddWithValue("@Description", txtDescrip.Text)
        cmdInsert.Parameters.AddWithValue("@Status", lstStatus.SelectedItem.Text)
        cmdInsert.Parameters.AddWithValue("@LDate", OleDbType.Date).Value = Now.Date()
		objConnection.Open()
		cmdInsert.ExecuteNonQuery()
		objConnection.Close()
		MessageLabel.Text = "This link was successfully added"
End Sub	

Sub Reset(s As Object, e As EventArgs)
		txtLName.Text=""
		txtUrl.Text=""
		txtRating.Text="0"
		txtDescrip.Text=""
End Sub

</Script>

<head>
<title>BCBG - Add a Link</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>

<body>
<!-- DIV for outer shell to set width of page -->
<div id="outeradmin"> 
  <!-- Div for topsection including logo and title -->
  <div class="top"><img src="../images/bcbg_logo2.jpg" /> 
    <div style="margin-bottom: 6px"> <a href="../default.aspx">Home</a>&nbsp; 
      <a href="../brewery.aspx">Breweries</a>&nbsp; <a href="../brands.aspx">Beers</a>&nbsp; 
    </div>
    <h1> <a href="default.aspx">Add Brewery, Add Brand</a>&nbsp; 
	  <a href="NewsEvents.aspx">Add News</a>&nbsp; 
	  <a href="newsedit.aspx">Edit News</a>&nbsp;
	  Add Link&nbsp; 
	  <a href="linkedit.aspx">Edit Links</a>&nbsp; 
      <a href="../_private/breweries.mdb">Download database</a>
	</h1>
  </div>

<h2>Add a Link</h2>
<form runat="server">
<asp:Label id="MessageLabel" runat="server" ForeColor="Red"></asp:Label>
<table>
<tr><td style="width: 59px">Name:</td><td><asp:TextBox ID="txtLName" size="50" runat="server" /></td></tr>
<tr><td>Category:</td><td><asp:DropDownList id="lstCategory" runat="server" DataTextField="Category" DataValueField="Category"></asp:DropDownList></td></tr>
<tr><td>URL:</td><td><asp:TextBox ID="txtUrl" size="50" runat="server" />(full url - include 'http://')</td></tr>
<tr><td>Rating:</td><td><asp:TextBox ID="txtRating" size="3" text="0" runat="server" />(0-5, higher rating is better)</td></tr>
<tr><td>Description:</td>
    <td>
    <FTB:FreeTextBox ID="txtDescrip" 
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" runat="Server" ToolbarStyleConfiguration="NotSet" Height="80" />
</tr>
<tr><td>Status:</td><td><asp:DropDownList id="lstStatus" runat="server" DataTextField="Status" DataValueField="Status" /></td></tr>
<tr><td>&nbsp;</td><td><asp:Button Text="Add Link" OnClick="Add_Link" runat="server" />&nbsp;
<asp:Button Text="Reset" OnClick="Reset" runat="server" />
</td></tr>
</table>

</form>
</div>
    <UserControl:Footadmin id="UserControl1" runat="server" />

</body>
</html>
