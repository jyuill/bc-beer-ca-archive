<%@ Control %>
<%@ import Namespace="System.IO" %>
<script runat="server">

    Public Oncolor As String = "orange"
    Public Offcolor As String = "white"
    Public Onheight As String = "24px"
    Public Offheight As String = "22px"
    Public Onpage As String = "tabpage"
    Public Offpage As String = "tabnav"
    Public tab1 As String = "tab1"
    Public tabOn As String = "tabOn"
    'This variable for sure needs to be declared outside sub in order to work in table below
    Public strNavTabs(8) As String
    Public strNavTabsH(8) As String
    Public strLink(8) As String
    Public strNavTab(8) As String
    
    Sub Page_Load()
    
    strNavTabs(0) = Offcolor
    strNavTabs(1) = Offcolor
    strNavTabs(2) = Offcolor
    strNavTabs(3) = Offcolor
    strNavTabs(4) = Offcolor
    strNavTabs(5) = Offcolor
    strNavTabs(6) = Offcolor
    strNavTabs(7) = Offcolor
    
    strNavTabsH(0) = Offheight
    strNavTabsH(1) = Offheight
    strNavTabsH(2) = Offheight
    strNavTabsH(3) = Offheight
    strNavTabsH(4) = Offheight
    strNavTabsH(5) = Offheight
    strNavTabsH(6) = Offheight
    strNavTabsH(7) = Offheight
    
    strLink(0) = Offpage
    strLink(1) = Offpage
    strLink(2) = Offpage
    strLink(3) = Offpage
    strLink(4) = Offpage
    strLink(5) = Offpage
    strLink(6) = Offpage
    strLink(7) = Offpage
    
    strNavTab(0) = tab1 
    strNavTab(1) = tab1
    strNavTab(2) = tab1
    strNavTab(3) = tab1
    strNavTab(4) = tab1
    strNavTab(5) = tab1
    strNavTab(6) = tab1
    strNavTab(7) = tab1
    
            Dim Filename as String
            Dim objFl as FileInfo
    
            Filename = Request.ServerVariables("Path_Translated")
            objFl = new FileInfo(Filename)
    
            Select Case objFl.Name
                Case "navtemplate.aspx"
                    strNavTabs(0)=OnColor
                    strNavTabsH(0)=Onheight
                    strLink(0)=Onpage
                Case "defaultnewnav.aspx"
                    strNavTabs(0)=Oncolor
                Case "brewery.aspx"
                    strNavTabs(1)=Oncolor
                    strNavTabsH(1)=Onheight
                    strLink(1)=Onpage
                    strNavTab(1)=tabOn
                Case "nav1menu4.aspx"
                    strNavTabs(2)=Oncolor
                Case "nav1menu7.aspx"
                    strNavTabs(3)=Oncolor
            End Select
    
    End Sub

</script>

<!--DIV for navbar-->
<div class="navbar3">
    <div class="tab1" style="LEFT: 5px"><a class="<%=strLink(0)%>" href="defaultnewnav.aspx">Home</a>
    </div>
    <div class="<%=strNavTab(1)%>" style="LEFT: 97px"><a class="<%=strLink(1)%>" href="brewery.aspx">Breweries</a>
    </div>
    <div class="tab1" style="LEFT: 189px"><a class="tabnav" href="xoriginal/brewpubs.htm">Brewpubs</a>
    </div>
    <div class="tab1" style="LEFT: 281px"><a class="tabnav" href="xoriginal/NEWS.HTM">News/Events</a>
    </div>
    <div class="tab1" style="LEFT: 373px"><a class="tabnav" href="discuss.htm">Discussion</a>
    </div>
    <div class="tab1" style="LEFT: 465px"><a class="tabnav" href="xoriginal/books.htm">Beer Books</a>
    </div>
    <div class="tab1" style="LEFT: 557px"><a class="tabnav" href="xoriginal/links.htm">Beer Links</a>
    </div>
    <div class="tab1" style="LEFT: 649px"><a class="tabnav" href="about.htm">About Us</a>
    </div>
</div>

