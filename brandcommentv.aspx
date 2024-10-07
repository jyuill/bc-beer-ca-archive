<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>


<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Sub Page_Load()
    
            If Not Page.IsPostBack Then
    
                '------- Making the connection ------
                Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
                'This works on my Server
                strConnection += "Data Source = "& Server.MapPath("_private/breweries.mdb")
    
                Dim objConnection as New OLEDBConnection(strConnection)
    
                '--------Connection made ---------
                '---Gets the brewery
                Dim strSQL as string = "SELECT * FROM tblBrewery WHERE Number=" + Request.Params("Number")
                Dim objAdapter as New OledbDataAdapter(strSQL, objConnection)
                Dim objDataSet as New DataSet()
                ObjAdapter.Fill(objDataSet, "tblBrewery")
    
                dlMaster.DataSource=objDataSet.Tables("tblBrewery")
                dlMaster.DataBind()
    
                '---Set up data set with featured brand
                Dim strSQLBrand as string = "SELECT * FROM tblBrand WHERE BdNumber=" + Request.Params("BdNumber")
                Dim objAdapterBrand as New OledbDataAdapter(strSQLBrand, objConnection)
                Dim objDataSetBrand as New DataSet()
                ObjAdapterBrand.Fill(objDataSetBrand, "tblBrand")
    
    'Add a new column to count number of user comments for each brewery
                     objDataSetBrand.Tables(0).Columns.Add(New DataColumn("Alco", GetType(String)))
                objDataSetBrand.Tables(0).Columns.Add(New DataColumn("Styles", GetType(String)))
                    objDataSetBrand.Tables(0).Columns.Add(New DataColumn("Review", GetType(String)))
    
              Dim zRow as DataRow
                 For each zRow in objDataSetBrand.Tables(0).Rows
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
                         zRow.Item("Review") = "No review available"
                     Else
                          zRow.Item("Review") = zRow.Item("Comment")
                     End If
    
                 Next
    
                dlBrand2.DataSource=objDataSetBrand.Tables("tblBrand")
                dlBrand2.DataBind()
    
            End If
    
    End Sub
       
    'This function used to get existing brand comments for display
    Function GetBrandComment (ByVal y as String)
            Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
            strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
            Dim dsBrandCom as New DataSet()
            Dim objConn as New OLEDBConnection(strConn)
            Dim strSQL3 as String
    
        strSQL3 = "SELECT tblBrand.BdNumber, tblBrandComment.Brand, tblBrandComment.UComment, tblBrandComment.URating, tblBrandComment.DateCom, tblBrandComment.Author, tblBrandComment.Email, tblBrandComment.Loc "
            strSQL3 &= "FROM tblBrand, tblBrandComment WHERE tblBrand.BdNumber = tblBrandComment.Brand AND tblBrand.BdNumber = " & y & " ORDER BY tblBrandComment.DateCom DESC"
    
            Dim daBrandCom as New OLEDBDataAdapter(strSQL3, objConn)
            daBrandCom.Fill(dsBrandCom, "tblBrandCom")
    
            dsBrandCom.Tables(0).Columns.Add(New DataColumn("AuthName", GetType(String)))
            dsBrandCom.Tables(0).Columns.Add(New DataColumn("AuthEmail", GetType(String)))
            dsBrandCom.Tables(0).Columns.Add(New DataColumn("AuthLoc", GetType(String)))
    
              Dim zRow as DataRow
                 For each zRow in dsBrandCom.Tables(0).Rows
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
    
            Return dsBrandCom.Tables("tblBrandCom")
    
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

    Function CalcAveRatingBd(ByVal y As String)
        Dim strConn As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
        strConn += "Data Source = " & Server.MapPath("_private/breweries.mdb")
        Dim dsRating As New DataSet()
        Dim objConn As New OleDbConnection(strConn)
        Dim strSQL3 As String
    
        strSQL3 = "SELECT tblBrandComment.Brand, tblBrandComment.URating "
        strSQL3 &= "FROM tblBrandComment WHERE tblBrandComment.Brand =" & y
    
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
    
</script>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>B.C. Beer Guide - View/Add Brand Comments</title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, &#13;&#10;breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,&#13;&#10; Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, &#13;&#10;Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" name="Description" />
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
  <div class="mainbox mainboxL" > 
    <!--<h1 align="center">B.C. Craft Breweries - View/Add Beer Comments </h1>-->
    
    <asp:datalist id="dlMaster" CssClass="dlmain" Runat="server">
        <ItemTemplate>
            <h1> 
              <asp:HyperLink id="HyperLink1" Text='<%# DataBinder.Eval(Container.DataItem, "BName") %>' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
  			 <%#AddStars(DataBinder.Eval(Container.DataItem, "Rating"))%>
              - Brand Comments </h1>
            <em>
            <%# DataBinder.Eval(Container.DataItem, "City") %>
            </em> </ItemTemplate>
    </asp:datalist> 
    <asp:datalist id="dlBrand2" CssClass="dlmain" Runat="server">
        <ItemTemplate>
            <strong>
            <%# DataBinder.Eval(Container.DataItem, "Brand") %>
            </strong>
            (<%# DataBinder.Eval(Container.DataItem, "Styles") %>,&nbsp 
            <%# DataBinder.Eval(Container.DataItem, "Alco") %>) 
			 <%#AddStars(DataBinder.Eval(Container.DataItem, "Rating"))%>
            - 
            <%# DataBinder.Eval(Container.DataItem, "Review") %>
            &nbsp 
            <span class="softdate"><%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:d}") %></span>
            <h2>Visitor Comments: &nbsp;</h2> <span> 
            <asp:HyperLink id="HyperLink2" Text='Add your own comments/rate this beer!' NavigateUrl='<%# "brandcomment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BName")) + "&BdNumber=" +  HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BdNumber"))%>' runat="server" />
            &nbsp; 
            <asp:HyperLink id="HyperLink3" Text='Back to full brewery info' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BName")) %>' runat="server" />
            </span> 
            <p><em>Average rating: </em><%# CalcAveRatingBd(DataBinder.Eval(Container.DataItem, "BdNumber"))%><hr />
                </p> 
            <asp:Datalist id="dlBrandComment" Runat="server" DataSource='<%# GetBrandComment(container.dataitem("BdNumber")) %>' >
				        <ItemTemplate>
                                    <%# AddStars(DataBinder.Eval(Container.DataItem, "URating")) %> 
                <div class="comment norm"><%# DataBinder.Eval(Container.DataItem, "UComment") %>
                </div>
                &nbsp;-&nbsp;<strong><%# DataBinder.Eval(Container.DataItem, "AuthName") %></strong>&nbsp;
			    <%# DataBinder.Eval(Container.DataItem, "AuthLoc") %>
		          <%# DataBinder.Eval(Container.DataItem, "AuthEmail") %>
		                          <em><%# DataBinder.Eval(Container.DataItem, "DateCom", "{0:dd/MM/yyyy}") %></em>
				
				  <hr />
                         </ItemTemplate>
                  </asp:Datalist>
                  <span> 
            <asp:HyperLink id="HyperLink4" Text='Add your own comments!' NavigateUrl='<%# "brandcomment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BName")) + "&BdNumber=" +  HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BdNumber"))%>' runat="server" />
            &nbsp; 
            <asp:HyperLink id="HyperLink5" Text='Back to full brewery info' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BName")) %>' runat="server" />
            </span> 
            </ItemTemplate>
     </asp:datalist> </div>
	 <UserControl:Foot id="UserControl4f" runat="server" /> 
</div></form>
</body>
</html>
