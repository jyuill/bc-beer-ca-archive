<%@ Page Language="VB" ContentType="text/html" ValidateRequest="false" Debug="false" %>

<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<%@ import Namespace="System.Globalization" %>

<script runat="server">
    
    Sub Page_Load()
		If Not Page.IsPostback Then
           	BindList()
			'lblDate.Text = Now.Date()
            lnkBrandEdit.NavigateUrl = "brandedit.aspx?Number=" + Request.Params("Number")
            lnkBrewery.NavigateUrl = "http://www.bcbeer.ca/breweryselect.aspx?Number=" + Request.Params("Number")
        End If
		
	End Sub
			
	Sub BindList()
			
                '------- Making the connection ------
                Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"           
                strConnection += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
				Dim objConnection as New OLEDBConnection(strConnection)
                '--------Connection made ---------
    
          		'1---Information retrieved from tblBrewery in Brewery database
        Dim strSQL As String = "SELECT * FROM tblBrewery WHERE Number= " + Request.Params("Number")
                Dim objAdapter as New OledbDataAdapter(strSQL, objConnection)
              
                '3---New Data Set created for main brewery information section
           		Dim objDataSet2 as New DataSet()
                objAdapter.Fill(objDataSet2, "tblBrewery2")
          
          		'---Datalist for main brewery information
                dlMaster.DataSource=objDataSet2.Tables("tblBrewery2")
                dlMaster.DataBind()
    
    End Sub
    
	'Populates Type dropdown list for editing
	Function GetTypes() as DataSet
		Dim strConnectionT as String = "Provider=Microsoft.Jet.OLEDB.4.0;"           
        strConnectionT += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionT as New OLEDBConnection(strConnectionT)
	
        Dim strSQLddlT As String
        strSQLddlT = "SELECT BType FROM tblType ORDER BY BType"
    
        Dim myDataAdapterT as OleDbDataAdapter = New OleDbDataAdapter(strSQLddlT, objConnectionT)
    
        Dim ddlDataSetT As DataSet = New DataSet()
        myDataAdapterT.Fill(ddlDataSetT, "Types")
        Return ddlDataSetT
    End Function
    
	'Shows existing Type in dropdown box for editing
	Function GetSelIndT(BType as String) as Integer
        Dim iLoop As Integer
    
        Dim strConnectionTS as String = "Provider=Microsoft.Jet.OLEDB.4.0;"           
        strConnectionTS += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionTS as New OLEDBConnection(strConnectionTS)
	
        Dim strSQLddlTS As String
        strSQLddlTS = "SELECT BType FROM tblType ORDER BY BType"
    
        Dim myDataAdapterTS as OleDbDataAdapter = New OleDbDataAdapter(strSQLddlTS, objConnectionTS)
    
        Dim ddlDataSetTS As DataSet = New DataSet()
        myDataAdapterTS.Fill(ddlDataSetTS, "BreweryType")
        'Return ddlDataSet
    
        Dim dtTS As DataTable = ddlDataSetTS.Tables("BreweryType")
        For iLoop = 0 to dtTS.Rows.Count - 1
          If BType = dtTS.Rows(iLoop)("BType") then
            Return iLoop
          End If
        Next iLoop
    End Function
    
    'Populates Brewery Status dropdown list for editing
    Function GetStatus() As DataSet
        Dim strConnectionS As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
        strConnectionS += "Data Source = " & Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionS As New OleDbConnection(strConnectionS)
	
        Dim strSQLddlS As String
        strSQLddlS = "SELECT Status FROM tblBreweryStatus"
    
        Dim myDataAdapterS As OleDbDataAdapter = New OleDbDataAdapter(strSQLddlS, objConnectionS)
    
        Dim ddlDataSetS As DataSet = New DataSet()
        myDataAdapterS.Fill(ddlDataSetS, "Statuses")
        Return ddlDataSetS
    End Function
    
    'Shows existing Status in dropdown box for editing
    Function GetSelIndS(ByVal Status As String) As Integer
        Dim iLoop As Integer
    
        Dim strConnectionSS As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
        strConnectionSS += "Data Source = " & Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionSS As New OleDbConnection(strConnectionSS)
	
        Dim strSQLddlSS As String
        strSQLddlSS = "SELECT Status FROM tblBreweryStatus"
    
        Dim myDataAdapterSS As OleDbDataAdapter = New OleDbDataAdapter(strSQLddlSS, objConnectionSS)
    
        Dim ddlDataSetSS As DataSet = New DataSet()
        myDataAdapterSS.Fill(ddlDataSetSS, "BreweryStatus")
        'Return ddlDataSet
    
        Dim dtSS As DataTable = ddlDataSetSS.Tables("BreweryStatus")
        For iLoop = 0 To dtSS.Rows.Count - 1
            If Status = dtSS.Rows(iLoop)("Status") Then
                Return iLoop
            End If
        Next iLoop
    End Function
    
	'Populates Region dropdownlist for editing
	Function GetRegions() as DataSet
		Dim strConnectionR as String = "Provider=Microsoft.Jet.OLEDB.4.0;"           
        strConnectionR += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionR as New OLEDBConnection(strConnectionR)
	
        Dim strSQLddlR As String
        strSQLddlR = "SELECT Region FROM tblRegions ORDER BY Region"
    
        Dim myDataAdapterR as OleDbDataAdapter = New OleDbDataAdapter(strSQLddlR, objConnectionR)
    
        Dim ddlDataSetR As DataSet = New DataSet()
        myDataAdapterR.Fill(ddlDataSetR, "Regions")
        Return ddlDataSetR
    End Function
	
	Function GetSelIndR(Region as String) as Integer
        Dim iLoop As Integer
    
        Dim strConnectionRS as String = "Provider=Microsoft.Jet.OLEDB.4.0;"           
        strConnectionRS += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionRS as New OLEDBConnection(strConnectionRS)
	
        Dim strSQLddlRS As String
        strSQLddlRS = "SELECT Region FROM tblRegions ORDER BY Region"
    
        Dim myDataAdapterRS as OleDbDataAdapter = New OleDbDataAdapter(strSQLddlRS, objConnectionRS)
    
        Dim ddlDataSetRS As DataSet = New DataSet()
        myDataAdapterRS.Fill(ddlDataSetRS, "Reg")
        'Return ddlDataSet
    
        Dim dtRS As DataTable = ddlDataSetRS.Tables("Reg")
        For iLoop = 0 to dtRS.Rows.Count - 1
          If Region = dtRS.Rows(iLoop)("Region") then
            Return iLoop
          End If
        Next iLoop
    End Function
	
	Private Sub dlMaster_Edit(Source As Object, E As DataListCommandEventArgs)
        'Set EditItemIndex property to the index of the record raising the event
        dlMaster.EditItemIndex = E.Item.ItemIndex
        BindList()
    End Sub
	
	Sub dlMaster_Update(Source As Object, E As DataListCommandEventArgs)
		'Parameterized for simplicity and flexibility - no apostrophe problem etc
		'Based on setup in linkedit.aspx
		
		Dim strLogo as String=CType(e.Item.FindControl("txtLogo"), TextBox).Text 'Logo file name
		Dim LogoBrowse as HtmlInputFile=CType(e.Item.FindControl("inpLogo"), HtmlInputFile) 'Browse box
		Dim strLogoFile as String 'Logo file name to be updated if required
		Dim strSplit() as String 'Splitting file name out of path if browse button used - brackets required
		Dim strLogoServer as String 'Uploading/saving file in correct location on server
			'Test if logo file already available
        If LogoBrowse.Value = "" Then
            If strLogo = "" Then
                strLogoFile = "blank.gif"
            Else
                strLogoFile = strLogo
            End If
            'Use browse box to upload file to server and get file name
        Else
            strLogoFile = LogoBrowse.Value
            strSplit = Split(strLogoFile, "\")
            strLogoFile = strSplit(UBound(strSplit))
            strLogoServer = Request.PhysicalApplicationPath + "/images/breweries/" + strLogoFile
            LogoBrowse.PostedFile.SaveAs(strLogoServer)
        End If
        Dim strBname As String = CType(E.Item.FindControl("txtBName"), TextBox).Text
        Dim strBmark As String = CType(E.Item.FindControl("txtBmark"), TextBox).Text
        Dim strBtype As String = CType(E.Item.FindControl("ddlTypes"), DropDownList).SelectedItem.Value
        Dim strStatus As String = CType(E.Item.FindControl("ddlStatus"), DropDownList).SelectedItem.Value
        Dim strAddress As String = CType(E.Item.FindControl("txtAddress"), TextBox).Text
        Dim strCity As String = CType(E.Item.FindControl("txtCity"), TextBox).Text
        Dim strRegion As String = CType(E.Item.FindControl("ddlRegions"), DropDownList).SelectedItem.Value
        Dim strPostal As String = CType(E.Item.FindControl("txtPostal"), TextBox).Text
        Dim strWebsite As String = CType(E.Item.FindControl("txtLink"), TextBox).Text
        Dim strEmail As String = CType(E.Item.FindControl("txtEmail"), TextBox).Text
        Dim strPh As String = CType(E.Item.FindControl("txtPh"), TextBox).Text
        Dim strFax As String = CType(E.Item.FindControl("txtFax"), TextBox).Text
        Dim strComment As String = CType(E.Item.FindControl("txtComment"), FreeTextBox).Text
        Dim dblRating As Double = CType(E.Item.FindControl("rblRating"), RadioButtonList).SelectedValue
        Dim dtDate As Date = Now.Date()
        
        Dim strUp As String = "UPDATE tblBrewery SET " & _
        "BName=@BName" & _
        ", Logo=@Logo" & _
        ", BMark=@Bmark" & _
        ", BType=@BType" & _
        ", Status=@Status" & _
        ", Address=@Address" & _
        ", City=@City" & _
        ", Region=@Region" & _
        ", Postal=@Postal" & _
        ", Website=@Website" & _
        ", Ph=@Ph" & _
        ", Fax=@Fax" & _
        ", Email=@Email" & _
        ", Comment=@Comment" & _
        ", Rating=@Rating" & _
        ", ComDate=@ComDate" & _
        " WHERE Number=" & Request.Params("Number")

        '------- Making the connection ------
        Dim strConnectionU As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
        strConnectionU += "Data Source = " & Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionU As New OleDbConnection(strConnectionU)
        Dim objCommandU As New OleDbCommand(strUp, objConnectionU)
		 		
        'Parameters must be added in same order as in SQL update stmt 
        objCommandU.Parameters.AddWithValue("@BName", strBname)
        objCommandU.Parameters.AddWithValue("@Logo", strLogoFile)
        objCommandU.Parameters.AddWithValue("@Bmark", strBmark)
        objCommandU.Parameters.AddWithValue("@BType", strBtype)
        objCommandU.Parameters.AddWithValue("@Status", strStatus)
        objCommandU.Parameters.AddWithValue("@Address", strAddress)
        objCommandU.Parameters.AddWithValue("@City", strCity)
        objCommandU.Parameters.AddWithValue("@Region", strRegion)
        objCommandU.Parameters.AddWithValue("@Postal", strPostal)
        objCommandU.Parameters.AddWithValue("@Website", strWebsite)
        objCommandU.Parameters.AddWithValue("@Ph", strPh)
        objCommandU.Parameters.AddWithValue("@Fax", strFax)
        objCommandU.Parameters.AddWithValue("@Email", strEmail)
        objCommandU.Parameters.AddWithValue("@Comment", strComment)
        objCommandU.Parameters.AddWithValue("@Rating", dblRating)
        'Original:
        objCommandU.Parameters.AddWithValue("@ComDate", dtDate)
        'Also works:
        'objCommandU.Parameters.AddWithValue("@ComDate", DateTime.Now.ToString)
        
        objConnectionU.Open()
        objCommandU.ExecuteNonQuery()
        objConnectionU.Close()
		
        'Switch off the Edit mode
        dlMaster.EditItemIndex = -1
        BindList()
    End Sub
	
	'Variation that includes try/catch/finally for error catching syntax
	'based on EditDatalist_CodeSample.htm (ASP.NET Developer's Cookbook)
	Private sub dlMaster_Delete(Source As Object, E As DataListCommandEventArgs)
    
        'Create the query...
        Dim strDel As String
        strDel = "Delete From tblBrewery Where Number =" & Request.Params("Number")
    
        'Update the data source...
		Dim strConnectionD as String = "Provider=Microsoft.Jet.OLEDB.4.0;"           
            strConnectionD += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
        Dim objConnectionD as New OLEDBConnection(strConnectionD)
      	Dim objCommandD as New OledbCommand(strDel, objConnectionD)
		
        Try
            objConnectionD.Open()
            objCommandD.ExecuteNonQuery
    
            'Switch off the Edit mode - but it goes back to brewery listing, even though deleted
            dlMaster.EditItemIndex = -1
            BindList()
			MessageLabel.Text = "This brewery successfully deleted"
    
        Catch _Error As Exception
            'MessageLabel.Text = _Error.Message
    
        Finally
            objConnectionD.Close()
        End Try
    End Sub
	
	Sub dlMaster_Cancel(ByVal sender As Object, ByVal e As DataListCommandEventArgs)
		dlMaster.EditItemIndex = -1
		BindList()
	End Sub
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>B.C. Beer Guide - Breweries</title> 
    <meta content="no index,no follow" name="robots"  />
    <link href="../bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>
