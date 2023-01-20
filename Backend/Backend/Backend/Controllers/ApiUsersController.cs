using Backend.Helpers;
using Backend.Models.Data;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ApiUsersController : ControllerBase
    {
        private readonly FlutterprojectContext _context;
        private readonly IWebHostEnvironment _environment;

        public ApiUsersController(FlutterprojectContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }


        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetProducts()
        {
            return await _context.User.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetProductsID(int id)
        {
           var user = await _context.User.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }
            return CreatedAtAction(nameof(GetProductsID), new { data = user });
        }

        [Route("Register")]
        [HttpPost]                                                          /*IFormFileCollection คือหลายรูป*/
        public async Task<ActionResult> Register([FromForm] User data, [FromForm] IFormFile UpFile)
        {
            var result = await _context.User.FindAsync(data.Id);
            if (result != null)
            {
                return CreatedAtAction(nameof(Register), new
                {
                    msg = "รหัสซ้ำ"
                });
            }

            #region ImageManageMent
            //               ได้WWW.rootออกมา           เก็บไว้ในuploads 
            var path = _environment.WebRootPath + ConstantUsers.Directory;
            // if (UpFile != null && UpFile.Length > 0) เขียนอีกเเบบ
            if (UpFile?.Length > 0)
            {
                try
                {
                    //uploads มีหรือป่าว ถ้าไม่มีให้สร้าง
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                    //ตัดเอาเฉพาะชื่อไฟล์
                    var fileName = data.Id + ConstantUsers.UserImage;
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
                        data.Image = ConstantUsers.Directory + fileName;
                    }
                }
                catch (Exception ex)
                {
                    return CreatedAtAction(nameof(Register), ex.ToString());
                }
            }

            #endregion

            await _context.User.AddAsync(data);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(Register), new { msg = "OK", data });
        }

        [Route("Login")]
        [HttpPost]
        public async Task<ActionResult> Login([FromForm] User data)
        {
            var result = await _context.User.FirstOrDefaultAsync(
                p => p.Email.Equals(data.Email) && p.Password.Equals(data.Password));
            if (result == null)
            {
                return CreatedAtAction(nameof(Login), new { msg = "ไม่พบผู้ใช้งาน" , uid = ""});
            }
            //คนที่เข้าระบบ     
            return CreatedAtAction(nameof(Login), new { msg = "OK", uid = Convert.ToString(result.Id) }) ;
        }

        [Route("PutData")]
        [HttpPut]
        public async Task<ActionResult> PutUser_Data([FromForm] User data, [FromForm] IFormFile UpFile)
        {
            //ถ้าใช้ตัวนี้มันไม่ให้ Update
            //var result = await _context.Products.FindAsync(data);
            //AsNoTracking ทำเส็จเเล้วให้ออกไป
            var result = await _context.User.AsNoTracking().FirstOrDefaultAsync(p => p.Id.Equals(data.Id));
            if (result == null)
            {
                return CreatedAtAction(nameof(PutUser_Data), new
                {
                    msg = "ไม่พบผู้ใช้งาน"
                });
            }
            if (data.Name != null)
            {
                result.Name = data.Name;
            }
            if (data.Password != null)
            {
                result.Password = data.Password;
            }
            if (data.Tel != null)
            {
                result.Tel = data.Tel;
            }
            if (data.Email != null)
            {
                result.Email = data.Email;
            }
            if (data.Address != null)
            {
                result.Address = data.Address;
            }
          
            _context.User.Update(result);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PutUser_Data), new { msg = "OK", data });
        }

        [Route("PutImage")]
        [HttpPut]
        public async Task<ActionResult> PutUser_Image([FromForm] User data, [FromForm] IFormFile UpFile)
        {
            //ถ้าใช้ตัวนี้มันไม่ให้ Update
            //var result = await _context.Products.FindAsync(data);
            //AsNoTracking ทำเส็จเเล้วให้ออกไป
            var result = await _context.User.AsNoTracking().FirstOrDefaultAsync(p => p.Id.Equals(data.Id));
            if (result == null)
            {
                return CreatedAtAction(nameof(PutUser_Image), new
                {
                    msg = "ไม่พบผู้ใช้งาน"
                });
            }
            #region ImageManageMent

            var path = _environment.WebRootPath + ConstantUsers.Directory;
            if (UpFile?.Length > 0)
            {
                try
                {
                    //ลบรูปภาพเดิม
                    var oldpath = _environment.WebRootPath + result.Image;
                    if (System.IO.File.Exists(oldpath)) System.IO.File.Delete(oldpath);
                    //

                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                    //ตัดเอาเฉพาะชื่อไฟล์
                    var fileName = data.Id + ConstantUsers.UserImage;
                    if (UpFile.FileName != null)
                    {
                        fileName += UpFile.FileName.Split('\\').LastOrDefault().Split('/').LastOrDefault();
                    }

                    using (FileStream filestream =
                        System.IO.File.Create(path + fileName))
                    {
                        UpFile.CopyTo(filestream);
                        filestream.Flush();

                        result.Image = ConstantUsers.Directory + fileName;
                    }
                }
                catch (Exception ex)
                {
                    return CreatedAtAction(nameof(PutUser_Image), new { msg = ex.ToString() });
                }
            }

            #endregion

            _context.User.Update(result);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(PutUser_Data), new { msg = "OK", data });
        }
    }
}
