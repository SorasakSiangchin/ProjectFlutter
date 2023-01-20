using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Backend.Models.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Backend.Helpers;
using System.IO;

namespace Backend.Controllers
{
    public class DetailProductsController : Controller
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;
        public DetailProductsController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        // GET: DetailProducts
        public async Task<IActionResult> Index(int? id)
        {
            var flutterprojectContext = _context.DetailProduct.Include(d => d.IdProductNavigation);
            return View(await flutterprojectContext.Where(e => e.IdProduct.Equals(id)).ToListAsync());
        }

        // GET: DetailProducts/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var detailProduct = await _context.DetailProduct
                .Include(d => d.IdProductNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (detailProduct == null)
            {
                return NotFound();
            }

            return View(detailProduct);
        }

        // GET: DetailProducts/Create
        public IActionResult Create()
        {
            ViewData["IdProduct"] = new SelectList(_context.Product, "Id", "Id");
            return View();
        }

        // POST: DetailProducts/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,IdProduct,Image,Weight,DataMore,Size")] DetailProduct detailProduct, [FromForm] IFormFileCollection UpFile)
        {
            if (ModelState.IsValid)
            {
                foreach (var file in UpFile)
                {
                    #region ImageManageMent
                    //               ได้WWW.rootออกมา           เก็บไว้ในuploadsDetailProducts 
                    var path = _environment.WebRootPath + ConstantDetailProducts.Directory;
                    // if (UpFile != null && UpFile.Length > 0) เขียนอีกเเบบ
                    string detailProduct1;
                    while (true)
                    {
                        detailProduct1 = ConstantDetailProducts.DetailProduct(detailProduct.IdProduct);
                        var idDetailProduct1 = await _context.DetailProduct.FindAsync(detailProduct1);
                        if (idDetailProduct1 == null)
                        {
                            break;
                        }
                    }
                    try
                    {
                        //uploadsDetailProducts มีหรือป่าว ถ้าไม่มีให้สร้าง
                        if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                        //ตัดเอาเฉพาะชื่อไฟล์
                        var fileName = detailProduct1;
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
                            detailProduct.Image = ConstantDetailProducts.Directory + fileName;
                            // สร้าง ID แบบ Auto
                            detailProduct.Id = detailProduct1;
                        }
                    }
                    catch (Exception ex)
                    {
                        return CreatedAtAction(nameof(Create), ex.ToString());
                    }
                    #endregion
                    await _context.DetailProduct.AddAsync(detailProduct);
                    await _context.SaveChangesAsync();

                }
              
            }
            ViewData["IdProduct"] = new SelectList(_context.Product, "Id", "Name", detailProduct.IdProduct);
            return RedirectToAction("Index","Products");
        }

        // GET: DetailProducts/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var detailProduct = await _context.DetailProduct.FindAsync(id);
            if (detailProduct == null)
            {
                return NotFound();
            }
            ViewData["IdProduct"] = new SelectList(_context.Product, "Id", "Id", detailProduct.IdProduct);
            return View(detailProduct);
        }

        // POST: DetailProducts/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("Id,IdProduct,Image,Weight,DataMore,Size")] DetailProduct detailProduct)
        {
            if (id != detailProduct.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(detailProduct);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!DetailProductExists(detailProduct.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["IdProduct"] = new SelectList(_context.Product, "Id", "Id", detailProduct.IdProduct);
            return View(detailProduct);
        }

        // GET: DetailProducts/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var detailProduct = await _context.DetailProduct
                .Include(d => d.IdProductNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (detailProduct == null)
            {
                return NotFound();
            }
            

            try
            {
                //ลบรูปภาพ
                var path = _environment.WebRootPath + detailProduct.Image;

                if (System.IO.File.Exists(path)) System.IO.File.Delete(path);

                _context.DetailProduct.Remove(detailProduct);
                await _context.SaveChangesAsync();
            }
            catch (Exception e)
            {
                //error
            }

            return RedirectToAction("Index", "DetailProducts");
        }

        // POST: DetailProducts/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var detailProduct = await _context.DetailProduct.FindAsync(id);
            _context.DetailProduct.Remove(detailProduct);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool DetailProductExists(string id)
        {
            return _context.DetailProduct.Any(e => e.Id == id);
        }
    }
}
