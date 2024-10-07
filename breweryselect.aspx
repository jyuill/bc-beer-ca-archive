<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252"  MaintainScrollPositionOnPostback="true" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="CSSselect" Src="css_select.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>


<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Dim Sortfield as String
	Dim numprev as String
    Dim numnext As String
    'Protected PageTitle As New HtmlGenericControl

	
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
        'Dim n as String
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
        
        '5--- Sets up data table for brands based on brewery number by
        '---- calling GetBrand function
        dlBrand.DataSource = GetBrand(Request.Params("Number"))
        dlBrand.DataBind()
        
        'Dim strSQLbc As String
        'strSQLbc = "SELECT tblBrewery.Number, tblBrewery.BName, tblBreweryComment.UComment "
        'strSQLbc &= "FROM tblBrewery, tblBreweryComment WHERE tblBrewery.Number = tblBreweryComment.BName AND tblBrewery.Number =" + Request.Params("Number")
        'Dim objAdapterBC As New OleDbDataAdapter(strSQLbc, objConnection)
        'Dim objDataSetBC As New DataSet()
        'objAdapterBC.Fill(objDataSetBC, "tblBrewComment")
        'dlBrewComment.DataSource = objDataSetBC.Tables("tblBrewComment")
        'dlBrewComment.DataBind()
        
        Me.PageTitle.InnerText = "BC Beer Guide: " & bn
        '6--- Close data connection
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
			
        Dim zRow As DataRow
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
    
    'This function gets the brewery comments associated with a given brewery - used only for counting number of comments to show beside link
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
    '---where x is the brewery number that is passed in by using the url parameter
    '---from within the Page_Load sub
    Function GetBrand (ByVal x as String)
            Dim strConn as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
            strConn += "Data Source = "& Server.MapPath("_private/breweries.mdb")
            Dim dsBrand as New DataSet()
            Dim objConn as New OLEDBConnection(strConn)
            Dim strSQL3 as String
    
        strSQL3 = "SELECT tblBrewery.Number, tblBrewery.BName, tblBrand.Brand, tblBrand.BdNumber, tblBrand.Style, tblBrand.Alc, tblBrand.Comment, tblBrand.Rating, tblBrand.ComDate, tblBrand.Bdbkmark "
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
            
            zRow.Item("Bookmark") = zRow.Item("BdNumber")
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
    
    Function AddWeb(ByVal input)
        Dim strWeb As String
        strWeb = ""
        If (input) Is DBNull.Value Then
            strWeb = ""
        Else
            If (input) > " " Then
                strWeb = "<br />" & input
            End If
        End If
        Return strWeb
    End Function
	
	Function AddPh(input)
        Dim strPh As String
        strPh = ""
        If (input) Is DBNull.Value Then
            strPh = ""
        Else
            If (input) > " " Then
                'Return "<br /></em>Tel:&nbsp;<em>" & input
                strPh = "<br />" & input
            End If
        End If
        Return strPh
	End Function
	
	Function AddEmail(input)
        Dim strMail As String
        strMail = ""
        If (input) Is DBNull.Value Then
            'Return Input
        Else
            If (input) > " " Then
                'Return "<br /></em>Email:<em>&nbsp;<a href='mailto:" & input & "'>" & input & "</a>"
                strMail = "<br /><a href='mailto:" & input & "'>" & input & "</a>"
            End If
        End If
        Return strMail
	End Function
	
    Protected Sub dlMaster_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataListCommandEventArgs)
        If e.CommandName = "ShowCom" Then
            dlMaster.SelectedIndex = e.Item.ItemIndex
            dlMaster.DataBind()
        End If
        
        If e.CommandName = "HideCom" Then
            dlMaster.SelectedIndex = -1
            dlMaster.DataBind()
        End If
    End Sub
    
    Sub DetailsBind(ByVal sender As Object, ByVal e As DataListItemEventArgs)
        ' see what type of row (header, footer, item, etc.) caused the event
        Dim oType As ListItemType = CType(e.Item.ItemType, ListItemType)

        ' only process it if it's the Selected row
        If oType = ListItemType.SelectedItem Then
            ' get value of brewery number for this row from DataKeys collection
            Dim sKey As String = dlMaster.DataKeys(e.Item.ItemIndex)
            ' get a reference to the DataGrid control in this row
            Dim dlBrewCom As DataList = CType(e.Item.FindControl("dlBrewCom"), DataList)

            '------- Making the connection ------
            Dim strConnectionbc As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
            'This works on my Server
            strConnectionbc += "Data Source = " & Server.MapPath("_private/breweries.mdb")
    
            Dim objConnectionbc As New OleDbConnection(strConnectionbc)
            '--------Connection made ---------
            
            Dim strSQLbc As String
            strSQLbc = "SELECT * FROM tblBreweryComment WHERE BName = " + sKey + " ORDER BY DateIn Desc"
            Dim objAdapterBC As New OleDbDataAdapter(strSQLbc, objConnectionbc)
            Dim objDataSetBC As New DataSet()
            objConnectionbc.Open()
            objAdapterBC.Fill(objDataSetBC, "tblBrewComment")

            objDataSetBC.Tables(0).Columns.Add(New DataColumn("AuthName", GetType(String)))
            objDataSetBC.Tables(0).Columns.Add(New DataColumn("AuthEmail", GetType(String)))
            objDataSetBC.Tables(0).Columns.Add(New DataColumn("AuthLoc", GetType(String)))

            Dim zRow As DataRow
            For Each zRow In objDataSetBC.Tables(0).Rows
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
                    If zRow.Item("Email") = "" Then
                        zRow.Item("AuthEmail") = ""
                    Else
                        zRow.Item("AuthEmail") = " (" & zRow.Item("Email") & ")"
                    End If
                End If
                If IsDBNull(zRow.Item("Loc")) Then
                    zRow.Item("AuthLoc") = ""
                Else
                    If zRow.Item("Loc") = "" Then
                        zRow.Item("AuthLoc") = ""
                    Else
                        zRow.Item("AuthLoc") = " " & zRow.Item("Loc")
                    End If
                End If
            Next

            dlBrewCom.DataSource = objDataSetBC.Tables("tblBrewComment")
            dlBrewCom.DataBind()
            ' bind nested comments datalist 
            objConnectionbc.Close()
            'Return dsBrewComment.Tables("tblBrewComment")
            
        End If

    End Sub
    
    '-- Applies SelectedItemTemplate when Show button clicked,
    '-- turns off SelectedItemTemplate when Hide button clicked
    Protected Sub dlBrand_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataListCommandEventArgs)
        If e.CommandName = "ShowComBd" Then
            dlBrand.SelectedIndex = e.Item.ItemIndex
            dlBrand.DataBind()
        End If
        
        If e.CommandName = "HideComBd" Then
            dlBrand.SelectedIndex = -1
            dlBrand.DataBind()
        End If
    End Sub
    
    Sub DetailsBindBd(ByVal sender As Object, ByVal e As DataListItemEventArgs)
        ' see what type of row (header, footer, item, etc.) caused the event
        Dim oType As ListItemType = CType(e.Item.ItemType, ListItemType)

        ' only process it if it's the Selected row
        If oType = ListItemType.SelectedItem Then
            ' get value of brewery number for this row from DataKeys collection
            Dim sKey As String = dlBrand.DataKeys(e.Item.ItemIndex)
            ' get a reference to the DataGrid control in this row
            Dim dlBdCom As DataList = CType(e.Item.FindControl("dlBdCom"), DataList)

            '------- Making the connection ------
            Dim strConnectionbdc As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
            'This works on my Server
            strConnectionbdc += "Data Source = " & Server.MapPath("_private/breweries.mdb")
    
            Dim objConnectionbdc As New OleDbConnection(strConnectionbdc)
            '--------Connection made ---------
            
            Dim strSQLbdc As String
            strSQLbdc = "SELECT * FROM tblBrandComment WHERE Brand = " + sKey + " ORDER BY DateCom Desc"
            Dim objAdapterBdC As New OleDbDataAdapter(strSQLbdc, objConnectionbdc)
            Dim objDataSetBdC As New DataSet()
            objConnectionbdc.Open()
            objAdapterBdC.Fill(objDataSetBdC, "tblBdComment")

            objDataSetBdC.Tables(0).Columns.Add(New DataColumn("AuthName", GetType(String)))
            objDataSetBdC.Tables(0).Columns.Add(New DataColumn("AuthEmail", GetType(String)))
            objDataSetBdC.Tables(0).Columns.Add(New DataColumn("AuthLoc", GetType(String)))

            Dim zRow As DataRow
            For Each zRow In objDataSetBdC.Tables(0).Rows
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
                    If zRow.Item("Email") = "" Then
                        zRow.Item("AuthEmail") = ""
                    Else
                        zRow.Item("AuthEmail") = " (" & zRow.Item("Email") & ")"
                    End If
                End If
                If IsDBNull(zRow.Item("Loc")) Then
                    zRow.Item("AuthLoc") = ""
                Else
                    If zRow.Item("Loc") = "" Then
                        zRow.Item("AuthLoc") = ""
                    Else
                        zRow.Item("AuthLoc") = " " & zRow.Item("Loc")
                    End If
                End If
            Next

            dlBdCom.DataSource = objDataSetBdC.Tables("tblBdComment")
            dlBdCom.DataBind()
            ' bind nested comments datalist 
            objConnectionbdc.Close()
            'Return dsBrewComment.Tables("tblBrewComment")
            
        End If
    End Sub
    
   
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title id="PageTitle" runat="server"></title> 
    <meta content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, breweries, craft breweries, beer, Phillips Brewing, Okanagan Spring, Granville Island, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, Bowen Island, Columbia Brewing, Kokanee" name="keywords" />
    <meta content="Beer brewed by breweries and microbreweries in British Columbia, including tasting comments on the beers" name="Description" />
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
   <asp:datalist id="dlMaster"  CssClass="dlmain" Runat="server" 
   AlternatingItemStyle-BorderWidth="0"
    OnItemCommand="dlMaster_ItemCommand"
     OnItemDataBound="DetailsBind"
   DataKeyField="Number">
    <ItemTemplate>
          <table>
            <tr>
                <td><asp:Image CssClass="brewlogo" ID="Image1" ImageUrl='<%# "images/breweries/" + Container.DataItem("Logo") %>' runat="server" /></td>
                <td><h1 class="bselect">
                <%# Container.DataItem("BName") %></a> </h1>
                <span class="btype" >&nbsp;-&nbsp;<%# Container.DataItem("BType") %>,
       						 <%# Container.DataItem("Status") %>&nbsp;&nbsp;
       						 <%#AddStars(Container.DataItem("Rating"))%>
							</span>	
				<br /><em> <%# Container.DataItem("Address") %><br /> 
                <%# Container.DataItem("City") %>
				<asp:hyperlink id="HyperLinkWebsite" Text='<%# AddWeb(Container.DataItem("Website")) %>' NavigateURL= '<%# "http://" + Container.DataItem("Website") %>' runat="server" />
                <%# AddEmail(Container.DataItem("Email")) %>
				<%# AddPh(DataBinder.Eval(Container.DataItem, "Ph")) %></em>		
            </td>
            </tr>
          </table>					
		<p>
        <%# Container.DataItem("Comment") %>
		<span class="softdate">(<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %>)</span>&nbsp 
        <asp:LinkButton ID="btnShow" runat="server" Text="More Comments" CommandName="ShowCom" />
        [<%# Container.DataItem("Comms") %>  <%# CalcAveRating(DataBinder.Eval(Container.DataItem, "Number"))%>] &nbsp; 
        <asp:HyperLink id="HyperLink1" Text='Add Your Comments/Rate this Brewery' NavigateURL='<%# "brewerycomment.aspx?Number=" + HttpUtility.UrlEncode(Container.DataItem("Number")) %>' runat="server" />
        </p>
    </ItemTemplate>
    <SelectedItemTemplate>
            <table>
            <tr>
                <td><asp:Image CssClass="brewlogo" ID="Image1" ImageUrl='<%# "images\breweries\" + Container.DataItem("Logo") %>' AlternateText="no logo" runat="server" /></td>
                <td><h1 class="bselect"><a name='<#% Container.DataItem("Bmark") %>' runat="server">
                <%# Container.DataItem("BName") %></a> </h1>
                <span class="btype" >&nbsp;-&nbsp;<%# Container.DataItem("BType") %>,
       						 <%# Container.DataItem("Status") %>&nbsp;&nbsp;
       						 <%#AddStars(Container.DataItem("Rating"))%>
							</span>	
				<br /><em> <%# Container.DataItem("Address") %><br /> 
                <%# Container.DataItem("City") %>
				<asp:hyperlink id="HyperLinkWebsite" Text='<%# AddWeb(Container.DataItem("Website")) %>' NavigateURL= '<%# "http://" + Container.DataItem("Website") %>' runat="server" />
                <%# AddEmail(Container.DataItem("Email")) %>
				<%# AddPh(DataBinder.Eval(Container.DataItem, "Ph")) %></em>		
            </td>
            </tr>
          </table>					
		    <p>
           <%# Container.DataItem("Comment") %>
			<span class="softdate">(<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %>)</span>&nbsp 
           </p><p>
           <asp:LinkButton ID="btnHide" runat="server" Text="Hide Brewery Comments" CommandName="HideCom" />&nbsp; 
           <asp:HyperLink id="HyperLink1" Text='Add Your Comments/Rate this Brewery' NavigateURL='<%# "brewerycomment.aspx?Number=" + HttpUtility.UrlEncode(Container.DataItem("Number")) %>' runat="server" />
           </p>
           <h4>Visitor Comments</h4>
           <em>Average rating: </em><%# CalcAveRating(DataBinder.Eval(Container.DataItem, "Number"))%><hr />
           <asp:DataList runat="server" ID="dlBrewCom" Width="100%">
              <ItemTemplate>
                <%# AddStars(DataBinder.Eval(Container.DataItem, "URating")) %> 
                
                <div class="comment" ><%# DataBinder.Eval(Container.DataItem, "UComment") %><br />
				</div>
				&nbsp;-&nbsp;<strong><%# DataBinder.Eval(Container.DataItem, "AuthName") %></strong>&nbsp;
			    <%# DataBinder.Eval(Container.DataItem, "AuthLoc") %>
		          <!-- email display removed - sensible request of visitor <%# DataBinder.Eval(Container.DataItem, "AuthEmail") %>-->
		          <em><%# DataBinder.Eval(Container.DataItem, "DateIn", "{0:dd/MM/yyyy}") %></em>
				  <hr />
                </ItemTemplate>
            </asp:DataList>
           <asp:LinkButton ID="LinkButton1" runat="server" Text="Hide Brewery Comments" CommandName="HideCom" />&nbsp; 
           <asp:HyperLink id="HyperLink2" Text='Add Comments/Rate this Brewery' NavigateURL='<%# "brewerycomment.aspx?Number=" + HttpUtility.UrlEncode(Container.DataItem("Number")) %>' runat="server" />
        </SelectedItemTemplate>
           <AlternatingItemStyle BorderWidth="0px" />
   </asp:datalist >
<h2>Brands</h2>
<p>
<asp:datalist id="dlBrand" Runat="server" Font-size="10pt" 
 OnItemCommand="dlBrand_ItemCommand" 
  OnItemDataBound="DetailsBindBd" 
   DataKeyField="BdNumber" >
	<ItemTemplate>
	    <a id='<%# DataBinder.Eval(Container.DataItem, "BdNumber") %>' >
        <strong><%# DataBinder.Eval(Container.DataItem, "Brand") %></strong></a>
        (<%# DataBinder.Eval(Container.DataItem, "Styles") %>, <%# DataBinder.Eval(Container.DataItem, "Alco")%>)
        <%#AddStars(Container.DataItem("Rating"))%> 
        - <%# Container.DataItem("Review") %>&nbsp;
        <span class="softdate"><%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %></span>&nbsp;
        <asp:LinkButton ID="btnShowBd" runat="server" CommandName="ShowComBd" >More Comments</asp:LinkButton>
        [<%# Container.DataItem("NumberComments") %>] &nbsp; 
        <asp:HyperLink id="HyperLink4" Text='Add Comments/Rate this Beer' NavigateURL='<%# "brandcomment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) + "&BdNumber=" + HttpUtility.UrlEncode(Container.DataItem("BdNumber")) %>' runat="server" />
        <p></p>
    </ItemTemplate>
    <SelectedItemTemplate>
        <strong><%# DataBinder.Eval(Container.DataItem, "Brand") %></strong>
        (<%# DataBinder.Eval(Container.DataItem, "Styles") %>, <%# DataBinder.Eval(Container.DataItem, "Alco")%>)
        <%#AddStars(Container.DataItem("Rating"))%> 
        - <%# Container.DataItem("Review") %>&nbsp;
        <span class="softdate"><%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %></span>&nbsp;
        <asp:LinkButton ID="btnHideBd" runat="server" CommandName="HideComBd" >Hide Beer Comments</asp:LinkButton>
        [<%# Container.DataItem("NumberComments") %>] &nbsp; 
        <asp:HyperLink id="HyperLink4" Text='Add Comments/Rate this Beer' NavigateURL='<%# "brandcomment.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) + "&BdNumber=" + HttpUtility.UrlEncode(Container.DataItem("BdNumber")) %>' runat="server" />
        <div style="margin-top: 10px; margin-left: 25px">
        <h4>Visitor Comments</h4>
        <em>Average rating: </em><%# CalcAveRatingBd(DataBinder.Eval(Container.DataItem, "BdNumber"))%><hr />
           <asp:DataList runat="server" ID="dlBdCom" Width="100%">
              <ItemTemplate>
                <%# AddStars(DataBinder.Eval(Container.DataItem, "URating")) %> 
                <div class="comment norm"><%# DataBinder.Eval(Container.DataItem, "UComment") %>
                </div>
                &nbsp;-&nbsp;<strong><%# DataBinder.Eval(Container.DataItem, "AuthName") %></strong>&nbsp;
			    <%# DataBinder.Eval(Container.DataItem, "AuthLoc") %>
		          <!-- email display removed - sensible request of visitor <%# DataBinder.Eval(Container.DataItem, "AuthEmail") %>-->
		                          <em><%# DataBinder.Eval(Container.DataItem, "DateCom", "{0:dd/MM/yyyy}") %></em>
				
				  <hr />
                </ItemTemplate>
            </asp:DataList></div>
    </SelectedItemTemplate>                                            
</asp:datalist>
</p>		
   
   <hr />
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
