using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ModelsList
{
    public class ListProducts
    {
        public int?[] idProduck { get; set; }
        public string  idAddress { get; set; }
        public int?[] numberProduct { get; set; }
        public int?[] PriceProduct { get; set; }
        public bool?  StatusMoney { get; set; }
        public int? PriceTotal { get; set; }
    }
}
