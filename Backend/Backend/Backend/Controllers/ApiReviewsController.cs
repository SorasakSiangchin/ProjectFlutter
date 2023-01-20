using Backend.Helpers;
using Backend.Models.Data;
using Backend.Models.ModelsList;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ApiReviewsController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;
        public ApiReviewsController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<Review>>> GetDelivery_Order(int? id)
        {
            var result = await _context.List.Where(e => e.IdProduct.Equals(id)).ToListAsync();
            if (result == null)
            {
                return NotFound();
            }
            List<Review> DataReview = new List<Review>();
            //var data = await _context.Review.AsNoTracking().FirstOrDefaultAsync(p => p.IdList.Equals("2565-02-25T00-02-44-955761-2"));
            for (var i = 0; i < result.Count ; i++)
            {
                var data = await _context.Review.Where(e=>e.IdList.Equals(result[i].Id)).ToListAsync();
                if (data != null)
                {
                
                    DataReview.AddRange(data);
                }
               

            }

            return CreatedAtAction(nameof(GetDelivery_Order), new { data = DataReview });
        }

        [HttpPost]
        public async Task<ActionResult> PostReview([FromForm] Reviews data , [FromForm] IFormFile UpFile)
        {
            var DataReview = new Review();

            Random randomNumber = new Random();
            // while คือ roobที่ไมมีที่สิ้นสุดจนกว่าเราจะสั่งให้หยุด
            while (true)
            {
                int num = randomNumber.Next(1000000);

                DataReview.Id = DateTime.Now.ToString("yyyy-MM-ddTHH-mm-ss") + "-" + num;

                DataReview.Date = DateTime.Today;

                var result = await _context.Order.FindAsync(DataReview.Id);

                if (result == null)
                {
                    break;
                };
            }
            #region ImageManageMent
            //               ได้WWW.rootออกมา           เก็บไว้ในuploads 
            var path = _environment.WebRootPath + ConstantReviews.Directory;
            // if (UpFile != null && UpFile.Length > 0) เขียนอีกเเบบ
            if (UpFile?.Length > 0)
            {
                try
                {
                    //uploads มีหรือป่าว ถ้าไม่มีให้สร้าง
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                    //ตัดเอาเฉพาะชื่อไฟล์
                    var fileName = DataReview.Id + ConstantReviews.ReviewImage;
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
                        DataReview.Image = ConstantReviews.Directory + fileName;
                    }
                }
                catch (Exception ex)
                {
                    return CreatedAtAction(nameof(PostReview), ex.ToString());
                }
            }
            DataReview.Data = data.dataReview;
            DataReview.IdList = data.idList;
            #endregion
            await _context.Review.AddAsync(DataReview);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PostReview), new { msg = "OK", DataReview });
        }

    }
}
