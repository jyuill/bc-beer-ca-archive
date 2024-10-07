<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>


<%@ IMPORT Namespace="System.Data" %>
<%@ IMPORT Namespace="System.Data.OLEDB" %>

<SCRIPT LANGUAGE="VB" RUNAT="server">
Sub Page_Load()

	If Not Page.IsPostBack Then

		'------- Making the connection ------
		Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
		
		'This works on my Server 
		strConnection += "Data Source = "& Server.MapPath("_private/breweries.mdb")
		
		Dim objConnection as New OLEDBConnection(strConnection)

		'--------Connection made ---------
		
		Dim strSQL as string = "SELECT * FROM tblBrewery WHERE Number=" + Request.Params("Number")		
		Dim objAdapter as New OledbDataAdapter(strSQL, objConnection)
		Dim objDataSet as New DataSet()
		ObjAdapter.Fill(objDataSet, "tblBrewery")

		dlMaster.DataSource=objDataSet.Tables("tblBrewery")
		dlMaster.DataBind()	
        End If
End Sub

'This function gets the brewery comments associated with a given brewery
Function GetBreweryComment (ByVal x as String)
	Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
		
	strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
	Dim dsBrewComment as New DataSet()
	Dim objConn as New OLEDBConnection(strConn)
	Dim strSQL3 as String

        strSQL3 = "SELECT tblBrewery.Number, tblBrewery.BName, tblBreweryComment.UComment, tblBreweryComment.URating, tblBreweryComment.DateIn, tblBreweryComment.Author, tblBreweryComment.Email, tblBreweryComment.Loc "
	strSQL3 &= "FROM tblBrewery, tblBreweryComment WHERE tblBrewery.Number = tblBreweryComment.BName AND tblBrewery.Number = " & x & " ORDER BY tblBreweryComment.DateIn DESC"

	Dim daBrewComment as New OLEDBDataAdapter(strSQL3, objConn)
	daBrewComment.Fill(dsBrewComment, "tblBrewComment")

	dsBrewComment.Tables(0).Columns.Add(New DataColumn("AuthName", GetType(String)))
	dsBrewComment.Tables(0).Columns.Add(New DataColumn("AuthEmail", GetType(String)))
	dsBrewComment.Tables(0).Columns.Add(New DataColumn("AuthLoc", GetType(String)))

 	    Dim zRow as DataRow
            For each zRow in dsBrewComment.Tables(0).Rows
                'If author's name is blank, name withheld displayed
                'Dealing with the dreaded DBNull that occurs when a field is empty
                If IsDBNull(zRow.Item("Author")) Then
		   zRow.Item("AuthName") = "Name withheld"
                Else
                     zRow.Item("AuthName") = zRow.Item("Author")
                End If
		If zRow.Item("Author") = "" Then
                    zRow.Item("AuthName") = "Name withheld"
                Else
                     zRow.Item("AuthName") = zRow.Item("Author")
                End If
		'If Email is blank, display nothing
		If IsDBNull(zRow.Item("Email")) Then
		    zRow.Item("AuthEmail") = ""
                Else
		    If ZRow.Item("Email") = "" Then
                      zRow.Item("AuthEmail") = ""
                    Else
                      zRow.Item("AuthEmail") = " (" & zRow.Item("Email") & ")"
                    End If
                End If
		If IsDBNull(zRow.Item("Loc")) Then
		     zRow.Item("AuthLoc") = ""
                Else
                    If ZRow.Item("Loc") = "" Then
                      zRow.Item("AuthLoc") = ""
 		    Else
		      zRow.Item("AuthLoc") = " " & zRow.Item("Loc")
		    End If
                End If
            Next

	Return dsBrewComment.Tables("tblBrewComment")

End Function

