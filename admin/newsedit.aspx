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
	
	Const strSQL as String = "SELECT * FROM tblNewsEvents ORDER BY EntryDate DESC"

 	Dim objAdapter as New OledbDataAdapter(strSQL, objConn)
              
    '3---New Data Set created for main brewery information section
    Dim objDataSet as New DataSet()
    objAdapter.Fill(objDataSet, "tblNE")
          
   '---Datalist for main brewery information
   dlNE.DataSource=objDataSet.Tables("tblNE")
   dlNE.DataBind()

End Sub
	
Private Sub dlNE_Edit(Source As Object, E As DataListCommandEventArgs)
        'Set EditItemIndex property to the index of the record raising the event
        dlNE.EditItemIndex = E.Item.ItemIndex
        BindData()
End Sub



Sub dlNE_Cancel(ByVal sender As Object, ByVal e As DataListCommandEventArgs)
		dlNE.EditItemIndex = -1
		BindData()
End Sub

Sub dlNE_Delete(ByVal sender As Object, ByVal e As DataListCommandEventArgs)
		'Based on ASP.NET Unleashed  p.534
		Dim strDelete as String
		Dim cmdDelete as OleDbCommand
		Dim intNnumber as Integer
		
		'Datakey is primary key in table - must be declared in Datalist
		intNnumber=dlNE.DataKeys(e.Item.ItemIndex)
		Conn()
		strDelete= "DELETE FROM tblNewsEvents WHERE Nnumber=@Nnum"
		cmdDelete = New OleDbCommand( strDelete, objConn )
		cmdDelete.Parameters.AddWithValue( "@Nnum", intNnumber )
		objConn.Open()
		cmdDelete.ExecuteNonQuery()
		objConn.Close()
		dlNE.EditItemIndex=-1
		BindData()
End Sub

Sub dlNE_Update(Source As Object, E As DataListCommandEventArgs)
		'Parameterized for simplicity and flexibility - no apostrophe problem etc
				
		Conn()
		
		Dim intNnum as Integer = dlNE.DataKeys(e.Item.ItemIndex)
		Dim strSubject as String =CType(e.Item.FindControl("txtSubject"), TextBox).Text
		Dim blEvent as Boolean =CType(e.Item.FindControl("chk1"), CheckBox ).Checked
		Dim strBmark as String = CType(e.Item.FindControl("txtBmark"), TextBox).Text
        Dim strDescription As String = CType(E.Item.FindControl("txtDescription"), FreeTextBox).Text
		Dim dtEnDate as Date = CType(e.Item.FindControl("txtEnDate"), TextBox).Text
		Dim dtEvDate as Date = CType(e.Item.FindControl("txtEvDate"), TextBox).Text
		Dim dtExDate as Date = CType(e.Item.FindControl("txtExDate"), TextBox).Text
		Dim strLink as String = CType(e.Item.FindControl("txtLink"), TextBox).Text
		
		Dim strSQLupdate as String = "UPDATE tblNewsEvents SET " & _
		"Subject=@Subject" & _
		", Eventitem=@Event" & _
		", Bmark=@Bmark" & _
		", Description=@Description" & _
		", EntryDate=@EnDate" & _
		", EventDate=@EvDate" & _
		", ExpiryDate=@ExDate" & _
		", Link=@Link" & _
		" WHERE Nnumber = @Nnum"
			 
		Dim cmdUpdate as OleDbCommand = new OleDbCommand(strSQLupdate, objConn)
		'Parameters must be added in same order as in SQL update stmt 
        cmdUpdate.Parameters.AddWithValue("@Subject", strSubject)
        cmdUpdate.Parameters.AddWithValue("@Event", blEvent)
        cmdUpdate.Parameters.AddWithValue("@Bmark", strBmark)
        cmdUpdate.Parameters.AddWithValue("@Description", strDescription)
        cmdUpdate.Parameters.AddWithValue("@EnDate", dtEnDate)
        cmdUpdate.Parameters.AddWithValue("@EvDate", dtEvDate)
        cmdUpdate.Parameters.AddWithValue("@ExDate", dtExDate)
        cmdUpdate.Parameters.AddWithValue("@Link", strLink)
        cmdUpdate.Parameters.AddWithValue("@Nnum", intNnum)
		
		objConn.Open()
		cmdUpdate.ExecuteNonQuery()
		objConn.Close()
		
        'Switch off the Edit mode
        dlNE.EditItemIndex = -1
        BindData()
End Sub
		
</Script>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title>BCBG - Edit News/Events</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../bcbgstyle.css" type="text/css" rel="stylesheet" />
<style type="text/css">
<!--
.btncol {
	width: 88px;
}
.light {
	color: #666666;
}
.border {
	border: 1px solid #666666;
}
.wide {
	width: 95%;
	text-align: right;
}

.wider {
	width: 100%
}


table {
	width: 95%;
	text-align: left;
	/*border: 1px solid #669966*/
}

-->
</style>
</head>

