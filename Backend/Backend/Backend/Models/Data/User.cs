﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace Backend.Models.Data
{
    public partial class User
    {
        public User()
        {
            Address = new HashSet<Address>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Tel { get; set; }
        public string Image { get; set; }

        public virtual ICollection<Address> Address { get; set; }
    }
}