<body>
<!-- DIV for outer shell to set width of page -->
<div id="outeradmin">
     <!-- Div for topsection including logo and title -->
  <div class="top"> <img src="../images/bcbg_logo2.jpg" alt="BC Beer Guide" /> 
    <div style="margin-bottom: 6px"> <a href="../default.aspx">Home</a>&nbsp; 
      <a href="../brewery.aspx">Breweries</a>&nbsp; <a href="../brands.aspx">Beers</a>&nbsp;|&nbsp;<a href="default.aspx">Add 
      Brewery/Brand</a> </div>
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
  <!--<div class="mainbox" >-->
  <form id="form1" runat="server">
  <h2>Edit Brewery Information</h2> 
  <p><asp:Label id="MessageLabel" runat="server" ForeColor="Red"></asp:Label></p>         
   <asp:HyperLink id="lnkBrewery" runat="server">Return to Brewery</asp:HyperLink>
   <asp:HyperLink id="lnkBrandEdit" runat="server">Review Brands</asp:HyperLink>
   <asp:datalist id="dlMaster" onEditCommand="dlMaster_Edit" onUpdateCommand="dlMaster_Update" onDeleteCommand="dlMaster_Delete" onCancelCommand="dlMaster_Cancel" CssClass="dlmain" Runat="server" AlternatingItemStyle-BorderWidth="0">
    <ItemTemplate>
		<asp:Button id="btnEdit1" Text="Edit Brewery" CommandName="Edit" runat="server" />
		<h1><%# DataBinder.Eval(Container.DataItem, "BName") %></h1>
       	<asp:Image ID="Image1" ImageUrl='<%# "..\images\breweries\" + DataBinder.Eval(Container.DataItem, "Logo") %>' 
		   AlternateText='<%# DataBinder.Eval(Container.DataItem, "Logo") %>' runat="server" CssClass="brewlogo" style="left: 1px" />
		<table>
		<tr>
		<td>Bookmark: </td><td><%# DataBinder.Eval(Container.DataItem, "Bmark") %></td>
		</tr>
		<tr>
		<td>Type: </td>
		<td><%# DataBinder.Eval(Container.DataItem, "BType") %></td>
		</tr>
		<tr>
		<td>Status: </td>
		<td><%# DataBinder.Eval(Container.DataItem, "Status") %></td>
		</tr>
		<tr>
		<td>Address:</td>
		<td><%# DataBinder.Eval(Container.DataItem, "Address") %></td>
		</tr>
		<tr>
		<td>City:</td>
		<td><%# DataBinder.Eval(Container.DataItem, "City") %></td>
		</tr>
		<tr>
		<td>Region: </td>
		<td><%# DataBinder.Eval(Container.DataItem, "Region") %></td>
		</tr>
		<tr>
		<td>Postal:</td>
		<td><%# DataBinder.Eval(Container.DataItem, "Postal") %></td>
		</tr>
		<tr>
		<td>Website:</td>
		<td><asp:hyperlink id="HyperLinkWebsite" 
				Text='<%# DataBinder.Eval(Container.DataItem, "Website") %>' 
				NavigateURL= '<%# "http://" + DataBinder.Eval(Container.DataItem, "Website") %>' runat="server" /><br>
        </td>
		</tr>
		<tr>
		<td>Phone:</td>
		<td><%# DataBinder.Eval(Container.DataItem, "Ph") %></td>
		</tr>
		<tr>
		<td>Fax:</td>
		<td><%# DataBinder.Eval(Container.DataItem, "Fax") %></td>
		</tr>
		<tr>
		<td>Email:</td>
		<td><%# DataBinder.Eval(Container.DataItem, "Email") %></td>
		</tr>
		<tr>
		<td>Rating:</td>
		<td><%# DataBinder.Eval(Container.DataItem, "Rating") %> stars</td>
		</tr>
		</table>				
		<p><%# DataBinder.Eval(Container.DataItem, "Comment") %> <i>(<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %>)</i>
		</p><br>
		<asp:Button id="btnEdit2" Text="Edit" CommandName="Edit" runat="server" />
	</ItemTemplate>
	<EditItemTemplate>
			<asp:Button CommandName="Update" Text="Update" runat="server" ID="btnUpdate" />&nbsp;
			<asp:Button CommandName="Delete" Text="Delete" runat="server" ID="btnDelete" />&nbsp;
			<asp:Button CommandName="Cancel" Text="Cancel" runat="server" ID="btnCancel" />
       <h1><a name= '<%#DataBinder.Eval(Container.DataItem, "Bmark") %>' runat="server">
           <%# DataBinder.Eval(Container.DataItem, "BName") %></a> </h1>
       	<!--<div class="blogo">-->
			<asp:Image ID="Image1" 
			ImageUrl='<%# "..\images\breweries\" + DataBinder.Eval(Container.DataItem, "Logo") %>' 
			AlternateText="brewery logo" runat="server" CssClass="brewlogo" />
			<asp:TextBox id="txtLogo" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Logo") %>' />
			 <!-- INPUT and TYPE=FILE specify an input box with BROWSE button -->
          	<input type="file" id="inpLogo" size="50" runat="server" />
		<!--</div>-->
		<table>
		<tr>
		<td>Name: </td><td><asp:Textbox id="txtBName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "BName") %>' Columns="48" /></td>
		</tr>
		<tr>
		<td>Bookmark: </td><td><asp:Textbox id="txtBmark" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Bmark") %>' />
		Type: <asp:DropDownList runat="server" id="ddlTypes" DataValueField="BType" DataTextField="BType" DataSource="<%# GetTypes() %>" SelectedIndex='<%# GetSelIndT(Container.DataItem("BType")) %>' ></asp:DropDownList>
		Status: <asp:DropDownList runat="server" id="ddlStatus" DataValueField="Status" DataTextField="Status" DataSource="<%# GetStatus() %>" SelectedIndex='<%# GetSelIndS(Container.DataItem("Status")) %>' ></asp:DropDownList>
		</td>
		
		</tr>
		
		<tr>
		<td>Address: </td><td><asp:TextBox id="txtAddress" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Address") %>' Columns="48" />
        City: <asp:TextBox id="txtCity" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "City") %>' Columns="10" />
        </td></tr>
        <tr><td>
		Region:</td><td> <asp:DropDownList runat="server" id="ddlRegions" DataValueField="Region" DataTextField="Region" DataSource="<%# GetRegions() %>" SelectedIndex='<%# GetSelIndR(Container.DataItem("Region")) %>' ></asp:DropDownList>
		Postal: <asp:Textbox id="txtPostal" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Postal") %>' Columns="5" /></td>
		</tr>
		<tr>
		<td>
		Website: </td><td><asp:TextBox id="txtLink" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Website") %>' Columns="40" />
		Email: <asp:Textbox id="txtEmail" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Email") %>' Columns="25" />
		</td></tr>
		<tr><td>
		Phone:</td><td> <asp:Textbox id="txtPh" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Ph") %>' Columns="10" />
		Fax: <asp:Textbox id="txtFax" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Fax") %>' Columns="10" />
            Rating:<asp:RadioButtonList ID="rblRating" runat="server" 
            RepeatDirection="Horizontal" RepeatLayout="Flow" 
            DataSourceID="AccessDataSource2" DataTextField="Rating" 
            DataValueField="Rating" 
            SelectedValue='<%# DataBinder.Eval(Container.DataItem, "Rating") %>'  />
            ('0' = Not Rated)
            <asp:AccessDataSource ID="AccessDataSource2" runat="server"
                DataFile="~/_private/Breweries.mdb" SelectCommand="SELECT [Rating] FROM [tblRating] ORDER BY [Rating]">
            </asp:AccessDataSource>
            
        </td>
		</tr>
		<tr>
		<td valign="top">Comment:</td><td>
		
		<FTB:FreeTextBox ID="txtComment" 
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" Text='<%# DataBinder.Eval(Container.DataItem, "Comment") %>' runat="Server" ToolbarStyleConfiguration="NotSet" />
		
		<i>(<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %>)</i></td>
		</tr>
		<tr><td>&nbsp;</td>
		<td><asp:Button CommandName="Update" Text="Update" runat="server" ID="btnUpdate2" />&nbsp;
			<asp:Button CommandName="Delete" Text="Delete" runat="server" ID="btnDelete2" />&nbsp;
			<asp:Button CommandName="Cancel" Text="Cancel" runat="server" ID="btnCancel2" />
		</td>
		</tr>
		</table>		
    </EditItemTemplate>
       <AlternatingItemStyle BorderWidth="0px" />
   </asp:datalist>
   </form>                      
 </div>
     <UserControl:Footadmin id="UserControl1" runat="server" />

</body>
</html>
