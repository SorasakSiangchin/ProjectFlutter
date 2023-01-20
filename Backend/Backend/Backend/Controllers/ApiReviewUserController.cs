using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ApiReviewUserController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        public ApiReviewUserController(FlutterprojectContext context)
        {
            _context = context;
        }

       
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser_ByID(string id)
        {
            var result = await _context.List.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(id));
            if (result == null)
            {
                return NotFound();
            }
            var result_order = await _context.Order.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(result.IdOrder));
            if (result_order == null)
            {
                return NotFound();
            }
            var result_address = await _context.Address.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(result_order.IdAddress));
            if (result_address == null)
            {
                return NotFound();
            }
            var result_user = await _context.User.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(result_address.IdUser));
            if (result_user == null)
            {
                return NotFound();
            }
            return CreatedAtAction(nameof(GetUser_ByID), new { data = result_user });
        }
       
    }
}
