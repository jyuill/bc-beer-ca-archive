
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="windows-1252"  %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register TagPrefix="UserCtrl" TagName="CSSselect" Src="css_select.ascx" %>

<%@ import Namespace="System.Globalization" %>
<%@ import Namespace="System.Globalization.CultureInfo" %>
<%@ import Namespace="System.IO" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Sub Page_Load()
	    
      If Not IsPostback Then
    
        '------- Making the connection ------
        Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
        strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
    
        Dim objConnection as New OLEDBConnection(strConnection)
    
        '--------Connection made ---------
    
    
            '---Counting records for site statistics
            Dim strBrewery As String = "SELECT Count(*) FROM tblBrewery WHERE NOT Status='Closed' AND BType = 'Micro-brewery' OR BType='Regional Brewery'"
            Dim strBrewpub As String = "SELECT Count(*) FROM tblBrewery WHERE BType = 'Brewpub' AND NOT Status='Closed'"
            Dim strClosed As String = "SELECT Count(*) FROM tblBrewery WHERE NOT Status='Closed'"
            Dim strBrands As String = "SELECT Count(BdNumber) FROM tblBrand"
            Dim strBrandComment As String = "SELECT Count(Number) FROM tblBrandComment"
            Dim strBreweryComment As String = "SELECT Count(Number) FROM tblBreweryComment"

            Dim objBrewery As New OleDbCommand(strBrewery, objConnection)
            Dim objBrewpub As New OleDbCommand(strBrewpub, objConnection)
            Dim objClosed As New OleDbCommand(strClosed, objConnection)
            Dim objBrands As New OleDbCommand(strBrands, objConnection)
            Dim objBrandCom As New OleDbCommand(strBrandComment, objConnection)
            Dim objBreweryCom As New OleDbCommand(strBreweryComment, objConnection)

            objConnection.Open()
            lblBreweryCount.Text = objBrewery.ExecuteScalar()
            lblBrewpubCount.Text = objBrewpub.ExecuteScalar()
            'lblClosed.Text = objClosed.ExecuteScalar()
            lblBrands.Text = objBrands.ExecuteScalar()
            Dim intBrandCom As Integer
            intBrandCom = objBrandCom.ExecuteScalar()
            Dim intBreweryCom As Integer
            intBreweryCom = objBreweryCom.ExecuteScalar()
            lblComment.Text = intBrandCom + intBreweryCom
            'lblBreweryCount.Text = GetBreweryCount()  alternative to using Count in SELECT stmt
         
            objConnection.Close()
            '--End record counting --
        End If
    End Sub
            
    'Used to count records in dataset as alternative to SELECT Count(*)
    Function GetBreweryCount()
        Dim strConn As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
        strConn += "Data Source = " & Server.MapPath("_private/breweries.mdb")
        Dim dsBreweryList As New DataSet()
        Dim objConn As New OleDbConnection(strConn)
        Dim strSQL3 As String
    
        strSQL3 = "SELECT tblBrewery.Number FROM tblBrewery"
    
        Dim daBreweryList As New OleDbDataAdapter(strSQL3, objConn)
        daBreweryList.Fill(dsBreweryList, "tblBrewCount")
    
        Dim NoBrewery As Integer
        NoBrewery = 0
    
        Dim cRow As DataRow
        For Each cRow In dsBreweryList.Tables(0).Rows
            NoBrewery = NoBrewery + 1
        Next
    
        Return NoBrewery
    
    End Function

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>British Columbia Beer Guide</title> 
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <meta content="beer, brewing, breweries, brewery, British Columbia, microbreweries, B.C., craft breweries, BC, Canada, micro-breweries, ale,  real ale, real beer, lager, john yuill" name="keywords" />
    <meta content="Enthusiasts guide to microbreweries and brewpubs in British Columbia, including brewery information, tasting comments, beer related news and events..." name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
<!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"> <UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> 
    <h1 class="title">Statistics</h1>
    
  </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> </div>
  </div>
  <!-- DIV for Main content area -->
  <div class="mainbox"> 
    
    <form runat="server">
    <div style="float: right; width: 150px; font-size: .9em">
        <h2 style="font-weight:normal; margin-top: 0px; margin-bottom: 0px; padding-left: 2px">B.C. Beer Guide Stats:</h2>
      <div style="background-color: #FFFF99; width: 100%"> 
      <table style="border-collapse: collapse; margin-left: 6px">
      <tr><td >Active breweries:</td><td><asp:Label ID=lblBreweryCount runat="server" /></td>
      </tr>
      <tr><td >Active brewpubs:</td><td><asp:Label ID=lblBrewpubCount runat="server" /></td>
      </tr>
      <tr><td>Beer brands:</td><td><asp:Label ID=lblBrands runat="server" /></td>
      </tr>
      <tr><td>Visitor comments:</td><td><asp:Label ID=lblComment runat="server" /></td>
      </tr>
      </table>
      </div>
     </div>
     
    </form>
  </div>
  <!-- End of DIV for Main Content Area -->
  <UserControl:Foot id="UserControl4f" runat="server" /> 
</div>
</body>
</html>
