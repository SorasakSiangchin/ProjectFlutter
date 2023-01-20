using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Backend.Models.Data;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Backend.Helpers;
using System.IO;

namespace Backend.Controllers
{
    public class ProductsController : Controller
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;

        public ProductsController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        // GET: Products
        public async Task<IActionResult> Index()
        {
            var flutterprojectContext = _context.Product.Include(p => p.IdCategoryProductNavigation);
            return View(await flutterprojectContext.ToListAsync());
        }

        // GET: Products/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product
                .Include(p => p.IdCategoryProductNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        // GET: Products/Create
        public IActionResult Create()
        {
            ViewData["IdCategoryProduct"] = new SelectList(_context.CategoryProduct, "Id", "Id");
            return View();
        }

        // POST: Products/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,IdCategoryProduct,Name,Price,Stock,Color,Image")] Product product , [FromForm] IFormFile UpFile)
        {
            if (ModelState.IsValid)
            {
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
                        var fileName = product.Id + ConstantProducts.ProductImage;
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
                            product.Image = ConstantProducts.Directory + fileName;
                        }
                    }
                    catch (Exception ex)
                    {
                        return CreatedAtAction(nameof(Create), ex.ToString());
                    }
                }

                #endregion
                await _context.Product.AddAsync(product);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["IdCategoryProduct"] = new SelectList(_context.CategoryProduct, "Id", "Id", product.IdCategoryProduct);
            return View(product);
        }

        // GET: Products/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }
            ViewData["IdCategoryProduct"] = new SelectList(_context.CategoryProduct, "Id", "Id", product.IdCategoryProduct);
            return View(product);
        }

        // POST: Products/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,IdCategoryProduct,Name,Price,Stock,Color,Image")] Product product , IFormFile UpFile)
        {
            if (id != product.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
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
                            var fileName = product.Id + ConstantProducts.ProductImage;
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
                                product.Image = ConstantProducts.Directory + fileName;
                            }
                        }
                        catch (Exception ex)
                        {
                            return CreatedAtAction(nameof(Edit), ex.ToString());
                        }
                    }

                    #endregion
                    _context.Update(product);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ProductExists(product.Id))
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
            ViewData["IdCategoryProduct"] = new SelectList(_context.CategoryProduct, "Id", "Id", product.IdCategoryProduct);
            return View(product);
        }

        // GET: Products/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product
                .Include(p => p.IdCategoryProductNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        // POST: Products/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int? id)
        {
            var result = await _context.Product.FindAsync(id);
            if (result == null)
            {
                return NotFound();
            }

            try
            {
                //ลบรูปภาพ
                var path = _environment.WebRootPath + result.Image;

                if (System.IO.File.Exists(path)) System.IO.File.Delete(path);

                _context.Product.Remove(result);
                await _context.SaveChangesAsync();
            }
            catch (Exception e)
            {
                return CreatedAtAction(nameof(DeleteConfirmed), e.ToString());
            }
            return RedirectToAction(nameof(Index));
        }

        private bool ProductExists(int id)
        {
            return _context.Product.Any(e => e.Id == id);
        }
    }
}
