using Backend.Models.Data;
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
    public class ApiDataAddressController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        public ApiDataAddressController(FlutterprojectContext context)
        {
            _context = context;
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<DataAddress>> GetDataAddress_ByID(string id)
        {
            var result_address = await _context.Address.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(id));
            if (result_address == null)
            {
                return CreatedAtAction(nameof(GetDataAddress_ByID), new
                {
                    data = "ไม่พบข้อมูล"
                });
            }
            var result_dataAddress = await _context.DataAddress.AsNoTracking().FirstOrDefaultAsync(e => e.Id.Equals(result_address.IdDataAddress));
            if (result_dataAddress == null)
            {
                return CreatedAtAction(nameof(GetDataAddress_ByID), new
                {
                    data = "ไม่พบข้อมูล"
                });
            }
            return CreatedAtAction(nameof(GetDataAddress_ByID), new { data = result_dataAddress });
        }
    }
}
