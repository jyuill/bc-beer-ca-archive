<%@ Page Language="VB"   ValidateRequest="false" MaintainScrollPositionOnPostback="true" MasterPageFile="~/admin/MasterAdmin.master" Title="BCBG Admin: Links" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>


<script runat="server">

Protected Sub DetailsView1_ItemDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewDeletedEventArgs)
        GridView1.DataBind()
    End Sub
    
    Protected Sub DetailsView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewInsertedEventArgs)
        GridView1.DataBind()
    End Sub
    
    Protected Sub DetailsView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewUpdatedEventArgs)
        GridView1.DataBind()
    End Sub
    
    Protected Sub DetailsView1_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles DetailsView1.PreRender
        If DetailsView1.CurrentMode = DetailsViewMode.Insert Then
            Dim txtDate As TextBox = DetailsView1.FindControl("TextBox5")
            If txtDate.Text = String.Empty Then
                txtDate.Text = Today()
            End If
            Dim txtRating As TextBox = DetailsView1.FindControl("TextBox3")
            If txtRating.Text = String.Empty Then
                txtRating.Text = "0"
            End If
        End If
        If DetailsView1.CurrentMode = DetailsViewMode.Edit Then
            Dim txtDate As TextBox = DetailsView1.FindControl("TextBox4")
            txtDate.Text = Today()
            Dim txtRating As TextBox = DetailsView1.FindControl("TextBox2")
            If txtRating.Text = String.Empty Then
                txtRating.Text = "0"
            End If
        End If
    End Sub

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="LinksContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h2>
        Edit/Add Links<asp:AccessDataSource ID="AccessDataSource1" runat="server" ConflictDetection="CompareAllValues"
            DataFile="~/_private/Breweries.mdb" DeleteCommand="DELETE FROM [tblLinks] WHERE [LName] = ? AND [LRating] = ? AND [URL] = ? AND [Category] = ? AND [Description] = ? AND [Status] = ? AND [LDate] = ?"
            InsertCommand="INSERT INTO [tblLinks] ([LName], [LRating], [URL], [Category], [Description], [Status], [LDate]) VALUES (?, ?, ?, ?, ?, ?, ?)"
            OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT [LName], [LRating], [URL], [Category], [Description], [Status], [LDate] FROM [tblLinks] ORDER BY [LName]"
            UpdateCommand="UPDATE [tblLinks] SET [LRating] = ?, [URL] = ?, [Category] = ?, [Description] = ?, [Status] = ?, [LDate] = ? WHERE [LName] = ? AND [LRating] = ? AND [URL] = ? AND [Category] = ? AND [Description] = ? AND [Status] = ? AND [LDate] = ?">
            <DeleteParameters>
                <asp:Parameter Name="original_LName" Type="String" />
                <asp:Parameter Name="original_LRating" Type="Int32" />
                <asp:Parameter Name="original_URL" Type="String" />
                <asp:Parameter Name="original_Category" Type="String" />
                <asp:Parameter Name="original_Description" Type="String" />
                <asp:Parameter Name="original_Status" Type="String" />
                <asp:Parameter Name="original_LDate" Type="DateTime" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="LRating" Type="Int32" />
                <asp:Parameter Name="URL" Type="String" />
                <asp:Parameter Name="Category" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Status" Type="String" />
                <asp:Parameter Name="LDate" Type="DateTime" />
                <asp:Parameter Name="original_LName" Type="String" />
                <asp:Parameter Name="original_LRating" Type="Int32" />
                <asp:Parameter Name="original_URL" Type="String" />
                <asp:Parameter Name="original_Category" Type="String" />
                <asp:Parameter Name="original_Description" Type="String" />
                <asp:Parameter Name="original_Status" Type="String" />
                <asp:Parameter Name="original_LDate" Type="DateTime" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="LName" Type="String" />
                <asp:Parameter Name="LRating" Type="Int32" />
                <asp:Parameter Name="URL" Type="String" />
                <asp:Parameter Name="Category" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Status" Type="String" />
                <asp:Parameter Name="LDate" Type="DateTime" />
            </InsertParameters>
        </asp:AccessDataSource>
    </h2>
    <h3>
        Select Link to Display Details (or to ADD new one)</h3>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" CellPadding="4" DataKeyNames="LName" DataSourceID="AccessDataSource1"
        ForeColor="#333333" GridLines="None">
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <Columns>
            <asp:CommandField ShowSelectButton="True" />
            <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category" />
            <asp:BoundField DataField="LName" HeaderText="LName" ReadOnly="True" SortExpression="LName" />
            <asp:BoundField DataField="URL" HeaderText="URL" SortExpression="URL" />
            <asp:BoundField DataField="LRating" HeaderText="LRating" SortExpression="LRating" />
            <asp:BoundField DataField="LDate" DataFormatString="{0:dd/MM/yyyy}" HeaderText="LDate"
                HtmlEncode="False" SortExpression="LDate" />
        </Columns>
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:AccessDataSource ID="AccessDataSource2" runat="server" ConflictDetection="CompareAllValues"
        DataFile="~/_private/Breweries.mdb" 
        DeleteCommand="DELETE FROM [tblLinks] WHERE [LName] = ?"
        InsertCommand="INSERT INTO [tblLinks] ([LName], [LRating], [URL], [Category], [Description], [Status], [LDate]) VALUES (?, ?, ?, ?, ?, ?, ?)"
        OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT [LName], [LRating], [URL], [Category], [Description], [Status], [LDate] FROM [tblLinks] WHERE ([LName] = ?)"
        UpdateCommand="UPDATE [tblLinks] SET [LRating] = ?, [URL] = ?, [Category] = ?, [Description] = ?, [Status] = ?, [LDate] = ? WHERE [LName] = ? AND [LRating] = ? AND [URL] = ? AND [Category] = ? AND [Description] = ? AND [Status] = ? AND [LDate] = ?">
        <DeleteParameters>
            <asp:Parameter Name="original_LName" Type="String" />
            <asp:Parameter Name="original_LRating" Type="Int32" />
            <asp:Parameter Name="original_URL" Type="String" />
            <asp:Parameter Name="original_Category" Type="String" />
            <asp:Parameter Name="original_Description" Type="String" />
            <asp:Parameter Name="original_Status" Type="String" />
            <asp:Parameter Name="original_LDate" Type="DateTime" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="LRating" Type="Int32" />
            <asp:Parameter Name="URL" Type="String" />
            <asp:Parameter Name="Category" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Status" Type="String" />
            <asp:Parameter Name="LDate" Type="DateTime" />
            <asp:Parameter Name="original_LName" Type="String" />
            <asp:Parameter Name="original_LRating" Type="Int32" />
            <asp:Parameter Name="original_URL" Type="String" />
            <asp:Parameter Name="original_Category" Type="String" />
            <asp:Parameter Name="original_Description" Type="String" />
            <asp:Parameter Name="original_Status" Type="String" />
            <asp:Parameter Name="original_LDate" Type="DateTime" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="GridView1" Name="LName" PropertyName="SelectedValue"
                Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="LName" Type="String" />
            <asp:Parameter Name="LRating" Type="Int32" />
            <asp:Parameter Name="URL" Type="String" />
            <asp:Parameter Name="Category" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Status" Type="String" />
            <asp:Parameter Name="LDate" Type="DateTime" />
        </InsertParameters>
    </asp:AccessDataSource>
    <asp:AccessDataSource ID="AccessDataSource3" runat="server" DataFile="~/_private/Breweries.mdb"
        SelectCommand="SELECT [Category] FROM [tblLinkCategory] ORDER BY [Category]"></asp:AccessDataSource>
    <asp:AccessDataSource ID="AccessDataSource4" runat="server" DataFile="~/_private/Breweries.mdb"
        SelectCommand="SELECT [Status] FROM [tblLinkStatus] ORDER BY [Status]"></asp:AccessDataSource>
    <br />
    <h3>
        Selected Link Displayed Here</h3>
    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" CellPadding="4"
        DataKeyNames="LName" DataSourceID="AccessDataSource2" ForeColor="#333333" GridLines="None"
        Height="50px" Width="100%" OnItemDeleted="DetailsView1_ItemDeleted" OnItemInserted="DetailsView1_ItemInserted" OnItemUpdated="DetailsView1_ItemUpdated">
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <CommandRowStyle BackColor="#FFFFC0" Font-Bold="True" />
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <Fields>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" />
            <asp:TemplateField HeaderText="LName" SortExpression="LName">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("LName") %>' Width="184px"></asp:Label>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("LName") %>' Width="300px"></asp:TextBox>
                </InsertItemTemplate>
                <HeaderStyle Width="75px" />
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("LName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="URL" SortExpression="URL">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("URL") %>' Width="400px"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("URL") %>' Width="400px"></asp:TextBox>
                </InsertItemTemplate>
                <HeaderStyle Width="75px" />
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("URL") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Category" SortExpression="Category">
                <EditItemTemplate>
                    &nbsp;<asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="AccessDataSource3"
                        DataTextField="Category" DataValueField="Category" SelectedValue='<%# Bind("Category") %>'
                        Width="220px">
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    &nbsp;<asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="AccessDataSource3" DataTextField="Category" DataValueField="Category" Width="220px" SelectedValue='<%# Bind("Category") %>'>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <HeaderStyle Width="75px" />
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Category") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Description" SortExpression="Description" HeaderStyle-VerticalAlign="Top">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Description") %>' Rows="5" TextMode="MultiLine" Width="90%"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Description") %>' Rows="5" TextMode="MultiLine" Width="90%"></asp:TextBox>
                </InsertItemTemplate>
                <HeaderStyle Width="75px" />
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="LRating" SortExpression="LRating">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("LRating") %>' Width="25px"></asp:TextBox>
                    (0-5, higher is better)
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("LRating") %>' Width="25px"></asp:TextBox>
                    (0-5, higher is better)
                </InsertItemTemplate>
                <HeaderStyle Width="75px" />
                <ItemTemplate>
                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("LRating") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Status" SortExpression="Status">
                <EditItemTemplate>
                    &nbsp;<asp:DropDownList ID="DropDownList4" runat="server" DataSourceID="AccessDataSource4"
                        DataTextField="Status" DataValueField="Status" SelectedValue='<%# Bind("Status") %>'>
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    &nbsp;<asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="AccessDataSource4"
                        DataTextField="Status" DataValueField="Status" Width="114px" SelectedValue='<%# Bind("Status") %>'>
                    </asp:DropDownList>
                </InsertItemTemplate>
                <HeaderStyle Width="75px" />
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="LDate" SortExpression="LDate">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("LDate") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("LDate", "{0:dd/MM/yyyy}") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("LDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" />
        </Fields>
        <FieldHeaderStyle BackColor="#FFFF99" Font-Bold="True" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:DetailsView>
        <UserControl:Footadmin id="UserControl1" runat="server" />

</asp:Content>

