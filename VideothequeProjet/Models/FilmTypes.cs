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
    
    public partial class FilmTypes
    {
        public FilmTypes()
        {
            this.Movies = new HashSet<Movies>();
        }
    
        public int typeID { get; set; }
        public string filmType { get; set; }
    
        public virtual ICollection<Movies> Movies { get; set; }
    }
}
