using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace neo
{
    public partial class Default : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["neo"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region Grid Doc

        protected void grvDoc_Load(object sender, EventArgs e)
        {
            ConsultaDoc();
        }

        protected void grvDoc_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parameter = e.Parameters.Split(':');

            switch (parameter[0])
            {
                case ("ConsultaDoc"):

                    ConsultaDoc();

                    break;

                case ("EditDoc"):

                    if (parameter[1] != String.Empty)
                    {
                        if (ConsultaSitDoc(Convert.ToInt32(parameter[1])) < 5)
                        {
                            grvDoc.JSProperties["cpOpe"] = "yesEdit";
                            grvDoc.JSProperties["cpIdDoc"] = (parameter[1]);
                        }
                        else
                        {
                            grvDoc.JSProperties["cpOpe"] = "noEdit";
                            grvDoc.JSProperties["cpMSG"] = "Error! You can't change this Doc!";
                        }
                    }

                    break;

                case ("DeletaDoc"):

                    if (parameter[1] != String.Empty)
                    {
                        DeletaDoc(Convert.ToInt32(parameter[1]));
                    }

                    break;

                case ("Pendente"):

                    if (parameter[1] != String.Empty)
                    {
                        MudaSituacaoDoc(1, Convert.ToInt32(parameter[1]));
                    }

                    break;

                case ("Finalizado"):

                    if (parameter[1] != String.Empty)
                    {
                        MudaSituacaoDoc(2, Convert.ToInt32(parameter[1]));
                    }

                    break;

                case ("Avaliacao"):

                    if (parameter[1] != String.Empty)
                    {
                        MudaSituacaoDoc(3, Convert.ToInt32(parameter[1]));
                    }

                    break;

                case ("Atendido"):

                    if (parameter[1] != String.Empty)
                    {
                        MudaSituacaoDoc(4, Convert.ToInt32(parameter[1]));
                    }

                    break;
            }
        }

        #endregion

        #region Metodos e Funções Doc

        public void ConsultaDoc()
        {
            string wheretxt = String.Empty;
            string strSitDoc = String.Empty;

            if (FiltrodataInicio.Date.Year > 1900 && FiltrodataFim.Date.Year > 1900)
            {
                wheretxt += " and (do.DataCadastro >= '" + FiltrodataInicio.Date.ToString("yyyy-MM-dd") + "') and (do.DataCadastro <= '" + FiltrodataFim.Date.ToString("yyyy-MM-dd") + "')";
            }

            if (FiltroNumeroDoc.Value != null)
            {
                wheretxt += " and do.NumeroDoc like '%" + FiltroNumeroDoc.Text.Trim() + "%'";
            }

            if (FiltrocboEmpresa.Value != null)
            {
                wheretxt += " and do.IdEmpresa = " + FiltrocboEmpresa.Value;
            }

            if (FiltrocboTipo.Value != null)
            {
                wheretxt += " and do.IdTipoDoc = " + FiltrocboTipo.Value;
            }

            if (FiltrolukSitDoc.Value != null)
            {
                ASPxGridView gridFiltrolukSit = FiltrolukSitDoc.GridView;

                List<object> fieldValues = gridFiltrolukSit.GetSelectedFieldValues(new string[] { "NomeSituacaoDoc" });

                int count = 1;

                if (fieldValues.Count > 0)
                {
                    for (int i = 0; i < fieldValues.Count; i++)
                    {
                        if (count == fieldValues.Count)
                        {
                            strSitDoc += "sd.NomeSituacaoDoc like '%" + fieldValues[i] + "%'";
                        }
                        else
                        {
                            strSitDoc += "sd.NomeSituacaoDoc like '%" + fieldValues[i] + "%' OR ";
                            count++;
                        }
                    }

                    strSitDoc = " and (" + strSitDoc + ")";
                }
            }

            if (wheretxt != String.Empty || strSitDoc != String.Empty)
            {
                SqlCommand comm = new SqlCommand();
                comm.Connection = con;
                comm.CommandText = @"SELECT do.IdDoc, do.IdTipoDoc, do.IdEmpresa, do.IdContato, do.DataCadastro, do.IdUsuario, do.DataVencimento, do.Vencimento,
                                     do.Observacao, do.Remessa, ti.NomeTipoDoc, e.NomeEmpresa, do.NumeroDoc, do.IdSituacaoDoc, sd.NomeSituacaoDoc, c.NomeContato,

                                     (Select sum(id.Total)
                                     from ItemDoc id
                                     where id.IdDoc = do.IdDoc) as Total

                                     FROM Doc do
                                     join Empresa e on do.IdEmpresa = e.IdEmpresa
                                     join Contato c on do.IdContato = c.IdContato
                                     join TipoDoc ti on do.IdTipoDoc = ti.IdTipoDoc 
                                     join SituacaoDoc sd on do.IdSituacaoDoc = sd.IdSituacaoDoc    
                                                                                                                                         
                                     where 1=1 " + wheretxt + strSitDoc + " order by do.IdDoc desc";

                con.Open();
                SqlDataReader reader = comm.ExecuteReader();
                var varTable = new DataTable();
                varTable.Load(reader);
                con.Close();

                if (varTable.Rows.Count > 0)
                {
                    grvDoc.DataSource = varTable;
                    grvDoc.DataBind();
                }
                else
                {
                    grvDoc.DataSource = null;
                    grvDoc.DataBind();
                }
            }
            else
            {
                grvDoc.DataSource = null;
                grvDoc.DataBind();
            }
        }

        public void DeletaDoc(Int32 IdDoc)
        {
            if (ConsultaSitDoc(IdDoc) < 5)
            {
                SqlCommand commItem = new SqlCommand();
                commItem.Connection = con;
                commItem.CommandText = "delete from ItemDoc where IdDoc = @IdDoc";
                commItem.Parameters.AddWithValue("@IdDoc", Convert.ToInt32(IdDoc));
                con.Open();
                commItem.ExecuteNonQuery();
                con.Close();

                SqlCommand commDoc = new SqlCommand();
                commDoc.Connection = con;
                commDoc.CommandText = "delete from Doc where IdDoc = @IdDoc";
                commDoc.Parameters.AddWithValue("@IdDoc", Convert.ToInt32(IdDoc));
                con.Open();
                commDoc.ExecuteNonQuery();
                con.Close();

                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Registro deletado com sucesso!";
            }
            else
            {
                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Erro, esta operação pode ser executada!";
            }
        }

        public void MudaSituacaoDoc(Int32 IdSituacaoDoc, Int32 IdDoc)
        {
            int IdSituacaoDocAtual = ConsultaSitDoc(IdDoc);

            SqlCommand commSit = new SqlCommand();
            commSit.Connection = con;

            commSit.CommandText = @"update Doc set IdSituacaoDoc = @IdSituacaoDoc where IdDoc = @IdDoc";
            commSit.Parameters.AddWithValue("@IdDoc", IdDoc);

            if (IdSituacaoDoc == 1 && IdSituacaoDocAtual == 2)
            {
                commSit.Parameters.AddWithValue("@IdSituacaoDoc", IdSituacaoDoc);
                con.Open();
                commSit.ExecuteNonQuery();
                con.Close();

                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Situação alterada com sucesso!";
            }
            else if (IdSituacaoDoc == 2 && IdSituacaoDocAtual == 1)
            {
                commSit.Parameters.AddWithValue("@IdSituacaoDoc", IdSituacaoDoc);
                con.Open();
                commSit.ExecuteNonQuery();
                con.Close();

                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Situação alterada com sucesso!";
            }
            else if (IdSituacaoDoc == 2 && IdSituacaoDocAtual == 3)
            {
                commSit.Parameters.AddWithValue("@IdSituacaoDoc", IdSituacaoDoc);
                con.Open();
                commSit.ExecuteNonQuery();
                con.Close();

                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Situação alterada com sucesso!";
            }
            else if (IdSituacaoDoc == 3 && IdSituacaoDocAtual == 2)
            {
                commSit.Parameters.AddWithValue("@IdSituacaoDoc", IdSituacaoDoc);
                con.Open();
                commSit.ExecuteNonQuery();
                con.Close();

                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Situação alterada com sucesso!";
            }
            else if (IdSituacaoDoc == 3 && IdSituacaoDocAtual == 4)
            {
                commSit.Parameters.AddWithValue("@IdSituacaoDoc", IdSituacaoDoc);
                con.Open();
                commSit.ExecuteNonQuery();
                con.Close();

                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Situação alterada com sucesso!";
            }
            else if (IdSituacaoDoc == 4 && IdSituacaoDocAtual == 3)
            {
                commSit.Parameters.AddWithValue("@IdSituacaoDoc", IdSituacaoDoc);
                con.Open();
                commSit.ExecuteNonQuery();
                con.Close();

                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Situação alterada com sucesso!";
            }
            else
            {
                grvDoc.JSProperties["cpOpe"] = "OK";
                grvDoc.JSProperties["cpMSG"] = "Erro, esta operação pode ser executada!";
            }
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

        #endregion       
    }
}