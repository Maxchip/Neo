<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Company.aspx.cs" Inherits="neo.Company" %>

<%@ Register Assembly="DevExpress.Web.v16.1, Version=16.1.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Company</title>
    <link href="css/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            background-image: url('../img/bg.jpg');
        }
    </style>
</head>
<script src="js/jquery.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">

    function ClosePopup(s, e) {
        $(form1).empty();
        window.parent.popupVisualizar.Hide();
    }

</script>
<body>
    <form id="form1" runat="server">

        <div class="navbar navbar-default navbar-fixed-top" role="navigation">
            <div class="navbar-header">

                <div class="pull-left">                    
                     &nbsp; &nbsp; &nbsp;
                    <dx:ASPxButton ID="btnVoltar" runat="server" EnableTheming="false" CssClass="btn btn-danger"
                        Text="Back" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                        <Image Url="icon/glyphicons-211-left-arrow.png" Height="18px" Width="18px"></Image>
                        <ClientSideEvents Click="function(s, e) { ClosePopup(s, e); }" />
                    </dx:ASPxButton>

                    <a class="btn">
                        <h4 style="color: white">Company Management</h4>
                    </a>

                    <dx:ASPxButton ID="btnIncluir" runat="server" EnableTheming="false" CssClass="btn btn-success" 
                        Text="New Company" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                        <Image Url="icon/glyphicons-37-file.png" Height="20px" Width="16px"></Image>
                        <ClientSideEvents Click="function(s, e) { grvEmpresa.AddNewRow(); }" />
                    </dx:ASPxButton>

                </div>
            </div>
        </div>

        <p></p>

        <div class="padin">

            <dx:ASPxGridView ID="grvEmpresa" runat="server" AutoGenerateColumns="False" DataSourceID="sdsEmpresa" KeyFieldName="IdEmpresa" EnableRowsCache="false"
                EnableCallbackAnimation="false" OnRowValidating="grvEmpresa_RowValidating" ClientInstanceName="grvEmpresa">

                <Columns>
                    <dx:GridViewCommandColumn VisibleIndex="0" ButtonType="Image" Caption="Manager" Width="110px" ShowClearFilterButton="true" ShowEditButton="true" ShowDeleteButton="true"
                        ShowNewButton="false" ShowCancelButton="true" ShowUpdateButton="true" ShowNewButtonInHeader="true">
                    </dx:GridViewCommandColumn>

                    <dx:GridViewDataTextColumn FieldName="IdEmpresa" ReadOnly="True" VisibleIndex="1" Visible="false">
                        <EditFormSettings Visible="False" />
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn FieldName="NomeEmpresa" Caption="Company Name" VisibleIndex="2">
                        <PropertiesTextEdit>
                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true">
                                <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                            </ValidationSettings>
                            <InvalidStyle BackColor="LightPink" />
                        </PropertiesTextEdit>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataCheckColumn FieldName="Ativo" VisibleIndex="3">
                    </dx:GridViewDataCheckColumn>
                </Columns>

                <SettingsText Title="Company Management" />
                <SettingsPager PageSize="10" Position="Bottom" Visible="true">
                    <PageSizeItemSettings Items="10, 20, 50" Visible="true" />
                </SettingsPager>
                <SettingsBehavior AllowFocusedRow="true" ColumnResizeMode="Control" />
                <Settings ShowFilterRow="True" ShowTitlePanel="true" />
                <SettingsEditing Mode="EditForm" EditFormColumnCount="1" NewItemRowPosition="Top" />
                <SettingsCommandButton>
                    <EditButton Text="Edit" Image-Url="icon/glyphicons-151-edit.png"></EditButton>
                    <NewButton Text="New" Image-Url="icon/glyphicons-37-file.png" Image-Height="18px" Image-Width="16px"></NewButton>
                    <CancelButton Text="Cancel" Image-Url="icon/glyphicons-193-circle-remove.png"></CancelButton>
                    <UpdateButton Text="Save" Image-Url="icon/glyphicons-194-circle-ok.png"></UpdateButton>
                    <DeleteButton Text="Delete" Image-Url="icon/glyphicons-17-bin.png" Image-Height="20px" Image-Width="18px"></DeleteButton>
                    <ClearFilterButton Text="Clear" Image-Url="icon/glyphicons-68-cleaning.png" Image-Height="24px" Image-Width="24px"></ClearFilterButton>
                </SettingsCommandButton>
                <Styles AlternatingRow-Enabled="True" FocusedRow-BackColor="#5cb85c" SelectedRow-BackColor="#F0AD4E"></Styles>

            </dx:ASPxGridView>

            <asp:SqlDataSource ID="sdsEmpresa" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
                DeleteCommand="DELETE FROM [Empresa] WHERE [IdEmpresa] = @IdEmpresa"
                InsertCommand="INSERT INTO [Empresa] ([NomeEmpresa], [Ativo]) VALUES (@NomeEmpresa, @Ativo)"
                SelectCommand="SELECT * FROM [Empresa]"
                UpdateCommand="UPDATE [Empresa] SET [NomeEmpresa] = @NomeEmpresa, [Ativo] = @Ativo WHERE [IdEmpresa] = @IdEmpresa">
                <DeleteParameters>
                    <asp:Parameter Name="IdEmpresa" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="NomeEmpresa" Type="String" />
                    <asp:Parameter Name="Ativo" Type="Boolean" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="NomeEmpresa" Type="String" />
                    <asp:Parameter Name="Ativo" Type="Boolean" />
                    <asp:Parameter Name="IdEmpresa" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>

    </form>
</body>
</html>
