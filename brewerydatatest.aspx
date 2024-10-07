<%@ IMPORT Namespace="System.Data" %>
<%@ IMPORT Namespace="System.Data.OLEDB" %>

<SCRIPT LANGUAGE="VB" RUNAT="server">
	Sub Page_Load()
		'------- Making the connection ------
		Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
		
		'This one works if you know the physical path
		'strConnection += "Data Source=C:\breweries.mdb"

		'This works as long as database is in same directory as page 
		'strConnection += "Data Source= "& Server.MapPath("breweries.mdb")
		
		'I believe this works if files are actually on Server - not for virtual web folders
		'strConnection += "Data Source = "& Server.MapPath("\_private\breweries.mdb")
		'Full string version of above
	'Dim strConnection as String = ("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("\_private\breweries.mdb"))

		'Either of these seem to work perfectly		
		'strConnection += "Data Source = "& Request.PhysicalApplicationPath & "_private\breweries.mdb;"
		strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\breweries.mdb")
		'--------Connection made ---------
		
		data_src.text= strConnection
		
		Dim strSQL as string = "SELECT BName, City FROM tblBrewery"
		Dim strResultsHolder as string

		Dim objConnection as New OLEDBConnection(strConnection)
		Dim objCommand as New OledbCommand(strSQL, objConnection)
		Dim objDataReader as OledbDataReader

		Try
			objConnection.Open()
			con_open.text="Connection opened successfully.<BR />"
		objDataReader = objCommand.ExecuteReader()				

		Do While objDataReader.Read()=True
			strResultsHolder +=objDataReader("BName")
			strResultsHolder +="&nbsp;"
			strResultsHolder +=objDataReader("City")
			strResultsHolder +="<BR />"
		Loop

		objDataReader.Close()

			objConnection.Close()
			con_close.text="Connection closed.<BR />"
		divBrewery.innerHTML = strResultsHolder
		Catch e as Exception
			con_open.text="Connection failed to open.<BR />"
			con_close.text=e.ToString()
		End Try
	End Sub
</SCRIPT>


<html>

<head>
<title>B.C. Beer Guide - Breweries </title>
<meta content="no index,no follow" name="robots" >
<link rel="stylesheet" type="text/css" href="bcbgstyle.css">
</head>

<body bgcolor="#FFFFFF" link="#800000" vlink="#CC3300" text="#000000">



<H2>Testing the data connection</H2>
<ASP:LABEL ID="data_src" RUNAT="server" /><BR />
<ASP:LABEL ID="con_open" RUNAT="server" /><BR />

<H2>Listing breweries and their locations</H2>
<DIV ID="divBrewery" runat="server">List here</DIV>

<ASP:LABEL ID="con_close" RUNAT="server" /><BR />


</body>
</html>
