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
    public class ApiProductsController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;

        public ApiProductsController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }
        [Route("ProductAll")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product>>> GetProductsAll()
        {
            return await _context.Product.Include(e=>e.IdCategoryProductNavigation.IdSellerNavigation).ToListAsync();
        }

        [Route("ProductNew")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product>>> GetProductsNew()
        {
            return await _context.Product.Include(e => e.IdCategoryProductNavigation.IdSellerNavigation).OrderByDescending(a => a.Id).Take(5).ToListAsync();
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<Product>> GetProductsByID(int id)
        {
            var product = await _context.Product.Include(e => e.IdCategoryProductNavigation.IdSellerNavigation).AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(id));
            if (product == null)
            {
                return NotFound();
            }
            return CreatedAtAction(nameof(GetProductsByID), new { data = product });
        }

        [HttpPost]
        public async Task<ActionResult> PostProduct([FromForm] Product data, [FromForm] IFormFile UpFile)
        {
            var result = await _context.Product.FindAsync(data.Id);
            if (result != null)
            {
                return CreatedAtAction(nameof(PostProduct), new
                {
                    msg = "รหัสซ้ำ"
                });
            }
            #region ImageManageMent
            //               ได้WWW.rootออกมา           เก็บไว้ในuploads 
            var path = _environment.WebRootPath + ConstantProducts.Directory;
            // if (UpFile != null && UpFile.Length > 0) เขียนอีกเเบบ
            if (UpFile?.Length > 0)
            {
                try
                {
                    //uploads มีหรือป่าว ถ้าไม่มีให้สร้าง
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                    //ตัดเอาเฉพาะชื่อไฟล์
                    var fileName = data.Id + ConstantProducts.ProductImage;
                    if (UpFile.FileName != null)
                    {
                        fileName += UpFile.FileName.Split('\\').LastOrDefault().Split('/').LastOrDefault();
                    }

                    //เอาไว้อ่านข้อมูลรูปภาพ
                    using (FileStream filestream =
                        System.IO.File.Create(path + fileName))
                    {
                        UpFile.CopyTo(filestream);
                        filestream.Flush();
                        data.Image = ConstantProducts.Directory + fileName;
                    }
                }
                catch (Exception ex)
                {
                    return CreatedAtAction(nameof(PostProduct), ex.ToString());
                }
            }

            #endregion
            await _context.Product.AddAsync(data);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PostProduct), new { msg = "OK", data });
        }
    }
}
