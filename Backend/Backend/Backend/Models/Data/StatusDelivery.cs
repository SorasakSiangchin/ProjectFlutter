﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace Backend.Models.Data
{
    public partial class StatusDelivery
    {
        public StatusDelivery()
        {
            Delivery = new HashSet<Delivery>();
        }

        public int Id { get; set; }
        public string StatusName { get; set; }

        public virtual ICollection<Delivery> Delivery { get; set; }
    }
}