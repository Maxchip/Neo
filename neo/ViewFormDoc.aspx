<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewFormDoc.aspx.cs" Inherits="neo.ViewFormDoc" %>

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

        $.ajax({
            url: "HandlerDoc.ashx",
            type: "POST",
            data: { IdDoc },
            dataType: "json",
            success: function (data) {

                txtIdDoc.SetText(data["Doc"][0].IdDoc);
                txtNumeroDoc.SetText(data["Doc"][0].NumeroDoc);
                txtCadastro.SetText(data["Doc"][0].DataCadastro);
                txtTipo.SetText(data["Doc"][0].NomeTipoDoc);
                txtEmpresa.SetText(data["Doc"][0].NomeEmpresa);
                txtContato.SetText(data["Doc"][0].NomeContato);
                txtSituacaoDoc.SetText(data["Doc"][0].NomeSituacaoDoc);
                chkVenciemnto.SetValue(data["Doc"][0].SemVencimento);
                txtVencimento.SetText(data["Doc"][0].Vencimento);
                txtDataVenc.SetText(data["Doc"][0].DataVencimento);
                txtUsuario.SetText(data["Doc"][0].NomeUsuario);
                txtRemessa.SetText(data["Doc"][0].Remessa);
                memoObs.SetText(data["Doc"][0].Observacao);

                var trHTML = '';

                $.each(data['Item'], function (i) {

                    trHTML += '<tr><td style="text-align:center">' + data['Item'][i].IdItemDoc +
                        '</td><td style="text-align:center">' + data['Item'][i].IdDoc +
                        '</td><td style="text-align:center">' + data['Item'][i].IdItem +
                        '</td><td style="text-align:center">' + data['Item'][i].Ordem +
                        '</td><td>' + data['Item'][i].NomeItem +
                        '</td><td style="text-align:center">' + data['Item'][i].Quantidade +
                        '</td><td style="text-align:right">' + 'R$ ' + data['Item'][i].Valor +
                        '</td><td style="text-align:right">' + 'R$ ' + data['Item'][i].Total +
                        '</td></tr>';
                });

                $('#tableItems').append(trHTML);

                document.getElementById('lblTotal').innerHTML = "Total: R$ " + data["Doc"][0].Total;
                
            },

            failure: function (data) {
                alert("Erro");
            }
        });
    });

    function ClosePopupDoc(s, e) {
        $(form1).empty();
        window.parent.popupVisualizar.Hide();
    }

</script>


<body>
    <form id="form1" runat="server">

        <div class="navbar navbar-default navbar-fixed-top" role="navigation">
            <div class="navbar-header">

                <div class="pull-left">

                    <a class="btn">
                        <h4 style="color: white">View Doc</h4>
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
                            <dx:ASPxTextBox ID="txtCadastro" runat="server" ClientInstanceName="txtCadastro" Width="100%" Caption="Cadastro" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <dx:ASPxTextBox ID="txtEmpresa" runat="server" ClientInstanceName="txtEmpresa" Width="100%" Caption="Empresa" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxTextBox ID="txtTipo" runat="server" ClientInstanceName="txtTipo" Width="100%" Caption="Tipo" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <dx:ASPxTextBox ID="txtContato" runat="server" ClientInstanceName="txtContato" Width="100%" Caption="Contato" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxTextBox ID="txtSituacaoDoc" runat="server" ClientInstanceName="txtSituacaoDoc" Width="100%" Caption="Situação Doc" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-1 col-md-1 col-lg-1" style="padding-top: 10px">
                            <dx:ASPxLabel runat="server" ID="lblFiltroData" Text="Sem Venc." Font-Bold="true"></dx:ASPxLabel>
                            <dx:ASPxCheckBox ID="chkVenciemnto" ClientInstanceName="chkVenciemnto" runat="server" Width="100%" ReadOnly="true">
                            </dx:ASPxCheckBox>
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxTextBox ID="txtVencimento" runat="server" ClientInstanceName="txtVencimento" Width="100%" Caption="Sem Vencimento" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxTextBox ID="txtDataVenc" runat="server" ClientInstanceName="txtDataVenc" Width="100%" Caption="Vencimento" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-3 col-md-3 col-lg-3">
                            <dx:ASPxTextBox ID="txtUsuario" runat="server" ClientInstanceName="txtUsuario" Width="100%" Caption="Usuário" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                        <div class="col-sm-2 col-md-2 col-lg-2">
                            <dx:ASPxTextBox ID="txtRemessa" runat="server" ClientInstanceName="txtRemessa" Width="100%" Caption="Remessa" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxTextBox>
                        </div>

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <dx:ASPxMemo ID="memoObs" runat="server" Caption="Observação" Width="100%" Height="150px" ClientInstanceName="memoObs" ReadOnly="true">
                                <CaptionSettings Position="Top" ShowColon="false" />
                            </dx:ASPxMemo>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-md-12 col-lg-12">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <h2>Items</h2>

                            <table id="tableItems" class="table table-striped table-bordered table-hover table-responsive" style="background-color: white">
                                <thead style="background-color:#337AB7; color:white">
                                    <tr>
                                        <th style="text-align:center">IdItemDoc</th>
                                        <th style="text-align:center">IdDoc</th>
                                        <th style="text-align:center">IdItem</th>
                                        <th style="text-align:center">Ordem</th>
                                        <th style="text-align:center">Descrição Item</th>
                                        <th style="text-align:center">Quantidade</th>
                                        <th style="text-align:center">Valor</th>
                                        <th style="text-align:center">Total</th>
                                    </tr>
                                </thead>
                            </table>
                            <table class="table table-responsive" style="background-color:#D9534F">
                                <tr>
                                    <td style="text-align:right">
                                        <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </form>
</body>
</html>
