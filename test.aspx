<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" ContentType="text/html" ResponseEncoding="iso-8859-1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<script language="VB" runat="server">
Dim strX as String = "Hello"

sub Page_Load(Sender as object, e as eventargs)
     testResponse()
end sub

Sub testResponse()
	Response.Write(strX) 
End Sub


</script>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>
<body>
<h1>Anything</h1>
<p>If it says 'Hello' above 'Anything' then this thing works.</p>
</body>
</html>
