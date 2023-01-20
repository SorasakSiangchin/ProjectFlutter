using Backend.Models;
using Backend.Models.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly FlutterprojectContext _context;

        public HomeController(ILogger<HomeController> logger,FlutterprojectContext context)
        {
            _logger = logger;
            _context = context;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public ActionResult Login_Admin()
        {
            return View();
        }
        [HttpPost]
        public async Task<ActionResult> Login_Admin(Admin data)
        {
            var result = await _context.Admin.FirstOrDefaultAsync(p => p.Email.Equals(data.Email) && p.Password.Equals(data.Password));
            if (result == null)
            {
                TempData["ErrorAdmin"] = "Error";
                return View(data);
            }
            return RedirectToAction("Index","Admins");
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
