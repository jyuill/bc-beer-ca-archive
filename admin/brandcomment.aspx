<%@ Page Language="VB"  MaintainScrollPositionOnPostback="true" MasterPageFile="~/admin/MasterAdmin.master" Title="BCBG Admin: Brand Comments" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>

<script runat="server">

Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        DetailsView1.PageIndex = GridView1.SelectedIndex
End Sub

    Protected Sub GridView1_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs)
        DetailsView1.DataBind()
    End Sub
    
    Protected Sub DetailsView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewUpdatedEventArgs)
        GridView1.DataBind()
    End Sub

    
    Function Truncate(ByVal strDescrip As String)
        Dim intLength As Integer
        intLength = 50
        If strDescrip.Length < intLength Then
            Return strDescrip
        Else
            Return strDescrip.Substring(0, intLength) & "..."
        End If
    End Function
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="LinksContent" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h2>
        Brand Comments from Visitors</h2>
    <asp:AccessDataSource ID="AccessDataSource1" runat="server" ConflictDetection="CompareAllValues"
        DataFile="~/_private/Breweries.mdb" 
        DeleteCommand="DELETE FROM [tblBrandComment] WHERE [Number] = ?"
        InsertCommand="INSERT INTO tblBrandComment([Number], Brand, UComment, DateCom, Author, Email, Loc, Gen_UComment, s_ColLineage, s_Generation, s_GUID, s_Lineage, URating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,)"
        OldValuesParameterFormatString="original_{0}" 
        SelectCommand="SELECT tblBrandComment.[Number], tblBrewery.BName AS BreweryName, tblBrand.Brand AS BrandName, tblBrandComment.UComment, tblBrandComment.DateCom, tblBrandComment.Author, tblBrandComment.Email, tblBrandComment.Loc, tblBrandComment.URating FROM ((tblBrandComment INNER JOIN tblBrand ON tblBrandComment.Brand = tblBrand.BdNumber) INNER JOIN tblBrewery ON tblBrand.BName = tblBrewery.[Number]) ORDER BY tblBrandComment.DateCom DESC"
        UpdateCommand="UPDATE tblBrandComment SET Brand = ?, UComment = ?, DateCom = ?, Author = ?, Email = ?, Loc = ?, Gen_UComment = ?, s_ColLineage = ?, s_Generation = ?, s_GUID = ?, s_Lineage = ?, URating = WHERE ([Number] = ?) AND (Brand = ?) AND (UComment = ?) AND (DateCom = ?) AND (Author = ?) AND (Email = ?) AND (Loc = ?) AND (Gen_UComment = ?) AND (s_ColLineage = ?) AND (s_Generation = ?) AND (s_GUID = ?) AND (s_Lineage = ?)">
        <DeleteParameters>
            <asp:Parameter Name="original_Number" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Brand" Type="Int32" />
            <asp:Parameter Name="UComment" Type="String" />
            <asp:Parameter Name="DateCom" Type="DateTime" />
            <asp:Parameter Name="Author" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Loc" Type="String" />
            <asp:Parameter Name="Gen_UComment" Type="Int32" />
            <asp:Parameter Name="s_ColLineage" Type="Object" />
            <asp:Parameter Name="s_Generation" Type="Int32" />
            <asp:Parameter Name="s_GUID" Type="Object" />
            <asp:Parameter Name="s_Lineage" Type="Object" />
            <asp:Parameter Name="original_Number" Type="Int32" />
            <asp:Parameter Name="original_Brand" Type="Int32" />
            <asp:Parameter Name="original_UComment" Type="String" />
            <asp:Parameter Name="original_DateCom" Type="DateTime" />
            <asp:Parameter Name="original_Author" Type="String" />
            <asp:Parameter Name="original_Email" Type="String" />
            <asp:Parameter Name="original_Loc" Type="String" />
            <asp:Parameter Name="original_Gen_UComment" Type="Int32" />
            <asp:Parameter Name="original_s_ColLineage" Type="Object" />
            <asp:Parameter Name="original_s_Generation" Type="Int32" />
            <asp:Parameter Name="original_s_GUID" Type="Object" />
            <asp:Parameter Name="original_s_Lineage" Type="Object" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Number" Type="Int32" />
            <asp:Parameter Name="Brand" Type="Int32" />
            <asp:Parameter Name="UComment" Type="String" />
            <asp:Parameter Name="DateCom" Type="DateTime" />
            <asp:Parameter Name="Author" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Loc" Type="String" />
            <asp:Parameter Name="Gen_UComment" Type="Int32" />
            <asp:Parameter Name="s_ColLineage" Type="Object" />
            <asp:Parameter Name="s_Generation" Type="Int32" />
            <asp:Parameter Name="s_GUID" Type="Object" />
            <asp:Parameter Name="s_Lineage" Type="Object" />
        </InsertParameters>
    </asp:AccessDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False"
        DataSourceID="AccessDataSource1" AllowPaging="True" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDeleted="GridView1_RowDeleted" CellPadding="1" DataKeyNames="Number">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowSelectButton="True" />
            <asp:BoundField DataField="Number" HeaderText="Number" InsertVisible="False" SortExpression="Number" />
            <asp:BoundField DataField="DateCom" DataFormatString="{0:dd/MM/yyyy}" HeaderText="DateCom"
                HtmlEncode="False" SortExpression="DateCom" />
            <asp:BoundField DataField="BreweryName" HeaderText="BreweryName" SortExpression="BreweryName" />
            <asp:BoundField DataField="BrandName" HeaderText="BrandName" SortExpression="BrandName" />
            <asp:TemplateField HeaderText="Comment" SortExpression="UComment">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("UComment") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Truncate(Eval("UComment")) %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="URating" HeaderText="URating" SortExpression="URating" />
            <asp:BoundField DataField="Author" HeaderText="Author" SortExpression="Author" />
        </Columns>
    </asp:GridView>
    <asp:AccessDataSource ID="AccessDataSource2" runat="server" DataFile="~/_private/Breweries.mdb"
        SelectCommand="SELECT tblBrandComment.[Number], tblBrandComment.Brand, tblBrandComment.UComment, tblBrandComment.DateCom, tblBrandComment.Author, tblBrandComment.Email, tblBrandComment.Loc, tblBrandComment.Gen_UComment, tblBrandComment.s_ColLineage, tblBrandComment.s_Generation, tblBrandComment.s_GUID, tblBrandComment.s_Lineage, tblBrand.Brand AS BrandName, tblBrewery.BName, tblBrandComment.URating FROM ((tblBrandComment INNER JOIN tblBrand ON tblBrandComment.Brand = tblBrand.BdNumber) INNER JOIN tblBrewery ON tblBrand.BName = tblBrewery.[Number]) WHERE (tblBrandComment.[Number] = ?)" 
        OldValuesParameterFormatString="original_{0}" 
        UpdateCommand="UPDATE tblBrandComment SET UComment = ?, DateCom = ?, Author = ?, Email = ?, Loc = ?, URating = ? WHERE [Number] = ?">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridView1" Name="Number" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
         <UpdateParameters>
            <asp:Parameter Name="UComment" Type="String" />
            <asp:Parameter Name="DateCom" Type="DateTime" />
            <asp:Parameter Name="Author" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Loc" Type="String" />
            <asp:Parameter Name="URating" Type="Double" />
            <asp:Parameter Name="original_Number" Type="Int32" />
            <asp:Parameter Name="original_UComment" Type="String" />
            <asp:Parameter Name="original_DateCom" Type="DateTime" />
            <asp:Parameter Name="original_Author" Type="String" />
            <asp:Parameter Name="original_Email" Type="String" />
            <asp:Parameter Name="original_Loc" Type="String" />
            <asp:Parameter Name="original_URating" Type="Double" />
        </UpdateParameters>
    </asp:AccessDataSource>
    &nbsp;&nbsp;
    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False"
        CellPadding="4" DataSourceID="AccessDataSource2" ForeColor="#333333"
        GridLines="None" Height="50px" Width="100%" DataKeyNames="Number"
        OnItemUpdated="DetailsView1_ItemUpdated">
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <CommandRowStyle BackColor="#FFFFC0" Font-Bold="True" />
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <Fields>
            <asp:CommandField ShowEditButton="True" />
            <asp:BoundField DataField="Number" HeaderText="Number" InsertVisible="False" ReadOnly="True"
                SortExpression="Number" />
            <asp:BoundField DataField="DateCom" HeaderText="DateCom" SortExpression="DateCom" />
            <asp:BoundField DataField="BName" HeaderText="Brewery" ReadOnly="True" SortExpression="BName" />
            <%-- <asp:BoundField DataField="Brand" HeaderText="Brand" SortExpression="Brand" />--%>
            <asp:BoundField DataField="BrandName" HeaderText="BrandName" ReadOnly="True" SortExpression="BrandName" />
            <asp:TemplateField HeaderText="Comment">
                <ItemStyle />
                <HeaderStyle Width="70px" />
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("UComment") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="Textbox2" runat="server" Text='<%# Bind("UComment") %>' Width="700"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <%-- <asp:BoundField DataField="UComment" HeaderText="UComment" SortExpression="UComment" />--%>
            <asp:BoundField DataField="URating" HeaderText="URating" SortExpression="URating" />
            <asp:BoundField DataField="Author" HeaderText="Author" SortExpression="Author" />
            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
            <asp:BoundField DataField="Loc" HeaderText="Loc" SortExpression="Loc" />
            <asp:CommandField ShowEditButton="True" />
        </Fields>
        <FieldHeaderStyle BackColor="#FFFF99" Font-Bold="True" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:DetailsView>
    <br />
        <UserControl:Footadmin id="UserControl1" runat="server" />

</asp:Content>

