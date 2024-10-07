<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ValidateRequest="false" ResponseEncoding="windows-1252" Debug="false" %>

<%@ IMPORT Namespace="System.Data" %>
<%@ IMPORT Namespace="System.Data.OLEDB" %>
<%@ IMPORT Namespace="System.Web.Mail" %>
<%@ IMPORT Namespace="System.IO" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>


<script LANGUAGE="VB" RUNAT="server">
    Sub Page_Error()
        
        Dim objMail2 As New System.Net.Mail.SmtpClient
        Dim objMailMessage2 As New System.Net.Mail.MailMessage
        Dim adrSender2 As New System.Net.Mail.MailAddress("brewery@bcbeer.ca")
        objMailMessage2.From = adrSender2
        objMailMessage2.To.Add("john@bcbeer.ca")
        objMailMessage2.Subject = "Error on BCBG"
        objMailMessage2.IsBodyHtml = True
        objMailMessage2.Body = "<html><head></head><body>" & _
            DateTime.Now & "<p>Error on BC Beer Guide.</p>" & _
            "<table><tr>" & _
            "<td>From:</td><td>" & Request.Url.ToString & _
            "</td></tr>" & _
            "<tr><td>Message:</td><td>" & Server.GetLastError.Message & _
            "</td></tr>" & _
            "<tr><td>Email:</td><td>" & Email.Value & _
            "</td></tr>" & _
            "<tr><td>Comment:</td><td>" & UComment.Value & _
            "</td></tr>" & _
             "</table>" & _
            "<p><i>Note: you will also receive notice from " & _
            "the errors page.</i></p></body></html>"
            
        '-For testing on local - also change lines 263, 304:
        'objMail2.Host = "localhost"
        '-For remote server:
        'objMail2.Host = "smtp.bcbeer.ca"
        'objMail2.Send(objMailMessage2)
        '**End of email1 to me section **
        'Response.Redirect("bcbgerror.aspx")
    End Sub
    
    Sub Page_Load()

        If Not Page.IsPostBack Then

            '------- Making the connection ------
            Dim strConnection As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
		
            'Find the database file on the server 
            strConnection += "Data Source = " & Server.MapPath("_private/breweries.mdb")
		
            Dim objConnection As New OleDbConnection(strConnection)
            '--------Connection made ---------
		
            Dim strSQL As String = "SELECT * FROM tblBrewery WHERE Number=" + Request.Params("Number")
            Dim objAdapter As New OleDbDataAdapter(strSQL, objConnection)
            Dim objDataSet As New DataSet()
            objAdapter.Fill(objDataSet, "tblBrewery")

            dlMaster.DataSource = objDataSet.Tables("tblBrewery")
            dlMaster.DataBind()
            dlMaster2.DataSource = objDataSet.Tables("tblBrewery")
            dlMaster2.DataBind()

            'Ensures comment form is blank when page loads
            Author.Value = ""
            UComment.Value = ""
            Email.Value = ""
            Loc.Value = ""
            MessageThanks.Text = ""
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
	strSQL3 &= "FROM tblBrewery, tblBrand WHERE tblBrewery.Number = tblBrand.BName AND tblBrewery.Number = " & x

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

