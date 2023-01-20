using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Helpers
{
    public class ConstantUsers
    {
        public static string Directory = "\\uploads_user\\";
        public static string UserImage = "user" + DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss");
    }
}
