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
    using System;
    using System.Collections.Generic;
    
    public partial class DVD
    {
        public DVD()
        {
            this.RentingDetails = new HashSet<RentingDetails>();
        }
    
        public int DVDID { get; set; }
        public int movieID { get; set; }
        public bool available { get; set; }
    
        public virtual Movies Movies { get; set; }
        public virtual ICollection<RentingDetails> RentingDetails { get; set; }
    }
}