'This function gets the brand names associated with a given brewery
Function GetBrand (ByVal x as String)
	Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
	strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
	
	Dim dsBrand as New DataSet()
	Dim objConn as New OLEDBConnection(strConn)
	Dim strSQL3 as String

	strSQL3 = "SELECT tblBrewery.Number, tblBrewery.BName, tblBrand.Brand, tblBrand.BdNumber, tblBrand.Style, tblBrand.Alc "
        strSQL3 &= "FROM tblBrewery, tblBrand WHERE tblBrewery.Number = tblBrand.BName AND tblBrewery.Number = " & x & " ORDER BY tblBrand.Brand"

	Dim daBrand as New OLEDBDataAdapter(strSQL3, objConn)
	daBrand.Fill(dsBrand, "tblBrand")

	'New columns added for managing style and alcohol data
	dsBrand.Tables(0).Columns.Add(New DataColumn("Styles", GetType(String)))	
	dsBrand.Tables(0).Columns.Add(New DataColumn("Alco", GetType(String)))

	Dim zRow as DataRow
	For each zRow in dsBrand.Tables(0).Rows
		'If style is blank, style unknown displayed
		'Dealing with the dreaded DBNull that occurs when a field is empty
		If IsDBNull(zRow.Item("Style")) Then
			zRow.Item("Styles") = "style unknown"
		Else
		 	zRow.Item("Styles") = zRow.Item("Style")
		End If
		'If alcohol % is unknown, then % unknown displayed
		If zRow.Item("Alc") > 0 Then
			zRow.Item("Alc") = zRow.Item("Alc") * 100
			zRow.Item("Alco") = Convert.ToString(zRow.Item("Alc")) + "%"
		Else 
		   zRow.Item("Alco") = "% unknown"
		End If
	Next
	Return dsBrand.Tables("tblBrand")

End Function

    Function AddStars(ByVal input)
        Dim strRating As String
        strRating = ""
        If (input) Is DBNull.Value Then
           
        Else
            Select Case (input)
                Case Is < 1
                    strRating = " "
                Case Is < 1.3
                    strRating = "<img alt='1 star - poor' src='images/star1.jpg' />"
                Case Is < 1.8
                    strRating = "<img alt='1.5 stars' src='images/star1half.jpg' />"
                Case Is < 2.3
                    strRating = "<img alt='2 stars - okay' src='images/star2.jpg' />"
                Case Is < 2.8
                    strRating = "<img alt='2.5 stars' src='images/star2half.jpg' />"
                Case Is < 3.3
                    strRating = "<img alt='3 stars - average' src='images/star3.jpg' />"
                Case Is < 3.8
                    strRating = "<img alt='3.5 stars' src='images/star3half.jpg' />"
                Case Is < 4.3
                    strRating = "<img alt='4 stars - above average' src='images/star4.jpg' />"
                Case Is < 4.8
                    strRating = "<img alt='4.5 stars' src='images/star4half.jpg' />"
                Case Is < 5.1
                    strRating = "<img alt='5 stars - superb!' src='images/star5.jpg' />"
            End Select
            
        End If
        Return strRating
    End Function

    '---Calculates average rating of brewery by site visitors
    Function CalcAveRating(ByVal y As String)
        Dim strConn As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
        strConn += "Data Source = " & Server.MapPath("_private/breweries.mdb")
        Dim dsRating As New DataSet()
        Dim objConn As New OleDbConnection(strConn)
        Dim strSQL3 As String
    
        strSQL3 = "SELECT tblBreweryComment.BName, tblBreweryComment.URating "
        strSQL3 &= "FROM tblBreweryComment WHERE tblBreweryComment.BName =" & y
    
        Dim daRating As New OleDbDataAdapter(strSQL3, objConn)
        daRating.Fill(dsRating, "tblRating")
        'Return dsBrandCom.Tables("tblBrandCom")
    
        'Get total of user ratings
        Dim intTtlRating As Integer 'total of ratings
        Dim intRaters As Integer 'total number of ratings
        Dim dblAveRating As Double 'average rating
        intTtlRating = 0
        intRaters = 0
    
        Dim bcRow As DataRow
        For Each bcRow In dsRating.Tables(0).Rows
            If bcRow.Item("URating") Is DBNull.Value Then
                intRaters = intRaters
            Else
                If bcRow.Item("URating") > 0 Then
                    intRaters = intRaters + 1
                    intTtlRating = intTtlRating + bcRow.Item("URating")
                End If
            End If
        Next
        
        'Calculate average rating
        dblAveRating = intTtlRating / intRaters
        
        'To return average number
        'Return dblAveRating
        Dim imgStars As String
        imgStars = AddStars(dblAveRating)
        Return imgStars
    End Function
    
