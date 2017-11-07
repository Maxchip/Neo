using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace neo
{
    public partial class Company : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["neo"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void grvEmpresa_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            SqlCommand comm = new SqlCommand();
            comm.Connection = con;
            comm.CommandText = "select IdEmpresa, NomeEmpresa from Empresa where NomeEmpresa = @NomeEmpresa";
            comm.Parameters.AddWithValue("@NomeEmpresa", e.NewValues["NomeEmpresa"].ToString());
            con.Open();
            SqlDataReader reader = comm.ExecuteReader();
            var varTable = new DataTable();
            varTable.Load(reader);
            con.Close();
            if (varTable.Rows.Count > 0)
            {
                if (grvEmpresa.IsNewRowEditing)
                {
                    GridViewDataTextColumn col = ((ASPxGridView)sender).Columns["NomeEmpresa"] as GridViewDataTextColumn;
                    e.Errors.Add(col, "Este item já existe");
                }

                if (!grvEmpresa.IsNewRowEditing)
                {
                    object rowKey = grvEmpresa.GetRowValues(grvEmpresa.EditingRowVisibleIndex, grvEmpresa.KeyFieldName);

                    SqlCommand commEd = new SqlCommand();
                    commEd.Connection = con;
                    commEd.CommandText = "select IdEmpresa, NomeEmpresa from Empresa where IdEmpresa = @IdEmpresa";
                    commEd.Parameters.AddWithValue("@IdEmpresa", Convert.ToInt32(rowKey));
                    con.Open();
                    SqlDataReader readerEd = commEd.ExecuteReader();
                    var varTableEd = new DataTable();
                    varTableEd.Load(readerEd);
                    con.Close();

                    if (Convert.ToInt32(rowKey) != Convert.ToInt32(varTable.Rows[0]["IdEmpresa"]))
                    {
                        GridViewDataTextColumn col = ((ASPxGridView)sender).Columns["NomeEmpresa"] as GridViewDataTextColumn;
                        e.Errors.Add(col, "Este item já existe");
                    }
                }
            }
        }
    }
}