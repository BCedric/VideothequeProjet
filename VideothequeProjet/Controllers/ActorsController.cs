using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using VideothequeProjet.Models;

namespace VideothequeProjet.Controllers
{
    [Authorize]
    public class ActorsController : Controller
    {
        private ProjetVideoEntities _db = new ProjetVideoEntities();

        // GET: Actors
        public ActionResult Index()
        {
            var actors = (from a in _db.Actors orderby a.lastName select a);
            return View(actors);
        }

        

        // GET: Actors/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Actors/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Actors/Delete/5
        public ActionResult Delete(int id)
        {
            try
            {
                _db.Actors.Remove(_db.Actors.Find(id));
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }        
    }
}
