
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" Debug="true" ContentType="text/html" ResponseEncoding="windows-1252"  %>
<html xmlns="http://www.w3.org/1999/xhtml">

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
	
	'Used on Inspiron server to show date in English rather than French due to bizarre setting somewhere
	'Should be disabled on live version so that info will be displayed according to the choice of viewers
	'Dim MyCulture As New CultureInfo("en-CA", False)
	'System.Threading.Thread.CurrentThread.CurrentCulture=MyCulture
	'System.Threading.Thread.CurrentThread.CurrentUICulture=MyCulture
    
      If Not IsPostback Then
    
        '------- Making the connection ------
        Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
        strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
    
        Dim objConnection as New OLEDBConnection(strConnection)
    
        '--------Connection made ---------
    
        '---Getting file save date for News
            'Dim Filename as String
            'Dim SaveDate As DateTime
    
        'Filename = Request.ServerVariables("Path_Translated")
        'SaveDate = File.GetLastWriteTime(Filename)
        'lblSaveDate.Text = SaveDate.ToLongDateString()
		lblSaveDate.Text = Date.Now.ToLongDateString()
        '----
    
        '---Dropdown list of Breweries
         objConnection.Open()
    
         'Create Command object for the query
         Dim strBName as String
         strBName = "SELECT Number, BName FROM tblBrewery ORDER BY BName"
         Dim objCmd as New OledbCommand(strBName, objConnection)
    
         'Create/Populate DataReader
         Dim objDR as OledbDataReader
         objDR = objCmd.ExecuteReader()
    
         'Databind DataReader to list control
         lstBName.DataSource=objDR
         lstBName.DataBind()
    
         objConnection.Close()
    
         'Select default item, where first item=0
         '--to add text at top:
         lstBName.Items.Insert(0, new ListItem("-- Breweries --"))
         '--to select from existing items
         lstBName.SelectedIndex=0
        '----
    
        '---Dropdown list of Cities
        objConnection.Open()
    
         'Create Command object for the query
         Dim strCity as String
         strCity = "SELECT City FROM tblCity ORDER BY City"
         Dim objCmdCity as New OledbCommand(strCity, objConnection)
    
         'Create/Populate DataReader
         Dim objDRCity as OledbDataReader
         objDRCity = objCmdCity.ExecuteReader()
    
         'Databind DataReader to list control
         lstCity.DataSource=objDRCity
         lstCity.DataBind()
    
         objConnection.Close()
    
         'Select default item, where first item=0
         '--to add text at top:
         lstCity.Items.Insert(0, new ListItem("-- Cities --"))
         '--to select from existing items
         lstCity.SelectedIndex=0
        '----
    
         '---Dropdown list of Regions
         objConnection.Open()
    
         'Create Command object for the query
         Dim strReg as String
         strReg = "SELECT Region FROM tblRegions ORDER BY Region"
         Dim objCmdReg as New OledbCommand(strReg, objConnection)
    
         'Create/Populate DataReader
         Dim objDRReg as OledbDataReader
         objDRReg = objCmdReg.ExecuteReader()
    
         'Databind DataReader to list control
         lstRegion.DataSource=objDRReg
         lstRegion.DataBind()
    
         objConnection.Close()
    
         'Select default item, where first item=0
         '--to add text at top:
         lstRegion.Items.Insert(0, new ListItem("-- Regions --"))
         '--to select from existing items
         lstRegion.SelectedIndex=0
        '----
    
    '   '---Dropdown list of Styles
         objConnection.Open()
    
         'Create Command object for the query
         Dim strStyle as String
         strStyle = "SELECT Style FROM tblStyle ORDER BY Style"
         Dim objCmdStyle as New OledbCommand(strStyle, objConnection)
    
         'Create/Populate DataReader
         Dim objDRStyle as OledbDataReader
         objDRStyle = objCmdStyle.ExecuteReader()
    
         'Databind DataReader to list control
         lstStyle.DataSource=objDRStyle
         lstStyle.DataBind()
    
         objConnection.Close()
    
         'Select default item, where first item=0
         '--to add text at top:
         lstStyle.Items.Insert(0, new ListItem("-- Beer Styles --"))
         '--to select from existing items
         lstStyle.SelectedIndex=0
        '----
    
        '---Get information on Updates
    
         objConnection.Open()
         Dim thisDate As DateTime
         Dim revDate As DateTime
         thisDate = DateTime.Now
         revDate = thisDate.AddDays(-120)    
    
            Dim strSQLR As String = "SELECT tblBrand.BdNumber, tblBrand.Brand, tblBrand.ComDate, tblBrand.Bdbkmark, "
         strSQLR += "tblBrewery.Number, tblBrewery.BName FROM tblBrand, tblBrewery " 
         strSQLR += "WHERE tblBrand.BName = tblBrewery.Number AND tblBrand.ComDate > Now()-90 " 
         strSQLR += "ORDER BY tblBrand.ComDate DESC"
            Dim objAdapterR As New OleDbDataAdapter(strSQLR, objConnection)
         Dim objDataSetR as New DataSet()
         ObjAdapterR.Fill(objDataSetR, "tblReviews")
    
            '---Datalist for new reviews
         dlReviews.DataSource=objDataSetR.Tables("tblReviews")
         dlReviews.DataBind()
    
         objConnection.Close()
        '---
    
        '---Get information for EVents
    
         objConnection.Open()
    
         Dim strSQLE as string = "SELECT Subject, Eventitem, Bmark, EntryDate, EventDate, "
         strSQLE += "ExpiryDate FROM tblNewsEvents WHERE Eventitem=True AND ExpiryDate>Date() ORDER BY EntryDate Desc"
         Dim objAdapterE as New OledbDataAdapter(strSQLE, objConnection)
         Dim objDataSetE as New DataSet()
         ObjAdapterE.Fill(objDataSetE, "tblEvents")
    
        '---Datalist for events
         dlEvents.DataSource=objDataSetE.Tables("tblEvents")
         dlEvents.DataBind()
    
         objConnection.Close()
        '---
    
        '---Get information for News
    
         objConnection.Open()
    
         Dim strSQLN as string = "SELECT Subject, Eventitem, Bmark, EntryDate, EventDate, "
         strSQLN += "ExpiryDate FROM tblNewsEvents WHERE Eventitem=False AND ExpiryDate>Date() ORDER BY EntryDate DESC"
         Dim objAdapterN as New OledbDataAdapter(strSQLN, objConnection)
         Dim objDataSetN as New DataSet()
         ObjAdapterN.Fill(objDataSetN, "tblNews")
    
        '---Datalist for news
         dlNews.DataSource=objDataSetN.Tables("tblNews")
         dlNews.DataBind()
    
         objConnection.Close()
        '---
    
	      '---Get information for new visitor comments on breweries
    
         objConnection.Open()
    
         Dim strSQLB as string = "SELECT tblBreweryComment.BName, tblBreweryComment.DateIn, tblBrewery.Number, tblBrewery.BName "
         strSQLB += "FROM tblBreweryComment, tblBrewery WHERE tblBreweryComment.BName = tblBrewery.Number AND tblBreweryComment.DateIn > Now()-40 "
		 strSQLB += "ORDER BY tblBreweryComment.DateIn DESC"
         Dim objAdapterB as New OledbDataAdapter(strSQLB, objConnection)
         Dim objDataSetB as New DataSet()
         ObjAdapterB.Fill(objDataSetB, "BrewComment")
    
        '---Datalist for brewery comments
         dlBrewCom.DataSource=objDataSetB.Tables("BrewComment")
         dlBrewCom.DataBind()
		 'dgBrewCom.DataSource=objDataSetB.Tables("BrewComment")
		 'dgBrewCom.DataBind()
    
         objConnection.Close()
        '---
		
		  '---Get information for new visitor comments on beers
    
         objConnection.Open()
    
         'Dim strSQLBB as string = "SELECT tblBrand.BdNumber, tblBrand.Brand, tblBrand.BName, tblBrandComment.Brand, tblBrandComment.DateCom "
         'strSQLBB += "FROM tblBrand, tblBrandComment WHERE tblBrandComment.Brand = tblBrand.BNumber AND tblBrandComment.DateCom > Now()-60"
         Dim strSQLBB as string = "SELECT tblBrewery.Number, tblBrewery.BName, tblBrand.BdNumber, tblBrand.Brand, tblBrand.BName, tblBrandComment.Brand, tblBrandComment.DateCom "
		 strSQLBB+= "FROM tblBrewery, tblBrand, tblBrandComment WHERE tblBrand.BdNumber = tblBrandComment.Brand AND tblBrand.BName = tblBrewery.Number AND tblBrandComment.DateCom > Now()-35 "
		 strSQLBB += "ORDER BY tblBrandComment.DateCom DESC"
		 Dim objAdapterBB as New OledbDataAdapter(strSQLBB, objConnection)
         Dim objDataSetBB as New DataSet()
         ObjAdapterBB.Fill(objDataSetBB, "BeerComment")
    
        '---Datalist for brewery comments
         dlBeerCom.DataSource=objDataSetBB.Tables("BeerComment")
         dlBeerCom.DataBind()
		 'dgBrewCom.DataSource=objDataSetB.Tables("BrewComment")
		 'dgBrewCom.DataBind()
    
         objConnection.Close()
        '---
	
            '---Get information on feature
            objConnection.Open()
            Dim strSQLf As String = "Select TOP 1 * FROM tblFeature ORDER BY fDate DESC"
            Dim objAdapterF As New OleDbDataAdapter(strSQLf, objConnection)
            Dim objDataSetF As New DataSet()
            objAdapterF.Fill(objDataSetF, "Feature")
            
            '---Datalist for feature
            dlFeature.DataSource = objDataSetF.Tables("Feature")
            dlFeature.DataBind()
          
            objConnection.Close()
       
            '---Counting records for site statistics
            Dim strBrewery As String = "SELECT Count(*) FROM tblBrewery WHERE NOT Status='Closed' AND BType = 'Microbrewery' OR BType='Regional Brewery'"
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
    
    
    'In response to Go button from brewery list
    'For postback when selection is changed without using button, put following in ddl tag
        'AutoPostBack="True" OnSelectedIndexChanged="BName_Click"
    Sub BName_Click(ByVal sender As Object, ByVal e As EventArgs)
     Response.Redirect("breweryselect.aspx?Number="+ lstBName.SelectedItem.Value)
    End Sub
    
     'In response to Go button from city list
    Sub City_Click(ByVal sender As Object, ByVal e As EventArgs)
     'Extra single quotes needed around selected item value because text
     Response.Redirect("brewery.aspx?City='"+ lstCity.SelectedItem.Value +"'")
    End Sub
    
    Sub Region_Click(ByVal sender As Object, ByVal e As EventArgs)
     Response.Redirect("brewery.aspx?Region='"+ lstRegion.SelectedItem.Value +"'")
    End Sub
    
    Sub Style_Click(ByVal sender As Object, ByVal e As EventArgs)
     Response.Redirect("brands.aspx?Style='"+ lstStyle.SelectedItem.Value +"'")
    End Sub

    Function Truncate(ByVal strDescrip As String)
        Dim intLength As Integer
        intLength = 160
        If strDescrip.Length < intLength Then
            Return strDescrip
        Else
            Return strDescrip.Substring(0, intLength) & "..."
        End If
    End Function
    
    
