<%@ Page Language="VB" MasterPageFile="~/admin/MasterAdmin.master" Title="BCBG Admin: Feature Comments" %>

<script runat="server">

    Function Truncate_lng(ByVal strDescrip As String)
        Dim intLength As Integer
        intLength = 75
        If strDescrip.Length < intLength Then
            Return strDescrip
        Else
            Return strDescrip.Substring(0, intLength) & "..."
        End If
    End Function
    
    Function Truncate_sht(ByVal strDescrip As String)
        Dim intLength As Integer
        intLength = 25
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
   <br />
    <asp:AccessDataSource ID="AccessDataSource1" runat="server" ConflictDetection="CompareAllValues"
        DataFile="~/_private/Breweries.mdb" 
        DeleteCommand="DELETE FROM [tblFeatureCom] WHERE [Fcomnum] = ?"
        InsertCommand="INSERT INTO [tblFeatureCom] ([Fcomnum], [Fnum], [Fcom], [DateIn], [Author]) VALUES (?, ?, ?, ?, ?)"
        OldValuesParameterFormatString="original_{0}" 
        SelectCommand="SELECT tblFeatureCom.Fcomnum, tblFeatureCom.Fnum, tblFeatureCom.Fcom, tblFeatureCom.DateIn, tblFeatureCom.Author, tblFeature.ftitle FROM (tblFeatureCom INNER JOIN tblFeature ON tblFeatureCom.Fnum = tblFeature.fnum) ORDER BY tblFeatureCom.DateIn"
        UpdateCommand="UPDATE [tblFeatureCom] SET [Fnum] = ?, [Fcom] = ?, [DateIn] = ?, [Author] = ? WHERE [Fcomnum] = ? AND [Fnum] = ? AND [Fcom] = ? AND [DateIn] = ? AND [Author] = ?">
        <DeleteParameters>
            <asp:Parameter Name="original_Fcomnum" Type="Int32" />
            
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Fnum" Type="Int32" />
            <asp:Parameter Name="Fcom" Type="String" />
            <asp:Parameter Name="DateIn" Type="DateTime" />
            <asp:Parameter Name="Author" Type="String" />
            <asp:Parameter Name="original_Fcomnum" Type="Int32" />
            <asp:Parameter Name="original_Fnum" Type="Int32" />
            <asp:Parameter Name="original_Fcom" Type="String" />
            <asp:Parameter Name="original_DateIn" Type="DateTime" />
            <asp:Parameter Name="original_Author" Type="String" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Fcomnum" Type="Int32" />
            <asp:Parameter Name="Fnum" Type="Int32" />
            <asp:Parameter Name="Fcom" Type="String" />
            <asp:Parameter Name="DateIn" Type="DateTime" />
            <asp:Parameter Name="Author" Type="String" />
        </InsertParameters>
    </asp:AccessDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" CellPadding="4" DataKeyNames="Fcomnum" DataSourceID="AccessDataSource1"
        ForeColor="#333333" GridLines="None" PageSize="20">
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <Columns>
            <asp:CommandField ShowDeleteButton="True" />
            <asp:BoundField DataField="Fcomnum" HeaderText="Fcomnum" InsertVisible="False" ReadOnly="True"
                SortExpression="Fcomnum" />
            <asp:TemplateField HeaderText="Title" SortExpression="ftitle">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("ftitle") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Truncate_sht(Eval("ftitle")) %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="DateIn" HeaderText="DateIn" SortExpression="DateIn" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="False" />
            <asp:BoundField DataField="Author" HeaderText="Author" SortExpression="Author" />
            <asp:TemplateField HeaderText="Comment" SortExpression="Fcom">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Fcom") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Truncate_lng(Eval("Fcom")) %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
</asp:Content>

