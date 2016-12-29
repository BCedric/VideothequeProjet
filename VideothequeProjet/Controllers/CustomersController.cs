using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using VideothequeProjet.Models;

namespace VideothequeProjet.Controllers
{
    [Authorize]
    public class CustomersController : Controller
    {

        private ProjetVideoEntities _db = new ProjetVideoEntities();

        // GET: Customers
        public ActionResult Index()
        {
            return View(_db.Customers.ToList());
        }

        // GET: Customers/Details/5
        public ActionResult Details(int id)
        {
            Customers customer = _db.Customers.Find(id);
            return View(customer);
        }

        // GET: Customers/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Customers/Create
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

        // GET: Customers/Edit/5
        public ActionResult Edit(int id)
        {
            Customers customer = _db.Customers.Find(id);
            return View(customer);
        }

        // POST: Customers/Edit/5
        [HttpPost]
        public ActionResult Edit(Customers customerToEdit)
        {
            var customer = (from c in _db.Customers where c.customerID == customerToEdit.customerID select c).First();
            try
            {
                customer.address = customerToEdit.address;
                customer.firstName = customerToEdit.firstName;
                customer.lastName = customerToEdit.lastName;
                customer.mailAddress = customerToEdit.mailAddress;
                customer.phoneNumber = customerToEdit.phoneNumber;

                _db.SaveChanges();

                return RedirectToAction("Index");
            }
            catch
            {                
                return View(customerToEdit);
            }
        }

        // GET: Customers/Delete/5
        public ActionResult Delete(int id)
        {            
            return View(_db.Customers.Find(id));
        }

        // POST: Customers/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            Customers customer = _db.Customers.Find(id);
            try
            {
               
                customer.Rentings.Clear();
                _db.Customers.Remove(customer);
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return View(customer);
            }
        }
    }
}
