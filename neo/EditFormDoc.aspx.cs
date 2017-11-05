using System;
using System.Data;
using System.Data.SqlClient;

namespace neo
{
    public partial class EditFormDoc : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["neo"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        #region Metodos e Funções Doc 

        protected void cboTipo_Init(object sender, EventArgs e)
        {
            Int32 IdDoc = Convert.ToInt32(Request.Params["IdDoc"]);

            if (IdDoc > 0)
            {
                cboTipo.ReadOnly = true;
                cboTipo.DropDownButton.Enabled = false;
            }
        }

        protected void txtCadastro_Init(object sender, EventArgs e)
        {
            Int32 IdDoc = Convert.ToInt32(Request.Params["IdDoc"]);

            if (IdDoc == 0)
            {
                txtCadastro.Text = DateTime.Now.Date.ToShortDateString();
            }
        }

        protected void cboSituacaoDoc_Init(object sender, EventArgs e)
        {
            Int32 IdDoc = Convert.ToInt32(Request.Params["IdDoc"]);

            if (IdDoc == 0)
            {
                cboSituacaoDoc.Value = 1;
            }
        }

        protected void cboContato_Init(object sender, EventArgs e)
        {
            Int32 IdDoc = Convert.ToInt32(Request.Params["IdDoc"]);

            if (IdDoc > 0)
            {              
                SqlCommand comm1 = new SqlCommand();
                comm1.Connection = con;
                comm1.CommandText = "select IdDoc, IdEmpresa, IdContato from Doc where IdDoc = @IdDoc";
                comm1.Parameters.AddWithValue("@IdDoc", IdDoc);
                con.Open();
                DataTable varTable1 = new DataTable();
                SqlDataReader reader1 = comm1.ExecuteReader();
                varTable1.Load(reader1);
                con.Close();

                SqlCommand comm2 = new SqlCommand();
                comm2.Connection = con;
                comm2.CommandText = "select IdContato, NomeContato, IdEmpresa from Contato where IdEmpresa = @IdEmpresa";
                comm2.Parameters.AddWithValue("@IdEmpresa", varTable1.Rows[0]["IdEmpresa"]);
                con.Open();
                DataTable varTable2 = new DataTable();
                SqlDataReader reader2 = comm2.ExecuteReader();
                varTable2.Load(reader2);
                con.Close();

                sdsContato.SelectParameters["IdEmpresa"].DefaultValue = varTable1.Rows[0]["IdEmpresa"].ToString();
                cboContato.Value = varTable1.Rows[0]["IdContato"];
                cboContato.DataBind();                
            }
        }        

        protected void cboContato_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {                       
            sdsContato.SelectParameters["IdEmpresa"].DefaultValue = e.Parameter;
            cboContato.DataBind();
        }

        public int ConsultaSitDoc(Int32 IdDoc)
        {
            SqlCommand comm = new SqlCommand();
            comm.Connection = con;
            comm.CommandText = @"SELECT IdSituacaoDoc FROM Doc where IdDoc = @IdDoc";
            comm.Parameters.AddWithValue("@IdDoc", IdDoc);
            con.Open();
            int IdSituacaoDoc = (int)comm.ExecuteScalar();
            con.Close();

            return IdSituacaoDoc;
        }

        protected void ConfirmaDoc()
        {
            Int32 IdSituacaoDoc = 0;
            Int32 IdDoc = 0;
            String NumeroDoc = String.Empty;

            if (HiddenIdDoc.Value != String.Empty)
            {
                IdSituacaoDoc = ConsultaSitDoc(Convert.ToInt32(HiddenIdDoc.Value));

                if (IdSituacaoDoc < 5)
                {
                    SqlCommand commEdit = new SqlCommand();
                    commEdit.Connection = con;

                    commEdit.CommandText = @"update Doc 
                                           set IdTipoDoc = @IdTipoDoc, IdEmpresa = @IdEmpresa, IdContato = @IdContato, Vencimento = @Vencimento,
                                           DataVencimento = @DataVencimento, Observacao = @Observacao, Remessa = @Remessa, IdUsuario = @IdUsuario,
                                           SemVencimento = @SemVencimento where IdDoc = @IdDoc";

                    commEdit.Parameters.AddWithValue("@IdDoc", HiddenIdDoc.Value);
                    commEdit.Parameters.AddWithValue("@IdTipoDoc", cboTipo.Value);
                    commEdit.Parameters.AddWithValue("@IdEmpresa", cboEmpresa.Value);
                    commEdit.Parameters.AddWithValue("@IdContato", HiddenIdContato.Value);
                    commEdit.Parameters.AddWithValue("@IdUsuario", cboUsuario.Value);

                    if (dateVencimento.Value != null)
                    {
                        commEdit.Parameters.AddWithValue("@DataVencimento", Convert.ToDateTime(dateVencimento.Value).Date);
                    }
                    else
                    {
                        commEdit.Parameters.AddWithValue("@DataVencimento", DBNull.Value);
                    }

                    if (chkVencimento.Checked)
                    {
                        commEdit.Parameters.AddWithValue("@SemVencimento", true);
                    }
                    else
                    {
                        commEdit.Parameters.AddWithValue("@SemVencimento", false);
                    }

                    commEdit.Parameters.AddWithValue("@Observacao", memoObs.Text.Trim());
                    commEdit.Parameters.AddWithValue("@Remessa", txtRemessa.Text.Trim());
                    commEdit.Parameters.AddWithValue("@Vencimento", txtVencimento.Text.Trim());

                    con.Open();
                    commEdit.ExecuteNonQuery();
                    con.Close();

                    grvItem.JSProperties["cpOpe"] = "OK";
                    grvItem.JSProperties["cpMSG"] = "Registro alterado com sucesso!";
                }
                else
                {
                    grvItem.JSProperties["cpOpe"] = "OK";
                    grvItem.JSProperties["cpMSG"] = "Error! You can't change this Doc!";
                }
            }
            else
            {
                SqlCommand commIns = new SqlCommand();
                commIns.Connection = con;
                commIns.CommandText = @"insert into Doc (IdTipoDoc, IdEmpresa, DataCadastro, IdContato, IdUsuario, DataVencimento, Observacao, Remessa, NumeroDoc, IdSituacaoDoc, Vencimento,
                                        SemVencimento)
                                        values (@IdTipoDoc, @IdEmpresa, @DataCadastro, @IdContato, @IdUsuario, @DataVencimento, @Observacao, @Remessa, @NumeroDoc, @IdSituacaoDoc, @Vencimento,
                                        @SemVencimento); select cast(scope_identity() as int)";

                commIns.Parameters.AddWithValue("@IdTipoDoc", cboTipo.Value);
                commIns.Parameters.AddWithValue("@IdEmpresa", cboEmpresa.Value);
                commIns.Parameters.AddWithValue("@DataCadastro", txtCadastro.Text);
                commIns.Parameters.AddWithValue("@IdContato", HiddenIdContato.Value);
                commIns.Parameters.AddWithValue("@IdUsuario", cboUsuario.Value);

                if (dateVencimento.Value != null)
                {
                    commIns.Parameters.AddWithValue("@DataVencimento", Convert.ToDateTime(dateVencimento.Value).Date);
                }
                else
                {
                    commIns.Parameters.AddWithValue("@DataVencimento", DBNull.Value);
                }

                if (chkVencimento.Checked)
                {
                    commIns.Parameters.AddWithValue("@SemVencimento", true);
                }
                else
                {
                    commIns.Parameters.AddWithValue("@SemVencimento", false);
                }

                commIns.Parameters.AddWithValue("@Observacao", memoObs.Text.Trim());
                commIns.Parameters.AddWithValue("@Remessa", txtRemessa.Text.Trim());

                if (Convert.ToInt32(cboTipo.Value) == 2)
                {
                    VerificaAnoNovo(Convert.ToInt32(cboTipo.Value));
                    NumeroDoc = CriaNumCartaCob();
                    commIns.Parameters.AddWithValue("@NumeroDoc", NumeroDoc);
                }
                else if (Convert.ToInt32(cboTipo.Value) == 3)
                {
                    VerificaAnoNovo(Convert.ToInt32(cboTipo.Value));
                    NumeroDoc = CriaNumCartaCob();
                    commIns.Parameters.AddWithValue("@NumeroDoc", NumeroDoc);
                }
                else
                {
                    commIns.Parameters.AddWithValue("@NumeroDoc", String.Empty);
                }

                commIns.Parameters.AddWithValue("@IdSituacaoDoc", cboSituacaoDoc.Value);

                commIns.Parameters.AddWithValue("@Vencimento", txtVencimento.Text.Trim());

                con.Open();
                IdDoc = (Int32)commIns.ExecuteScalar();
                con.Close();

                grvItem.JSProperties["cpOpe"] = "New";
                grvItem.JSProperties["cpNDoc"] = NumeroDoc;
                grvItem.JSProperties["cpIDoc"] = IdDoc;
                grvItem.JSProperties["cpMSG"] = "Registro criado com sucesso!";
            }
        }

