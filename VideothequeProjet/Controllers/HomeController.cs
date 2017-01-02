using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using VideothequeProjet.Models;

namespace VideothequeProjet.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {

        private ProjetVideoEntities _db = new ProjetVideoEntities();

        private IDal dal;


        public HomeController() : this(new IDal()){}


        private HomeController(IDal dalIoc)
        {
            dal = dalIoc;
        }

        [AllowAnonymous]
       public ActionResult Index()
       {
           UserViewModel viewModel = new UserViewModel { Authentifie = HttpContext.User.Identity.IsAuthenticated };
           if (HttpContext.User.Identity.IsAuthenticated)
            {
                viewModel.user = dal.ObtenirUtilisateur(HttpContext.User.Identity.Name);
            }

           ViewBag.DvdLoues = (from rd in _db.RentingDetails where !rd.back select rd.DVD);
           
            return View(viewModel);
       }
        [AllowAnonymous]
        [HttpPost]
       public ActionResult Index(UserViewModel viewModel, string returnUrl)
        {
            if (ModelState.IsValid)
            {
                Users utilisateur = dal.Authentifier(viewModel.user.login, viewModel.user.password);
                if (utilisateur != null)
                {
                    FormsAuthentication.SetAuthCookie(utilisateur.userID.ToString(), false);
                    if (!string.IsNullOrWhiteSpace(returnUrl) && Url.IsLocalUrl(returnUrl))
                        return Redirect(returnUrl);
                    return Redirect("/Movies");
                }
                ModelState.AddModelError("Utilisateur.Prenom", "Login et/ou mot de passe incorrect(s)");
            }
            return View(viewModel);
        }

        /*
        public ActionResult CreerCompte()
        {
            return View();
        }

        [HttpPost]
        public ActionResult CreerCompte(Users utilisateur)
        {
            if (ModelState.IsValid)
            {
                int id = dal.AjouterUsers(utilisateur.login, utilisateur.password);
                FormsAuthentication.SetAuthCookie(id.ToString(), false);
                return Redirect("/");
            }
            return View(utilisateur);
        }
         * 
         * */

        //GET: /Home/DvdRented
        public ActionResult DvdRented()
        {
            return View((from rd in _db.RentingDetails where !rd.back orderby rd.dateEnd select rd).ToList());
        }

        public ActionResult topOrder()
        {
            var dvds = _db.Movies.OrderByDescending(m => _db.RentingDetails.Where(rd => rd.DVD.Movies.Equals(m)).Count()).ToList();
            ViewBag.rentingDetails = _db.RentingDetails;
            return View(dvds);
        }

        public ActionResult Deconnexion()
        {
            FormsAuthentication.SignOut();
            return Redirect("/");
        }
}

}

       
    
