<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="iso-8859-1"  Culture="en-CA"  ValidateRequest="false" %>

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
		'Populates brand comment date with current date - brewery date is automatically current date
		'same intended result but this allows option to select alternate date
		Dim commDate As DateTime = DateTime.Now
		txtDate.Text=String.Format("{0:dd/MM/yyyy}", commDate)
	
	   '-------Needed to load dropdown lists
       '------- Making the connection ------
     	Dim strConnectionD as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
     	strConnectionD += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
     	Dim objConnectionD as New OleDbConnection(strConnectionD)   
        '--------Connection made ---------
    
         objConnectionD.Open()
    	'---Dropdown list for brewery type
         'Create Command object for the query
         Dim strBType as String
         strBType = "SELECT BType FROM tblType ORDER BY BType"
         Dim objCmd as New OledbCommand(strBType, objConnectionD)
 
         'Create/Populate DataReader - type list 
         Dim objDR as OledbDataReader
         objDR = objCmd.ExecuteReader()
    
         'Databind DataReader to list control
         lstType.DataSource=objDR
         lstType.DataBind()
	
            '---Dropdown list for brewery status
            Dim strBStatus As String
            strBStatus = "SELECT Status FROM tblBreweryStatus"
            Dim objCmdS As New OleDbCommand(strBStatus, objConnectionD)
            
            Dim objDRS As OleDbDataReader
            objDRS = objCmdS.ExecuteReader()
            
            lstStatus.DataSource = objDRS
            lstStatus.DataBind()
            
		 objConnectionD.Close()
	
            
            
		 objConnectionD.Open()
    	'---Dropdown list for region
         'Create Command object for the query
         Dim strReg as String
         strReg = "SELECT Region FROM tblRegions"
         Dim objCmdr as New OledbCommand(strReg, objConnectionD)
 
         'Create/Populate DataReader - type list 
         Dim objDRr as OledbDataReader
         objDRr = objCmdr.ExecuteReader()
    
         'Databind DataReader to list control
         lstReg.DataSource=objDRr
         lstReg.DataBind()
	
		 objConnectionD.Close()
		 
		 objConnectionD.Open()
		 '---Dropdown list for brewery names (for adding brand)
		 Dim strBName as String
		 strBName = "SELECT Number, BName FROM tblBrewery ORDER BY BName"
		 Dim objCmdb as New OledbCommand(strBName, objConnectionD)
		 Dim objDRb as OledbDataReader
		 objDRb=objCmdb.ExecuteReader()
		 lstBrewery.DataSource=objDRb
		 lstBrewery.DataBind()
    
         'Select default item, where first item=0
         '--to add text at top:
         'lstType.Items.Insert(0, new ListItem("-- Select from List --"))
         '--to select from existing items
         'lstType.SelectedIndex=0
		 
		  objConnectionD.Close()
		 
		 objConnectionD.Open()

		 '---Dropdown list for beer styles (for adding brand)
		 Dim strStyle as String
		 strStyle = "SELECT Style FROM tblStyle"
		 Dim objCmdstyle as New OledbCommand(strStyle, objConnectionD)
		 Dim objDRstyle as OledbDataReader
		 objDRstyle=objCmdstyle.ExecuteReader()
		 lstStyle.DataSource=objDRstyle
		 lstStyle.DataBind()	
		 objConnectionD.Close()
	End If
End Sub

