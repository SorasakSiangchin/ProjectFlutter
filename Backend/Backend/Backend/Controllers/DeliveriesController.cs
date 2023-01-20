using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Backend.Models.Data;

namespace Backend.Controllers
{
    public class DeliveriesController : Controller
    {
        private readonly FlutterprojectContext _context;

        public DeliveriesController(FlutterprojectContext context)
        {
            _context = context;
        }

        // GET: Deliveries
        public async Task<IActionResult> Index()
        {
            var flutterprojectContext = _context.Delivery.Include(d => d.IdOrderNavigation).Include(d => d.IdStatusDeliveryNavigation);
            return View(await flutterprojectContext.ToListAsync());
        }

        // GET: Deliveries/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var delivery = await _context.Delivery
                .Include(d => d.IdOrderNavigation)
                .Include(d => d.IdStatusDeliveryNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (delivery == null)
            {
                return NotFound();
            }

            return View(delivery);
        }

        // GET: Deliveries/Create
        public IActionResult Create()
        {
            ViewData["IdOrder"] = new SelectList(_context.Order, "Id", "Id");
            ViewData["IdStatusDelivery"] = new SelectList(_context.StatusDelivery, "Id", "Id");
            return View();
        }

        // POST: Deliveries/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,IdOrder,IdStatusDelivery,Date")] Delivery delivery ,string id)
        {
            if (ModelState.IsValid)
            {

                _context.AddAsync(delivery);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["IdOrder"] = new SelectList(_context.Order, "Id", "Id", delivery.IdOrder);
            ViewData["IdStatusDelivery"] = new SelectList(_context.StatusDelivery, "Id", "Id", delivery.IdStatusDelivery);
            return View(delivery);
        }

        // GET: Deliveries/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var delivery = await _context.Delivery.FindAsync(id);
            if (delivery == null)
            {
                return NotFound();
            }
            ViewData["IdOrder"] = new SelectList(_context.Order, "Id", "Id", delivery.IdOrder);
            ViewData["IdStatusDelivery"] = new SelectList(_context.StatusDelivery, "Id", "Id", delivery.IdStatusDelivery);
            return View(delivery);
        }

        // POST: Deliveries/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,IdOrder,IdStatusDelivery,Date")] Delivery delivery)
        {
            if (id != delivery.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(delivery);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!DeliveryExists(delivery.Id))
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
            ViewData["IdOrder"] = new SelectList(_context.Order, "Id", "Id", delivery.IdOrder);
            ViewData["IdStatusDelivery"] = new SelectList(_context.StatusDelivery, "Id", "Id", delivery.IdStatusDelivery);
            return View(delivery);
        }

        // GET: Deliveries/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var delivery = await _context.Delivery
                .Include(d => d.IdOrderNavigation)
                .Include(d => d.IdStatusDeliveryNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (delivery == null)
            {
                return NotFound();
            }

            return View(delivery);
        }

        // POST: Deliveries/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var delivery = await _context.Delivery.FindAsync(id);
            _context.Delivery.Remove(delivery);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool DeliveryExists(int id)
        {
            return _context.Delivery.Any(e => e.Id == id);
        }
    }
}
