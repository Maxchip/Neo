<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditFormDoc.aspx.cs" Inherits="neo.EditFormDoc" %>

<%@ Register Assembly="DevExpress.Web.v16.1, Version=16.1.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Form</title>
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

    $(document).ready(function () {

        var IdDoc = ('<%=this.Request.QueryString["IdDoc"]%>');

        if (IdDoc > 0) {

            $.ajax({
                url: "HandlerDoc.ashx",
                type: "POST",
                data: { IdDoc },
                dataType: "json",
                success: function (data) {               
                    document.getElementById('HiddenIdDoc').value = data["Doc"][0].IdDoc;
                    txtIdDoc.SetText(data["Doc"][0].IdDoc);
                    txtNumeroDoc.SetText(data["Doc"][0].NumeroDoc);
                    txtCadastro.SetText(data["Doc"][0].DataCadastro);                   
                    cboTipo.SetValue(data["Doc"][0].IdTipoDoc);
                    cboEmpresa.SetValue(data["Doc"][0].IdEmpresa);                    
                    cboSituacaoDoc.SetValue(data["Doc"][0].IdSituacaoDoc);
                    chkVencimento.SetValue(data["Doc"][0].SemVencimento);
                    txtVencimento.SetText(data["Doc"][0].Vencimento);
                    dateVencimento.SetText(data["Doc"][0].DataVencimento);
                    cboUsuario.SetValue(data["Doc"][0].IdUsuario);
                    txtRemessa.SetText(data["Doc"][0].Remessa);
                    memoObs.SetText(data["Doc"][0].Observacao);
                    grvItem.Refresh();
                },
                failure: function (data) {
                    alert("Erro");
                }
            });
        }
        else {                
            document.getElementById('HiddenIdDoc').value = "";
            grvItem.Refresh();
        }
    });

    function ClosePopupDoc(s, e) {
        $(form1).empty();
        window.parent.popupVisualizar.Hide();
        window.parent.grvDoc.Refresh();
    }    

    function OnVencimento(s, e) {
        if (chkVencimento.GetValue() == true) {
            dateVencimento.SetValue(null);
            dateVencimento.SetEnabled(false);
            var elem = document.getElementById('Venc');
            elem.style.display = "block";
            txtVencimento.SetValue(null);
            txtVencimento.SetVisible(true);
            txtVencimento.SetEnabled(true);            
        }
        else {
            dateVencimento.SetValue(null);
            dateVencimento.SetEnabled(true);
            txtVencimento.SetValue(null);
            txtVencimento.SetEnabled(false);
            var elem = document.getElementById('Venc');
            elem.style.display = "none";
        }
    }

    function OnObservacao(s, e) {

        if (cboTipo.GetValue() == 2) {
            memoObs.SetText("Observações:\n\n1) Developing applications, deploying and maintaining systems\n\n2) Analyzing, evaluating processes and automate this processes in a system to get control\n\n3) Improving database, reports, SQL Query and Integration of Systems");
        }
        else if (cboTipo.GetValue() == 3) {
            memoObs.SetText("Dados Bancários:\n\nBanco Itaú\nAG: 0000\nC/C 00000-0\nFavorecido: Cezar Souza\nCPF: 000.000.000-00\nR$");
        }
    }

    //Funções Item

    function ClosePopupItem(s, e) {
        ASPxClientEdit.ClearEditorsInContainerById('DivItem');
        popupItem.Hide();
    }

    function OnCustomButton(s, e) {
        if (e.buttonID == "btnEditaItem") {
            grvItem.GetRowValues(grvItem.GetFocusedRowIndex(), 'IdDoc;IdItemDoc;Ordem;IdItem;Quantidade;Valor;Total', ShowPopupItem);
        }
        if (e.buttonID == "btnDeletaItem") {
            popupDelItem.Show();
        }
    }

    function ShowPopupItem(values) {
        popupItem.Show();
        ASPxClientEdit.ClearEditorsInContainerById('DivItem');
        document.getElementById('HiddenIdDoc').value = (values[0]);
        document.getElementById('HiddenIdItemDoc').value = (values[1]);
        spinOrdem.SetValue(values[2]);
        cboItem.SetValue(values[3]);
        spinQtd.SetValue(values[4]);
        spinValor.SetValue(values[5]);
        spinTotal.SetValue(values[6]);
    }

    function OnDeletaItem(IdItemDoc) {
        grvItem.PerformCallback('DeletaItem:' + IdItemDoc);
    }

    function OnNewItem(s, e) {
        if (document.getElementById('HiddenIdDoc').value != "") {
            popupItem.Show();
            ASPxClientEdit.ClearEditorsInContainerById('DivItem');
            document.getElementById('HiddenIdItemDoc').value = "";
        }
        else {
            popupMSG.Show();
            lblMSG.SetText("Salve este Registro antes de incluir item!");
        }
    }

    function OnEndCall(s, e) {
        if (s.cpOpe == 'OK') {
            s.cpOpe = 'null';
            popupItem.Hide();
            popupMSG.Show();
            lblMSG.SetText(s.cpMSG);
            grvItem.Refresh();
        }
        else if (s.cpOpe == 'New') {
            s.cpOpe = 'null';
            txtNumeroDoc.SetText(s.cpNDoc);
            document.getElementById('HiddenIdDoc').value = (s.cpIDoc);
            txtIdDoc.SetText(s.cpIDoc);
            popupMSG.Show();
            lblMSG.SetText(s.cpMSG);
        }
    }

    function OnSetValorItem(s) {
        var ValorBase = s.GetSelectedItem().GetColumnText('Valor');
        spinValor.SetValue(ValorBase.replace(',', '.'));
        OnCalculaItem();
    }

    function OnCalculaItem() {
        spinTotal.SetValue(spinQtd.GetValue() * spinValor.GetValue());
    }  

    function OnContato() {
        document.getElementById('HiddenIdContato').value = cboContato.GetValue();         
    }