'Add new brewery information
Sub Add_Brewery (s As Object, e As EventArgs)

	   '------- Making the connection ------
     	Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
     	strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
     	Dim objConnection as New OleDbConnection(strConnection)   
        '--------Connection made ---------
		
		Dim strInsert As String
		Dim cmdInsert As OleDbCommand
		
        strInsert = "Insert Into tblBrewery (BName, BType, Status, BMark, Address, City, Region, Postal, "
        strInsert += "Ph, Fax, Email, Website, Logo, Comment, Rating, ComDate) "
        strInsert += "Values (@BName, @BType, @Status, @BMark, @Address, @City, @Region, @Postal, "
        strInsert += "@Ph, @Fax, @Email, @Website, @Logo, @Comment, @Rating, @ComDate)"
		cmdInsert = New OleDbCommand(strInsert, objConnection)
        cmdInsert.Parameters.AddWithValue("@BName", txtBName.Text)
        cmdInsert.Parameters.AddWithValue("@BType", lstType.SelectedItem.Text)
        cmdInsert.Parameters.AddWithValue("@Status", lstStatus.SelectedItem.Text)
        cmdInsert.Parameters.AddWithValue("@BMark", txtBMark.Text)
        cmdInsert.Parameters.AddWithValue("@Address", txtAddress.Text)
        cmdInsert.Parameters.AddWithValue("@City", txtCity.Text)
        cmdInsert.Parameters.AddWithValue("@Region", lstReg.SelectedItem.Text)
        cmdInsert.Parameters.AddWithValue("@Postal", txtPostal.Text)
        cmdInsert.Parameters.AddWithValue("@Ph", txtPh.Text)
        cmdInsert.Parameters.AddWithValue("@Fax", txtFax.Text)
        cmdInsert.Parameters.AddWithValue("@Email", txtEmail.Text)
        cmdInsert.Parameters.AddWithValue("@Website", txtWebsite.Text)
        'cmdInsert.Parameters.AddWithValue("@Logo", txtLogo.Text)
		
        'Variables needed for logo image
		 Dim sPath As String
		 Dim sFile As String
		 Dim sSplit() As String
		 
		'If inpLogo field is empty, blank.gif is automatically added
		 If inpLogo.PostedFile.Filename.Length = 0 Then
		 	sFile = "blank.gif"
		 Else
			 sFile = inpLogo.PostedFile.Filename
			 'Splits file name from path
			 sSplit = Split(sFile, "\")
		 	 sFile = sSplit(Ubound(sSplit))
         	 'Attach file name to path where it needs to be saved
		 	 sPath = Request.PhysicalApplicationPath + "/images/breweries/" + sFile
		 	'Save file in appropriate path location - lblResults can be used for confirmation/testing
		  	 inpLogo.PostedFile.SaveAs(sPath)
		 End If
        cmdInsert.Parameters.AddWithValue("@Logo", sFile)
        cmdInsert.Parameters.AddWithValue("@Comment", txtComment.Text)
        If rblRating.SelectedValue > "0" Then
            cmdInsert.Parameters.AddWithValue("@Rating", OleDbType.Integer).Value = rblRating.SelectedValue
        Else
            cmdInsert.Parameters.AddWithValue("@Rating", OleDbType.Integer).Value = 0
        End If
        
        'Ensures consistent date formatting
        Dim dtBreweryD As DateTime
        dtBreweryD = String.Format("{0:dd/MM/yyyy}", DateTime.Now)
        'objCommandU.Parameters.AddWithValue("@ComDate", DateTime.Now.ToString)
        
        cmdInsert.Parameters.Add("@ComDate", OleDbType.Date).Value = dtBreweryD
        'cmdInsert.Parameters.Add("@ComDate", OleDbType.Date).Value = Now.Date()
        objConnection.Open()
        cmdInsert.ExecuteNonQuery()
        objConnection.Close()
        lblConfirmBrewery.Text = "This brewery has been added."
    End Sub

'Add new beer information
Sub Add_Beer (s As Object, e As EventArgs)

	'Required on Inspiron server because of weird French culture settings that mark decimal as comma
	System.Threading.Thread.CurrentThread.CurrentCulture=MyCulture
	System.Threading.Thread.CurrentThread.CurrentUICulture=MyCulture

	   '------- Making the connection ------
     	Dim strConnectionB as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
     	strConnectionB += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
     	Dim objConnectionB as New OleDbConnection(strConnectionB)   
        '--------Connection made ---------
		
		Dim strInsertB As String
		Dim cmdInsertB As OleDbCommand
		
        'strInsertB = "Insert Into tblBrand (Brand, BName, Style, Alc, Comment, Rating, ComDate, Bdbkmark) "
        'strInsertB += "Values (@Brand, @BName, @Style, @Alc, @Comment, @Rating, @ComDate, @Bdbkmark)"
        strInsertB = "Insert Into tblBrand (Brand, BName, Style, Alc, Comment, Rating, ComDate) "
        strInsertB += "Values (@Brand, @BName, @Style, @Alc, @Comment, @Rating, @ComDate)"
        cmdInsertB = New OleDbCommand(strInsertB, objConnectionB)
        cmdInsertB.Parameters.AddWithValue("@Brand", txtBrand.Text)
		'Collects number value (primary key from brewery table) related to brewery name
		cmdInsertB.Parameters.Add(New OleDbParameter("@BName", OleDbType.Integer))
        cmdInsertB.Parameters("@BName").Value = lstBrewery.SelectedItem.value
		'Uses the number placed in txtNum via Get_Number as alternative (and clumsier) approach
		'cmdInsertB.Parameters.Add("@BName", txtNum.Text)
        cmdInsertB.Parameters.AddWithValue("@Style", lstStyle.SelectedItem.Text)
		'Convoluted approach required to convert text from textbox to same format (double) as database field
		Dim txtAlco as String
		txtAlco=txtAlc.Text
		Dim dblAlc as Double
		dblAlc=Convert.ToDouble(txtAlco)
		'dblAlc=dblAlc/100
		cmdInsertB.Parameters.Add(New OleDbParameter("@Alc", OleDbType.Double))
        cmdInsertB.Parameters("@Alc").Value = dblAlc
        Dim strBrdNull As String
        strBrdNull = "No info available"
        If String.IsNullOrEmpty(txtBrdComment.Text) Then
            cmdInsertB.Parameters.AddWithValue("@Comment", strBrdNull)
        Else
            cmdInsertB.Parameters.AddWithValue("@Comment", txtBrdComment.Text)
        End If
        
        If rblRating.SelectedValue > "0" Then
            cmdInsertB.Parameters.AddWithValue("@Rating", OleDbType.Integer).Value = rblRating.SelectedValue
        Else
            cmdInsertB.Parameters.AddWithValue("@Rating", OleDbType.Integer).Value = 0
        End If
        
        'Ensures consistent date formatting
        Dim dtBeerD As DateTime
        dtBeerD = String.Format("{0:dd/MM/yyyy}", txtDate.Text)       
        cmdInsertB.Parameters.AddWithValue("@ComDate", dtBeerD)
        'Previous version - day/month ended up getting switched
        'cmdInsertB.Parameters.AddWithValue("@ComDate", txtDate.Text)
        'For current date - originally used
        'cmdInsertB.Parameters.Add("@ComDate", OleDbType.Date).Value = Now.Date()
        objConnectionB.Open()
        cmdInsertB.ExecuteNonQuery()
        objConnectionB.Close()
        
        pnlConfirm.Visible = True
        lblConfirmBeer.Text = "This beer was successfully added"
    End Sub

'Used to get brewery number based on dropdownlist selection but not needed due to DataValueField set to Number
'Left here as example of how to get data in a textbox updated according to selection in dropdownlist
'Requires OnSelectedIndexChanged="Get_Number" AutoPostBack="True" in dropdownlist tag
Sub Get_Number (s As Object, e As EventArgs)
'------- Making the connection ------
     	Dim strConnectionN as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
     	strConnectionN += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
     	Dim objConnectionN as New OleDbConnection(strConnectionN)   
        '--------Connection made ---------
        
		objConnectionN.Open()
    	'---Dropdown list for brewery type
         'Create Command object for the query
         Dim strNum as String
         strNum = "SELECT Number, BName FROM tblBrewery WHERE BName=" & "'" & lstBrewery.SelectedItem.Text & "'"
		 Dim daNumber as New OLEDBDataAdapter(strNum, objConnectionN)
		 Dim dsNumber as New DataSet()
		 daNumber.Fill(dsNumber, "tblNumber")
		 Dim intBrewery as Integer
		 intBrewery=dsNumber.Tables(0).Rows(0).Item("Number")	
		 'txtNum.Text=intBrewery   taken out because text box disabled

End Sub

Sub ResetBeer(s As Object, e As EventArgs)
		txtBrand.Text=""
        txtAlc.Text = "0"
        lstStyle.ClearSelection()
		txtBrdComment.Text=""
		txtDate.Text=Now.Date()
        'txtBrdBkmk.Text=""
        lblConfirmBeer.Text = ""
        pnlConfirm.Visible = False
        rblRatingBd.ClearSelection()
    End Sub

</Script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>BCBG - Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../bcbgstyle.css" type="text/css" rel="stylesheet" />
</head>

<body>
<!-- DIV for outer shell to set width of page -->
<div id="outeradmin"> 
  <!-- Div for topsection including logo and title -->
  <div class="top"><img src="../images/bcbg_logo2.jpg" alt="BCBG" /> 
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

<h2>Add a Brewery</h2>
<form id="form1" runat="server">
<asp:Label id="lblConfirmBrewery" runat="server" ForeColor="Red"></asp:Label>
<table>
<tr><td style="width: 59px">Name:</td><td><asp:TextBox ID="txtBName" runat="server" Columns="40" /></td>
	<td><asp:DropDownList id="lstType" runat="server" DataTextField="BType" DataValueField="BType"></asp:DropDownList>
        <asp:DropDownList id="lstStatus" runat="server" DataTextField="Status" DataValueField="Status"></asp:DropDownList>
    </td>
</tr>
</table>
<table>
<tr><td>Bookmark:</td><td><asp:TextBox ID="txtBMark" runat="server" Columns="10" Visible="false" />(no longer used but haven't had time
to take out all code references</td></tr>
<tr><td>Address:</td><td><asp:TextBox ID="txtAddress" runat="server" Columns="40" /></td>
	<td>City:</td><td><asp:TextBox ID="txtCity" runat="server" Columns="30" /></td>
</tr>
<tr>
	<td>Postal:</td><td><asp:TextBox ID="txtPostal" runat="server" Columns="10" /></td>
	<td>Region:</td><td><asp:DropDownList id="lstReg" runat="server" DataTextField="Region" DataValueField="Region" /></td>
</tr>
<tr><td>Phone:</td><td><asp:TextBox ID="txtPh" runat="server" /></td>
	<td>Fax:</td><td><asp:TextBox ID="txtFax" runat="server" /></td></tr>
<tr><td>Email:</td><td><asp:TextBox ID="txtEmail" runat="server" Columns="40" /></td>
	<td>Website:</td><td><asp:TextBox ID="txtWebsite" runat="server" Columns="40" />(no 'http://')</td></tr>
<tr><td>Logo:</td><td><%--<asp:TextBox ID="txtLogo" size="30" runat="server" />  --%>
			<!-- INPUT and TYPE=FILE specify an input box with BROWSE button -->
          	<input type="file" id="inpLogo" size="40" runat="server" />
</td></tr>
</table>
<table>
<tr><td>Comment:</td>
    <td>
    <FTB:FreeTextBox ID="txtComment" 
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" runat="Server" ToolbarStyleConfiguration="NotSet" Height="100" Width="700" />
    </td>
</tr>
<tr><td>Rating:</td>
<td><asp:RadioButtonList ID="rblRating" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                    <asp:ListItem Text="1" Value="1" />
                    <asp:ListItem Text="2" Value="2" />
                    <asp:ListItem Text="3" Value="3" />
                    <asp:ListItem  Value="4" Text="4" />
                    <asp:ListItem Text="5" Value="5" />
                </asp:RadioButtonList>
                (1=poor, 5=superb)
  </td>
</tr>
<tr><td>&nbsp;</td><td><asp:Button Text="Add Brewery" OnClick="Add_Brewery" runat="server" ID="btnAddBrewery" /></td></tr>
</table>
<h2>Add a Brand</h2>
<asp:Panel runat="server" ID="pnlConfirm" Visible="false">
<asp:Label id="lblConfirmBeer" runat="server" ForeColor="Red"></asp:Label>
<asp:Button ID="btnReset1" Text="Reset" OnClick="ResetBeer" runat="server" />
</asp:Panel>
<table>
<tr>
<td style="width: 59px">Brewery:</td><td><asp:DropDownList id="lstBrewery" DataTextField="BName" DataValueField="Number" runat="server"></asp:DropDownList></td>
<td><%-- Used to get number but not needed with DataValueField in ddl set to Number <asp:TextBox id="txtNum" size="10" runat="server" />--%><%-- <asp:Button Text="Get Number" OnClick="Get_Number" runat="server" />--%></td>
</tr>
<tr>
<td>Brand:</td><td><asp:TextBox ID="txtBrand" runat="server" Columns="40" /></td>
<td>Style:</td><td><asp:DropDownList id="lstStyle" DataTextField="Style" DataValueField="Style" runat="server"></asp:DropDownList></td>
<td>Alc %:</td><td><asp:TextBox ID="txtAlc" runat="server" Columns="2" />(5%=.05; 0 if unknown)</td>
</tr>
</table>
<table>
<tr>
    <td>Comment:</td>
    <td>
        <FTB:FreeTextBox ID="txtBrdComment" 
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" runat="Server" ToolbarStyleConfiguration="NotSet" Height="80" Width="700" />
    </td>
</tr>
<tr><td>Rating:</td>
<td><asp:RadioButtonList ID="rblRatingBd" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                    <asp:ListItem Text="1" Value="1" />
                    <asp:ListItem Text="2" Value="2" />
                    <asp:ListItem Text="3" Value="3" />
                    <asp:ListItem  Value="4" Text="4" />
                    <asp:ListItem Text="5" Value="5" />
                </asp:RadioButtonList>
                (1=poor, 5=superb)
  </td>
</tr>
<tr>
<td>Date:</td><td><asp:TextBox ID="txtDate"  runat="server" Columns="10" />(dd/mm/yyyy)</td>
</tr>
<tr>
<td>&nbsp;</td>
<td><asp:Button Text="Add Beer" OnClick="Add_Beer" runat="server" ID="btnAddBeer" />&nbsp;
<asp:Button Id="btnReset2" Text="Reset" OnClick="ResetBeer" runat="server" /></td>
</tr>
</table>
</form>
</div>

    <UserControl:Footadmin id="UserControl1" runat="server" />
</body>
</html>
