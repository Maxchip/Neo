<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="neo.Default" %>

<%@ Register Assembly="DevExpress.Web.v16.1, Version=16.1.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<script type="text/javascript">        

    function OnCustomButtonDoc(s, e) {
        if (e.buttonID == "btnEditDoc") {
            grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc', function (value) { grvDoc.PerformCallback('EditDoc:' + value); });           
        }
        if (e.buttonID == "btnPrintDoc") {
            grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc;IdTipoDoc', OnPrintDoc);
        }
        if (e.buttonID == "btnDelDoc") {
            popupDelDoc.Show();
        }
        if (e.buttonID == "btnSitDoc") {
            popupSituacaoDoc.Show();
        }
        if (e.buttonID == "btnViewDoc") {
            grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc', OnViewDoc);
        }
    }

    function OnNewDoc(s, e) {
        popupVisualizar.SetContentUrl('EditFormDoc.aspx?IdDoc=0');
        popupVisualizar.Show();
    }    

    function OnViewDoc(IdDoc) {
        popupVisualizar.SetContentUrl('ViewFormDoc.aspx?IdDoc=' + IdDoc);
        popupVisualizar.Show();
    }

    function OnPrintDoc(values) {
        popupVisualizar.SetContentUrl('PrintView.aspx?IdDoc=' + values[0] + '&IdTipoDoc=' + values[1]);
        popupVisualizar.Show();
    }

    function OnDeletaDoc(IdDoc) {
        grvDoc.PerformCallback('DeletaDoc:' + IdDoc);
    }

    function OnPendente(s, e) {
        grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc', function (value) { grvDoc.PerformCallback('Pendente:' + value); });
    }

    function OnFinalizado(s, e) {
        grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc', function (value) { grvDoc.PerformCallback('Finalizado:' + value); });
    }

    function OnAvaliacao(s, e) {
        grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc', function (value) { grvDoc.PerformCallback('Avaliacao:' + value); });
    }

    function OnAtendido(s, e) {
        grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc', function (value) { grvDoc.PerformCallback('Atendido:' + value); });
    }

    function OnEndCallDoc(s, e) {

        if (s.cpOpe == 'OK') {
            s.cpOpe = 'null';
            popupMSG.Show();
            lblMSG.SetText(s.cpMSG);
            grvDoc.Refresh();
        }
        else if (s.cpOpe == 'noEdit') {
            s.cpOpe = 'null';
            popupMSG.Show();
            lblMSG.SetText(s.cpMSG);
        }
        else if (s.cpOpe == 'yesEdit') {    
            s.cpOpe = 'null';
            popupVisualizar.SetContentUrl('EditFormDoc.aspx?IdDoc=' + s.cpIdDoc);
            popupVisualizar.Show();
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="css/bootstrap.css" rel="stylesheet" />
    <script src="js/jquery.js"></script>
    <script src="js/bootstrap.js"></script>
    <style>
        body {
            background-image: url('../img/bg.jpg');
        }
    </style>
    <title>neo</title>
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar-lower" role="navigation">
            <div class="panel panel-default">
                <div class="panel-heading2">
                    <div class="form-inline">

                        <a href="Default.aspx">
                            <img src="img/maxlogo.png" />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp
                        </a>

                        <a class="btn btn-primary" role="button" data-toggle="collapse" href="#collapseGridDoc" aria-expanded="true" aria-controls="collapseGridDoc">
                            <span class="glyphicon glyphicon-th" aria-hidden="true"></span>
                        </a>

                        <a class="accordion-toggle btn btn-primary" data-toggle="collapse" href="#collapseFiltro" aria-expanded="false" aria-controls="collapseFiltro">
                            <span class="glyphicon glyphicon-filter" aria-hidden="true"></span>
                        </a>

                        <dx:ASPxButton ID="btnNovoRegistro" runat="server" EnableTheming="false" CssClass="btn btn-success"
                            Text="Novo Registro" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                            <Image Url="icon/glyphicons-37-file.png" Height="20px" Width="15px"></Image>
                            <ClientSideEvents Click="function(s, e) { OnNewDoc(s, e); }" />
                        </dx:ASPxButton>

                        <a class="btn">
                            <h4>Modelo de Documento</h4>
                        </a>

                    </div>
                </div>
            </div>
        </nav>

        <div class="collapse collapse in" id="collapseFiltro">

            <div class="panel panel-info">
                <div class="panel-heading">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-sm-12 col-md-12 col-lg-12">
                                <div class="col-sm-2 col-md-2 col-lg-2">
                                    <dx:ASPxDateEdit ID="FiltrodataInicio" runat="server" DisplayFormatString="dd/MM/yyyy" EditFormatString="dd/MM/yyyy" ClientInstanceName="FiltrodataInicio" Width="100%" HorizontalAlign="Left" Caption="Cad. Inicio">
                                        <CaptionSettings Position="Top" ShowColon="false" />
                                        <ClientSideEvents ValueChanged="function(s, e){ if (((s.GetValue() != null) && (FiltrodataFim.GetValue() != null)) || ((s.GetValue() == null) && (FiltrodataFim.GetValue() == null))) { grvDoc.PerformCallback('ConsultaDoc'); } }" />
                                        <ClearButton Visibility="True" Position="Left" DisplayMode="Always"></ClearButton>
                                    </dx:ASPxDateEdit>
                                </div>
                                <div class="col-sm-2 col-md-2 col-lg-2">
                                    <dx:ASPxDateEdit ID="FiltrodataFim" runat="server" DisplayFormatString="dd/MM/yyyy" EditFormatString="dd/MM/yyyy" ClientInstanceName="FiltrodataFim" Width="100%" Caption="Cad. Fim">
                                        <CaptionSettings Position="Top" ShowColon="false" />
                                        <DateRangeSettings StartDateEditID="FiltrodataInicio"></DateRangeSettings>
                                        <ClientSideEvents ValueChanged="function(s, e){ if (((s.GetValue() != null) && (FiltrodataInicio.GetValue() != null)) || ((s.GetValue() == null) && (FiltrodataInicio.GetValue() == null))) { grvDoc.PerformCallback('ConsultaDoc'); } }" />
                                        <ClearButton Visibility="True" Position="Left" DisplayMode="Always"></ClearButton>
                                    </dx:ASPxDateEdit>
                                </div>
                                <div class="col-sm-2 col-md-2 col-lg-2">
                                    <div class="input-group">

                                        <dx:ASPxTextBox ID="FiltroNumeroDoc" runat="server" ClientInstanceName="FiltroNumeroDoc" Width="100%" Caption="Nº Documento">
                                            <CaptionSettings Position="Top" ShowColon="false" />
                                            <ClientSideEvents ValueChanged="function(s, e){ grvDoc.PerformCallback('ConsultaDoc'); }" />
                                        </dx:ASPxTextBox>

                                        <span class="input-group-btn">
                                            <dx:ASPxButton ID="ASPxButton1" runat="server" Text="" EnableTheming="false" CssClass="btn btn-danger btn-Filter" UseSubmitBehavior="false" AutoPostBack="false" Width="10px">
                                                <Image Url="icon/glyphicons-193-circle-remove.png" Height="15px" Width="15px"></Image>
                                                <ClientSideEvents Click="function(s, e){ FiltroNumeroDoc.SetValue(null); grvDoc.PerformCallback('ConsultaDoc'); }" />
                                            </dx:ASPxButton>
                                        </span>
                                    </div>
                                </div>
                                <div class="col-sm-2 col-md-2 col-lg-2">
                                    <dx:ASPxComboBox ID="FiltrocboEmpresa" runat="server" ClientInstanceName="FiltrocboEmpresa" Width="100%" Caption="Empresa"
                                        DataSourceID="sdsEmpresa" ValueField="IdEmpresa" ValueType="System.Int32" TextField="NomeEmpresa"
                                        EnableCallbackMode="true" CallbackPageSize="50" LoadDropDownOnDemand="true" ShowShadow="false" DropDownStyle="DropDown" DataSecurityMode="Strict">
                                        <CaptionSettings Position="Top" ShowColon="false" />
                                        <ClientSideEvents ValueChanged="function(s, e){ grvDoc.PerformCallback('ConsultaDoc'); }" />
                                        <ClearButton Visibility="True" Position="Left" DisplayMode="Always"></ClearButton>
                                    </dx:ASPxComboBox>
                                </div>
                                <div class="col-sm-2 col-md-2 col-lg-2">
                                    <dx:ASPxComboBox ID="FiltrocboTipo" runat="server" ClientInstanceName="FiltrocboTipo" Width="100%" Caption="Tipo Documento"
                                        DataSourceID="sdsTipoDoc" ValueField="IdTipoDoc" ValueType="System.Int32" TextField="NomeTipoDoc"
                                        ShowShadow="false" DropDownStyle="DropDown" DataSecurityMode="Strict">
                                        <CaptionSettings Position="Top" ShowColon="false" />
                                        <ClientSideEvents ValueChanged="function(s, e){ grvDoc.PerformCallback('ConsultaDoc'); }" />
                                        <ClearButton Visibility="True" Position="Left" DisplayMode="Always"></ClearButton>
                                    </dx:ASPxComboBox>
                                </div>

                                <div class="col-sm-2 col-md-2 col-lg-2">
                                    <dx:ASPxGridLookup ID="FiltrolukSitDoc" runat="server" KeyFieldName="IdSituacaoDoc" PopupHorizontalAlign="RightSides" AutoPostBack="false" DataSourceID="sdsSituacaoDoc" ClientInstanceName="FiltrolukSitDoc"
                                        SelectionMode="Multiple" Width="100%" TextFormatString="{1}" MultiTextSeparator="/" AutoGenerateColumns="False" Caption="Situação Doc">
                                        <Columns>
                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="50px">
                                            </dx:GridViewCommandColumn>
                                            <dx:GridViewDataColumn FieldName="IdSituacaoDoc" Visible="false" VisibleIndex="1">
                                            </dx:GridViewDataColumn>
                                            <dx:GridViewDataColumn FieldName="NomeSituacaoDoc" Visible="true" VisibleIndex="2" Caption="Sit. Doc" Width="110px">
                                            </dx:GridViewDataColumn>
                                        </Columns>

                                        <GridViewProperties>
                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>
                                            <SettingsPager PageSize="99"></SettingsPager>
                                            <Settings VerticalScrollBarMode="Visible" />
                                        </GridViewProperties>
                                        <CaptionSettings Position="Top" ShowColon="false" />
                                        <ClientSideEvents ValueChanged="function(s, e){ grvDoc.PerformCallback('ConsultaDoc'); }" />
                                        <ClearButton Visibility="True" Position="Left" DisplayMode="Always"></ClearButton>
                                    </dx:ASPxGridLookup>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="collapse collapse in" id="collapseGridDoc">
            <div class="container-fluid">
                <div class="row">

                    <dx:ASPxGridView ID="grvDoc" runat="server" AutoGenerateColumns="false" KeyFieldName="IdDoc" ClientInstanceName="grvDoc" Width="100%"
                        OnLoad="grvDoc_Load" OnCustomCallback="grvDoc_CustomCallback">

                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0" ButtonType="Image" Width="80px" ShowClearFilterButton="false" ShowEditButton="false" ShowDeleteButton="false" ShowNewButton="false" ShowCancelButton="false" ShowUpdateButton="false">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton Visibility="AllDataRows" ID="btnViewDoc" Text="Visualizar" Image-Url="icon/glyphicons-52-eye-open.png" Image-Height="17px" Image-Width="25px">
                                    </dx:GridViewCommandColumnCustomButton>
                                    <dx:GridViewCommandColumnCustomButton Visibility="AllDataRows" ID="btnSitDoc" Text="Situação" Image-Url="icon/glyphicons-137-cogwheel.png" Image-Height="20px" Image-Width="20px">
                                    </dx:GridViewCommandColumnCustomButton>
                                    <dx:GridViewCommandColumnCustomButton Visibility="AllDataRows" ID="btnEditDoc" Text="Editar" Image-Url="icon/glyphicons-151-edit.png">
                                    </dx:GridViewCommandColumnCustomButton>
                                    <dx:GridViewCommandColumnCustomButton Visibility="AllDataRows" ID="btnDelDoc" Text="Deletar" Image-Url="icon/glyphicons-17-bin.png" Image-Height="20px" Image-Width="18px">
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>

                            <dx:GridViewCommandColumn VisibleIndex="0" ButtonType="Image" Width="80px" ShowClearFilterButton="false" ShowEditButton="false" ShowDeleteButton="false" ShowNewButton="false" ShowCancelButton="false" ShowUpdateButton="false">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton Visibility="AllDataRows" ID="btnPrintDoc" Text="Imprimir" Image-Url="icon/glyphicons-16-print.png" Image-Height="20px" Image-Width="20px">
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>

                            <dx:GridViewDataTextColumn FieldName="IdDoc" Caption="Id Doc" VisibleIndex="1" Visible="true">
                            </dx:GridViewDataTextColumn>                            

                            <dx:GridViewDataDateColumn FieldName="DataCadastro" Caption="Cadastro" VisibleIndex="2" Width="100px">
                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                <CellStyle HorizontalAlign="Center"></CellStyle>
                            </dx:GridViewDataDateColumn>

                            <dx:GridViewDataTextColumn FieldName="NumeroDoc" Caption="Nº Documento" VisibleIndex="3" Width="150px">
                                <CellStyle HorizontalAlign="Center"></CellStyle>
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataTextColumn FieldName="NomeTipoDoc" Caption="Tipo Documento" VisibleIndex="4" Width="150px">
                                <CellStyle HorizontalAlign="Center"></CellStyle>
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataDateColumn FieldName="DataVencimento" Caption="Vencimento" VisibleIndex="5" Width="100px">
                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                <CellStyle HorizontalAlign="Center"></CellStyle>
                            </dx:GridViewDataDateColumn>

                            <dx:GridViewDataTextColumn FieldName="NomeEmpresa" Caption="Empresa" VisibleIndex="6">
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataTextColumn FieldName="NomeContato" Caption="Contact" VisibleIndex="7">
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataTextColumn FieldName="NomeSituacaoDoc" Caption="Situação Documento" VisibleIndex="8" Width="150px">
                                <CellStyle HorizontalAlign="Center"></CellStyle>
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataTextColumn FieldName="Total" Caption="Total" VisibleIndex="9" Width="300px">
                                <PropertiesTextEdit DisplayFormatString="c2">
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Right"></CellStyle>
                            </dx:GridViewDataTextColumn>

                        </Columns>

                        <ClientSideEvents CustomButtonClick="OnCustomButtonDoc" EndCallback="OnEndCallDoc" />

                        <SettingsPager PageSize="10" Position="Bottom">
                            <PageSizeItemSettings Items="10, 20, 50" Visible="true" />
                        </SettingsPager>
                        <SettingsDetail ShowDetailButtons="true" ShowDetailRow="false" />
                        <Settings ShowFilterRow="false" ShowTitlePanel="false" ShowHeaderFilterButton="false" ShowGroupPanel="false" ShowFooter="true" ShowGroupFooter="VisibleIfExpanded" />
                        <SettingsBehavior AllowFocusedRow="true" />

                        <Styles AlternatingRow-Enabled="True" FocusedRow-BackColor="#5cb85c" SelectedRow-BackColor="#F0AD4E">
                            <GroupRow BackColor="#337AB7" Font-Bold="true" ForeColor="White"></GroupRow>
                            <Footer BackColor="#D9534F" Font-Bold="true"></Footer>
                        </Styles>

                        <SettingsLoadingPanel Text="" />

                        <TotalSummary>
                            <dx:ASPxSummaryItem FieldName="Total" ShowInGroupFooterColumn="Total" SummaryType="Sum" DisplayFormat="Total: {0:c2}" />
                        </TotalSummary>

                    </dx:ASPxGridView>
                </div>
            </div>
        </div>

        <dx:ASPxPopupControl ID="popupVisualizar" runat="server" AllowDragging="false" PopupAnimationType="Slide" ClientInstanceName="popupVisualizar" EnableViewState="false" ShowOnPageLoad="false" ScrollBars="Auto"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Maximized="true" Modal="true" CloseAction="CloseButton" CloseOnEscape="true" ShowCloseButton="false" LoadContentViaCallback="None" ShowHeader="false">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl3" runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="popupMSG" runat="server" HeaderText="" AllowDragging="false" PopupAnimationType="Slide" ClientInstanceName="popupMSG" ShowOnPageLoad="false"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="200px" Height="150px" Modal="true" CloseAction="None" CloseOnEscape="false" ShowCloseButton="false" ShowHeader="false">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl8" runat="server">

                    <table style="width: 100%; text-align: center">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="lblMSG" ClientInstanceName="lblMSG" Font-Size="16px" runat="server" Text=""></dx:ASPxLabel>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table style="width: 200px">
                        <tr style="width: 200px; text-align: center">
                            <td>
                                <dx:ASPxButton ID="ASPxButton2" runat="server" Text="OK" EnableTheming="false" CssClass="btn btn-success btn-sm" UseSubmitBehavior="false" AutoPostBack="false" Width="170px">
                                    <Image Url="icon/glyphicons-194-circle-ok.png" Height="18px" Width="18px"></Image>
                                    <ClientSideEvents Click="function(s, e) { popupMSG.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="popupSituacaoDoc" runat="server" HeaderText="Painel de Operações" AllowDragging="false" PopupAnimationType="Slide" ClientInstanceName="popupSituacaoDoc" EnableViewState="false" ShowOnPageLoad="false"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="280px" Height="300px" Modal="true" CloseAction="CloseButton" CloseOnEscape="false" ShowCloseButton="true">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl6" runat="server">

                    <div class="row">
                        <div class="col-sm-12 text-center">

                            <div class="input-group">
                                <dx:ASPxLabel ID="ASPxLabel3" Font-Size="16px" runat="server" Text="Mudança de Situação"></dx:ASPxLabel>                                                      
                                <p></p>
                            </div>

                            <div class="center-block">

                                <dx:ASPxButton ID="btnPendente" runat="server" EnableTheming="false" CssClass="btn btn-success"
                                    Text="Pendente" UseSubmitBehavior="false" AutoPostBack="false" Width="150px">
                                    <ClientSideEvents Click="function(s, e) { OnPendente(s, e); }" />
                                </dx:ASPxButton>
                                <p></p>


                                <dx:ASPxButton ID="btnFinalizado" runat="server" EnableTheming="false" CssClass="btn btn-warning"
                                    Text="Finalizado" UseSubmitBehavior="false" AutoPostBack="false" Width="150px">
                                    <ClientSideEvents Click="function(s, e) { OnFinalizado(s, e); }" />
                                </dx:ASPxButton>
                                <p></p>

                                <dx:ASPxButton ID="btnAvaliacao" runat="server" EnableTheming="false" CssClass="btn btn-primary"
                                    Text="Avaliação" UseSubmitBehavior="false" AutoPostBack="false" Width="150px">
                                    <ClientSideEvents Click="function(s, e) { OnAvaliacao(s, e); }" />
                                </dx:ASPxButton>
                                <p></p>


                                <dx:ASPxButton ID="btnAtendido" runat="server" EnableTheming="false" CssClass="btn btn-danger"
                                    Text="Atendido" UseSubmitBehavior="false" AutoPostBack="false" Width="150px">
                                    <ClientSideEvents Click="function(s, e) { OnAtendido(s, e); }" />
                                </dx:ASPxButton>
                                <p></p>

                            </div>
                        </div>

                    </div>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="popupDelDoc" runat="server" HeaderText="" AllowDragging="false" PopupAnimationType="Slide" ClientInstanceName="popupDelDoc" ShowOnPageLoad="false"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="200px" Height="150px" Modal="true" CloseAction="None" CloseOnEscape="false" ShowCloseButton="false" ShowHeader="false">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl5" runat="server">

                    <table style="width: 100%; text-align: center">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="ASPxLabel2" ClientInstanceName="ASPxLabel1" Font-Size="16px" runat="server" Text="Deseja realamente deletar este Registro?"></dx:ASPxLabel>
                            </td>

                        </tr>
                    </table>
                    <br />
                    <table style="width: 200px">
                        <tr style="width: 200px; text-align: center">
                            <td>
                                <dx:ASPxButton ID="ASPxButton5" runat="server" Text="Sim" EnableTheming="false" CssClass="btn btn-success btn-sm" UseSubmitBehavior="false" AutoPostBack="false" Width="60px">
                                    <Image Url="icon/glyphicons-194-circle-ok.png" Height="18px" Width="18px"></Image>
                                    <ClientSideEvents Click="function(s, e) { grvDoc.GetRowValues(grvDoc.GetFocusedRowIndex(), 'IdDoc', OnDeletaDoc); popupDelDoc.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="ASPxButton8" runat="server" Text="Não" EnableTheming="false" CssClass="btn btn-danger btn-sm" UseSubmitBehavior="false" AutoPostBack="false" Width="60px">
                                    <Image Url="icon/glyphicons-194-circle-ok.png" Height="18px" Width="18px"></Image>
                                    <ClientSideEvents Click="function(s, e) { popupDelDoc.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <asp:SqlDataSource ID="sdsEmpresa" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [Empresa]"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsTipoDoc" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [TipoDoc]"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsSituacaoDoc" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [SituacaoDoc]"></asp:SqlDataSource>

    </form>
</body>
</html>
