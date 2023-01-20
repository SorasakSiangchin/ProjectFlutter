using Backend.Models.Data;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ApiCategoryProductsController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        public ApiCategoryProductsController(FlutterprojectContext context)
        {
            _context = context;
        }
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CategoryProduct>>> GetCategory_Products()
        {
            return await _context.CategoryProduct.Include(e => e.IdSellerNavigation).ToListAsync();
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<CategoryProduct>> GetCategory_Products_ByID(int? id)
        {
            var result = await _context.CategoryProduct.Include(e => e.IdSellerNavigation).AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(id));
            if (result == null)
            {
                return CreatedAtAction(nameof(GetCategory_Products_ByID), new
                {
                    data = "ไม่พบข้อมูล"
                });
            }
            return CreatedAtAction(nameof(GetCategory_Products_ByID), new { data = result });
        }
    }
}