'Routine for adding Comments
Sub Add_Comment_Click(Sender As Object, E As EventArgs)

        'Sets up variables for emailing results to me
        Dim objMail As New System.Net.Mail.SmtpClient
        Dim objMailMessage As New System.Net.Mail.MailMessage
        Dim adrSender As New System.Net.Mail.MailAddress("brewery@bcbeer.ca")
        objMailMessage.From = adrSender
        objMailMessage.To.Add("john@bcbeer.ca")
        
        '--ValidateRequest is set to false in Page declaration.
        '--Ok, as long as ALL form fields are validated
        '--to ensure no HTML/SCRIPT code gets through.
        '--If ValidateRequest used, creates error before sub
        '--has chance to send email with invalid form data.
        '--Try - Catch tried without success to catch ValidateRequest errors.
        
        '--Determines if page is valid 
        '--based on CustomValidator2_ServerValidate below.
        '--Designed to catch form entries with html/script code,
        '--send users to error.aspx and report them to me via email.
        
        If Page.IsValid Then
        
            '------- Making the connection ------
            Dim strConnC As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
            strConnC += "Data Source = " & Server.MapPath("_private/breweries.mdb")
            Dim dsBrandComC As New DataSet()
            Dim objConnC As New OleDbConnection(strConnC)
            '--------Connection made ---------

            Dim strSQLInsert As String
            Dim objCommand As OleDbCommand

            strSQLInsert = "INSERT INTO tblBreweryComment (BName, UComment, URating, DateIn, Author, Email, Loc) values (@BName, @UComment, @URating, @DateIn, @Author, @Email, @Loc)"

            objCommand = New OleDbCommand(strSQLInsert, objConnC)

            objCommand.Parameters.Add(New OleDbParameter("@BName", OleDbType.VarChar, 20))
            objCommand.Parameters.Add(New OleDbParameter("@UComment", OleDbType.VarChar, 2000))
            objCommand.Parameters.Add(New OleDbParameter("@URating", OleDbType.VarChar, 3))
            objCommand.Parameters.Add(New OleDbParameter("@DateIn", OleDbType.Date))
            objCommand.Parameters.Add(New OleDbParameter("@Author", OleDbType.VarChar, 25))
            objCommand.Parameters.Add(New OleDbParameter("@Email", OleDbType.VarChar, 25))
            objCommand.Parameters.Add(New OleDbParameter("@Loc", OleDbType.VarChar, 25))

            objCommand.Parameters("@BName").Value = Request.Params("Number")
            objCommand.Parameters("@UComment").Value = UComment.Value
            If URating.SelectedItem Is Nothing Then
                objCommand.Parameters("@URating").Value = 0
            Else
                objCommand.Parameters("@URating").Value = URating.SelectedValue
            End If
            'use Now() to get the full date and time
            objCommand.Parameters("@DateIn").Value = Now()
            objCommand.Parameters("@Author").Value = Author.Value
            objCommand.Parameters("@Email").Value = Email.Value
            objCommand.Parameters("@Loc").Value = Loc.Value

            objConnC.Open()
            objCommand.ExecuteNonQuery()
            objConnC.Close()

            'This re-displays the information, including the new comment - not sure why needed, but is
            Dim strSQL As String = "SELECT * FROM tblBrewery WHERE Number=" + Request.Params("Number")
            Dim objAdapter As New OleDbDataAdapter(strSQL, objConnC)
            Dim objDataSet As New DataSet()
            objAdapter.Fill(objDataSet, "tblBrewery")

            dlMaster2.DataSource = objDataSet.Tables("tblBrewery")
            dlMaster2.DataBind()
		
            'Get brand name from Brand table in DataSet to include in email below
            Dim strBrewery As String
            strBrewery = objDataSet.Tables(0).Rows(0).Item("BName")

            MessageThanks.Text = "Your brewery comment has been added - cheers!"

            '**Sends email to me notifying of new comment **
            '**using variables established at top of function 
            objMailMessage.Subject = "New brewery comment: " + strBrewery + "!"
            objMailMessage.IsBodyHtml = True
            objMailMessage.Body = "<html><head></head><body>" & _
                DateTime.Now & "<p>" & Author.Value & " (" & Email.Value & "; " & Loc.Value & ") has added " & _
                "comment on <strong>" & strBrewery & ": </strong></p>" & UComment.Value
            '-For local testing:
            'objMail.Host = "localhost"
            '-For remote use:
            objMail.Host = "smtp.bcbeer.ca"
            objMail.Send(objMailMessage)
        
            '**End of email to me section **

            'Makes form invisible and thanks message visible
            pnlFback.Visible = False
            HyperLink2.Text = "Return to Brewery"
            HyperLink2.NavigateUrl = "~/breweryselect.aspx?Number=" + Request.Params("Number")
  
            pnlMessage.Visible = True

            'Clears the form for next time
            Author.Value = ""
            Email.Value = ""
            Loc.Value = ""
            UComment.Value = ""
            'MessageThanks.Text=""
            Session.Clear()
        
        Else
            '**Sends email to me notifying of intruder**
            
            objMailMessage.Subject = "Invalid beer comment"
            '--IsBodyHtml false because want to show html tags in error email
            objMailMessage.IsBodyHtml = False
            objMailMessage.Body = DateTime.Now & _
            " Someone has tried to enter the following invalid text into the brand comment form " & _
            " at " & Request.Url.ToString & " ... " & _
            " Author: " & _
            Author.Value & _
            "; Email: " & _
             Email.Value & _
             "; Location: " & _
             Loc.Value & _
             "; Comment: " & _
             UComment.Value
            
            '-For testing on local:
            objMail.Host = "localhost"
            '-For remote server:
            'objMail.Host = "smtp.bcbeer.ca"
            objMail.Send(objMailMessage)
            '**End of email to me section **
            '** Clears fields
            
            '**Redirects browser to home page **
            '*could use error page, but this keeps them guessing
            Response.Redirect("default.aspx")
            
        End If
    End Sub

