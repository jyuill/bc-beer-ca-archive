<!--This user control includes email address & brewery search
for use on all pages-->
<%@ Control %>
<script runat="server">
    'In response to selection from brewery dropdown or
    'Go button
    'For postback when selection is changed without using button, put following in ddl tag
    'AutoPostBack="True" OnSelectedIndexChanged="BName_Click"
    Sub BName_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("breweryselect.aspx?Number=" + DropDownList1.SelectedItem.Value)
    End Sub


</script>
<div class="socialbutton">      
    <!-- AddThis Button BEGIN -->
    <div class="addthis_toolbox addthis_default_style addthis_16x16_style">
    <a class="addthis_button_facebook"></a>
    <a class="addthis_button_twitter"></a>
    <a class="addthis_button_pinterest_share"></a>
    <a class="addthis_button_google_plusone_share"></a>
    </div>
     <!-- this script section for AddThis social plugin tracking in GA -->
    <script type="text/javascript">
        var addthis_config = {
            data_ga_property: 'UA-3371059-1',
            data_ga_social: true
        }; 
    </script>
    <script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=undefined"></script>
    <!-- AddThis Button END -->
</div>
<span class="mail">
<span class="ital">Comments, questions, suggestions? </span>
<!--The unusual method of setting up 'mailto' below is devised to fool email trawlers -->
<a class="mail" onmouseover="this.href='mai' + 'lto:' + 'john' + '@' + 'bcbeer.ca'" href="mail.html">
e-mail me!</a> 
</span>
<!-- Brewery search section -->
<div style="position: relative; top: -14px; text-align: right; width: 320px; left: 454px"> 
    <em>Find a brewery:</em>&nbsp;
                    <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" 
                    DataSourceID="dsBrewery" DataTextField="BName" 
                    DataValueField="Number" Width="170px" 
                    OnSelectedIndexChanged="BName_Click"
                    AppendDataBoundItems="true" >
                    <asp:ListItem Text="-- Select a Brewery --" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button id="Button1" runat="server" text="Go" OnClick="BName_Click" CssClass="btn"></asp:Button>
                    <asp:AccessDataSource ID="dsBrewery" runat="server" DataFile="~/_private/Breweries.mdb"
                         SelectCommand="SELECT [Number], [BName] FROM [tblBrewery] ORDER BY [BName]">
                    </asp:AccessDataSource>
                </div>