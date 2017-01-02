using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using VideothequeProjet.Models;
using System.Data.Entity.Infrastructure;

namespace VideothequeProjet.Controllers
{
    [Authorize]
    public class MoviesController : Controller
    {
        private ProjetVideoEntities _db = new ProjetVideoEntities();

        // GET: Movies
        public ActionResult Index(string field = "")
        {
            List<Movies> movies;

            switch (field)
            {             
                case "duration":
                    movies = (from m in _db.Movies orderby (m.duration) select m).ToList();
                    break;

                case "year":
                    movies = (from m in _db.Movies orderby (m.year) select m).ToList();
                    break;
                case "note":
                    movies = (from m in _db.Movies orderby (m.note) descending select m).ToList();
                    break;
                case "director":
                    movies = (from m in _db.Movies orderby (m.Directors.FirstOrDefault().lastName) select m).ToList();
                    break;
               
                case "filmtype":
                    movies = (from m in _db.Movies orderby (m.FilmTypes.FirstOrDefault().filmType) select m).ToList();
                    break;                
                default :
                    movies = (from m in _db.Movies orderby (m.title) select m).ToList();
                    break;
            }
             
            return View(movies);
        }

        // GET: Movies/Details/5
        public ActionResult Details(int id)
        {
            Movies movie = _db.Movies.Find(id);
            ViewBag.exemplaireLoues = (from rd in _db.RentingDetails join d in  _db.DVD on rd.DVDID equals d.DVDID where d.movieID == id where d.available where !rd.back select rd);
            ViewBag.nbLoues = (from rd in _db.RentingDetails join d in _db.DVD on rd.DVDID equals d.DVDID where d.movieID == id where d.available where !rd.back select rd).Count();
            return View(movie);
        }

        // GET: Movies/Create
        public ActionResult Create()
        {
            ViewBag.Type = _db.FilmTypes.ToList();         
            return View();
        }

        // POST: Movies/Create
        [HttpPost]
        public ActionResult Create([Bind(Exclude = "MovieID")] Movies MoviesToCreate, int[] selectedTypes, string synopsis, int nbEx)
        {
            
            if (!ModelState.IsValid )
            {
                ViewBag.Type = _db.FilmTypes.ToList();
                return View();
            }
            try
            {
                foreach (FilmTypes type in _db.FilmTypes.Where(type => selectedTypes.Contains(type.typeID) ))
                {
                    MoviesToCreate.FilmTypes.Add(type);
                }

                int i = 0;
                while (i < nbEx)
                {
                    MoviesToCreate.DVD.Add(new DVD());
                    ++i;
                }
                MoviesToCreate.synopsis = synopsis;
                

                _db.Movies.Add(MoviesToCreate);
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            catch (RetryLimitExceededException /* dex */)
            {
                //Log the error (uncomment dex variable name and add a line here to write a log.)
                ModelState.AddModelError("", "Unable to save changes. Try again, and if the problem persists, see your system administrator.");
            }                       
            return View(MoviesToCreate);

        }

       

        // GET: Movies/Edit/5
        public ActionResult Edit(int? id, int[] selectedTypes)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            var movieToEdit = (from m in _db.Movies where m.movieID == id select m).First();


            if (movieToEdit == null) return HttpNotFound();


            ViewBag.Type = _db.FilmTypes.ToList();
            return View(movieToEdit);
        }

        // POST: Movies/Edit/5
        [HttpPost]
        public ActionResult Edit(Movies movieToEdit, int[] selectedTypes, string synopsis, int nbEx)
        {
            
            int nbLoues = (from rd in _db.RentingDetails join d in _db.DVD on rd.DVDID equals d.DVDID where d.movieID == movieToEdit.movieID where !rd.back select rd).Count();
            int nbCourantEx = (from m in _db.Movies where m.movieID == movieToEdit.movieID select m).First().DVD.Where(dvd => dvd.available).Count();
            var errors = this.ModelState.Keys.SelectMany(key => this.ModelState[key].Errors);
            if (!ModelState.IsValid || nbCourantEx - nbEx > nbCourantEx - nbLoues)
            {               
                return View(movieToEdit);
            }
            try
            {
                var movie = _db.Movies.Find(movieToEdit.movieID);

                movie.duration = movieToEdit.duration;
                movie.note = movieToEdit.note;
                movie.price = movieToEdit.price;
                movie.title = movieToEdit.title;
                movie.year = movieToEdit.year;
                movie.synopsis = synopsis;


                movie.FilmTypes.Clear();
                if (selectedTypes != null)
                {
                    foreach (FilmTypes type in _db.FilmTypes.Where(type => selectedTypes.Contains(type.typeID)))
                    {
                        if (!movie.FilmTypes.Contains(type))
                            movie.FilmTypes.Add(type);
                    }
                }

                foreach (DVD d in movie.DVD)
                {
                    if (movie.DVD.Where(dvd => dvd.available).Count() <= nbEx) break;
                    if (!this.estLoue(d))
                    {
                        d.available = false;
                    }
                }

                while (nbEx > movie.DVD.Where(dvd=>dvd.available).Count())
                {
                    movie.DVD.Add(new DVD());
                }
                                              
                _db.SaveChanges();
                

                return RedirectToAction("Index");
            }
            catch(Exception ex)
            {
                return View();
            }
         }

        // GET: Movies/Delete/5
        public ActionResult Delete(int id)
        {
            return View(_db.Movies.Find(id));
        }

        // POST: Movies/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {

                var movie = _db.Movies.Find(id);
                movie.Directors.Clear();
                movie.FilmTypes.Clear();
                movie.DVD.Clear();

                _db.Movies.Remove(movie);
                _db.SaveChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Movies/AjaxRequest
        public ActionResult AjaxRequest(string nameDir)
        {
            var directors = (from d in _db.Directors
                             orderby d.lastName
                             where (d.lastName+" "+d.firstName).ToLower().Contains(nameDir.ToLower())
                             select d);
            
           int nbdir = directors.Count();
           
            return Json(directors.ToList());
        }

        // GET: Movies/DirectorEdit/5
        public ActionResult DirectorEdit(int id)
        {
            var movie = _db.Movies.Find(id);
            ViewBag.movie = movie;
            ViewBag.directors = (from d in _db.Directors orderby d.lastName select d);
                
            return View(movie);
        }

        // POST: Movies/DirectorEdit/5
        [HttpPost]
        public ActionResult DirectorEdit(int id, int[] directors)
        {            
            var movie = _db.Movies.Find(id);
            movie.Directors.Clear();
            foreach (var idDir in directors)
            {
                movie.Directors.Add(_db.Directors.Find(idDir));
            }                        
            _db.SaveChanges();
            return RedirectToAction("Index");
        }

        // GET: Movies/ActorEdit/5
        public ActionResult ActorEdit(int id)
        {
            var movie = _db.Movies.Find(id);
            ViewBag.movie = movie;
            ViewBag.actors = (from a in _db.Actors orderby a.lastName select a);

            return View(movie);
        }

        // POST: Movies/ActorEdit/5
        [HttpPost]
        public ActionResult ActorEdit(int id, int[] actors)
        {
            var movie = _db.Movies.Find(id);
            movie.Actors.Clear();
            foreach (var idAct in actors)
            {
                movie.Actors.Add(_db.Actors.Find(idAct));
            }
            _db.SaveChanges();
            return RedirectToAction("Index");
        }

        public bool estLoue(DVD dvd)
        {
            foreach (RentingDetails rd in dvd.RentingDetails)
            {
                if (!rd.back)
                {
                    return true;
                }
            }
            return false;
        }

    }
}