</SCRIPT>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>B.C. Beer Guide - Brewery Comments </title>
<meta name="keywords"
content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, 
breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,
 Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, 
Bowen Island, Columbia Brewing, Kokanee" />
<meta name="Description"
content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
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
    <!--<h1>B.C. Craft Breweries - Brewery Comments</h1>-->
    <asp:datalist id="dlMaster" Cssclass="dlmain" Runat="server" >
		<ItemTemplate>
            <h1> 
              <asp:HyperLink id="HyperLink1" Text='<%# DataBinder.Eval(Container.DataItem, "BName") %>' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
              - Brewery Comments </h1>
            <em> 
            <%# DataBinder.Eval(Container.DataItem, "City") %>
            </em> 
			 <p><%# AddStars(DataBinder.Eval(Container.DataItem, "Rating")) %></p>
            <div class="comment"> 
              <%# DataBinder.Eval(Container.DataItem, "Comment") %></div>
            <p> 
              <asp:Datalist id="dlBrand"
				Runat="server"
				RepeatDirection="Horizontal"
				RepeatLayout="Flow"
				DataSource='<%# GetBrand(container.dataitem("Number")) %>' >
				<ItemTemplate>
                    <asp:HyperLink ID="HyperLink6" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Brand") %>' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) + "#" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BdNumber")) %>' ></asp:HyperLink>
				  (<%# DataBinder.Eval(Container.DataItem, "Styles") %>,
				   <%# DataBinder.Eval(Container.DataItem, "Alco") %>) 	
				</ItemTemplate>
			  </asp:Datalist>
           
            <h2>Visitor Comments</h2>
	        <span> 
            <asp:HyperLink id="HyperLink2" Text='Add your own comments/rate this brewery!' NavigateUrl='<%# "brewerycomment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
            &nbsp; 
            <asp:HyperLink id="HyperLink3" Text='Back to full brewery info' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
            </span>     
            <p><em>Average rating: </em><%# CalcAveRating(DataBinder.Eval(Container.DataItem, "Number"))%><hr />
                </p>
            <asp:Datalist id="dlBreweryComment"
				Runat="server"
				DataSource='<%# GetBreweryComment(container.dataitem("Number")) %>' >
				<ItemTemplate>
				 <%# AddStars(DataBinder.Eval(Container.DataItem, "URating")) %>
                <div class="comment" ><%# DataBinder.Eval(Container.DataItem, "UComment") %><br />
				</div>
				&nbsp;-&nbsp;<strong><%# DataBinder.Eval(Container.DataItem, "AuthName") %></strong>&nbsp;
			    <%# DataBinder.Eval(Container.DataItem, "AuthLoc") %>
		         <%-- <%# DataBinder.Eval(Container.DataItem, "AuthEmail") %> --%>
		          <em><%# DataBinder.Eval(Container.DataItem, "DateIn", "{0:dd/MM/yyyy}") %></em>
				  <hr />
				</ItemTemplate>
			</asp:Datalist>
			            <span> 
            <asp:HyperLink id="HyperLink4" Text='Add your own comments!' NavigateUrl='<%# "brewerycomment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
            &nbsp; 
            <asp:HyperLink id="HyperLink5" Text='Back to full brewery info' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
            </span> 

           </ItemTemplate>
</asp:datalist> </div>
<UserControl:Foot id="UserControl4f" runat="server" /> 
</div>
</form>
</body>
</html>