Sub Cancel_Comment_Click(Sender As Object, E As EventArgs)
  Author.Value=""
  UComment.Value=""
  Email.Value=""
  MessageThanks.Text=""
End Sub

Sub Reveal_Form_Click (Sender As Object, E As EventArgs)
  pnlFback.Visible = true
  pnlMessage.Visible = false
End Sub

    '--Validator test used for comment form field
    '--More Else If can be added if more invalid strings are identified
    Protected Sub CustomValidator1_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs)
        If args.Value.ToLower.IndexOf("<") > -1 Then
            args.IsValid = False
            Exit Sub
        ElseIf args.Value.ToLower.IndexOf("http") > -1 Then
            args.IsValid = False
            Exit Sub
        ElseIf args.Value.ToLower.IndexOf("//") > -1 Then
            args.IsValid = False
            Exit Sub
        Else
            args.IsValid = True
        End If
    End Sub
    
    '---Determines appropriate star image based on rating number 
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
    
    '---Calculates average rating by site users
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
    
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>B.C. Beer Guide Add Brewery Comments </title>
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
      <!--<p>Below is the information currently available on the brewery of your choice. 
        If you have any information or opinions on this brewery, feel free to 
        add your own words.</p>-->
       
      <asp:datalist id="dlMaster"
	Runat="server"
	CssClass="dlmain"	
	>
	    <ItemTemplate>
              <h1> 
                <asp:HyperLink id="HyperLink1" Text='<%# DataBinder.Eval(Container.DataItem, "BName") %>' NavigateUrl='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number")) %>' runat="server" />
                - Add Comments/Rate this Brewery </h1>
              <em> 
              <%# DataBinder.Eval(Container.DataItem, "City") %>
              </em> 
              <p> 
                <%# DataBinder.Eval(Container.DataItem, "Comment") %>
              <br />
                <%# AddStars(DataBinder.Eval(Container.DataItem, "Rating")) %>
              </p>
              <p> 
                <asp:Datalist id="dlBrand"
				Runat="server"
				RepeatDirection="Horizontal"
				RepeatLayout="Flow"
				DataSource='<%# GetBrand(container.dataitem("Number")) %>' >
				<ItemTemplate>
				  <b><%# DataBinder.Eval(Container.DataItem, "Brand") %></b>
				  (<%# DataBinder.Eval(Container.DataItem, "Styles") %>,
				   <%# DataBinder.Eval(Container.DataItem, "Alco") %>) 	
				</ItemTemplate>
			</asp:Datalist>
                </ItemTemplate>
	 </asp:datalist> 
      <hr />
      <asp:panel id="pnlFback" cssclass="comment" runat="server">
    <h2><a id="comm">Add your comments on this brewery!</a></h2>
    <p class="short">(all fields optional - info will not be sold or otherwise abused)</p>
    <table ><tr>
      <td> Your Name: </td><td>
        <input type="text" id="Author" size="30" runat="server" />
          <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="Author"
              ErrorMessage="Alphabetic characters only please." ValidationExpression="^[a-zA-Z.,''-'\s]{1,40}$"></asp:RegularExpressionValidator></td></tr>
        <tr> 
          <td> Your Email: </td>
          <td > <input type="text" id="Email" size="30" runat="server" /> (email not displayed publicly)
              <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="Email"
                  ErrorMessage="Valid email address please" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
        </tr>
        <tr> 
          <td> Your Locale: </td>
          <td> <input type="text" id="Loc" size="30" runat="server" /> 
              <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="Loc"
                  ErrorMessage="Alphabetic characters only." ValidationExpression="^[a-zA-Z.,''-'\s]{1,40}$"></asp:RegularExpressionValidator></td>
        </tr>
        <tr> 
          <td class="attop"> Your Comments: </td>
          <td> <textarea id="UComment" cols="75" rows="5" runat="server" />
              <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="UComment" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator></td>
        </tr>
        <tr>
            <td>Rating:</td>
            <td>
                <asp:RadioButtonList ID="URating" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                    <asp:ListItem Text="1" Value="1" />
                    <asp:ListItem Text="2" Value="2" />
                    <asp:ListItem Text="3" Value="3" />
                    <asp:ListItem  Value="4" Text="4" />
                    <asp:ListItem Text="5" Value="5" />
                </asp:RadioButtonList>
                (1=poor, 5=superb)</td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
          <td> <input type="submit" onserverclick="Add_Comment_Click" Value="Send in Comment" runat="server" /> 
            &nbsp; <asp:button id="Cancel_Comments" Text="Clear Comments" OnClick="Cancel_Comment_Click" RUNAT="server" /> </td>
        </tr>
    </table>
	</asp:panel>
      <asp:panel id="pnlMessage" Cssclass="comment" runat="server" Visible="False">
		<strong><asp:label id="MessageThanks" runat="server" /></strong>&nbsp;
          <asp:HyperLink ID="HyperLink2" runat="server" >Back to full brewery information</asp:HyperLink>
 	  </asp:panel>
      <hr />
      <h2>Previous Visitor Comments:</h2>
        
      <asp:datalist id="dlMaster2"
	Runat="server"
	Cellpadding="3"
	>
	<ItemTemplate><em>Average rating: </em><%#CalcAveRating(DataBinder.Eval(Container.DataItem, "Number"))%><hr />
              <asp:Datalist id="dlBreweryComment"
				Runat="server"
				DataSource='<%# GetBreweryComment(container.dataitem("Number")) %>' >
				<ItemTemplate>
				 <p><%# AddStars(DataBinder.Eval(Container.DataItem, "URating")) %> 
                <em><%# DataBinder.Eval(Container.DataItem, "DateIn", "{0:dd/MM/yyyy}") %></em>
                <div class="comment" ><%# DataBinder.Eval(Container.DataItem, "UComment") %><br />
				</div>
				&nbsp;-&nbsp;<strong><%# DataBinder.Eval(Container.DataItem, "AuthName") %></strong>&nbsp;
			    <%# DataBinder.Eval(Container.DataItem, "AuthLoc") %>
		          <!--<%# DataBinder.Eval(Container.DataItem, "AuthEmail") %>-->
				 </p>
				</ItemTemplate>
			</asp:Datalist>
              </ItemTemplate>
</asp:datalist> </div>
<UserControl:Foot id="UserControl4f" runat="server" /> 
  </div>
</form>
</body>
</html>
