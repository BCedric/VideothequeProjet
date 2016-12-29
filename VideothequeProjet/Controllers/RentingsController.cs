using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using VideothequeProjet.Models;

namespace VideothequeProjet.Controllers
{
    [Authorize]
    public class RentingsController : Controller
    {

        private ProjetVideoEntities _db = new ProjetVideoEntities();
        
        // GET: Rentings/Details/5
        public ActionResult Details(int id)
        {
            return View(_db.Rentings.Find(id));
        }

        // GET: Rentings/Create/5
        public ActionResult Create(int customerID)
        {            
            ViewBag.customer = _db.Customers.Find(customerID);
            return View();
        }

        // POST: Rentings/Create
        [HttpPost]
        public ActionResult Create(Rentings rentingToCreate, int idCus)
        {
            try
            {
                var customer = _db.Customers.Find(idCus);
                customer.Rentings.Add(rentingToCreate);
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return View(rentingToCreate);
            }
        }

        // GET: Rentings/addDVD/5
        public ActionResult addMovies()
        {
            
        }

        // POST: Rentings/addDVD/5
        [HttpPost]
        public ActionResult addMovies(int[] id)
        {

        }

        // GET: Rentings/addDVD/5
        public ActionResult deleteMovie(int id)
        {

        }



        

        // GET: Rentings/Delete/5
        public ActionResult Delete(int id)
        {
            return View(_db.Rentings.Find(id));
        }

        // POST: Rentings/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View(_db.Rentings.Find(id));
            }
        }
    }
}
