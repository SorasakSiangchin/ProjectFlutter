using Backend.Helpers;
using Backend.Models.Data;
using Backend.Models.ModelsList;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ApiOrdersController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;
        public ApiOrdersController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrder()
        {
            return await _context.Order.Include(e => e.IdAddressNavigation).Include(e => e.List).ToListAsync();
        }

        // ดึงOrderที่ยังไม่ได้ยืนยันการชำระเงิน
        [Route("StatusMoney")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrder_ProofTransfer()
        {
            var result = await _context.Order.Where(e => e.ProofTransfer == null || e.StatusMoney == false).Include(e => e.Delivery).Include(e => e.List).ToListAsync();
            foreach (var item in result)
            {
                if (item.List.Count == 0)
                {
                    var data = await _context.Order.FindAsync(item.Id);
                    if (data == null)
                    {
                        return NotFound();
                    }
                    _context.Order.Remove(data);
                    await _context.SaveChangesAsync();
                    return result;
                }
            }
            return result;
        }

        // ดึงOrderที่ผู้ใช้งานยืนยัน
        [Route("StatusForUser")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrder_StatusForUser()
        {
            return await _context.Order.Where(e => e.StatusForUser == true).Include(e => e.Delivery).Include(e => e.List).ToListAsync();
        }

        // ดึงOrderที่ยืนยันการชำระเงินแล้วแต่ยังไม่ยืนยันจากผู้ใช้งาน(ที่ต้องได้รับ)
        [Route("ToGet")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrder_to_receive()
        {
            return await _context.Order.Where(e => e.StatusForUser == false && e.StatusMoney == true).Include(e => e.Delivery).Include(e => e.List).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult> PostOrder([FromForm] ListProducts data)
        {
            // เอาไว้เก็บข้อมูลที่ส่งมาจาก fontend
            var DataOrder = new Order();
            var DataAddress = new Address();
            Random randomNumber = new Random();
            // while คือ roobที่ไมมีที่สิ้นสุดจนกว่าเราจะสั่งให้หยุด
            while (true)
            {
                int num = randomNumber.Next(1000000);

                DataOrder.Id = DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss") + "-" + num;

                DataOrder.Date = DateTime.Today;

                var result = await _context.Order.FindAsync(DataOrder.Id);

                if (result == null)
                {
                    break;
                };
            }

            DataOrder.IdAddress = data.idAddress;
            //-- เอาไว้เก็บผลรวมของราคาสินค้าทั้งหมด --
            //int? sum = 0;
            //-- เอาไว้เก็บราคาสินค้า --
           // int? numb;

            //--------- คำนวนเงินที่เราต้องจ่าย ------------
            //for (var i = 0; i < data.idProduck.Length; i++)
            //{
            //    numb = data.numberProduct[i] * data.PriceProduct[i];
            //    sum += numb;
            //    DataOrder.PriceTotal = sum;
            //}
            DataOrder.PriceTotal = data.PriceTotal;
            //-------- เป็นค่าเริ่มต้นให้ DataOrder.StatusMoney เป็น false -------
            DataOrder.StatusMoney = false;
            DataOrder.StatusForUser = false;
            //รับเป็นริส ประเภทเป็น List ใน DB
            var DataList = new List<List>();
            var L = data.idProduck.Length;

            //---------- เป็นการ Add สินค้าไว้ใน List ที่ละรายการ -------
            for (var i = 0; i < L; i++)
            {
                var tem = new List() { Id = DataOrder.Id + "-" + i, IdOrder = DataOrder.Id, IdProduct = data.idProduck[i], PriceProduct = data.PriceProduct[i], NumberProduct = data.numberProduct[i] };
                DataList.Add(tem);
            }
            //--------------------------------------------------

            //---------- AddRangeAsync เป็นการ Add ทั้งหมด ------
            await _context.Order.AddRangeAsync(DataOrder);


            // ------------------ Add สินค้าทั้งหมดไว้ใน List ---------------
            await _context.List.AddRangeAsync(DataList);
            //---------------------------------------------------------

            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(PostOrder), new { msg = "OK", data });
        }


        [HttpPut]
        public async Task<ActionResult> PutOrder_Upload([FromForm] Order data , [FromForm] IFormFile UpFile)
        {
            var result = await _context.Order.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(data.Id));
            if (result == null)
            {
                return CreatedAtAction(nameof(PutOrder_Upload), new
                {
                    msg = "ไม่ใบสั่งซื้อสินค้า"
                });
            }
            #region ImageManageMent

            var path = _environment.WebRootPath + ConstantOrders.Directory;
            if (UpFile?.Length > 0)
            {
                try
                {
                    //ลบรูปภาพเดิม
                    var oldpath = _environment.WebRootPath + result.ProofTransfer;
                    if (System.IO.File.Exists(oldpath)) System.IO.File.Delete(oldpath);
                    //

                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                    //ตัดเอาเฉพาะชื่อไฟล์
                    var fileName = data.Id + ConstantOrders.OrderImage;
                    if (UpFile.FileName != null)
                    {
                        fileName += UpFile.FileName.Split('\\').LastOrDefault().Split('/').LastOrDefault();
                    }

                    using (FileStream filestream =
                        System.IO.File.Create(path + fileName))
                    {
                        UpFile.CopyTo(filestream);
                        filestream.Flush();

                        result.ProofTransfer = ConstantOrders.Directory + fileName;
                    }
                }
                catch (Exception ex)
                {
                    return CreatedAtAction(nameof(PutOrder_Upload), new { msg = ex.ToString() });
                }
            }

            #endregion

             var result_list = await _context.List.Where(p => p.IdOrder == data.Id).ToListAsync();
            if (result_list != null)
            {
                for (var i = 0; i < result_list.Count; i++)
                {
                    var ProductData = await _context.Product.FindAsync(result_list[i].IdProduct);
                    int? num = 0;
                    num = ProductData.Stock - result_list[i].NumberProduct;
                    ProductData.Stock = num;
                    _context.Product.Update(ProductData);
                    await _context.SaveChangesAsync();
                }
            }
            //data.StatusMoney = true;
            _context.Order.Update(result);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PutOrder_Upload), new { msg = "OK", result });
        }

        [Route("ToGet")]
        [HttpPut]
        public async Task<ActionResult> PutOrder_Confirm_Product([FromForm] Order data)
        {
            var result = await _context.Order.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(data.Id));
            if (result == null)
            {
                return CreatedAtAction(nameof(PutOrder_Upload), new
                {
                    msg = "ไม่ใบสั่งซื้อสินค้า"
                });
            }
            result.StatusForUser = data.StatusForUser;
            _context.Order.Update(result);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PutOrder_Upload), new { msg = "OK", result });
        }

        [Route("Admin")]
        [HttpPut]
        public async Task<ActionResult> PutOrder_Confirm_Product_Admin([FromForm] Order data, [FromForm] Lists dataList)
        {
            var result = await _context.Order.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(data.Id));
            if (result == null)
            {
                return CreatedAtAction(nameof(PutOrder_Confirm_Product_Admin), new
                {
                    msg = "ไม่ใบสั่งซื้อสินค้า"
                });
            }


            //if (dataList != null)
            //{
            //    for (var i = 0; i < dataList.idList.Length; i++)
            //    {
            //        var ProductData = await _context.Product.FindAsync(dataList.idProduckList[i]);
            //        int? num = 0;
            //        num = ProductData.Stock - dataList.numberProductList[i];
            //        ProductData.Stock = num;
            //        _context.Product.Update(ProductData);
            //        await _context.SaveChangesAsync();
            //    }
            //}
            result.StatusMoney = data.StatusMoney;
            _context.Order.Update(result);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PutOrder_Confirm_Product_Admin), new { msg = "OK", result });
        }
    }
}
