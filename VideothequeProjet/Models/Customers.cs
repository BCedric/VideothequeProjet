//------------------------------------------------------------------------------
// <auto-generated>
//     Ce code a été généré à partir d'un modèle.
//
//     Des modifications manuelles apportées à ce fichier peuvent conduire à un comportement inattendu de votre application.
//     Les modifications manuelles apportées à ce fichier sont remplacées si le code est régénéré.
// </auto-generated>
//------------------------------------------------------------------------------

namespace VideothequeProjet.Models
{
    using System.ComponentModel.DataAnnotations;
    using System;
    using System.Collections.Generic;
    
    public partial class Customers
    {
        public Customers()
        {
            this.Rentings = new HashSet<Rentings>();
        }
    
        public int customerID { get; set; }
        [Display(Name="Prénom")]
        public string firstName { get; set; }
        [Display(Name = "Nom")]
        public string lastName { get; set; }
        [Display(Name = "Addresse")]
        public string address { get; set; }
        [Display(Name = "Numéro de téléphone")]
        public string phoneNumber { get; set; }
        [Display(Name = "Addresse mail")]
        public string mailAddress { get; set; }
    
        public virtual ICollection<Rentings> Rentings { get; set; }
    }
}