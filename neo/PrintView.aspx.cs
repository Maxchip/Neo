using neo.Report;
using System;
using System.Data.SqlClient;

namespace neo
{
    public partial class PrintView : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["neo"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            PrintReport ReportDoc = new PrintReport();
            ReportDoc.Parameters["IdDoc"].Value = Convert.ToInt32(Request.Params["IdDoc"].ToString());

            ASPxDocumentViewer1.Report = ReportDoc;                     
        }             
    }
}