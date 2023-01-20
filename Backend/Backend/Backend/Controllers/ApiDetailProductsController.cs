using Backend.Helpers;
using Backend.Models.Data;
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
    public class ApiDetailProductsController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;
        public ApiDetailProductsController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<DetailProduct>>> GetDetailProduct(int? id)
        {
            var detailproduct = await _context.DetailProduct.Where(p => p.IdProduct == id).ToListAsync();
            if (detailproduct == null)
            {
                return NotFound();
            }
            return detailproduct;
        }

        //------------------ เป็นการสร้างรูปมากกว่า 1 รูป ------------------------
        [HttpPost]
        public async Task<ActionResult> PostDetailProductt([FromForm] DetailProduct data, [FromForm] IFormFileCollection UpFile)
        {
            var data_product = await _context.Product.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(data.IdProduct));
            if (data_product == null)
            {
                return CreatedAtAction(nameof(PostDetailProductt), new
                {
                    msg = "ไม่พบข้อมูลสินค้า"
                });
            }
            foreach (var file in UpFile)
            {
                #region ImageManageMent
                //               ได้WWW.rootออกมา           เก็บไว้ในuploadsDetailProducts 
                var path = _environment.WebRootPath + ConstantDetailProducts.Directory;
                // if (UpFile != null && UpFile.Length > 0) เขียนอีกเเบบ
                string detailProduct ;
                while (true)
                {
                    detailProduct = ConstantDetailProducts.DetailProduct(data.IdProduct);
                    var idDetailProduct = await _context.DetailProduct.FindAsync(detailProduct);
                    if (idDetailProduct == null)
                    {
                        break;
                    }
                }
                try
                {
                    //uploadsDetailProducts มีหรือป่าว ถ้าไม่มีให้สร้าง
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                    //ตัดเอาเฉพาะชื่อไฟล์
                    var fileName = detailProduct;
                    if (file.FileName != null)
                    {
                        //----------- เอา fileName มาต่อกับ ชื่อไฟล์ของรูปภาพ ------------
                        fileName += file.FileName.Split('\\').LastOrDefault().Split('/').LastOrDefault();
                    }
                    //เอาไว้อ่านข้อมูลรูปภาพ
                    using (FileStream filestream =
                        System.IO.File.Create(path + fileName))
                    {
                        file.CopyTo(filestream);
                        filestream.Flush();
                        // ให้ data.Image เท่ากับรูปภาพที่อยู่ในไฟล์ uploadsDetailProducts 
                        data.Image = ConstantDetailProducts.Directory + fileName;
                        // สร้าง ID แบบ Auto
                        data.Id = detailProduct;
                    }
                }
                catch (Exception ex)
                {
                    return CreatedAtAction(nameof(PostDetailProductt), ex.ToString());
                }
                #endregion
                await _context.DetailProduct.AddAsync(data);
                await _context.SaveChangesAsync();

            }
            //if (data.Image == null)
            //{
            //    var detailProduct = Constants02.DetailProduct(data.IdProduct);
            //    data.Id = detailProduct;
            //    await _context.DetailProduct.AddAsync(data);
            //    await _context.SaveChangesAsync();
            //}
            return CreatedAtAction(nameof(DetailProduct), new { msg = "OK", data });
        }
    }
}
