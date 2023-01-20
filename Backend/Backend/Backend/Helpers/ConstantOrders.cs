using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Helpers
{
    public class ConstantOrders
    {
        public static string Directory = "\\uploads_order\\";
        public static string OrderImage = "order" + DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss");
    }
}
