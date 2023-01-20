using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Helpers
{
    public class ConstantReviews
    {
        public static string Directory = "\\uploads_review\\";
        public static string ReviewImage = "review" + DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss");
    }
}
