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
    public class ApiListsController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;
        public ApiListsController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<List>>> GetListId(string id)
        {
            var result = await _context.List.Where(e => e.IdOrder == id).Include(i => i.IdProductNavigation).ToListAsync();
            if (result == null)
            {
               
                return NotFound();
            }


            return result;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<List>> DeleteOrderPoduct(string id)
        {
            var result = await _context.List.FindAsync(id);
            if (result == null)
            {

                return NotFound();
            }

            _context.List.Remove(result);
            await _context.SaveChangesAsync();
            return result;
        }

    }
}
