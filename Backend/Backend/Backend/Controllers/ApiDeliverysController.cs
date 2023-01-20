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
    public class ApiDeliverysController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;
        public ApiDeliverysController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }
        [Route("Delivery_Order")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Delivery>>> GetDelivery_Order()
        {
            return await _context.Delivery.ToListAsync();
        }

        [Route("Delivery_Data")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<StatusDelivery>>> GetDelivery_Data()
        {
            return await _context.StatusDelivery.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Delivery>> GetDelivery_Order(string id)
        {
            var delivery = await _context.Delivery.Include(e=>e.IdStatusDeliveryNavigation).AsNoTracking().FirstOrDefaultAsync(e => e.IdOrder.Equals(id));
            if (delivery == null)
            {
                return CreatedAtAction(nameof(GetDelivery_Order), new
                {
                    data = "ไม่พบข้อมูลการจัดส่ง"
                });
            }
            return CreatedAtAction(nameof(GetDelivery_Order), new { data = delivery });
        }

        [HttpPost]                                                                /*IFormFileCollection คือหลายรูป*/
        public async Task<ActionResult> postDelivery([FromForm] Delivery data)
        {
            var result = await _context.Delivery.FindAsync(data.Id);
            if (result != null)
            {
                return CreatedAtAction(nameof(postDelivery), new
                {
                    msg = "รหัสซ้ำ"
                });
            }
            data.Date = DateTime.Today;


            await _context.Delivery.AddAsync(data);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(postDelivery), new { msg = "OK", data });
        }

    }
}
