<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB"  ValidateRequest="false"  MaintainScrollPositionOnPostback="true" ContentType="text/html" ResponseEncoding="iso-8859-1" Culture="en-CA" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>


<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<%@ import Namespace="System.Globalization" %>
<%@ import Namespace="System.Globalization.CultureInfo" %>

<script runat="server" >
'Declare connection string name once so don't need different name each time
Dim strConnection as String
Dim objConnection as OleDbConnection

    Sub Page_Load()
		If Not Page.IsPostback Then
           	BindData()
			'lblDate.Text = Now.Date()
            lnkBreweryEdit.NavigateURL = "breweryedit.aspx?Number=" + Request.Params("Number")
        End If
		
	End Sub
			
	Sub BindData()		
                '------- Making the connection ------
                strConnection = "Provider=Microsoft.Jet.OLEDB.4.0;"
				strConnection += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
				objConnection= New OLEDBConnection(strConnection)
                '--------Connection made ---------
    
          		'1---Information retrieved from tblBrewery in Brewery database
                Dim strSQL as string = "SELECT * FROM tblBrewery WHERE Number=" + Request.Params("Number")
                Dim objAdapter as New OledbDataAdapter(strSQL, objConnection)
              
                '3---New Data Set created for main brewery information section
           		Dim objDataSet2 as New DataSet()
				objConnection.Open()
                objAdapter.Fill(objDataSet2, "tblBrewery2")
          
          		'---Datalist for main brewery information
                dlBrewery.DataSource=objDataSet2.Tables("tblBrewery2")
                dlBrewery.DataBind()
				
				Dim strBrand as string= "SELECT * FROM tblBrand WHERE BName=" + Request.Params("Number")
				Dim objAdapterBr as New OleDbDataAdapter(strBrand, objConnection)
				Dim objDataSetBr as New DataSet()
				objAdapterBr.Fill(objDataSetBr, "tblBrands")
				
				dgBrand.DataSource=objDataSetBr.Tables("tblBrands")
				dgBrand.DataBind()
				objConnection.Close()
				    
    End Sub
	
	'Populates Style dropdown list for editing
	Function GetStyles() as DataSet
        '------- Making the connection ------
        strConnection = "Provider=Microsoft.Jet.OLEDB.4.0;"
		strConnection += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
		objConnection= New OLEDBConnection(strConnection)
       '--------Connection made ---------

        Dim strSQLddlS As String
        strSQLddlS = "SELECT Style FROM tblStyle ORDER BY Style"
    
        Dim myDataAdapterS as OleDbDataAdapter = New OleDbDataAdapter(strSQLddlS, objConnection)
    
        Dim ddlDataSetS As DataSet = New DataSet()
        myDataAdapterS.Fill(ddlDataSetS, "Styles")
        Return ddlDataSetS
    End Function
	
	'Shows existing Style in dropdown box for editing
	Function GetSelIndS(Style as String) as Integer
        Dim iLoop As Integer
    
        '------- Making the connection ------
        strConnection = "Provider=Microsoft.Jet.OLEDB.4.0;"
		strConnection += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
		objConnection= New OLEDBConnection(strConnection)
       '--------Connection made ---------
	
        Dim strSQLddlSt As String
        strSQLddlSt = "SELECT Style FROM tblStyle ORDER BY Style"
        Dim myDataAdapterSt as OleDbDataAdapter = New OleDbDataAdapter(strSQLddlSt, objConnection)
    
        Dim ddlDataSetSt As DataSet = New DataSet()
        myDataAdapterSt.Fill(ddlDataSetSt, "BeerStyle")
    
        Dim dtStyle As DataTable = ddlDataSetSt.Tables("BeerStyle")
        For iLoop = 0 to dtStyle.Rows.Count - 1
          If Style = dtStyle.Rows(iLoop)("Style") then
            Return iLoop
          End If
        Next iLoop
    End Function
	
	Sub dgBrand_Edit(sender As Object, e As DataGridCommandEventArgs)
    	dgBrand.EditItemIndex = e.Item.ItemIndex
    	BindData()
	End Sub

	Sub dgBrand_Cancel(sender As Object, e As DataGridCommandEventArgs)
    	dgBrand.EditItemIndex = -1
    	BindData()
	End Sub

	Sub dgBrand_Delete(sender As Object, e As DataGridCommandEventArgs)
    	'Get the FAQID of the row whose Delete button was clicked
    	Dim BdNum as String = dgBrand.DataKeys(e.Item.ItemIndex)
    
     	Dim strDeleteSql As String
      	strDeleteSql = "DELETE FROM tblBrand WHERE BdNumber= " & BdNum '& e.item.cells(2).text
    
        '------- Making the connection ------
        strConnection = "Provider=Microsoft.Jet.OLEDB.4.0;"
		strConnection += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
		objConnection= New OLEDBConnection(strConnection)
       '--------Connection made ---------
      	objConnection.Open()
    
      	Dim objCommand = New OLEDBCommand(strDeleteSql, objConnection)
      	objCommand.ExecuteNonQuery()
    
      	dgBrand.EditItemIndex = -1
    
      	objConnection.Close()
     	BindData()
    End Sub
    
    'NOT most advanced method - see brandedit, linkedit or newsedit
	Sub dgBrand_Update(sender As Object, e As DataGridCommandEventArgs)
		'--Assign variables to values in the edited row.  Cells(0) is update/cancel; Cells(1) is Del
		'--Controls(x) is 1 because 2nd control in template column
		'--FindControl method used as alternate, generally more user friendly
   		Dim intBdNumber as Integer = e.Item.Cells(2).Text
   		Dim strBrand as String = CType(e.Item.Cells(3).Controls(1), TextBox).Text
		Dim strStyle as String = CType(e.Item.FindControl("lstStyle"), DropDownList).SelectedItem.Value		
        Dim dblAlc As Double = CType(e.Item.Cells(5).Controls(1), TextBox).Text
        Dim strComment As String = CType(e.Item.FindControl("txtComment"), FreeTextBox).Text
        Dim dblRating As Double = CType(e.Item.Cells(7).Controls(1), TextBox).Text
        Dim dtComDate As Date
		'--Updates with current date if date box is blank - otherwise error
		If CType(e.Item.FindControl("txtComDate"), TextBox).Text = "" Then
			dtComDate=Now.Date()
		Else
			dtComDate=CType(e.Item.FindControl("txtComDate"), TextBox).Text
		End If
        'Dim strMark As String = CType(e.Item.FindControl("txtBdbkmk"), TextBox).Text
        Dim blShow As Boolean = CType(e.Item.FindControl("chkShowEd"), CheckBox).Checked
        Dim blCurrent As Boolean = CType(e.Item.FindControl("chkCurrentEd"), CheckBox).Checked
        
		'Construct the SQL statement using Parameters
        Dim strSQL As String = "UPDATE [tblBrand] SET " & _
     "[Brand] = @Brand, " & _
          "[Style] = @Style, " & _
     "[Alc] = @Alc, " & _
     "[Comment] = @Comment, " & _
     "[Rating] = @Rating, " & _
     "[ComDate] = @ComDate, " & _
     "[BdShowHome]= @Show, " & _
     "[BdCurrent]= @Current " & _
     "WHERE [BdNumber] =" & e.Item.Cells(2).Text

        ' "[Bdbkmark] = @Mark, " & _
        '------- Making the connection ------
        strConnection = "Provider=Microsoft.Jet.OLEDB.4.0;"
		strConnection += "Data Source = "& Server.MapPath("../_private/breweries.mdb")
		objConnection = New OLEDBConnection(strConnection)
		objConnection.Open()
       '--------Connection made and open---------
		
		Dim myCommand as OleDbCommand = new OleDbCommand(strSQL, objConnection)
    	myCommand.CommandType = CommandType.Text

	    ' Add Parameters to the SQL query
    	Dim parameterBrand as OleDbParameter = new OleDbParameter("@Brand", OleDbType.VarWChar, 50)	
		parameterBrand.Value=strBrand
		myCommand.Parameters.Add(parameterBrand)
		
		Dim parameterStyle as OleDbParameter = new OleDbParameter("@Style", OleDbType.VarWChar, 50)	
		parameterStyle.Value=strStyle
		myCommand.Parameters.Add(parameterStyle)

		Dim parameterAlc as OleDbParameter = new OleDbParameter("@Alc", OleDbType.Double)	
		parameterAlc.Value=dblAlc
		myCommand.Parameters.Add(parameterAlc)

		Dim parameterCom as OleDbParameter = new OleDbParameter("@Comment", OleDbType.VarWChar,800)	
		parameterCom.Value=strComment
		myCommand.Parameters.Add(parameterCom)

        Dim parameterRat As OleDbParameter = New OleDbParameter("@Rating", OleDbType.Double)
        parameterRat.Value = dblRating
        myCommand.Parameters.Add(parameterRat)
        
		Dim parameterComDate as OleDbParameter = new OleDbParameter("@ComDate", OleDbType.Date)	
		parameterComDate.Value=dtComDate
		myCommand.Parameters.Add(parameterComDate)

        'Dim parameterMark as OleDbParameter = new OleDbParameter("@Mark", OleDbType.VarWChar,100)	
        'parameterMark.Value=strMark
        'myCommand.Parameters.Add(parameterMark)
        
        Dim parameterShow As OleDbParameter = New OleDbParameter("@Show", OleDbType.Boolean)
        parameterShow.Value = blShow
        myCommand.Parameters.Add(parameterShow)

        Dim parameterCurrent As OleDbParameter = New OleDbParameter("@Current", OleDbType.Boolean)
        parameterCurrent.Value = blCurrent
        myCommand.Parameters.Add(parameterCurrent)

		myCommand.ExecuteNonQuery()   'Execute the UPDATE query  
		objConnection.Close()

		'Finally, set the EditItemIndex to -1 and rebind the DataGrid
    	dgBrand.EditItemIndex = -1
    	BindData()    
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
    <div style="margin-bottom: 6px"> <a href="../default.aspx">Home</a>&nbsp;<a href="../brewery.aspx">Breweries</a>&nbsp;<a href="../brands.aspx">Beers</a> 
    </div>
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
  <h2>Edit Brand Information</h2> 
  
  <p><asp:Label id="MessageLabel" runat="server" ForeColor="Red"></asp:Label></p>         
   <asp:HyperLink ID="lnkBreweryEdit" runat="server">Back to Brewery Editing</asp:HyperLink>
   <asp:datalist id="dlBrewery"  CssClass="dlmain" Runat="server">
    <ItemTemplate>
		<h1 style="margin-bottom: 5px">
                <%# DataBinder.Eval(Container.DataItem, "BName") %></h1>
	</ItemTemplate>
   </asp:datalist>
   
   <asp:datagrid id="dgBrand" runat="server"
   		Autogeneratecolumns="False"
		OnEditCommand="dgBrand_Edit"
		OnCancelCommand="dgBrand_Cancel"
		OnDeleteCommand="dgBrand_Delete"
		OnUpdateCommand="dgBrand_Update"
		DataKeyField="BdNumber" CellPadding="4" ForeColor="#333333" GridLines="None"
   >
   <headerstyle ForeColor="White" BackColor="#990000" Font-Bold="True" />
	<columns>
		<asp:EditCommandColumn EditText="Edit" 
          ButtonType="PushButton"
          UpdateText="Update" CancelText="Cancel" >
                    <ItemStyle VerticalAlign="Top" Width="40px" />
                </asp:EditCommandColumn>
		<asp:ButtonColumn ButtonType="PushButton" Text="Del" CommandName="Delete" >
    <ItemStyle VerticalAlign="Top" />
