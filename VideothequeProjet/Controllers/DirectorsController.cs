using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using VideothequeProjet.Models;

namespace VideothequeProjet.Controllers
{
    [Authorize]
    public class DirectorsController : Controller
    {
        private ProjetVideoEntities _db = new ProjetVideoEntities();

        // GET: Directors
        public ActionResult Index()
        {
            return View(_db.Directors.ToList());
        }

        // GET: Directors/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Directors/Create
        [HttpPost]
        public ActionResult Create(Directors directorsToCreate)
        {
            try
            {
                _db.Directors.Add(directorsToCreate);
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Directors/Delete/5
        public ActionResult Delete(int id)
        {
            _db.Directors.Remove(_db.Directors.Find(id));
            _db.SaveChanges();
            return RedirectToAction("Index");
        }

    }
}
