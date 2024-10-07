<%@ Page Language="VB"  MaintainScrollPositionOnPostback="true" MasterPageFile="~/admin/MasterAdmin.master" Title="BCBG Admin: Brewery Comments" %>
<%@ Register TagPrefix="UserControl" TagName="Footadmin" Src="footer-admin.ascx" %>

<script runat="server">
Function Truncate(ByVal strDescrip As String)
        Dim intLength As Integer
        intLength = 60
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
        Brewery Comments from Visitors</h2>
    <asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/_private/Breweries.mdb"
        SelectCommand="SELECT tblBreweryComment.[Number], tblBrewery.BName, tblBreweryComment.UComment, tblBreweryComment.DateIn, tblBreweryComment.Author, tblBreweryComment.URating FROM (tblBrewery INNER JOIN tblBreweryComment ON tblBrewery.[Number] = tblBreweryComment.BName) ORDER BY tblBreweryComment.DateIn Desc"
        DeleteCommand="DELETE FROM [tblBreweryComment] WHERE [Number] = ?"
        OldValuesParameterFormatString="original_{0}"> 
        <DeleteParameters>
            <asp:Parameter Name="original_Number" Type="Int32" />
        </DeleteParameters>
    </asp:AccessDataSource>

    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" DataSourceID="AccessDataSource1" PageSize="20" CellPadding="2" ForeColor="#333333" GridLines="None" DataKeyNames="Number">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" DeleteText="Del" />
            <asp:BoundField DataField="Number" HeaderText="Number" InsertVisible="False" SortExpression="Number" />
            <asp:BoundField DataField="BName" HeaderText="Brewery" SortExpression="BName" />
            <asp:BoundField DataField="DateIn" HeaderText="DateIn" SortExpression="DateIn" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="False" />
            <asp:BoundField DataField="Author" HeaderText="Author" SortExpression="Author" />
            <asp:TemplateField HeaderText="Comment" SortExpression="UComment">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("UComment") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Truncate(Eval("UComment")) %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="URating" HeaderText="Rating" SortExpression="URating" />
        </Columns>
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
        <UserControl:Footadmin id="UserControl1" runat="server" />

</asp:Content>

