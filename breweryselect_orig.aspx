<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="CSSselect" Src="css_select.ascx" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Dim Sortfield as String
	Dim numprev as String
    Dim numnext as String
	
            Sub Page_Load()
                '------- Making the connection ------
                Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
                'This works on my Server
                strConnection += "Data Source = "& Server.MapPath("_private/breweries.mdb")
    
                Dim objConnection as New OLEDBConnection(strConnection)
    
                '--------Connection made ---------
    
           '1---Information retrieved from tblBrewery in Brewery database
                Dim strSQL as string = "SELECT * FROM tblBrewery WHERE Number=" + Request.Params("Number")
                
				Dim objAdapter as New OledbDataAdapter(strSQL, objConnection)
                Dim objDataSet as New DataSet()
				objConnection.Open()
                ObjAdapter.Fill(objDataSet, "tblBrewery")
				
				'Grabbing brewery name info to use with GetPrev and GetNext for prev/next record links
				Dim bn as String
				bn = objDataSet.Tables(0).Rows(0).Item("BName")
				GetPrev(bn)
				GetNext(bn)
				'If numprev is blank value there are no previous breweries so link is disabled
				'If numprev is DBNull.Value Then
				If numprev="" Then
					lnkPrevb.href=""
					lnkPrevbT.href=""
					'Could be used to hide Prev link when not available - I prefer to show it disabled
					'lblPrev.Visible=False
				Else
					lnkPrevb.href="breweryselect.aspx?Number=" + numprev
					lnkPrevbT.href="breweryselect.aspx?Number=" + numprev
				End If
				'If numnext is blank link is disabled
				If numnext="" Then
					lnkNextb.href=""
					lnkNextbT.href=""
				Else
					lnkNextb.href="breweryselect.aspx?Number=" + numnext
					lnkNextbT.href="breweryselect.aspx?Number=" + numnext
				End If
				
				'Creates link to editing page
    			lnkEdit.href="admin/breweryedit.aspx?Number=" + Request.Params("Number")
				
           '2---Add a new column to count number of user comments for each brewery
    			objDataSet.Tables(0).Columns.Add(New DataColumn("Comms", GetType(String)))
					'Can setup extra columns to store previous and next record numbers for links
				'objDataSet.Tables(0).Columns.Add(New DataColumn("Prevb", GetType(String)))
				'objDataSet.Tables(0).Columns.Add(New DataColumn("Nextb", GetType(String)))
				
           '3---Uses GetBreweryComment function to count number of user comments for use with link to comments
                'Can use GetPrev and GetNext to get brewery numbers for previous and next records for links
					'GetPrev and GetNext not used here as links are placed outstide datalist on page
				'Loop even though only 1 row
				Dim zRow as DataRow
                Dim x as Integer
				Dim n as String
                For each zRow in objDataSet.Tables(0).Rows
                    X = zRow.Item("Number")
                    zRow.Item("Comms") = GetBreweryComment(x)
						'Sets up columns with previous and next record numbers
					'n = zRow.Item("BName")
					'zRow.Item("Prevb") = GetPrev(n)
					'zRow.Item("Nextb") = GetNext(n)
					  	'Use href below to create prev/next links or use data in table for asp.net hyperlinks 
					'Prevb.href="breweryselect.aspx?Number=" + numprev
					'Nextb.href="breweryselect.aspx?Number=" + numnext
                Next
    
           '4---Datalist for main brewery information
                dlMaster.DataSource=objDataSet.Tables("tblBrewery")
                dlMaster.DataBind()
    			objConnection.Close()
            End Sub
			
    'Gets number for previous brewery in list to display in link
    Function GetPrev(ByVal n as String)
            Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
            strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
            Dim dsBrewery as New DataSet()
            Dim objConn as New OLEDBConnection(strConn)
            Dim strSQL2 as String
            strSQL2 = "SELECT * from tblBrewery ORDER BY BName"
            Dim daBrewery as New OLEDBDataAdapter(strSQL2, objConn)
            daBrewery.Fill(dsBrewery, "tblBreweries")
			
			Dim zRow as DataRow
			Dim nam as String
                For each zRow in dsBrewery.Tables(0).Rows
					If zRow.Item("BName") < n Then
						numprev=zRow.Item("Number")
					End If
                Next
            Return numprev		
    End Function
	
	'Gets number for next brewery in list to display in link
    Function GetNext(ByVal n as String)
            Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
            strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
            Dim dsBrewery as New DataSet()
            Dim objConn as New OLEDBConnection(strConn)
            Dim strSQL2 as String
            strSQL2 = "SELECT * from tblBrewery ORDER BY BName"
            Dim daBrewery as New OLEDBDataAdapter(strSQL2, objConn)
            daBrewery.Fill(dsBrewery, "tblBreweries")
			
			Dim zRow as DataRow
                For each zRow in dsBrewery.Tables(0).Rows
					If zRow.Item("BName") > n Then
						numnext = zRow.Item("Number")
						Exit For
					End If
                Next
            Return numnext
    End Function
    
    'This function gets the brewery comments associated with a given brewery - used only for counting number of comments to show by link
    Function GetBreweryComment (ByVal x as String)
            Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
            strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
            Dim dsBrewComment as New DataSet()
            Dim objConn as New OLEDBConnection(strConn)
            Dim strSQL3 as String
    
            strSQL3 = "SELECT tblBrewery.Number, tblBrewery.BName, tblBreweryComment.UComment "
            strSQL3 &= "FROM tblBrewery, tblBreweryComment WHERE tblBrewery.Number = tblBreweryComment.BName AND tblBrewery.Number = " & x
    
            Dim daBrewComment as New OLEDBDataAdapter(strSQL3, objConn)
            daBrewComment.Fill(dsBrewComment, "tblBrewComment")
    
            Dim NoComms as Integer
            NoComms = 0
            'Return NoComms = dsBrewComment.Tables(0).Rows.Count
            'Return dsBrewComment.Tables("tblBrewComment")
    
            'Do while dsBrewComment.Tables(0).Rows.Count = False
            '  NoComms = NoComms + 1
            'Loop
    
            Dim cRow as DataRow
            For each cRow in dsBrewComment.Tables(0).Rows
              NoComms = NoComms + 1
            Next
    
            Return NoComms
    
    End Function
    
    '---This function gets the brands and related information (style, alc, comment, date) associated with a given brewery,
    '---where x is the brewery number that is passed in by virtue of the fact
    '---that the GetBrand function is called from within the dlMaster datagrid, and so uses the number field from the brewery table (I think)
    Function GetBrand (ByVal x as String)
            Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
            strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
            Dim dsBrand as New DataSet()
            Dim objConn as New OLEDBConnection(strConn)
            Dim strSQL3 as String
    
            strSQL3 = "SELECT tblBrewery.Number, tblBrewery.BName, tblBrand.Brand, tblBrand.BdNumber, tblBrand.Style, tblBrand.Alc, tblBrand.Comment, tblBrand.ComDate "
            strSQL3 &= "FROM tblBrewery, tblBrand WHERE tblBrewery.Number = tblBrand.BName AND tblBrewery.Number = " & x & " ORDER BY tblBrand.Brand"
    
            Dim daBrand as New OLEDBDataAdapter(strSQL3, objConn)
            daBrand.Fill(dsBrand, "tblBrand")
    
            'New columns added for managing style, alcohol, comment, bookmark
            dsBrand.Tables(0).Columns.Add(New DataColumn("Styles", GetType(String)))
            dsBrand.Tables(0).Columns.Add(New DataColumn("Alco", GetType(String)))
           dsBrand.Tables(0).Columns.Add(New DataColumn("Review", GetType(String)))
           'New column to hold count of number of user comments for display
           dsBrand.Tables(0).Columns.Add(New DataColumn("NumberComments", GetType(String)))
           dsBrand.Tables(0).Columns.Add(New DataColumn("Bookmark", GetType(String)))
    
            Dim zRow as DataRow
           Dim c as Integer
            For each zRow in dsBrand.Tables(0).Rows
                'If style is blank, style unknown displayed
                'Dealing with the dreaded DBNull that occurs when a field is empty
                If IsDBNull(zRow.Item("Style")) Then
                    zRow.Item("Styles") = "style unknown"
                Else
                     zRow.Item("Styles") = zRow.Item("Style")
                End If
                'If alcohol % blank, then % unknown displayed
                If zRow.Item("Alc") > 0 Then
                    zRow.Item("Alc") = zRow.Item("Alc") * 100
                    zRow.Item("Alco") = Convert.ToString(zRow.Item("Alc")) + "%"
                Else
                   zRow.Item("Alco") = "% unknown"
                End If
               'If Comment is blank, display No review available
                If IsDBNull(zRow.Item("Comment")) Then
                    zRow.Item("Review") = "no review available"
                Else
                     zRow.Item("Review") = zRow.Item("Comment")
                End If
                'Put number of comments in each brand row
    
                c = zRow.Item("BdNumber")
                    zRow.Item("NumberComments") = GetBrandComment(c)
            
                zRow.Item("Bookmark") = zRow.Item("Brand")
            Next
    
            Return dsBrand.Tables("tblBrand")
    
    End Function
    
    '---This function gets the user comments associated with each brand - used only to count number of comments
    Function GetBrandComment (ByVal y as String)
            Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
            strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
            Dim dsBrandCom as New DataSet()
            Dim objConn as New OLEDBConnection(strConn)
            Dim strSQL3 as String
    
            strSQL3 = "SELECT tblBrand.BdNumber, tblBrandComment.Brand, tblBrandComment.UComment "
            strSQL3 &= "FROM tblBrand, tblBrandComment WHERE tblBrand.BdNumber = tblBrandComment.Brand AND tblBrand.BdNumber = " & y
    
            Dim daBrandCom as New OLEDBDataAdapter(strSQL3, objConn)
            daBrandCom.Fill(dsBrandCom, "tblBrandCom")
            'Return dsBrandCom.Tables("tblBrandCom")
    
           'Set up counter for number of user comments
            Dim NoBdComms as Integer
            NoBdComms = 0
    
            Dim bcRow as DataRow
            For each bcRow in dsBrandCom.Tables(0).Rows
              NoBdComms = NoBdComms + 1
            Next
    
            'Create variable to send number of comments
            Return NoBdComms
    
    End Function
    
	Function AddWeb(input)
		If (Input) Is DbNull.Value Then
			'Return Input
		Else
			If (Input)>" " Then
				'Return "<br /></em>Tel:&nbsp;<em>" & input
				Return "<br />" & input
			End If
		End If
	End Function
	
	Function AddPh(input)
		If (Input) Is DbNull.Value Then
			'Return Input
		Else
			If (Input)>" " Then
				'Return "<br /></em>Tel:&nbsp;<em>" & input
				Return "<br />" & input
			End If
		End If
	End Function
	
	Function AddEmail(input)
		If (Input) Is DbNull.Value Then
			'Return Input
		Else
			If (Input)>" " Then
				'Return "<br /></em>Email:<em>&nbsp;<a href='mailto:" & input & "'>" & input & "</a>"
				Return "<br /><a href='mailto:" & input & "'>" & input & "</a>"

			End If
		End If
	End Function
	
