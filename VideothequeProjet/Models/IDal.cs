using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace VideothequeProjet.Models
{
    public class IDal 
    {

        private ProjetVideoEntities _db = new ProjetVideoEntities();        
       
        public int AjouterUsers(string login, string prenom, string nom, string motDePasse)
        {

            string motDePasseEncode = this.CalculateMD5Hash(motDePasse);
            Users utilisateur = new Users();
            utilisateur.login = login;
            utilisateur.firstName = prenom;
            utilisateur.lastName = nom;
            utilisateur.password = motDePasseEncode;
            _db.Users.Add(utilisateur);
            _db.SaveChanges();
            return utilisateur.userID;
        }

        public Users Authentifier(string login, string motDePasse)
        {
            string motDePasseEncode = this.CalculateMD5Hash(motDePasse);
            var user = (from a in _db.Users where a.password.ToLower() == motDePasseEncode.ToLower() where a.login == login select a);
            if (user.Count() == 0)
            {
                return null;
            }
            return user.First();
        }

        public Users ObtenirUtilisateur(int id)
        {
            return _db.Users.Find(id);
        }

        public Users ObtenirUtilisateur(string idString)
        {
            int id;
            if (int.TryParse(idString, out id))
                return ObtenirUtilisateur(id);
            return null;
        }


        public string CalculateMD5Hash(string input)

        {
            // step 1, calculate MD5 hash from input
            System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();
            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
            byte[] hash = md5.ComputeHash(inputBytes);


            // step 2, convert byte array to hex string
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }
            return sb.ToString();
        }



    }
}