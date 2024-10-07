<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="iso-8859-1"  Culture="en-CA" ValidateRequest="false" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>

<script runat="server">

        Function MyInsertMethod(ByVal subject As String, ByVal eventitem As Boolean, ByVal bmark As String, ByVal description As String, ByVal entryDate As Date, ByVal eventDate As Date, ByVal expiryDate As Date, ByVal link As String) As Integer
            'Dim connectionString As String = "Provider=Microsoft.Jet.OLEDB.4.0; Ole DB Services=-4; Data Source=C:\Documents an"& _
   ' "d Settings\John\My Documents\My Webs\Beer\_private\Breweries.mdb"
    '        Dim dbConnection As System.Data.IDbConnection = New System.Data.OleDb.OleDbConnection(connectionString)
    
			'Using strings from web.config in combination with Request.PhysicalApplicationPath
			Dim strConn as String
			Dim dbConnection As IDbConnection
			strConn = ConfigurationManager.AppSettings("strConfig1")
			strConn+= Request.PhysicalApplicationPath 
			strConn+= ConfigurationManager.AppSettings("strConfig2")
			dbConnection = New OleDbConnection(strConn)   
	
            Dim queryString As String = "INSERT INTO [tblNewsEvents] ([Subject], [Eventitem], [Bmark], [Description], [Ent"& _
    "ryDate], [EventDate], [ExpiryDate], [Link]) VALUES (@Subject, @Eventitem, @Bmark, @Description, "& _
    "@EntryDate, @EventDate, @ExpiryDate, @Link)"
            Dim dbCommand As System.Data.IDbCommand = New System.Data.OleDb.OleDbCommand
            dbCommand.CommandText = queryString
            dbCommand.Connection = dbConnection
    
            Dim dbParam_subject As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_subject.ParameterName = "@Subject"
            dbParam_subject.Value = subject
            dbParam_subject.DbType = System.Data.DbType.String
            dbCommand.Parameters.Add(dbParam_subject)
            Dim dbParam_eventitem As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_eventitem.ParameterName = "@Eventitem"
            dbParam_eventitem.Value = eventitem
            dbParam_eventitem.DbType = System.Data.DbType.Boolean
            dbCommand.Parameters.Add(dbParam_eventitem)
            Dim dbParam_bmark As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_bmark.ParameterName = "@Bmark"
            dbParam_bmark.Value = bmark
            dbParam_bmark.DbType = System.Data.DbType.String
            dbCommand.Parameters.Add(dbParam_bmark)
            Dim dbParam_description As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_description.ParameterName = "@Description"
            dbParam_description.Value = description
            dbParam_description.DbType = System.Data.DbType.String
            dbCommand.Parameters.Add(dbParam_description)
            Dim dbParam_entryDate As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_entryDate.ParameterName = "@EntryDate"
            dbParam_entryDate.Value = entryDate
            dbParam_entryDate.DbType = System.Data.DbType.DateTime
            dbCommand.Parameters.Add(dbParam_entryDate)
            Dim dbParam_eventDate As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_eventDate.ParameterName = "@EventDate"
            dbParam_eventDate.Value = eventDate
            dbParam_eventDate.DbType = System.Data.DbType.DateTime
            dbCommand.Parameters.Add(dbParam_eventDate)
            Dim dbParam_expiryDate As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_expiryDate.ParameterName = "@ExpiryDate"
            dbParam_expiryDate.Value = expiryDate
            dbParam_expiryDate.DbType = System.Data.DbType.DateTime
            dbCommand.Parameters.Add(dbParam_expiryDate)
            Dim dbParam_link As System.Data.IDataParameter = New System.Data.OleDb.OleDbParameter
            dbParam_link.ParameterName = "@Link"
            dbParam_link.Value = link
            dbParam_link.DbType = System.Data.DbType.String
            dbCommand.Parameters.Add(dbParam_link)
    
            Dim rowsAffected As Integer = 0
            dbConnection.Open
            Try
                rowsAffected = dbCommand.ExecuteNonQuery
            Finally
                dbConnection.Close
            End Try
    
            Return rowsAffected
        End Function
    
    Sub btnAddNews_Click(sender As Object, e As EventArgs)
        Dim strSubject As String
        Dim strBmark As String
        Dim strDescrip As String
        Dim strLink As String
        Dim blnEventItem As Boolean
        Dim dtEntryD As DateTime
        Dim dtEntryDc As DateTime 'Needed to provide holder for formatted date
        Dim dtEventD As DateTime
        Dim dtExpiryD As DateTime
    
        strSubject = txtSubject.Text
        strBmark = txtBook.Text
        strDescrip = txtDescrip.Text
        strLink = txtLink.Text
        blnEventItem = chkEvent.Checked
        'Next line used to ensure date is proper format other error
        'if date contains day that is above 12
        dtEntryDc=String.Format("{0:dd/MM/yyyy}", txtEntryD.Text)
        dtEntryD = dtEntryDc
        dtEventD = txtEventD.Text
        dtExpiryD = txtExpiryD.Text
    
        'Try
            MyInsertMethod (strSubject, blnEventItem, strBmark, strDescrip, dtEntryD, dtEventD, dtExpiryD, strLink)
            lblMessage.Text = "News/Event has been added"
			'btnReset_Click()
        'Catch
            'lblMessage.Text="An error adding news"
        'End Try
    End Sub
    
	Sub btnReset_Click(sender As Object, e As EventArgs)
        txtSubject.Text=""
		txtBook.Text=""
		txtEntryD.Text=""
		txtEventD.Text="1/1/1"
		txtExpiryD.Text=""
		txtDescrip.Text=""
		txtLink.Text=""
		lblMessage.Text=""
    End Sub
	
    Sub btnToday_Click(sender As Object, e As EventArgs)
        Dim entryDate As DateTime = DateTime.Now
    	txtEntryD.Text=String.Format("{0:dd/MM/yyyy}", entryDate)
		Dim expiryDate as DateTime = entryDate.AddDays(60)
		txtExpiryD.Text=String.Format("{0:dd/MM/yyyy}", expiryDate)
    End Sub

	Sub btnThreeMths_Click(sender As Object, e As EventArgs)
        Dim expiryDate As DateTime = DateTime.Now
		expiryDate = expiryDate.AddDays(90)
    	txtExpiryD.Text=String.Format("{0:dd/MM/yyyy}", expiryDate)
    End Sub

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Edit News and Events </title>
    <link href="../bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <!-- DIV for outer shell to set width of page -->
    
