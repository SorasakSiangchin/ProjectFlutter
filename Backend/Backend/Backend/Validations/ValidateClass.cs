using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.Data
{
    public partial class ValidateAdmin
    {
  
        [Display(Name = "รหัส")]
        public int Id { get; set; }
        
        [Display(Name = "ชื่อ")]
        public string Name { get; set; }
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        [Display(Name = "อีเมล")]
        [EmailAddress(ErrorMessage = "โปรดกรอกเป็นรูปแบบอีเมล์")]
        public string Email { get; set; }
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        [Display(Name = "รหัสผ่าน")]
        public string Password { get; set; }
        [Display(Name = "รูปภาพ")]
        public string Image { get; set; }
    }
    [ModelMetadataType(typeof(ValidateAdmin))]
    public partial class Admin
    {
    }


    public partial class ValidateSeller
    {
        [Display(Name = "รหัส")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public int Id { get; set; }
        [Display(Name = "ชื่อ")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public string Name { get; set; }
        [Display(Name = "เบอร์โทร")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        [DataType(DataType.PhoneNumber)]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid phone number")]
        public string Tel { get; set; }
        [Display(Name = "อีเมล")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        [EmailAddress(ErrorMessage = "โปรดกรอกเป็นรูปแบบอีเมล์")]
        public string Email { get; set; }
        [Display(Name = "รหัสผ่าน")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public string Password { get; set; }
        [Display(Name = "รูปภาพ")]
        public string Image { get; set; }
        [Display(Name = "ที่อยู่")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public string Address { get; set; }
    }
    [ModelMetadataType(typeof(ValidateSeller))]
    public partial class Seller
    {
    }




    public partial class ValidateProduct
    {
        [Display(Name = "รหัส")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public int Id { get; set; }
        [Display(Name = "ไอดีประเภท")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public int? IdCategoryProduct { get; set; }
        [Display(Name = "ชื่อ")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public string Name { get; set; }
        [Display(Name = "ราคา")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public int? Price { get; set; }
        [Display(Name = "จำนวน")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public int? Stock { get; set; }
        [Display(Name = "สี")]
        [Required(ErrorMessage = "กรุณากรอกข้อมูล")]
        public string Color { get; set; }
        [Display(Name = "รูปภาพ")]
        public string Image { get; set; }
    }
    [ModelMetadataType(typeof(ValidateProduct))]
    public partial class Product
    {
    }
}