</asp:ButtonColumn>
		<asp:BoundColumn DataField="BdNumber" HeaderText="#" ReadOnly="True" >
    <ItemStyle VerticalAlign="Top" />
</asp:BoundColumn>
		<asp:TemplateColumn HeaderText="Brand Name">
			<ItemTemplate >
				<%# DataBinder.Eval(Container.DataItem, "Brand") %>
			</ItemTemplate>
			<EditItemTemplate>
          		<asp:TextBox id="txtBrand" runat="server" Width="150px"
             		Text='<%# DataBinder.Eval(Container.DataItem, "Brand") %>' />
       		</EditItemTemplate>
    <ItemStyle VerticalAlign="Top" Width="150px" />
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Style">
			<ItemTemplate >
				<%# DataBinder.Eval(Container.DataItem, "Style") %>
			</ItemTemplate>
			<EditItemTemplate>
				<asp:DropDownList id="lstStyle" runat="server" 
					DataTextField="Style" DataValueField="Style" DataSource="<%# GetStyles() %>" 
					SelectedIndex='<%# GetSelIndS(Container.DataItem("Style")) %>'></asp:DropDownList>
       		</EditItemTemplate>
    <ItemStyle VerticalAlign="Top" Width="70px" />
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Alc" >
			<ItemTemplate >
				<%# DataBinder.Eval(Container.DataItem, "Alc") %>
			</ItemTemplate>
			<EditItemTemplate>
          		<asp:TextBox id="txtAlc" runat="server" Width="30px"
             		Text='<%# DataBinder.Eval(Container.DataItem, "Alc") %>' />
       		</EditItemTemplate>
    <ItemStyle VerticalAlign="Top" Width="30px" />
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Comment"  >
			<ItemTemplate >
				<%# DataBinder.Eval(Container.DataItem, "Comment") %>
			</ItemTemplate>
			<EditItemTemplate>
             	<FTB:FreeTextBox ID="txtComment" 
		ToolbarLayout="fontfacesmenu,fontsizesmenu,bold,italic,strikethrough|bulletedlist,numberedlist;Cut, Copy, Paste, Delete;CreateLink,UnLink"
		SupportFolder="~/FtbWebResource.axd" Text='<%# DataBinder.Eval(Container.DataItem, "Comment") %>' runat="Server" ToolbarStyleConfiguration="NotSet" Height="50px" DownLevelCols="50" Width="500px" />
       		</EditItemTemplate>
    <ItemStyle VerticalAlign="Top" Width="500px" />
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Rating" >
			<ItemTemplate >
				<%#DataBinder.Eval(Container.DataItem, "Rating")%>
			</ItemTemplate>
			<EditItemTemplate>
          		<asp:TextBox id="txtRating" runat="server" Width="30px"
             		Text='<%# DataBinder.Eval(Container.DataItem, "Rating") %>' />
       		</EditItemTemplate>
            <ItemStyle VerticalAlign="Top" Width="30px" />
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Date" >
			<ItemTemplate >
				<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %>
			</ItemTemplate>
			<EditItemTemplate>
          		<asp:TextBox id="txtComDate" runat="server" Width="70px"
             		Text='<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %>' />
       		</EditItemTemplate>
            <ItemStyle VerticalAlign="Top" Width="70px" />
		</asp:TemplateColumn>
		<%--<asp:TemplateColumn HeaderText="BookMark" >
			<ItemTemplate >
				<%# DataBinder.Eval(Container.DataItem, "Bdbkmark") %>
			</ItemTemplate>
			<EditItemTemplate>
          		<asp:TextBox id="txtBdbkmk" runat="server" Width="50px"
             		Text='<%# DataBinder.Eval(Container.DataItem, "Bdbkmark") %>' />
       		</EditItemTemplate>
            <ItemStyle VerticalAlign="Top" Width="50px" />
		</asp:TemplateColumn>--%>
        <asp:TemplateColumn HeaderText="Show*">
            <ItemTemplate >
                <asp:CheckBox ID="CheckBox2" Checked='<%#DataBinder.Eval(Container.DataItem, "BdShowHome")%>' Enabled=false runat="server" />
			</ItemTemplate>
			<EditItemTemplate>
                <asp:CheckBox ID="chkShowEd" Checked='<%#DataBinder.Eval(Container.DataItem, "BdShowHome")%>' runat="server" />
       		</EditItemTemplate>
        </asp:TemplateColumn>
                        
        <asp:TemplateColumn HeaderText="Current**">
             <ItemTemplate >
                <asp:CheckBox ID="CheckBox3" Checked='<%#DataBinder.Eval(Container.DataItem, "BdCurrent")%>' Enabled=false runat="server" />
			</ItemTemplate>
			<EditItemTemplate>
                <asp:CheckBox ID="chkCurrentEd" Checked='<%#DataBinder.Eval(Container.DataItem, "BdCurrent")%>' runat="server" />
       		</EditItemTemplate>
        </asp:TemplateColumn>
	</columns>
                    <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                    <SelectedItemStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                    <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                    <AlternatingItemStyle BackColor="White" />
                    <ItemStyle BackColor="#FFFBD6" ForeColor="#333333" />
	</asp:datagrid>
	* "Show" checked means this item will show on the home page in the Update section if it is within the date range.<br />
	** "Current" checked means this is a current beer offering, unchecked indicates
                past brand (may be listed separately)&nbsp;</form>                      
 </div>
     <UserControl:Footadmin id="UserControl1" runat="server" />

</body>
</html>
