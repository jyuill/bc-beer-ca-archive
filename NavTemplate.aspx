<%@ Page Language="VB" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Dim Sortfield as String
    
            Sub Page_Load()
                '------- Making the connection ------
                Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
    
                'This works on my Server
                strConnection += "Data Source = "& Server.MapPath("_private/breweries.mdb")
    
                Dim objConnection as New OLEDBConnection(strConnection)
    
                '--------Connection made ---------
    		'--------Add any code necessary for page function----------
    
     
            End Sub
    

</script>

    <!-- Refers to files that are that are comprised of re-usable code that is common to many pages - in this case the top section and navigation -->
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="Mailto.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav1.ascx" %>

<html>
<head>
<title>BCBG Template </title> 
<meta name="keywords" content="beer, microbreweries, British Columbia, B.C., BC, micro-breweries, 
breweries, craft breweries, beer, Okanagan Spring, Granville Island, Shaftebury,
 Bear Brewing, Nelson Brewing, Mt. Begbie, Vancouver Island, Sleeman, Tree Brewing, 
Bowen Island, Columbia Brewing, Kokanee" />
<meta name="Description" content="Beer brewed by breweries and micro-breweries in British Columbia, including tasting comments on the beers" />
<link rel="stylesheet" type="text/css" href="bcbgstyle.css" />
</head>
    
<body class="bkgrnd">
<!-- cellpadding and cellspacing are required to fit table to navigation bar and can't be set CSS -->
<table class="topreg" cellpadding=0 cellspacing=0 align="center">
<tr><td>   
         <h1 class="title"><img src="gifs/BCBGlogo%20stretch.gif" width="625" height="100" alt="British Columbia Beer Guide - Breweries in B.C. and Their Beers"> </h1>
      
      	<UserControl:Nav runat="server" />
      	<UserControl:Mail runat="server" />
</td></tr>
</table>
<!-- with cellpadding set to 0, 'padding' can actually be set in CSS -->       
<table class="main" cellpadding=0 align="center">
   <tr><td>
        <h1>Heading 1 (Title)</h1>
        <p>
        (Intro text) 
        </p>
       </td></tr>
</table>
<p>   
</body>
</html>

