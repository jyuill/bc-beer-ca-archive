<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Page Language="VB" AutoEventWireup="true" ValidateRequest="false" MaintainScrollPositionOnPostback="true" ContentType="text/html" Debug="false" ResponseEncoding="windows-1252" %>

<%@ Register TagPrefix="UserControl" TagName="Logo" Src="Logo_reg.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Nav" Src="nav_bar.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Mail" Src="mailto_lookup.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="SaveDate" Src="SaveDate.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="Foot" Src="footer.ascx" %>
<%@ Register Src="css_select.ascx" TagName="CSSselect" TagPrefix="UserCtrl" %>
<%@ Register TagPrefix="UserCtrl" TagName="GoogleTagMgr" Src="~/ga_tag_mgr.ascx" %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.OLEDB" %>
<script runat="server">

    Sub Page_Load()
        
        If Not IsPostBack Then
    
            '------- Making the connection ------
            Dim strConnection As String = "Provider=Microsoft.Jet.OLEDB.4.0;"
            strConnection += "Data Source = " & Request.PhysicalApplicationPath & ("_private\breweries.mdb")
    
            Dim objConnection As New OleDbConnection(strConnection)
    
            '--------Connection made ---------
            
            '---Info for all features
            objConnection.Open()
            Dim strSQLfa As String = "Select * FROM tblFeature ORDER BY fDate DESC"
            Dim objAdapterFa As New OleDbDataAdapter(strSQLfa, objConnection)
            Dim objDataSetFa As New DataSet()
            objAdapterFa.Fill(objDataSetFa, "FeatureList")
            
            '---Datalist for feature
            dlFeatureList.DataSource = objDataSetFa.Tables("FeatureList")
            dlFeatureList.DataBind()
          
            Dim fn As String
            fn = objDataSetFa.Tables(0).Rows(0).Item("fsub")
            Me.PageTitle.InnerText = "BC Beer Guide Feature: " & fn

            
            objConnection.Close()
            
            MessageLabel.Text = ""
       
        End If
    End Sub

    Protected Sub DetailsView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DetailsViewInsertedEventArgs)
        Dim strName As String = e.Values("Author")
        Dim strContent As String = e.Values("Fcom")
        
        '--ValidateRequest is set to false in Page declaration.
        '--Ok, as long as ALL form fields are validated
        '--to ensure no HTML/SCRIPT code gets through.
        '--If ValidateRequest used, creates error before sub
        '--has chance to send email with invalid form data.
        '--Try - Catch tried without success to catch ValidateRequest errors.
        
        '--Determines if page is valid 
        '--based on CustomValidator2_ServerValidate below.
        '--Designed to catch form entries with html/script code,
        '--send users to error.aspx and report them to me via email.
        If Page.IsValid Then
        
            DataList1.DataBind()
            'e.Values.Item(0)
            'Dim strName As String = e.Values("Author")
            'Dim strContent As String = e.Values("Fcom")
            'Dim intFnum As Integer = e.Values("Fnum")
            MessageLabel.Text = "Thanks for adding your comment!"
               
            Dim objMail As New System.Net.Mail.SmtpClient
            Dim objMailMessage As New System.Net.Mail.MailMessage
            Dim adrSender As New System.Net.Mail.MailAddress("feature@bcbeer.ca")
            objMailMessage.From = adrSender
            objMailMessage.To.Add("john@bcbeer.ca")
            objMailMessage.Subject = "New feature comment!"
            objMailMessage.IsBodyHtml = False
            objMailMessage.Body = "The following feature comment has been added: " & _
            "Date: " & DateTime.Now & "; " & _
            "Name: " & strName & "; " & _
            "Content: " & strContent
            '-For local testing:
            'objMail.Host = "localhost"
            '-For remote use/internet connection:
            objMail.Host = "smtp.bcbeer.ca"
            objMail.Send(objMailMessage)
    
        Else
            '--Invalid comment entry            
            Dim objMail As New System.Net.Mail.SmtpClient
            Dim objMailMessage As New System.Net.Mail.MailMessage
            Dim adrSender As New System.Net.Mail.MailAddress("feature@bcbeer.ca")
            objMailMessage.From = adrSender
            objMailMessage.To.Add("john@bcbeer.ca")
            objMailMessage.Subject = "Invalid feature comment!"
            objMailMessage.IsBodyHtml = False
            objMailMessage.Body = "The following feature comment has been added: " & _
            "Date: " & DateTime.Now & "; " & _
            "Name: " & strName & "; " & _
            "Content: " & strContent
            '-For local testing:
            'objMail.Host = "localhost"
            '-For remote use/internet connection:
            objMail.Host = "smtp.bcbeer.ca"
            objMail.Send(objMailMessage)
            '- Redirects to home page rather than error
            ' - keeps them guessing
            Response.Redirect("default.aspx")

        End If
    End Sub
    
    Protected Sub CustomValidator1_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs)
        If args.Value.ToLower.IndexOf("<") > -1 Then
            args.IsValid = False
            Exit Sub
        ElseIf args.Value.ToLower.IndexOf("http") > -1 Then
            args.IsValid = False
            Exit Sub
        Else
            args.IsValid = True
        End If
    End Sub
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title id="PageTitle" runat="server"></title> 
    <meta content="beer, brewing, breweries, British Columbia, microbreweries, B.C., craft breweries, BC, Canada, beer, micro-breweries, breweries, ale, cottage breweries, &#13;&#10;real ale, real beer, lager" name="keywords" />
    <meta content="Beer news and events in B.C. beer, brewing, brewery, micro-brewery, brewpubs" name="Description" />
    <UserCtrl:CSSselect id="uctrl_css" runat="server" /> 
