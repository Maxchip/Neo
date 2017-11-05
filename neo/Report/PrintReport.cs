using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;
using System.Data.SqlClient;

namespace neo.Report
{
    public partial class PrintReport : DevExpress.XtraReports.UI.XtraReport
    {
        SqlConnection con = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["neo"].ConnectionString);

        public PrintReport()
        {
            InitializeComponent();
        }

        int counter = 1;
        int prevId = 1;

        private void xrLabel24_BeforePrint(object sender, System.Drawing.Printing.PrintEventArgs e)
        {
            (sender as XRControl).Text = System.Convert.ToString(counter);

            if (Convert.ToInt32(GetCurrentColumnValue("IdItemDoc")) > 0)
            {
                int id = (int)this.GetCurrentColumnValue("IdItemDoc");

                if (id != prevId)
                {
                    prevId = id;
                    counter++;
                }
            }
        }       
    }
}
