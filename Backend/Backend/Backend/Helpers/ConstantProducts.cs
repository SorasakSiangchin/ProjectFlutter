using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Helpers
{
    public class ConstantProducts
    {
        public static string Directory = "\\uploads_product\\";
        public static string ProductImage = "product" + DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss");
    }
}
