using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ModelsList
{
    public class Lists
    {
        //----------- เอาไว้เก็บข้อมูลเพื่อ นำจำนวนที่ซื้อมาลบกับจำนวนที่มี ------------

        public string[] idList { get; set; }
        public int?[] idProduckList { get; set; }
        public int?[] numberProductList { get; set; }
        public int?[] PriceProductList { get; set; }

    }

    public class PriceTotalList
    {
        //----------- เอาไว้เก็บข้อมูลเพื่อ นำจำนวนคิดราคารวมต่อรายการใน List ------------

        public int? PriceProduct { get; set; }
        public int? NumberProduct { get; set; }


    }
}