<div id="outer"> 
<form id="Form1" runat="server">
  <!-- Div for topsection including logo and title -->
  <div class="top"><img alt="BC Beer Guide" src="../images/bcbg_logo2.jpg" /> 
    <div style="MARGIN-BOTTOM: 6px"><a href="../default.aspx">Home</a>&nbsp;<a href="../brewery.aspx">Breweries</a>&nbsp;<a href="../brands.aspx">Beers</a> 
      | <a href="default.aspx">Admin Home</a> </div>
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
     
    <table  width="300">
      <tbody>
        <tr> 
          <td> <asp:Label id="Label1" runat="server">Subject</asp:Label></td>
          <td> <asp:TextBox id="txtSubject" runat="server" Width="416px"></asp:TextBox> </td>
        </tr>
        <tr> 
          <td> <asp:Label id="Label2" runat="server">Bookmark</asp:Label></td>
          <td> <asp:TextBox id="txtBook" runat="server"></asp:TextBox>(no longer needed) 
          <%--bookmark field is no longer used - bookmark is established automatically using Nnumber - but haven't had time to remove all associated code --%></td>
        </tr>
        <tr> 
          <td> <asp:Label id="Label3" runat="server">Entry Date</asp:Label></td>
          <td> <asp:TextBox id="txtEntryD" runat="server"></asp:TextBox> &nbsp;(dd/mm/yyyy)&nbsp; <asp:Button id="btnToday" onclick="btnToday_Click" runat="server" Text="Today"></asp:Button> </td>
        </tr>
        <tr> 
          <td> <asp:Label id="Label4" runat="server">Event</asp:Label></td>
          <td> <asp:CheckBox id="chkEvent" runat="server"></asp:CheckBox> </td>
        </tr>
        <tr> 
          <td> <asp:Label id="Label5" runat="server">Event Date</asp:Label></td>
          <td> <asp:TextBox id="txtEventD" text="1/1/1" runat="server"></asp:TextBox> &nbsp;(dd/mm/yyyy - use 1/1/1 if not event)</td>
        </tr>
        <tr> 
          <td> <asp:Label id="Label6" runat="server">Expiry</asp:Label></td>
          <td> <asp:TextBox id="txtExpiryD" runat="server"></asp:TextBox>
            &nbsp;(dd/mm/yyyy)&nbsp; <asp:Button id="btnTwoMths" onclick="btnThreeMths_Click" runat="server" Text="3 Months"></asp:Button></td>
        </tr>
        <tr> 
          <td> <asp:Label id="Label7" runat="server">Description</asp:Label></td>
          <td> <FTB:FreeTextBox ID="txtDescrip" 
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" runat="Server" ToolbarStyleConfiguration="NotSet" Height="200" />
           </td>
        </tr>
        <tr> 
          <td> <asp:Label id="Label8" runat="server">Link</asp:Label></td>
          <td> <asp:TextBox id="txtLink" runat="server" Width="385px"></asp:TextBox>
            (no 'http://')</td>
        </tr>
        <tr> 
          <td> </td>
          <td> <asp:Button id="btnAddNews" onclick="btnAddNews_Click" runat="server" Text="Add News/Event"></asp:Button> <asp:Button id="btnReset" onclick="btnReset_Click" runat="server" Text="Reset"></asp:Button> </td>
        </tr>
      </tbody>
    </table>
    <p> 
      <asp:Label id="lblMessage" runat="server"></asp:Label>
    </p>
    <!-- Insert content here -->
  </form>
</div>
    <UserControl:Footadmin id="UserControl1" runat="server" />

</body>
</html>
