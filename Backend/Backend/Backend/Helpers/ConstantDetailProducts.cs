using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Helpers
{
    public class ConstantDetailProducts
    {
        public static string Directory = "\\uploads_detailproduct\\";
        public static string DetailProductImage = "detailproduct" + DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss");
        public static string DetailProduct(int? id)
        {
            return id + "-" + DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss-fffffff");
        }
    }
}
