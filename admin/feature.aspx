<%@ Page Language="VB" MasterPageFile="~/admin/MasterAdmin.master"  ValidateRequest="false" Title="Add/Edit Feature" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>

<script runat="server">
   
    'Updates GridView when records added in DetailsView
    Protected Sub DetailsView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewUpdatedEventArgs)
        GridView1.DataBind()
    End Sub

    'Updates GridView when records deleted in DetailsView
    Protected Sub DetailsView1_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewDeletedEventArgs)
        GridView1.DataBind()
    End Sub
    
    'Updates GridView when records added in DetailsView
    Protected Sub DetailsView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewInsertedEventArgs)
        GridView1.DataBind()
    End Sub
    
    Protected Sub DetailsView1_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles DetailsView1.PreRender
        If DetailsView1.CurrentMode = DetailsViewMode.Insert Then
            Dim txtDate As TextBox = DetailsView1.FindControl("TextBox6")
                    
            If txtDate.Text = String.Empty Then
                txtDate.Text = Today.ToShortDateString
                txtDate.Text = Date.Now
                '-- Tried some options to get the LFC server to accept d/m/y data.
                '-- Could not get it to work, despite success on other pages.
                '-- Accepted as trade-off for much simpler programming here than other pages.
                'Dim dtFeatureD As DateTime
                'dtFeatureD = String.Format("{0:dd/MM/yyyy}", Date.Now)
                'txtDate.Text = dtFeatureD
                'txtDate.Text = String.Format("{0:dd/MM/yyyy}", DateTime.Now)
            End If
            Dim txtImage As TextBox = DetailsView1.FindControl("TextBox5")
            If txtImage.Text = String.Empty Then
                txtImage.Text = "blank.gif"
            End If
            Dim chkShow As CheckBox = DetailsView1.FindControl("CheckBox1")
            If chkShow.Checked = False Then
                chkShow.Checked = True
            End If
        End If
    End Sub

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="LinksContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h2>
        Add/Edit Feature</h2>
    <h3>
        Select Feature to Display Details</h3>
    <asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/_private/Breweries.mdb"
        SelectCommand="SELECT [fnum], [fdate], [fsub], [ftitle], [fcontent], [flink], [fimage] FROM [tblFeature] ORDER BY [fdate] DESC">
    </asp:AccessDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" CellPadding="4" DataKeyNames="fnum" DataSourceID="AccessDataSource1"
        ForeColor="#333333" GridLines="None">
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <Columns>
            <asp:CommandField ShowSelectButton="True" />
            <asp:BoundField DataField="fnum" HeaderText="fnum" InsertVisible="False" ReadOnly="True"
                SortExpression="fnum" />
            <asp:BoundField DataField="fdate" HeaderText="Date" SortExpression="fdate" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="False" />
            <asp:BoundField DataField="fsub" HeaderText="Subject" SortExpression="fsub" />
            <asp:BoundField DataField="ftitle" HeaderText="Headline Title" SortExpression="ftitle" />
        </Columns>
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <br />
    <h3>
        Edit/Delete/Add Feature Items Here</h3>
    <span class="smaller">(Select feature above to display details or to ADD new feature)</span><br />
    <asp:AccessDataSource ID="AccessDataSource2" runat="server" ConflictDetection="CompareAllValues"
        DataFile="~/_private/Breweries.mdb" 
        DeleteCommand="DELETE FROM [tblFeature] WHERE [fnum] = ?"
        InsertCommand="INSERT INTO [tblFeature] ([fdate], [fsub], [ftitle], [fcontent], [flink], [fimage], [fshow]) VALUES (?, ?, ?, ?, ?, ?, ?)"
        OldValuesParameterFormatString="original_{0}" 
        SelectCommand="SELECT [fnum], [fdate], [fsub], [ftitle], [fcontent], [flink], [fimage], [fshow] FROM [tblFeature] WHERE ([fnum] = ?)"
        UpdateCommand="UPDATE [tblFeature] SET [fdate] = ?, [fsub] = ?, [ftitle] = ?, [fcontent] = ?, [flink] = ?, [fimage] = ?, [fshow]=? WHERE [fnum] = ?">
        <DeleteParameters>
            <asp:Parameter Name="original_fnum" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="fdate" Type="DateTime" />
            <asp:Parameter Name="fsub" Type="String" />
            <asp:Parameter Name="ftitle" Type="String" />
            <asp:Parameter Name="fcontent" Type="String" />
            <asp:Parameter Name="flink" Type="String" />
            <asp:Parameter Name="fimage" Type="String" />
            <asp:Parameter Name="fshow" Type="Boolean" />
            <asp:Parameter Name="original_fnum" Type="Int32" />
            <asp:Parameter Name="original_fdate" Type="DateTime" />
            <asp:Parameter Name="original_fsub" Type="String" />
            <asp:Parameter Name="original_ftitle" Type="String" />
            <asp:Parameter Name="original_fcontent" Type="String" />
            <asp:Parameter Name="original_flink" Type="String" />
            <asp:Parameter Name="original_fimage" Type="String" />
            <asp:Parameter Name="original_fshow" Type="Boolean" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="GridView1" Name="fnum" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="fdate" Type="DateTime" />
            <asp:Parameter Name="fsub" Type="String" />
            <asp:Parameter Name="ftitle" Type="String" />
            <asp:Parameter Name="fcontent" Type="String" />
            <asp:Parameter Name="flink" Type="String" />
            <asp:Parameter Name="fimage" Type="String" />
            <asp:Parameter Name="fshow" Type="Boolean" />
        </InsertParameters>
    </asp:AccessDataSource>
    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" CellPadding="4"
        DataKeyNames="fnum" DataSourceID="AccessDataSource2" ForeColor="#333333" GridLines="None"
        Height="50px" Width="100%" OnItemUpdated="DetailsView1_ItemUpdated" OnItemDeleted="DetailsView1_ItemDeleted" OnItemInserted="DetailsView1_ItemInserted">
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <CommandRowStyle BackColor="#FFFFC0" Font-Bold="True" />
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <Fields>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" />
            <asp:BoundField DataField="fnum" HeaderText="fnum" InsertVisible="False" ReadOnly="True"
                SortExpression="fnum" >
                <HeaderStyle Width="100px" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Date" SortExpression="fdate">
                <EditItemTemplate>
                <%--Do not add date format here - server will not accept. Don't know why since other data input
                pages on site submit date in d/m/y order without problem...but more manual programming.--%>
                    <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("fdate") %>'></asp:TextBox>
                    (m/d/y required by server for input; will be displayed as d/m/y on site pages)
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("fdate", "{0:dd/MM/yyyy}") %>'></asp:TextBox>
                    (m/d/y required by server for input; display on pages will be d/m/y; time is used to sort features added same day)
                </InsertItemTemplate>
                <HeaderStyle Width="100px" />
                <ItemTemplate>
                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("fdate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                </ItemTemplate>
                <ControlStyle Width="150px" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="General Subject" SortExpression="fsub">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("fsub") %>' Width="100%"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("fsub") %>' Width="100%"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("fsub") %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle Width="100px" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Title" SortExpression="ftitle">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("ftitle") %>' Width="100%"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("ftitle") %>' Width="100%"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("ftitle") %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle Width="100px" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Content" SortExpression="fcontent">
                <EditItemTemplate>
                    <FTB:freetextbox id="TextBox3" 
		supportfolder="~/FtbWebResource.axd" text='<%# Bind("fcontent") %>' runat="Server" Height="150px" />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <FTB:freetextbox id="TextBox3" 
		supportfolder="~/FtbWebResource.axd" text='<%# Bind("fcontent") %>' runat="Server" Height="150px" />    
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("fcontent") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Link" SortExpression="flink">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("flink") %>' Width="100%"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("flink") %>' Width="100%"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("flink") %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle Width="100px" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Image file" SortExpression="fimage">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("fimage") %>' Width="150px"></asp:TextBox>
                    (width: 75-100px; blank.gif for blank)
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("fimage") %>' Width="150px"></asp:TextBox>
                    (width: 75-100px; blank.gif for blank)&nbsp;
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("fimage") %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle Width="100px" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Show?">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("fshow") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("fshow") %>' />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("fshow") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" />
        </Fields>
        <FieldHeaderStyle BackColor="#FFFF99" Font-Bold="True" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:DetailsView>
</asp:Content>

