<%@ Control Language="VB" %>
<%@ import Namespace="System.IO" %>
<script runat="server">

    Sub Page_Load()
    
      If Not IsPostback Then
    
        '---Getting file save date
        Dim Filename as String
        Dim SaveDate as DateTime
        
        Filename = Request.ServerVariables("Path_Translated")
        SaveDate = File.GetLastWriteTime(Filename)
        lblSaveDate.Text = SaveDate.ToLongDateString()
        '----
        
      End If  
    End Sub
    
</script>
<span class="sdate">Updated:&nbsp;
<asp:label id="lblSaveDate" runat="server" />
</span>