</script>

<body>
    <form id="form1" runat="server">

        <div class="navbar navbar-default navbar-fixed-top" role="navigation">
            <div class="navbar-header">

                <div class="pull-left">

                    <a class="btn">
                        <h4 style="color: white">Edit Doc</h4>
                    </a>

                    <dx:ASPxButton ID="btnVoltar" runat="server" EnableTheming="false" CssClass="btn btn-danger"
                        Text="Voltar" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                        <Image Url="icon/glyphicons-211-left-arrow.png" Height="18px" Width="18px"></Image>
                        <ClientSideEvents Click="function(s, e) { ClosePopupDoc(s, e); }" />
                    </dx:ASPxButton>

                </div>
            </div>
        </div>

        <p></p>       

        <div class="padin">
            <div class="container-fluid">

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">

                        <asp:HiddenField ID="HiddenIdDoc" runat="server" ClientIDMode="Static" />

                        <asp:HiddenField ID="HiddenIdContato" runat="server" ClientIDMode="Static" />

                        <div class="col-sm-1 col-md-1 col-lg-1">
                            <dx:ASPxTextBox ID="txtIdDoc" runat="server" ClientInstanceName="txtIdDoc" Width="100%" Caption="Id Doc" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-1 col-md-1 col-lg-1">
                            <dx:ASPxTextBox ID="txtNumeroDoc" runat="server" ClientInstanceName="txtNumeroDoc" Width="100%" Caption="Nº Documento" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxTextBox ID="txtCadastro" runat="server" ClientInstanceName="txtCadastro" Width="100%" Caption="Cadastro" ReadOnly="true" OnInit="txtCadastro_Init">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>                            
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxComboBox ID="cboTipo" runat="server" ValueType="System.Int32" ValueField="IdTipoDoc" ClientInstanceName="cboTipo" TextField="NomeTipoDoc" OnInit="cboTipo_Init"
                                Caption="Tipo Doc" Width="100%" DataSourceID="sdsTipoDoc" ShowShadow="false" DropDownStyle="DropDown" DataSecurityMode="Strict">
                                <CaptionSettings Position="Top" ShowColon="false" />
                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="a">
                                    <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                </ValidationSettings>
                                <InvalidStyle BackColor="LightPink" />
                                <ClientSideEvents ValueChanged="function(s, e) { OnObservacao(); }" />
                            </dx:ASPxComboBox>
                        </div>

                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <dx:ASPxComboBox ID="cboEmpresa" runat="server" ClientInstanceName="cboEmpresa" Width="100%" Caption="Empresa"
                                DataSourceID="sdsEmpresa" ValueField="IdEmpresa" ValueType="System.Int32" TextField="NomeEmpresa"
                                ShowShadow="false" DropDownStyle="DropDown" DataSecurityMode="Strict">
                                <CaptionSettings Position="Top" ShowColon="false" />
                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="a">
                                    <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                </ValidationSettings>
                                <InvalidStyle BackColor="LightPink" />
                                <ClientSideEvents ValueChanged="function(s, e){ cboContato.PerformCallback(s.GetValue()); }" />                               
                            </dx:ASPxComboBox>
                        </div>

                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <dx:ASPxComboBox ID="cboContato" runat="server" ClientInstanceName="cboContato" Width="100%" Caption="Contato" OnInit="cboContato_Init"
                                DataSourceID="sdsContato" ValueField="IdContato" ValueType="System.Int32" TextField="NomeContato" OnCallback="cboContato_Callback" 
                                ShowShadow="false" DropDownStyle="DropDown" DataSecurityMode="Strict">
                                <CaptionSettings Position="Top" ShowColon="false" />
                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="a">
                                    <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                </ValidationSettings>
                                <InvalidStyle BackColor="LightPink" />                                
                                <ClientSideEvents ValueChanged="function(s, e){ OnContato(); }" />
                            </dx:ASPxComboBox>
                        </div>

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxComboBox ID="cboSituacaoDoc" runat="server" ValueType="System.Int32" ValueField="IdSituacaoDoc" ClientInstanceName="cboSituacaoDoc" TextField="NomeSituacaoDoc"
                                Caption="Situação Doc" Width="100%" DataSourceID="sdsSituacaoDoc" ShowShadow="false" DropDownButton-Enabled="false" ReadOnly="true" OnInit="cboSituacaoDoc_Init">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxComboBox>
                        </div>
                        <div class="col-sm-1 col-md-1 col-lg-1" style="padding-top: 10px">
                            <dx:ASPxLabel runat="server" ID="lblFiltroData" Text="Sem Venc." Font-Bold="true"></dx:ASPxLabel>
                            <dx:ASPxCheckBox ID="chkVencimento" ClientInstanceName="chkVencimento" runat="server" Width="100%">
                                <ClientSideEvents Init="function(s, e){ OnVencimento(); }" ValueChanged="function(s, e){ OnVencimento(); }" />
                            </dx:ASPxCheckBox>
                        </div>

                        <div id="Venc" class="Venc">
                            <div class="col-sm-2 col-md-2 col-lg-2">
                                <dx:ASPxTextBox ID="txtVencimento" runat="server" ClientInstanceName="txtVencimento" Width="100%" Caption="Sem Vencimento">
                                    <CaptionSettings Position="Top" ShowColon="false" />
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="a">
                                        <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                    </ValidationSettings>
                                    <InvalidStyle BackColor="LightPink" />
                                </dx:ASPxTextBox>
                            </div>
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxDateEdit ID="dateVencimento" Caption="Com Vencimento" runat="server" ClientInstanceName="dateVencimento"
                                DisplayFormatString="dd/MM/yyyy" EditFormatString="dd/MM/yyyy" Width="100%">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxDateEdit>
                        </div>

                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <dx:ASPxComboBox ID="cboUsuario" runat="server" ValueType="System.Int32" ValueField="IdUsuario" ClientInstanceName="cboUsuario" TextField="NomeUsuario"
                                Caption="Usuário" Width="100%" DataSourceID="sdsUsuario" ShowShadow="false" DropDownStyle="DropDown" DataSecurityMode="Strict">
                                <CaptionSettings Position="Top" ShowColon="false" />
                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="a">
                                    <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                </ValidationSettings>
                                <InvalidStyle BackColor="LightPink" />
                            </dx:ASPxComboBox>
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxTextBox ID="txtRemessa" runat="server" ClientInstanceName="txtRemessa" Width="100%" Caption="Remessa">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <dx:ASPxMemo ID="memoObs" runat="server" Caption="Observação" Width="100%" Height="100px" ClientInstanceName="memoObs" MaxLength="5000">
                                <ClientSideEvents Init="function(s, e){ var ele = s.GetText(); lblObs.SetText(ele.length + ' de 5000 Caracteres') }" KeyUp="function(s, e){ var ele = s.GetText(); lblObs.SetText(ele.length + ' de 5000 Caracteres') }" />
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxMemo>
                            <dx:ASPxLabel ID="lblObs" ClientInstanceName="lblObs" Font-Size="10px" runat="server" Text="(Máximo 5000 Caracteres)"></dx:ASPxLabel>
                        </div>
                    </div>
                </div>

                <p></p>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="col-sm-2 col-md-2 col-lg-2">

                            <dx:ASPxButton ID="btnNewItem" runat="server" ClientInstanceName="btnNewItem" EnableTheming="false" CssClass="btn btn-success btn-sm"
                                Text="Novo Item" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                                <Image Url="icon/glyphicons-37-file.png" Height="18px" Width="15px"></Image>
                                <ClientSideEvents Click="function(s, e) { OnNewItem(s, e); }" />
                            </dx:ASPxButton>

                        </div>
                    </div>
                </div>

                <p></p>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="col-sm-12 col-md-12 col-lg-12">

                            <dx:ASPxGridView ID="grvItem" runat="server" AutoGenerateColumns="false" DataSourceID="sdsItemDoc" KeyFieldName="IdItemDoc" ClientInstanceName="grvItem" Width="100%"
                                OnLoad="grvItem_Load" OnCustomCallback="grvItem_CustomCallback">

                                <Columns>

                                    <dx:GridViewCommandColumn VisibleIndex="0" ButtonType="Image" Caption="GerenciarItem" Name="GerenciarItem" Width="110px" ShowClearFilterButton="false" ShowEditButton="false" ShowDeleteButton="false"
                                        ShowNewButton="false" ShowCancelButton="false" ShowUpdateButton="false" ShowNewButtonInHeader="false">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton Visibility="AllDataRows" ID="btnEditaItem" Text="Editar" Image-Url="icon/glyphicons-151-edit.png">
                                            </dx:GridViewCommandColumnCustomButton>

                                            <dx:GridViewCommandColumnCustomButton Visibility="AllDataRows" ID="btnDeletaItem" Text="Deleta" Image-Url="icon/glyphicons-17-bin.png" Image-Height="20px" Image-Width="18px">
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>

                                    <dx:GridViewDataTextColumn FieldName="IdItemDoc" VisibleIndex="1" Visible="false">
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="IdDoc" VisibleIndex="2" Visible="false">
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Ordem" VisibleIndex="3" Caption="Ordem" Width="100px">
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="IdItem" VisibleIndex="4" Caption="Id Item" Visible="false">
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="NomeItem" VisibleIndex="5" Caption="Descrição do Item">
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Quantidade" VisibleIndex="6" Caption="Quantidade" Width="100px">
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Valor" VisibleIndex="7" Caption="Valor Unit." Width="200px">
                                        <PropertiesTextEdit DisplayFormatString="c2"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Total" VisibleIndex="8" Caption="Total" Width="200px" ReadOnly="true">
                                        <PropertiesTextEdit DisplayFormatString="c2"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>

                                </Columns>

                                <ClientSideEvents CustomButtonClick="OnCustomButton" EndCallback="OnEndCall" />

                                <SettingsPager PageSize="9999" Visible="False">
                                    <PageSizeItemSettings ShowAllItem="true"></PageSizeItemSettings>
                                </SettingsPager>

                                <Settings ShowFilterRow="false" ShowTitlePanel="false" ShowHeaderFilterButton="false" ShowGroupPanel="false" ShowFooter="true" />
                                <SettingsBehavior AllowFocusedRow="true" />

                                <Styles AlternatingRow-Enabled="True" FocusedRow-BackColor="#5cb85c" SelectedRow-BackColor="#F0AD4E">
                                    <GroupRow BackColor="#337AB7" Font-Bold="true" ForeColor="White"></GroupRow>
                                    <Footer BackColor="#D9534F" Font-Bold="true"></Footer>
                                </Styles>
                                <SettingsLoadingPanel Text="" />

                                <TotalSummary>
                                    <dx:ASPxSummaryItem FieldName="Total" ShowInGroupFooterColumn="Total" SummaryType="Sum" DisplayFormat="Total: {0:c2}" />
                                </TotalSummary>

                                <SettingsCommandButton>
                                    <EditButton Text="Editar" Image-Url="icon/glyphicons-151-edit.png"></EditButton>
                                    <NewButton Text="Incluir" Image-Url="icon/glyphicons-37-file.png" Image-Height="18px" Image-Width="16px"></NewButton>
                                    <CancelButton Text="Cancelar" Image-Url="icon/glyphicons-193-circle-remove.png"></CancelButton>
                                    <UpdateButton Text="Salvar" Image-Url="icon/glyphicons-194-circle-ok.png"></UpdateButton>
                                    <DeleteButton Text="Deletar" Image-Url="icon/glyphicons-17-bin.png" Image-Height="20px" Image-Width="18px"></DeleteButton>
                                    <ClearFilterButton Text="Limpar" Image-Url="icon/glyphicons-68-cleaning.png" Image-Height="24px" Image-Width="24px"></ClearFilterButton>
                                </SettingsCommandButton>

                            </dx:ASPxGridView>

                        </div>
                    </div>
                </div>

                <p></p>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <dx:ASPxButton ID="btnConfirmar" runat="server" EnableTheming="false" CssClass="btn btn-success btn-sm" ClientInstanceName="btnConfirmar"
                                Text="Salvar" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                                <Image Url="icon/glyphicons-194-circle-ok.png" Height="18px" Width="18px"></Image>
                                <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('a')){ grvItem.PerformCallback('ConfirmaDoc'); } }" />
                            </dx:ASPxButton>
                            <dx:ASPxButton ID="btnCancelar" runat="server" EnableTheming="false" CssClass="btn btn-danger btn-sm" ClientInstanceName="btnCancelar"
                                Text="Fechar" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                                <ClientSideEvents Click="function(s, e) { ClosePopupDoc(s, e); }" />
                                <Image Url="icon/glyphicons-198-remove.png" Height="18px" Width="18px"></Image>
                            </dx:ASPxButton>
                        </div>
                    </div>
                </div>

            </div>
        </div>

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

        <dx:ASPxPopupControl ID="popupItem" runat="server" HeaderText="" AllowDragging="false" PopupAnimationType="Slide" ClientInstanceName="popupItem" ShowOnPageLoad="false"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="1050px" Height="150px" Modal="true" CloseAction="None" CloseOnEscape="false" ShowCloseButton="false" ShowHeader="false">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server">
                    <div id="DivItem">

                        <div class="container-fluid">

                            <h4>Edição de Item</h4>

                            <div class="row">
                                <div class="col-sm-12 col-md-12 col-lg-12">

                                    <asp:HiddenField ID="HiddenIdItemDoc" runat="server" ClientIDMode="Static" />

                                    <div class="col-sm-1 col-md-1 col-lg-1">
                                        <dx:ASPxSpinEdit ID="spinOrdem" runat="server" Width="100%" Caption="Ordem" ClientInstanceName="spinOrdem"
                                            SpinButtons-ShowIncrementButtons="false" MaxValue="99" MinValue="0" AllowNull="false" AllowMouseWheel="false" Increment="0">
                                            <CaptionSettings Position="Top" ShowColon="false" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="b">
                                                <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                            </ValidationSettings>
                                            <InvalidStyle BackColor="LightPink" />
                                        </dx:ASPxSpinEdit>
                                    </div>

                                    <div class="col-sm-6 col-md-6 col-lg-6">
                                        <dx:ASPxComboBox ID="cboItem" runat="server" ValueType="System.Int32" ValueField="IdItem" ClientInstanceName="cboItem" TextField="NomeItem" TextFormatString="{0} | {1:c2}"
                                            Caption="Nome Item" Width="100%" DataSourceID="sdsItem" ShowShadow="false" DropDownStyle="DropDown" DataSecurityMode="Strict">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="NomeItem" Caption="Descrição do Item" />
                                                <dx:ListBoxColumn FieldName="Valor" Caption="Valor" />
                                            </Columns>
                                            <CaptionSettings Position="Top" ShowColon="false" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="b">
                                                <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                            </ValidationSettings>
                                            <InvalidStyle BackColor="LightPink" />
                                            <ClientSideEvents SelectedIndexChanged="function(s, e) {OnSetValorItem(s);}" />
                                        </dx:ASPxComboBox>
                                        <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
                                            SelectCommand="SELECT * FROM [Item]"></asp:SqlDataSource>
                                    </div>

                                    <div class="col-sm-1 col-md-1 col-lg-1">
                                        <dx:ASPxSpinEdit ID="spinQtd" runat="server" Width="100%" Caption="Qtd" ClientInstanceName="spinQtd"
                                            SpinButtons-ShowIncrementButtons="false" MaxValue="99" MinValue="1" AllowNull="false" AllowMouseWheel="false" Increment="0">
                                            <CaptionSettings Position="Top" ShowColon="false" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="b">
                                                <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                            </ValidationSettings>
                                            <InvalidStyle BackColor="LightPink" />
                                            <ClientSideEvents ValueChanged="function(s, e) { OnCalculaItem(); }" />
                                        </dx:ASPxSpinEdit>
                                    </div>

                                    <div class="col-sm-2 col-md-2 col-lg-2">
                                        <dx:ASPxSpinEdit ID="spinValor" runat="server" Width="100%" Caption="Valor Unit." ClientInstanceName="spinValor" DisplayFormatString="c2"
                                            SpinButtons-ShowIncrementButtons="false" MaxValue="2147483647" MinValue="0" AllowNull="false" AllowMouseWheel="false" Increment="0">
                                            <CaptionSettings Position="Top" ShowColon="false" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" SetFocusOnError="true" ValidationGroup="b">
                                                <RequiredField IsRequired="true" ErrorText="Campo obrigatório" />
                                            </ValidationSettings>
                                            <InvalidStyle BackColor="LightPink" />
                                            <ClientSideEvents ValueChanged="function(s, e) { OnCalculaItem(); }" />
                                        </dx:ASPxSpinEdit>
                                    </div>

                                    <div class="col-sm-2 col-md-2 col-lg-2">
                                        <dx:ASPxSpinEdit ID="spinTotal" runat="server" Width="100%" Caption="Total" ClientInstanceName="spinTotal" DisplayFormatString="c2" ClientEnabled="false"
                                            SpinButtons-ShowIncrementButtons="false" MaxValue="2147483647" MinValue="0" AllowNull="false" AllowMouseWheel="false" Increment="0">
                                            <CaptionSettings Position="Top" ShowColon="false" />
                                        </dx:ASPxSpinEdit>
                                    </div>
                                </div>
                            </div>

                            <p></p>

                            <div class="row">
                                <div class="col-sm-12 col-md-12 col-lg-12">
                                    <div class="col-sm-6 col-md-6 col-lg-6">
                                        <dx:ASPxButton ID="ASPxButton3" runat="server" EnableTheming="false" CssClass="btn btn-success btn-sm"
                                            Text="Confirmar" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                                            <Image Url="icon/glyphicons-194-circle-ok.png" Height="18px" Width="18px"></Image>
                                            <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('b')){ grvItem.PerformCallback('ConfirmaItem'); } }" />
                                        </dx:ASPxButton>
                                        <dx:ASPxButton ID="ASPxButton4" runat="server" EnableTheming="false" CssClass="btn btn-danger btn-sm"
                                            Text="Fechar" UseSubmitBehavior="false" AutoPostBack="false" Width="120px">
                                            <ClientSideEvents Click="function(s, e) { ClosePopupItem(s, e); }" />
                                            <Image Url="icon/glyphicons-198-remove.png" Height="18px" Width="18px"></Image>
                                        </dx:ASPxButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="popupDelItem" runat="server" HeaderText="" AllowDragging="false" PopupAnimationType="Slide" ClientInstanceName="popupDelItem" ShowOnPageLoad="false"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="200px" Height="150px" Modal="true" CloseAction="None" CloseOnEscape="false" ShowCloseButton="false" ShowHeader="false">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl4" runat="server">

                    <table style="width: 100%; text-align: center">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="ASPxLabel1" ClientInstanceName="ASPxLabel1" Font-Size="16px" runat="server" Text="Deseja realamente deletar este Registro?"></dx:ASPxLabel>
                            </td>

                        </tr>
                    </table>
                    <br />
                    <table style="width: 200px">
                        <tr style="width: 200px; text-align: center">
                            <td>
                                <dx:ASPxButton ID="ASPxButton6" runat="server" Text="Sim" EnableTheming="false" CssClass="btn btn-success btn-sm" UseSubmitBehavior="false" AutoPostBack="false" Width="60px">
                                    <Image Url="icon/glyphicons-194-circle-ok.png" Height="18px" Width="18px"></Image>
                                    <ClientSideEvents Click="function(s, e) { grvItem.GetRowValues(grvItem.GetFocusedRowIndex(), 'IdItemDoc', OnDeletaItem); popupDelItem.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="ASPxButton7" runat="server" Text="Não" EnableTheming="false" CssClass="btn btn-danger btn-sm" UseSubmitBehavior="false" AutoPostBack="false" Width="60px">
                                    <Image Url="icon/glyphicons-194-circle-ok.png" Height="18px" Width="18px"></Image>
                                    <ClientSideEvents Click="function(s, e) { popupDelItem.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <asp:SqlDataSource ID="sdsContato" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [Contato] where IdEmpresa = @IdEmpresa">
            <SelectParameters>
                <asp:ControlParameter ControlID="cboEmpresa" Name="IdEmpresa" PropertyName="Value" DefaultValue="0" Type="Int32" />                
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsItemDoc" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT id.IdItemDoc, id.IdDoc, id.Ordem, id.IdItem, i.NomeItem, id.Quantidade, id.Valor, id.Total FROM [ItemDoc] id 
                                                               join Item i on id.IdItem = i.IdItem
                                                               where IdDoc = @IdDoc order by Ordem asc">
            <SelectParameters>
                <asp:ControlParameter ControlID="HiddenIdDoc" Name="IdDoc" PropertyName="Value" DefaultValue="0" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsEmpresa" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [Empresa]"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsTipoDoc" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [TipoDoc]"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsUsuario" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [Usuario]"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsSituacaoDoc" runat="server" ConnectionString="<%$ ConnectionStrings:neo %>"
            SelectCommand="SELECT * FROM [SituacaoDoc]"></asp:SqlDataSource>

    </form>
</body>
</html>