        #endregion

        #region Grid Item

        protected void grvItem_Load(object sender, EventArgs e)
        {
            if (HiddenIdDoc.Value != String.Empty)
            {
                sdsItemDoc.SelectParameters["IdDoc"].DefaultValue = HiddenIdDoc.Value;
            }
        }

        protected void grvItem_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parameter = e.Parameters.Split(':');

            switch (parameter[0])
            {
                case ("ConfirmaDoc"):

                    ConfirmaDoc();

                    break;

                case ("ConfirmaItem"):

                    ConfirmaItem();

                    break;

                case ("DeletaItem"):

                    if (parameter[1] != String.Empty)
                    {
                        DeletaItem(Convert.ToInt32(parameter[1]));
                    }

                    break;
            }
        }

        #endregion

        #region Metodos e Funções Item

        public void DeletaItem(Int32 IdItemDoc)
        {
            SqlCommand comm = new SqlCommand();
            comm.Connection = con;
            comm.CommandText = "delete from ItemDoc where IdItemDoc = @IdItemDoc";
            comm.Parameters.AddWithValue("@IdItemDoc", Convert.ToInt32(IdItemDoc));
            con.Open();
            comm.ExecuteNonQuery();
            con.Close();

            grvItem.JSProperties["cpOpe"] = "OK";
            grvItem.JSProperties["cpMSG"] = "Registro deletado com sucesso!";
        }

        public void ConfirmaItem()
        {
            if (HiddenIdItemDoc.Value != String.Empty)
            {
                SqlCommand commEdit = new SqlCommand();
                commEdit.Connection = con;

                commEdit.CommandText = @"update ItemDoc 
                                         set Ordem = @Ordem, IdItem = @IdItem, Quantidade = @Quantidade, 
                                         Valor = @Valor, Total = @Total
                                         where IdItemDoc = @IdItemDoc";

                commEdit.Parameters.AddWithValue("@IdItemDoc", HiddenIdItemDoc.Value);
                commEdit.Parameters.AddWithValue("@Ordem", spinOrdem.Value);
                commEdit.Parameters.AddWithValue("@IdItem", cboItem.Value);
                commEdit.Parameters.AddWithValue("@Quantidade", spinQtd.Value);

                commEdit.Parameters.AddWithValue("@Valor", Convert.ToDouble(spinValor.Value));
                commEdit.Parameters.AddWithValue("@Total", Convert.ToDouble(spinTotal.Value));

                con.Open();
                commEdit.ExecuteNonQuery();
                con.Close();

                grvItem.JSProperties["cpOpe"] = "OK";
                grvItem.JSProperties["cpMSG"] = "Registro alterado com sucesso!";
            }
            else
            {
                SqlCommand commIns = new SqlCommand();
                commIns.Connection = con;
                commIns.CommandText = @"insert into ItemDoc (IdDoc, Ordem, IdItem, Quantidade, Valor, Total)
                                        values (@IdDoc, @Ordem, @IdItem, @Quantidade, @Valor, @Total)";

                commIns.Parameters.AddWithValue("@IdDoc", HiddenIdDoc.Value);
                commIns.Parameters.AddWithValue("@Ordem", spinOrdem.Value);
                commIns.Parameters.AddWithValue("@IdItem", cboItem.Value);
                commIns.Parameters.AddWithValue("@Quantidade", spinQtd.Value);

                commIns.Parameters.AddWithValue("@Valor", Convert.ToDouble(spinValor.Value));
                commIns.Parameters.AddWithValue("@Total", Convert.ToDouble(spinTotal.Value));

                con.Open();
                commIns.ExecuteNonQuery();
                con.Close();

                grvItem.JSProperties["cpOpe"] = "OK";
                grvItem.JSProperties["cpMSG"] = "Registro criado com sucesso!";
            }
        }

        #endregion

        #region Cria Nº Doc

        public string CriaNumNotaDeb()
        {
            SqlCommand comm = new SqlCommand();
            comm.Connection = con;
            comm.CommandText = "Select CONVERT(varchar(15), NEXT VALUE FOR dbo.SeqNumCartaCob) + ('/') + RIGHT(CAST(YEAR(GETDATE()) as CHAR(4)), 2) as NumNotaDeb";
            con.Open();
            string NumNotaDeb = (string)comm.ExecuteScalar();
            con.Close();

            return NumNotaDeb;
        }

        public string CriaNumCartaCob()
        {
            SqlCommand comm = new SqlCommand();
            comm.Connection = con;
            comm.CommandText = "Select CONVERT(varchar(15), NEXT VALUE FOR dbo.SeqNumNotaDeb) + ('/') + RIGHT(CAST(YEAR(GETDATE()) as CHAR(4)), 2) as NumCartaCob";
            con.Open();
            string NumCartaCob = (string)comm.ExecuteScalar();
            con.Close();

            return NumCartaCob;
        }

        public void VerificaAnoNovo(int IdTipoDoc)
        {
            int anoNovo = Convert.ToInt32(DateTime.Now.ToString("yy"));
            int mesAtual = DateTime.Now.Month;

            if (mesAtual == 1)
            {
                SqlCommand commVelho = new SqlCommand();
                commVelho.Connection = con;
                commVelho.CommandText = "Select top 1 RIGHT(CAST(YEAR(DataCadastro) as CHAR(4)), 2) as DataCadastro from Doc where IdTipoDoc = @IdTipoDoc order by IdDoc desc";
                commVelho.Parameters.AddWithValue("@IdTipoDoc", IdTipoDoc);
                con.Open();
                int anoVelho = (int)commVelho.ExecuteScalar();
                con.Close();

                if (IdTipoDoc == 2)
                {
                    if (anoVelho < anoNovo)
                    {
                        SqlCommand commNovo = new SqlCommand();
                        commNovo.Connection = con;
                        commNovo.CommandText = "declare @command varchar(MAX) SET @command = 'ALTER SEQUENCE dbo.SeqNumNotaDeb RESTART WITH 1' execute (@command)";
                        con.Open();
                        commNovo.ExecuteNonQuery();
                        con.Close();
                    }
                }
                else if (IdTipoDoc == 3)
                {
                    if (anoVelho < anoNovo)
                    {
                        SqlCommand commNovo = new SqlCommand();
                        commNovo.Connection = con;
                        commNovo.CommandText = "declare @command varchar(MAX) SET @command = 'ALTER SEQUENCE dbo.SeqNumCartaCob RESTART WITH 1' execute (@command)";
                        con.Open();
                        commNovo.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
        }

        #endregion        
    }
}