<body>
<!-- DIV for outer shell to set width of page -->
<div id="outeradmin"> 
  <!-- Div for topsection including logo and title -->
  <div class="top"><img alt="BC Beer Guide" src="../images/bcbg_logo2.jpg" /> 
    <div style="margin-bottom: 6px"> <a href="../default.aspx">Home</a>&nbsp; 
      <a href="../brewery.aspx">Breweries</a>&nbsp; <a href="../brands.aspx">Beers</a> 
      &nbsp; </div>
   <div>ADMIN:
                <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="default.aspx">Add Brewery/Beer</asp:HyperLink>
                <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="NewsEvents.aspx">Add News</asp:HyperLink>
                <asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl="newsedit.aspx">Edit News</asp:HyperLink>
                <asp:HyperLink ID="HyperLink7" runat="server" NavigateUrl="feature.aspx">Features</asp:HyperLink>
                &nbsp;
                <asp:HyperLink ID="HyperLink8" runat="server" NavigateUrl="links.aspx">Links</asp:HyperLink>
                <asp:HyperLink ID="HyperLink11" runat="server" NavigateUrl="brewerycomment.aspx">Brewery Comments</asp:HyperLink>
                <asp:HyperLink ID="HyperLink10" runat="server" NavigateUrl="brandcomment.aspx">Beer Comments</asp:HyperLink>
                <asp:HyperLink ID="HyperLink12" runat="server" NavigateUrl="featurecomment.aspx">Feature Comments</asp:HyperLink>
            </div>
  </div>

<h2>Edit Links</h2>
<form id="form1" runat="server">

<asp:Datalist id="dlNE" 
	DataKeyField="Nnumber"
	onEditCommand="dlNE_Edit" onUpdateCommand="dlNE_Update" 
	onCancelCommand="dlNE_Cancel"
	onDeleteCommand="dlNE_Delete"
	EditItemStyle-backcolor="#FFFF66"
	Width="90%"
	runat="server">
	<itemtemplate>
	
		<table>
			<tr><td><asp:Button id="btnEdit1" Text="Edit News" CommandName="Edit" runat="server" /></td>
				<td class="light">Subject:</td>
				<td class="border wider" ><%# Container.DataItem("Subject") %>
					</td></tr>
		<tr>
			<td class="btncol">&nbsp;</td>
			<td>&nbsp;</td>
			<td>
			<table class="wide">
				<tr><td class="light">Event:</td><td><asp:CheckBox id="chk1" checked='<%# Container.DataItem("EventItem") %>' runat="server" /></td>
			    	<%--<td class="light">Bkmark:</td><td class="border"><%# Container.DataItem("Bmark") %></td>--%>
			    	<td class="light">Event Date:</td><td class="border"><%# DataBinder.Eval(Container.DataItem, "EventDate", "{0:dd/MM/yyyy}") %></td>
			    	<td class="light">Entry Date:</td><td class="border"><%# DataBinder.Eval(Container.DataItem, "EntryDate", "{0:dd/MM/yyyy}") %></td>
			    	<td class="light">Expiry:</td><td class="border"><%# DataBinder.Eval(Container.DataItem, "ExpiryDate", "{0:dd/MM/yyyy}") %></td>
				</tr>
			</table>
			</td>
		</tr>
			<tr><td class="btncol">&nbsp;</td>
			<td class="light">Description:</td>
			<td class="border"><%# Container.DataItem("Description") %></td></tr>
			<tr><td>&nbsp;</td><td class="light">Link:</td><td class="border"><%# Container.DataItem("Link") %></td></tr>
		</table>
	</itemtemplate>
	<separatortemplate>
		<hr>
	</separatortemplate>
	<EditItemTemplate>
		<table>
			<tr><td><asp:Button CommandName="Update" Text="Update" runat="server" /></td>
				<td class="light">Subject:</td>
				<td ><asp:Textbox id="txtSubject" runat="server" Text='<%# Container.DataItem("Subject") %>' />
				</td>
			</tr>
		<tr>
			<td class="btncol"><asp:Button CommandName="Cancel" Text="Cancel" runat="server" /></td>
			<td><asp:Button CommandName="Delete" Text="Delete" runat="server" /></td>
			<td>
			<table class="wide">
				<tr><td class="light">Event:</td><td><asp:CheckBox id="chk1" checked='<%# Container.DataItem("EventItem") %>' runat="server" /></td>
			    	<td class="light"><%--Bkmark:--%></td><td ><asp:Textbox id="txtBmark"  runat="server" Text='<%# Container.DataItem("Bmark") %>' Visible="false" />
                    <%-- bookmark field no longer used - bookmark is established automatically using Nnumber - but haven't had time to remove all associated code
			        --%></td>
			    	<td class="light">Event Date:</td><td style="width: 100px" ><asp:Textbox id="txtEvDate"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EventDate", "{0:dd/MM/yyyy}") %>' Width="100px" /></td>
			    	<td class="light">Entry Date:</td><td ><asp:Textbox id="txtEnDate"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EntryDate", "{0:dd/MM/yyyy}") %>' Width="100px" /></td>
			    	<td class="light">Expiry:</td><td ><asp:Textbox id="txtExDate"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ExpiryDate", "{0:dd/MM/yyyy}") %>' Width="100px" /></td>
				</tr>
			</table>
			</td>
		</tr>
			<tr><td class="btncol"></td>
			    <td class="light">Description:</td>
			    <td >
			    <FTB:FreeTextBox ID="txtDescription" 
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" Text='<%# DataBinder.Eval(Container.DataItem, "Description") %>' runat="Server" ToolbarStyleConfiguration="NotSet" Height="200" />
			    </td>
			</tr>
			<tr><td>&nbsp;</td><td class="light">Link:</td>
			    <td ><asp:Textbox id="txtLink" runat="server" Text='<%# Container.DataItem("Link") %>' /></td>
			</tr>
		</table>
	</EditItemTemplate>
                <EditItemStyle BackColor="#FFFF66" />
</asp:Datalist>

</form>
</div>
    <UserControl:Footadmin id="UserControl1" runat="server" />

</body>
</html>
