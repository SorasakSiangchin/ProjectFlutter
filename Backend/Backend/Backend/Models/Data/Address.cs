// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace Backend.Models.Data
{
    public partial class Address
    {
        public Address()
        {
            Order = new HashSet<Order>();
        }

        public string Id { get; set; }
        public int? IdUser { get; set; }
        public string IdDataAddress { get; set; }

        public virtual DataAddress IdDataAddressNavigation { get; set; }
        public virtual User IdUserNavigation { get; set; }
        public virtual ICollection<Order> Order { get; set; }
    }
}