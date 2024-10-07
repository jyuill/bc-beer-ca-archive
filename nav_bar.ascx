<%@ Control %>
<%@ import Namespace="System.IO" %>
<script runat="server">

    'These variables refer to styles on linked CSS
    Public Onpage As String = "tabpage"
    Public Offpage As String = "tabnav"
    Public tab1 As String = "tab1"
    Public tabOn As String = "tabOn"
    'These variables used in navbar div to set CSS style depending on whether or not current page
    Public strNavTab(9) As String
    Public strLink(9) As String
    
    Sub Page_Load()
    
    strNavTab(0) = tab1
    strNavTab(1) = tab1
    strNavTab(2) = tab1
    strNavTab(3) = tab1
    strNavTab(4) = tab1
    strNavTab(5) = tab1
    strNavTab(6) = tab1
        strNavTab(7) = tab1
        strNavTab(8) = tab1
    
    strLink(0) = Offpage
    strLink(1) = Offpage
    strLink(2) = Offpage
    strLink(3) = Offpage
    strLink(4) = Offpage
    strLink(5) = Offpage
    strLink(6) = Offpage
        strLink(7) = Offpage
        strLink(8) = Offpage
    
    
            Dim Filename as String
            Dim objFl as FileInfo
    
            Filename = Request.ServerVariables("Path_Translated")
            objFl = new FileInfo(Filename)
    
            Select Case objFl.Name
                Case "default.aspx"
                    strNavTab(0)=tabOn
                    strLink(0)=Onpage
                Case "brewery.aspx"
                    strNavTab(1)=tabOn
                    strLink(1)=Onpage
                Case "Brewery.aspx"
                    strNavTab(1)=tabOn
                    strLink(1)=Onpage
                Case "breweryselect.aspx"
                    strNavTab(1)=tabOn
                    strLink(1)=Onpage
                'Case "brewerycommentv.aspx"
                '    strNavTab(1)=tabOn
                '    strLink(1)=Onpage
                'Case "brewerycomment.aspx"
                '    strNavTab(1)=tabOn
                '    strLink(1)=Onpage 
                'Case "BreweryCommentv.aspx"
                '    strNavTab(1)=tabOn
                '    strLink(1)=Onpage       
                Case "brands.aspx"
                    strNavTab(2)=tabOn
                    strLink(2)=Onpage
                Case "news.aspx"
                    strNavTab(3)=tabOn
                strLink(3) = Onpage
            Case "feature.aspx"
                strNavTab(4) = tabOn
                strLink(4) = Onpage
            Case "featureselect.aspx"
                strNavTab(4) = tabOn
                strLink(4) = Onpage
            Case "links.aspx"
                strNavTab(5) = tabOn
                strLink(5) = Onpage
            Case "store.aspx"
                strNavTab(6) = tabOn
                strLink(6) = Onpage
            Case "about.aspx"
                strNavTab(7) = tabOn
                strLink(7) = Onpage
        End Select
    
    End Sub

</script>
<!-- Creates DIV for Navigation Bar at top -->
<div class="<%=strNavTab(0)%>" style="LEFT: 5px"><a class="<%=strLink(0)%>" href="default.aspx">Home</a></div>
<div class="<%=strNavTab(1)%>" style="LEFT: 95px"><a class="<%=strLink(1)%>" href="brewery.aspx">Breweries</a></div>
<div class="<%=strNavTab(2)%>" style="LEFT: 185px"><a class="<%=strLink(2)%>" href="brands.aspx">Beers</a></div>
<div class="<%=strNavTab(3)%>" style="LEFT: 275px"><a class="<%=strLink(3)%>" href="news.aspx">News/Events</a></div>
<div class="<%=strNavTab(4)%>" style="LEFT: 365px"><a class="<%=strLink(4)%>" href="feature.aspx">Features</a></div>
<div class="<%=strNavTab(5)%>" style="LEFT: 455px"><a class="<%=strLink(5)%>" href="links.aspx">Beer Links</a></div>
<div class="<%=strNavTab(6)%>" style="LEFT: 545px"><a class="<%=strLink(6)%>" href="store.aspx">Poster</a></div>
<div class="<%=strNavTab(7)%>" style="LEFT: 635px"><a class="<%=strLink(7)%>" href="about.aspx">About BCBG</a></div>
<div class="tab2"><a href="admin/default.aspx" class="admin">+</a></div>


