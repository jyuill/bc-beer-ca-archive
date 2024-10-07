<%@ IMPORT Namespace="System.Data" %>
<%@ IMPORT Namespace="System.Data.OLEDB" %>

<SCRIPT LANGUAGE="VB" RUNAT="server">
	Sub Page_Load()
		'------- Making the connection ------
		Dim strConnection as String = "Provider=Microsoft.Jet.OLEDB.4.0;"
		
		'Either of these seem to work perfectly		
		'strConnection += "Data Source = "& Request.PhysicalApplicationPath & "_private\relatives.mdb;"
		strConnection += "Data Source = "& Request.PhysicalApplicationPath & ("_private\relatives.mdb")
		'--------Connection made ---------
		
		data_src.text= strConnection
		
		Dim strSQL as string = "SELECT Name, Relation, City FROM tblRelatives"
		Dim strResultsHolder as string

		Dim objConnection as New OLEDBConnection(strConnection)
		Dim objCommand as New OledbCommand(strSQL, objConnection)
		Dim objDataReader as OledbDataReader

		Try
			objConnection.Open()
			con_open.text="Connection opened successfully.<BR />"
		objDataReader = objCommand.ExecuteReader()				

		Do While objDataReader.Read()=True
			strResultsHolder +=objDataReader("Name")
			strResultsHolder +="&nbsp;"
			strResultsHolder +=objDataReader("Relation")
			strResultsHolder +="&nbsp;"
			strResultsHolder +=objDataReader("City")
			strResultsHolder +="<BR />"
		Loop

		objDataReader.Close()

			objConnection.Close()
			con_close.text="Connection closed.<BR />"
		divFamily.innerHTML = strResultsHolder
		Catch e as Exception
			con_open.text="Connection failed to open.<BR />"
			con_close.text=e.ToString()
		End Try
	End Sub
</SCRIPT>

<html>

<head>
<title>Database ASP.NET </title>

</head>

<H1>Testing ASP.NET Database</H1>
<p>Primitive but effective test for database connection and display.</p>
<H2>Testing the data connection</H2>
<ASP:LABEL ID="data_src" RUNAT="server" /><BR />
<ASP:LABEL ID="con_open" RUNAT="server" /><BR />

<H2>Listing relatives and their locations</H2>
<DIV ID="divFamily" runat="server">List here</DIV>
<P>
<ASP:LABEL ID="con_close" RUNAT="server" /><BR />

</body>
</html>
