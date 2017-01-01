using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using VideothequeProjet.Models;
using System.Web.Security;

namespace VideothequeProjet.Controllers
{
    [Authorize]
    public class RentingsController : Controller
    {

        private ProjetVideoEntities _db = new ProjetVideoEntities();


        //GET : Rentings/Show/5
        public ActionResult Show(int id)
        {
            var model = _db.Rentings.Find(id);
            return View(model);
        }
        
        
        // GET: Rentings/Details/5
        public ActionResult Details(int id)
        {
            var model = _db.Rentings.Find(id);
            return View(model);
        }

        // GET: Rentings/Create/5
        public ActionResult Create(int customerID)
        {
            var model = new Rentings();
            model.cost = 0;
            var rentID = (from r in _db.Rentings select r).Count();
            if (rentID == 0) rentID = 1;
            else rentID = (from r in _db.Rentings orderby r.rentingID descending select r).First().rentingID+1;
            model.rentingID = rentID;
            model.Customers = _db.Customers.Find(customerID);
            var userID = HttpContext.User.Identity.Name;
            model.Users = _db.Users.Find(Int32.Parse(userID));
           
            _db.Rentings.Add(model);
            _db.SaveChanges();

            return RedirectToAction("Details", "Rentings", new { id = model.rentingID});
        }

        // POST: Rentings/Create
        [HttpPost]
        public ActionResult Create(Rentings rentingToCreate, int idCus)
        {
            try
            {
                var customer = _db.Customers.Find(idCus);
                rentingToCreate.cost = 0;
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
        public ActionResult addDVD(int id)
        {
            var dvd = _db.DVD.First();
            
            ViewBag.DVDs =_db.DVD.OrderBy(d => d.Movies.title).ToList();            
            return View(_db.Rentings.Find(id));
        }

        // POST: Rentings/addDVD/5
        [HttpPost]
        public ActionResult addDVD(int id, int[] dvds)
        {
            var renting = _db.Rentings.Find(id);
            var rdRegistered = _db.RentingDetails.Where(rd => rd.rentingID == id).ToList();
            for (int i = 0; i < rdRegistered.Count(); ++i )
            {
                _db.RentingDetails.Remove(rdRegistered[i]);
            }
            renting.RentingDetails.Clear();
            renting.cost = 0;
            foreach (int dvdid in dvds)
            {
                var dvd = _db.DVD.Find(dvdid);
                var rd = new RentingDetails();
                rd.price = dvd.Movies.price;
                rd.DVD = dvd;               
                rd.Rentings = renting;
                renting.RentingDetails.Add(rd);
                renting.cost += rd.price;
            }

            _db.SaveChanges();
            
            return RedirectToAction("Details", new { id = id });
        }

        // GET: Rentings/ValidateRenting/5
        public ActionResult ValidateRenting(int id)
        {
            var renting = _db.Rentings.Find(id);
            foreach (var rd in renting.RentingDetails)
            {
                rd.back = false;
                rd.dateStart = DateTime.Today;
                rd.dateEnd = DateTime.Today.AddDays(14);
            }
            _db.SaveChanges();
            return RedirectToAction("Details", "Customers", new { id = renting.customerID });
        }

        // GET: Rentings/AbandonRenting/5
        public ActionResult AbandonRenting(int id)
        {
            try
            {
                var renting = _db.Rentings.Find(id);               
                _db.Rentings.Remove(renting);
                _db.SaveChanges();
                return RedirectToAction("Details", "Customers", new { id = renting.customerID });
            }
            catch
            {
                return View();
            }
        }





        

        // GET: Rentings/DVDBack/5
        public ActionResult DVDBack(int rdid)
        {
            var rd = _db.RentingDetails.Find(rdid);
            rd.back = true;
            rd.dateEnd = DateTime.Today;
            
            _db.SaveChanges();
            return RedirectToAction("Details", "Customers", new { id = rd.Rentings.customerID });
        }

    }
}
