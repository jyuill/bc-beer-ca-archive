<%@ Control %>
<%@ import Namespace="System.IO" %>

<script runat="server">
Public css1 As String 'main stylesheet
Public css2 As String  'additional stylesheet - browser not IE, such as Firefox
Public css1h As String

'Surprisingly does not seem to conflict with page load on page calling user control
'
Sub Page_Load

		Css_selector()
    
End Sub

    Public Sub Css_selector()
        css1 = "bcbgstyle.css"
        Select Case (Request.Browser.Browser)
            Case "IE"
                css2 = ""
                Select Case (Request.Browser.MajorVersion)
                    Case "7"
                        css2 = "bcbgstyleF.css"
                End Select
            Case Else
                css2 = "bcbgstyleF.css"
        End Select
    End Sub

</script>
<link href="<%=css1%>" rel="stylesheet" type="text/css" />
<link href="<%=css2%>" rel="stylesheet" type="text/css" />
