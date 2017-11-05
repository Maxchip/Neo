using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;

namespace neo
{
    /// <summary>
    /// Summary description for HandlerDoc
    /// </summary>
    public class HandlerDoc : IHttpHandler
    {
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["neo"].ConnectionString);

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            string IdDoc = context.Request["IdDoc"];

            objJson Lista = new objJson();
            Lista.Doc = new List<object>();
            Lista.Item = new List<object>();

            // Query Doc
            SqlCommand commDoc = new SqlCommand();
            commDoc.Connection = con;
            commDoc.CommandText = @"SELECT do.IdDoc, do.IdTipoDoc, ti.NomeTipoDoc, do.IdEmpresa, e.NomeEmpresa, do.IdContato, c.NomeContato, do.IdUsuario, u.NomeUsuario, 
                                  do.DataCadastro, do.DataVencimento, do.SemVencimento, do.Vencimento,  
                                  do.Remessa, do.Observacao, do.NumeroDoc, do.IdSituacaoDoc, sd.NomeSituacaoDoc,

                                  (Select cast(sum(id.Total) as decimal(10,2)) 
                                  from ItemDoc id
                                  where id.IdDoc = do.IdDoc) as Total

                                  FROM Doc do
                                  join Empresa e on do.IdEmpresa = e.IdEmpresa
                                  join Contato c on do.IdContato = c.IdContato
                                  join TipoDoc ti on do.IdTipoDoc = ti.IdTipoDoc 
                                  join SituacaoDoc sd on do.IdSituacaoDoc = sd.IdSituacaoDoc
                                  join Usuario u on do.IdUsuario = u.IdUsuario 

                                  where do.IdDoc = " + IdDoc;

            con.Open();
            SqlDataReader readerDoc = commDoc.ExecuteReader();

            while (readerDoc.Read())
            {
                Lista.Doc.Add(new
                {
                    IdDoc = readerDoc["IdDoc"],
                    NumeroDoc = readerDoc["NumeroDoc"],
                    DataCadastro = Convert.ToDateTime(readerDoc["DataCadastro"]).ToShortDateString(),
                    IdTipoDoc = readerDoc["IdTipoDoc"],
                    NomeTipoDoc = readerDoc["NomeTipoDoc"],
                    IdEmpresa = readerDoc["IdEmpresa"],
                    NomeEmpresa = readerDoc["NomeEmpresa"],
                    IdContato = readerDoc["IdContato"],
                    NomeContato = readerDoc["NomeContato"],
                    IdSituacaoDoc = readerDoc["IdSituacaoDoc"],
                    NomeSituacaoDoc = readerDoc["NomeSituacaoDoc"],
                    DataVencimento = readerDoc["DataVencimento"] != DBNull.Value ? Convert.ToDateTime(readerDoc["DataVencimento"]).ToShortDateString() : "",
                    SemVencimento = readerDoc["SemVencimento"],
                    Vencimento = readerDoc["Vencimento"],
                    IdUsuario = readerDoc["IdUsuario"],
                    NomeUsuario = readerDoc["NomeUsuario"],
                    Remessa = readerDoc["Remessa"],
                    Observacao = readerDoc["Observacao"],
                    Total = readerDoc["Total"].ToString()
                });
            }              
            con.Close();

            // Query Item
            SqlCommand commItem = new SqlCommand();
            commItem.Connection = con;
            commItem.CommandText = @"SELECT i.IdItemDoc, i.IdDoc, i.IdItem, i.Ordem, i.Quantidade, cast(i.Valor as decimal(10,2)) as Valor, cast(i.Total as decimal(10,2)) as Total, e.NomeItem

                                   FROM ItemDoc i
                                   join Item e on i.IdItem = e.IdItem                                

                                   where i.IdDoc = " + IdDoc + " order by Ordem";

            con.Open();
            SqlDataReader readerItem = commItem.ExecuteReader();

            while (readerItem.Read())
            {
                Lista.Item.Add(new
                {
                    IdItemDoc = readerItem["IdItemDoc"],
                    IdDoc = readerItem["IdDoc"],
                    IdItem = readerItem["IdItem"],
                    Ordem = readerItem["Ordem"],
                    NomeItem = readerItem["NomeItem"],
                    Quantidade = readerItem["Quantidade"],
                    Valor = readerItem["Valor"].ToString(),
                    Total = readerItem["Total"].ToString()                   
                });
            }
            con.Close();

            context.Response.Write(new JavaScriptSerializer().Serialize(Lista));
        }

        public class objJson
        {
            public List<object> Doc;
            public List<object> Item;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }        
    }
}

//CustomerName = r["name"] is DBNull? null : r["name"].ToString() 
//var dt = new DataTable();
//dt.Load(myDataReader);
//list<DataRow> dr = dt.AsEnumerable().ToList();

//var varTable = new DataTable();
//varTable.Load(reader);
//List<DataRow> doc = varTable.AsEnumerable().ToList();

//List<object> doc = new List<object>(varTable.Select());

//List<object> doc = varTable.AsEnumerable().ToList<object>();