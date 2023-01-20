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
    public class ApiAddressController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        public ApiAddressController(FlutterprojectContext context)
        {
            _context = context;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<Address>>> GetAddressByID(int? id)
        {
            var result = await _context.Address.Include(e => e.IdDataAddressNavigation).Where(e => e.IdUser.Equals(id)).ToListAsync();
            if (result == null)
            {
                return CreatedAtAction(nameof(GetAddressByID), new
                {
                    data = "ไม่พบข้อมูล"
                });
            }
            return CreatedAtAction(nameof(GetAddressByID), new { data = result });
        }


        [HttpPost]
        public async Task<ActionResult> PostProduct([FromForm] DataAddress data, [FromForm] int? IDUser)
        {
            Random randomNumber = new Random();
            while (true)
            {
                int num = randomNumber.Next(1000000);

                data.Id = DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss") + "-" + num;

                var result_add_result = await _context.Address.FindAsync(data.Id);

                if (result_add_result == null)
                {
                    break;
                };
            }

            // *********** เช็คเพิ่อ **************************
            var result = await _context.DataAddress.FindAsync(data.Id);
            if (result != null)
            {
                return CreatedAtAction(nameof(PostProduct), new
                {
                    msg = "รหัสซ้ำ"
                });
            }
            //*******************************************

            var Data_Address = new Address();
            
            while (true)
            {
                int num = randomNumber.Next(1000000);

                Data_Address.Id = DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss") + "-" + num;

                var result_add_result = await _context.Address.FindAsync(Data_Address.Id);

                if (result_add_result == null)
                {
                    break;
                };
            }
            Data_Address.IdUser = IDUser;
            Data_Address.IdDataAddress = data.Id;

            await _context.Address.AddRangeAsync(Data_Address);
            await _context.DataAddress.AddAsync(data);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PostProduct), new { msg = "OK", data });
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<DataAddress>> DeleteAddress(string id)
        {
            var result_dataAddress = await _context.DataAddress.FindAsync(id);
            if (result_dataAddress == null)
            {
                return NotFound();
            }
            var result_address = await _context.Address.AsNoTracking().FirstOrDefaultAsync(p => p.IdDataAddress.Equals(id));
            if (result_address == null)
            {

                return NotFound();
            }
            _context.Address.Remove(result_address);
            _context.DataAddress.Remove(result_dataAddress);
            await _context.SaveChangesAsync();
            return result_dataAddress;
        }

    }
}