</head>
<body>
<UserCtrl:GoogleTagMgr ID="UserCtrlGTM" runat="server" />

<form id="form1" runat="server">
<!-- DIV for outer shell to set width of page -->
<div id="outer"> 
  <!-- Div for topsection including logo and slogan -->
  <div class="top"><UserControl:Logo id="UserControl1" runat="server"></UserControl:Logo> 
  </div>
  <!--DIV surrounding navbar embedded in usercontrols -->
  <div class="navsection"> <USERCONTROL:NAV id="UserControl2" runat="server"></USERCONTROL:NAV> 
    <div id="belowNavbar"> <UserControl:Mail id="UserControl3" runat="server"></UserControl:Mail> 
      <div id="subNav">  </div>
    </div>
  </div>
  <div class="mainbox" > 
    
      <h1 class="old">On Tap Features </h1>
      <div >          
          <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="#allf">All Features</asp:HyperLink>&nbsp;
          <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="#comments">Comments</asp:HyperLink>
          <!-- FormView for selected Feature -->
          <asp:FormView ID="FormView1" runat="server" DataKeyNames="fnum" DataSourceID="AccessDataSource1" CssClass="bigger" Width="100%">
              <ItemTemplate>
                  <asp:Label ID="fnumLabel" runat="server" Text='<%# Eval("fnum") %>' Visible="false"></asp:Label>
                  <h2><asp:Label ID="fsubLabel" runat="server" Text='<%# Bind("fsub") %>'></asp:Label></h2>
                  <h3 class="nonital"><asp:Label ID="ftitleLabel" runat="server" Text='<%# Bind("ftitle") %>'></asp:Label></h3>
                  <span class="softdate"><asp:Label ID="fdateLabel" runat="server" Text='<%# Bind("fdate", "{0:dd/MM/yyyy}") %>'></asp:Label></span>           
                   <p><asp:Image CssClass="fimage" ID="FeatImage" ImageUrl='<%# "images\features\" + Container.DataItem("fimage") %>' AlternateText="no image" runat="server" />
                   <asp:Label ID="fcontentLabel" runat="server" Text='<%# Bind("fcontent") %>'></asp:Label>
                   </p>
                  <p>
                  <asp:Label ID="Label1" runat="server" Text="More info: "></asp:Label><asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# Bind("flink") %>'><asp:Label ID="flinkLabel" runat="server" Text='<%# Bind("flink") %>' /></asp:HyperLink>
                    </p>
              </ItemTemplate>
          </asp:FormView>
          <asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/_private/Breweries.mdb"
              SelectCommand="SELECT [fnum], [fdate], [fsub], [ftitle], [fcontent], [flink], [fimage] FROM [tblFeature] WHERE ([fnum] = ?)">
              <SelectParameters>
                  <asp:QueryStringParameter Name="fnum" QueryStringField="Number" Type="Int32" />
              </SelectParameters>
          </asp:AccessDataSource>
      </div><br /> 
      <div>
        <h3 class="color">Comments</h3>
        <!-- DataList displaying comments -->
        <asp:DataList ID="DataList1" runat="server" DataKeyField="Fcomnum" DataSourceID="AccessDataSource2">
              <ItemTemplate>
                <p style="margin-top:0px; margin-bottom: 5px" class="bigger">
                <asp:Label ID="AuthorLabel" runat="server" Text='<%# Bind("Author") %>' Font-Bold="True"></asp:Label>&nbsp;
                <asp:Label ID="LocationLabel" runat="server" Text='<%# Bind("Location") %>'></asp:Label>&nbsp;
                <asp:Label ID="DateInLabel" runat="server" Text='<%# Bind("DateIn", "{0:dd/MM/yyyy}") %>' Font-Italic="True" CssClass="softdate"></asp:Label><br />
                <asp:Label ID="FcomLabel" runat="server" Text='<%# Bind("Fcom") %>'></asp:Label></p>
            </ItemTemplate>
          </asp:DataList>&nbsp;&nbsp;
        <asp:AccessDataSource ID="AccessDataSource2" runat="server" DataFile="~/_private/Breweries.mdb"
            SelectCommand="SELECT [Fcomnum], [Fnum], [Fcom], [DateIn], [Author], [Location] FROM [tblFeatureCom] WHERE ([Fnum] = ?) ORDER BY [DateIn] DESC">
            <SelectParameters>
                <asp:ControlParameter ControlID="FormView1" Name="Fnum" PropertyName="SelectedValue"
                    Type="Int32" />
            </SelectParameters>
        </asp:AccessDataSource>
      </div>
        <div >
            <asp:AccessDataSource ID="AccessDataSource3" runat="server"
                DataFile="~/_private/Breweries.mdb" 
                SelectCommand="SELECT [Fnum], [Fcom], [DateIn], [Author], [Location], [Fcomnum] FROM [tblFeatureCom]" 
                ConflictDetection="CompareAllValues" 
                InsertCommand="INSERT INTO [tblFeatureCom] ([Author], [Location], [Fcom], [Fnum]) VALUES (?, ?, ?, ?)" >
                <InsertParameters>
                    <asp:Parameter Name="Author" Type="String" />
                    <asp:Parameter Name="Location" Type="String" />
                    <asp:Parameter Name="Fcom" Type="String" />
                    <asp:ControlParameter ControlID="FormView1" Name="Fnum" PropertyName="SelectedValue"
                    Type="Int32" />
                </InsertParameters>
            </asp:AccessDataSource>
            <h3 class="color">Add Your Comment</h3>
            <asp:Label ID="MessageLabel" runat="server" Font-Bold="true" Font-Italic="true"></asp:Label>
            <!-- DetailsView for adding comments - default mode=insert -->
            <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="Fcomnum"
                DataSourceID="AccessDataSource3" Height="50px" Width="90%" OnItemInserted="DetailsView1_ItemInserted" AllowPaging="True" DefaultMode="Insert" GridLines="None">
                <Fields>
                    <asp:TemplateField HeaderText="Name" SortExpression="Author">
                       
                        <InsertItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Author") %>' Width="200px"></asp:TextBox>
                            <asp:RegularExpressionValidator
                                ID="RegularExpressionValidator1" runat="server" ErrorMessage="Alphabetic characters only please" ValidationExpression="^[a-zA-Z.,&quot;-'\s]{1,40}$" ControlToValidate="TextBox1"></asp:RegularExpressionValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("Author") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Width="50px" />
                        
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Location" SortExpression="Location">
                       
                        <InsertItemTemplate>
                            <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Location") %>' Width="200px"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="TextBox2"
                                ErrorMessage="Alphabetic characters only please" ValidationExpression="^[a-zA-Z.,''-'\s]{1,40}$"></asp:RegularExpressionValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("Location") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Width="50px" />
                       
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Comment" SortExpression="Fcom">
                        
                        <InsertItemTemplate>
                            <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Fcom") %>' Rows="4" TextMode="MultiLine" Width="95%"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="TextBox3" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("Fcom") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle VerticalAlign="Top" Width="60px" />
                        
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" ButtonType="Button" InsertText="Post" NewText="New Comment" />
                </Fields>
            </asp:DetailsView>
            <br />
        </div>
      <div>
      <h2>
          <a id="allf"></a>All Features</h2>
           <asp:DataList ID="dlFeatureList" runat="server">
            <ItemTemplate>
                <%-- <asp:Image CssClass="fimage" ID="FeatImage" ImageUrl='<%# "images\features\" + Container.DataItem("fimage") %>' AlternateText="no image" runat="server" /> --%>               
                
                <asp:HyperLink ID="HyperLink8" NavigateURL='<%# "featureselect.aspx?Number=" + HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"fnum")) %>' runat="server">
                <%# Databinder.Eval(Container.DataItem, "fsub") %>:&nbsp;<%# Databinder.Eval(Container.DataItem, "ftitle") %>
                </asp:HyperLink>
                <span class="softdate">(<%# DataBinder.Eval(Container.DataItem, "fdate", "{0:dd/MM/yyyy}") %>)</span><br />
            </ItemTemplate>
        
        </asp:DataList>
      </div>
    
  </div>
  <UserControl:Foot id="UserControl4f" runat="server" /> 
</div></form>                
</body>
</html>