</script>

<head>
    <title>B.C. Beer Guide - Breweries</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body><form runat="server">
<!-- DIV for outer shell to set width of page -->
<div id="outer">
    <!-- Div for topsection including logo and slogan -->
    <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo>
	</div>
	<!--DIV surrounding navbar embedded in usercontrols -->
	<div class="navsection">
			<USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV>
	 		<div id="belowNavbar">
				<UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> 	
			</div>   
		</div>
         
  <div class="mainbox" >
  	<div style="position: relative; top: 0px; left: 25%; width: 45%; text-align: center; z-index: 10; font-size: 0.9em; margin-top: -3px">
	   		<a id="lnkPrevbT" style="text-decoration: none" runat="server">&laquo;&nbsp;Prev Brewery</a>&nbsp;&nbsp;|&nbsp;
	    	<a id="lnkNextbT" style="text-decoration: none" runat="server">Next Brewery&nbsp;&raquo;</a>
	</div>                  
   <asp:datalist id="dlMaster" Border="0" Class="dlmain" Runat="server">
    <ItemTemplate>
          <h1 class="bselect"><a name= '<#% Container.DataItem("Bmark") %>' runat="server">
            <%# DataBinder.Eval(Container.DataItem, "BName") %></a> </h1>
       						<span class="btype">&nbsp;-&nbsp;<%# DataBinder.Eval(Container.DataItem, "BType") %>
							</span>						
							<div class="blogo">
									<asp:Image Class="brewlogo" ID="Image1" ImageUrl='<%# "images\breweries\" + Container.DataItem("Logo") %>' AlternateText="brewery logo" runat="server" />
							</div>
								   <br /><em> <%# DataBinder.Eval(Container.DataItem, "Address") %><br /> 
                                    <%# DataBinder.Eval(Container.DataItem, "City") %>
									<asp:hyperlink id="HyperLinkWebsite" Text='<%# AddWeb(Container.DataItem("Website")) %>' NavigateURL= '<%# "http://" + Container.DataItem("Website") %>' runat="server" />
                                    <%# AddEmail(Container.DataItem("Email")) %>
									<%# AddPh(DataBinder.Eval(Container.DataItem, "Ph")) %></em>
									<p>
                                        <%# DataBinder.Eval(Container.DataItem, "Comment") %> <i>(<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:d}") %>)</i>&nbsp 
                                        <asp:HyperLink id="HyperLink2" Text='More Comments' NavigateURL='<%# "BreweryCommentv.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
                                        [<%# DataBinder.Eval(Container.DataItem, "Comms") %>] &nbsp; 
                                        <asp:HyperLink id="HyperLink1" Text='Add Your Own Comments on this Brewery' NavigateURL='<%# "BreweryComment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
                                    </p>
                                    <p>
                                        <asp:Datalist id="dlBrand" Runat="server" Font-size="10pt" Font-Name="Arial" DataSource=<%# GetBrand(container.dataitem("Number")) %> >
				                             <ItemTemplate>
                                                <strong><a name= '<%#DataBinder.Eval(Container.DataItem, "Bookmark") %>' runat="server"> <%# DataBinder.Eval(Container.DataItem, "Brand") %></a></strong> (<%# DataBinder.Eval(Container.DataItem, "Styles") %>, <%# DataBinder.Eval(Container.DataItem, "Alco")%>)
                                                - <%# DataBinder.Eval(Container.DataItem, "Review") %><i>&nbsp<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:d}") %></i>&nbsp 
                                                <asp:HyperLink id="HyperLink3" Text='More Comments' NavigateURL='<%# "BrandCommentv.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) + "&BdNumber=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BdNumber")) %>' runat="server" />
                                                [<%# DataBinder.Eval(Container.DataItem, "NumberComments") %>] &nbsp; 
                                                <asp:HyperLink id="HyperLink4" Text='Add Your Own Comments on this Beer' NavigateURL='<%# "BrandComment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) + "&BdNumber=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BdNumber")) %>' runat="server" />
                                                <p></p>
                                            </ItemTemplate>
                                        </asp:datalist>







                                   </p>		
     </ItemTemplate>
   </asp:datalist>
   <hr>
	<div style="position: relative; text-align: left">
		<div style="position: relative; text-align: left; width: 25%; z-index: 20">
       	<a href="default.aspx">Home</a>&nbsp;&nbsp;<a href="brewery.aspx">Full Brewery List</a>
		</div>
	   	<div style="position: absolute; top: 0px; left: 25%; width: 45%; text-align: center; z-index: 10">
	   		<asp:label id="lblPrev" runat="server"><a id="lnkPrevb" style="text-decoration: none" runat="server">&laquo;&nbsp;Prev Brewery</a>&nbsp;&nbsp;</asp:label>|&nbsp;
	    	<a id="lnkNextb" style="text-decoration: none" runat="server">Next Brewery&nbsp;&raquo;</a>
		</div>
   		<div style="position: absolute; top: 0px; left: 75%; width: 24%; text-align: right; z-index: 5">
			<a id="lnkEdit" style="text-decoration: none" runat="server">+</a>
		</div>
	</div>
 </div>
 <!-- End of Mainbox -->
 <UserControl:Foot id="UserControl4" runat="server" />
</div>
 <!-- End of Outer --></form>
</body>
</html>