</script>

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
    <h1 >An Enthusiast's Guide to British Columbia Microbreweries</h1>
    
      <script type="text/javascript"><!--
        google_ad_client = "pub-8366893486281629";
        google_alternate_ad_url = "http://www.bcbeer.ca/google_adsense_script.html";
        google_ad_width = 728;
        google_ad_height = 90;
        google_ad_format = "728x90_as";
        google_ad_type = "text_image";
        google_ad_channel ="";
        google_color_border = "E1771E";
        google_color_bg = "FFFFCC";
        google_color_link = "940F04";
        google_color_text = "000000";
        google_color_url = "0066CC";
    //--></script>
    <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
    </script>  
  </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> </div>
  </div>
  <!-- DIV for Main content area -->
  <div class="mainbox"> 
    <h2 class="home">B.C. microbreweries, brewpubs and 
      their products, </h2>
    <h2 class="home2"> with background information and tasting comments. </h2>
    <p class="lists"> You can browse the &nbsp; 
      <asp:HyperLink id="HyperLink1" runat="server" NavigateUrl="brewery.aspx">Full Brewery list</asp:HyperLink>
      &nbsp;OR &nbsp; 
      <asp:HyperLink id="HyperLink2" runat="server" NavigateUrl="brands.aspx">Full list of Beer Brands</asp:HyperLink>
      &nbsp;OR ... </p>
    <form runat="server">
      <table class="selection">
        <tbody>
          <tr> 
            <td class="bld"> Select Brewery:</td>
            <td> or</td>
            <td class="bld"> Select City:</td>
            <td> or</td>
            <td class="bld"> Select region:</td>
            <td> or</td>
            <td class="bld"> Select beer style:</td>
          </tr>
          <tr> 
            <td > <asp:DropDownList id="lstBName" AutoPostBack="true" OnSelectedIndexChanged="BName_click" runat="server" Width="165px" DataTextField="BName" DataValueField="Number"></asp:DropDownList> <asp:Button id="Button1" onclick="BName_Click" runat="server" text="Go"></asp:Button> </td>
            <td>&nbsp; </td>
            <td> <asp:DropDownList id="lstCity" AutoPostBack="true" OnSelectedIndexChanged="City_click" runat="server" Width="110px" DataTextField="City" DataValueField="City"></asp:DropDownList> <asp:Button id="Button2" onclick="City_Click" runat="server" text="Go"></asp:Button> </td>
            <td>&nbsp; </td>
            <td> <asp:DropDownList id="lstRegion" AutoPostBack="true" OnSelectedIndexChanged="Region_click" runat="server" Width="115px" DataTextField="Region" DataValueField="Region"></asp:DropDownList> <asp:Button id="Button3" onclick="Region_Click" runat="server" text="Go"></asp:Button> </td>
            <td>&nbsp; </td>
            <td> <asp:DropDownList id="lstStyle" AutoPostBack="true" OnSelectedIndexChanged="Style_click" runat="server" Width="125px" DataTextField="Style" DataValueField="Style"></asp:DropDownList> <asp:Button id="Button4" onclick="Style_Click" runat="server" text="Go"></asp:Button> </td>
          </tr>
        </tbody>
      </table>
      <div class="lftn">
      <h2>What's New as of 
        <asp:label id="lblSaveDate" runat="server"></asp:label>
        ? </h2>
      <table >
        <tr> 
          <td class="leftcol">Updates:</td>
          <td class="rightcol">  
		    <asp:DataList id="dlReviews" RepeatLayout="Flow" RepeatDirection="Horizontal" runat="server">
                   <ItemTemplate>
                    <span class="bld" style="font-size: 1em"><%# DataBinder.Eval(Container.DataItem, "BName") %></span>:
                    <asp:HyperLink id="HyperLink3" NavigateURL='<%# "breweryselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"Number"))+"#"+HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BdNumber")) %>' runat="server">
                           <%# DataBinder.Eval(Container.DataItem, "Brand") %>
                    </asp:HyperLink>
                    <span class="softdate">(<%# DataBinder.Eval(Container.DataItem, "ComDate", "{0:dd/MM/yyyy}") %>)</span>&nbsp; 
					</ItemTemplate>
               </asp:DataList>
		  </td>
        </tr>
        <tr> 
          <td class="leftcol">Events:</td>
          <td class="rightcol">  <asp:DataList id="dlEvents"  RepeatLayout="Flow" RepeatDirection="Horizontal" runat="server">
                <ItemTemplate>
                    <asp:HyperLink id="HyperLink4" NavigateURL='<%# "news.aspx#" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BMark")) %>' runat="server">
                              <%# DataBinder.Eval(Container.DataItem, "Subject") %> 
                       </asp:HyperLink>
                    <span><%--(<%# DataBinder.Eval(Container.DataItem, "EntryDate", "{0:dd/MM/yyyy}") %>) --%>&nbsp;</span>
				</ItemTemplate>
              </asp:DataList> </td>
        </tr>
        <tr> 
          <td class="leftcol">News:</td>
          <td class="rightcol">  <asp:DataList id="dlNews" RepeatLayout="Flow" RepeatDirection="Horizontal" runat="server">
                  <ItemTemplate>
                    <asp:HyperLink id="HyperLink5" NavigateURL='<%# "news.aspx#" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"BMark")) %>' runat="server">
                                                        <%# DataBinder.Eval(Container.DataItem, "Subject") %> 
                       </asp:HyperLink>
                    <span>(<%# DataBinder.Eval(Container.DataItem, "EntryDate", "{0:dd/MM/yyyy}") %>) </span>
				</ItemTemplate>
              </asp:DataList> </td>
        </tr>
      </table>
      <table width=100%>
        <tr > 
          <td class="leftcol leftcolv">Visitor Comments</td>
        </tr>
      </table>
      <table>
        <tr>
        <td class="leftcol">Breweries:</td>
          <td>  
		    <%-- Datalist for brewery comments --%>	
			<asp:DataList id="dlBrewCom" RepeatLayout="Flow" RepeatDirection="Horizontal" runat="server">
                 	<ItemTemplate>
                    		<asp:HyperLink id="HyperLink6" NavigateURL='<%# "brewerycommentv.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"[0]")) %>' runat="server">
						 		<%# DataBinder.Eval(Container.DataItem,"[3]") %>
							</asp:HyperLink>
                    		<span>(<%# DataBinder.Eval(Container.DataItem, "DateIn", "{0:dd/MM/yyyy}") %>)</span>
					 </ItemTemplate>
            </asp:DataList><br />
           </td>
		</tr>
		<tr>
		    <td class="leftcol">Beers:</td>
		    <td>
		    <%-- Datalist for brand comments --%>
			<asp:DataList id="dlBeerCom" RepeatLayout="Flow" RepeatDirection="Horizontal" runat="server">
                 	<ItemTemplate>
                    	<%# DataBinder.Eval(Container.DataItem,"[1]") %>
                    	<asp:HyperLink id="HyperLink7" NavigateURL='<%# "brandcommentv.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"[0]")) + "&BdNumber=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"[2]")) %>' runat="server">		    
							<%# DataBinder.Eval(Container.DataItem,"[3]") %>
						</asp:HyperLink>
                    	<span >(<%# DataBinder.Eval(Container.DataItem, "DateCom", "{0:dd/MM/yyyy}") %>) </span>
					</ItemTemplate>
             </asp:DataList> </td>
        </tr>
      </table>
      </div>
      <div class="rhtn">
        <%-- Datalist for feature --%>
        <asp:DataList ID="dlFeature" runat="server">
            <ItemTemplate>
                <h2>On Tap:&nbsp;<%#DataBinder.Eval(Container.DataItem, "fsub")%></h2>
                <asp:Image CssClass="fimage" ID="FeatImage" ImageUrl='<%# "images\features\" + Container.DataItem("fimage") %>' AlternateText="no image" runat="server" />               
                <asp:HyperLink ID="HyperLink8" NavigateURL='<%# "featureselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"fnum")) %>' runat="server"><h3><%# Databinder.Eval(Container.DataItem, "ftitle") %></h3></asp:HyperLink>
                <span class="softdate">(<%# DataBinder.Eval(Container.DataItem, "fdate", "{0:dd/MM/yyyy}") %>)</span><br />
                <p style="text-align:justify">
                    <%# Truncate(Databinder.Eval(Container.DataItem, "fcontent")) %>
                    <asp:HyperLink ID="HyperLink9" NavigateURL='<%# "featureselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"fnum")) %>' runat="server" Text="more" />
                </p>
            </ItemTemplate>
        </asp:DataList>
      </div>
      <!-- This div placed below 2 floating divs using clear:both so that main div will wrap
      around in Firefox -->
      <div style="clear:both; line-height: 0px;">&nbsp;</div>
      <!-- Poster advertisement placed by CSS style -->
      <!--<a href="store.aspx"><img src="images/store/posterad2.jpg" class="posterad" alt="BC Beer Poster for sale" /></a> -->
      <div class="posterad">
	  	<asp:AdRotator id="ar1" AdvertisementFile="posterad.xml" BorderWidth="0" Height="62px" runat=server /><br />
	  	<a href="store.aspx">Posters For Sale</a>
	  </div>
	  <div class="stats">
        <h2 style="font-weight:normal; font-size: .94em; margin-top: 0px; margin-bottom: 0px; padding-left: 2px">B.C. Beer Guide Stats:</h2>
        <div style="background-color: #FFFFCC; width: 100%"> 
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
   <!--footer outside main box identifying website builder-->
    <UserControl:Foot id="UserControl4f" runat="server" />
  </div><!--end of outer box-->
  <!--stupid spacer div to make room for the page to scroll down to footer-->
<div>&nbsp;</div>
</body>
</html>
