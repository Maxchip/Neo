<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintView.aspx.cs" Inherits="neo.PrintView" %>

<%@ Register Assembly="DevExpress.XtraReports.v16.1.Web, Version=16.1.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Print View</title>
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
    function OnCloseClick(s, e) {
        $(form1).empty();
        window.parent.popupVisualizar.Hide();
    }
</script>
<body>
    <form id="form1" runat="server">

        <div>
            <dx:ASPxDocumentViewer ID="ASPxDocumentViewer1" runat="server">
                <ToolbarItems>
                    <dx:ReportToolbarButton Name="Fechar" Text="Fechar" />
                    <dx:ReportToolbarSeparator />
                    <dx:ReportToolbarButton ItemKind="Search" />
                    <dx:ReportToolbarSeparator />
                    <dx:ReportToolbarButton ItemKind="PrintReport" />
                    <dx:ReportToolbarButton ItemKind="PrintPage" />
                    <dx:ReportToolbarSeparator />
                    <dx:ReportToolbarButton Enabled="False" ItemKind="FirstPage" />
                    <dx:ReportToolbarButton Enabled="False" ItemKind="PreviousPage" />
                    <dx:ReportToolbarLabel ItemKind="PageLabel" />
                    <dx:ReportToolbarComboBox ItemKind="PageNumber" Width="65px">
                    </dx:ReportToolbarComboBox>
                    <dx:ReportToolbarLabel ItemKind="OfLabel" />
                    <dx:ReportToolbarTextBox IsReadOnly="True" ItemKind="PageCount" />
                    <dx:ReportToolbarButton ItemKind="NextPage" />
                    <dx:ReportToolbarButton ItemKind="LastPage" />
                    <dx:ReportToolbarSeparator />
                    <dx:ReportToolbarButton ItemKind="SaveToDisk" />
                    <dx:ReportToolbarButton ItemKind="SaveToWindow" />
                    <dx:ReportToolbarComboBox ItemKind="SaveFormat" Width="70px">
                        <Elements>
                            <dx:ListElement Value="pdf" />
                            <dx:ListElement Value="xls" />
                            <dx:ListElement Value="xlsx" />
                            <dx:ListElement Value="rtf" />
                            <dx:ListElement Value="mht" />
                            <dx:ListElement Value="html" />
                            <dx:ListElement Value="txt" />
                            <dx:ListElement Value="csv" />
                            <dx:ListElement Value="png" />
                        </Elements>
                    </dx:ReportToolbarComboBox>
                    <dx:ReportToolbarSeparator />
                </ToolbarItems>
                <ClientSideEvents ToolbarItemClick="function(s, e) {
	                                            if(e.item.name == 'Fechar') {
                                                OnCloseClick(s, e);
                                                }
                                                }" />
            </dx:ASPxDocumentViewer>
        </div>
    </form>
</body>
</html>
