using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using iTextSharp;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;

namespace VideothequeProjet.Models
{
    public class PdfManager
    {
        private string savePath;
        private Rentings renting;
        public PdfManager(Rentings renting, string saveP)
        {                      
            this.savePath = saveP;
            this.renting = renting;
        }


        public void generateBild()
        {
            FileStream fs = new FileStream(savePath + "\\" + renting.Customers.firstName + renting.Customers.lastName+renting.rentingID+".pdf", FileMode.Create, FileAccess.Write, FileShare.None);
            //INIT fs
            Rectangle rec = new Rectangle(PageSize.A4);
            Document MyPdf = new Document(rec);
            PdfWriter writer = PdfWriter.GetInstance(MyPdf, fs);
            MyPdf.Open();

            //titre
            Chunk c = new Chunk("Facture", FontFactory.GetFont(FontFactory.COURIER, 20, Font.BOLD));
            Paragraph p = new Paragraph(c);            
            
            p.Alignment = Element.ALIGN_CENTER;
            p.SpacingAfter = 12;
            MyPdf.Add(p);

            //données client
            p = new Paragraph();
            Chunk chunk;

            chunk = new Chunk(this.renting.Customers.firstName+" "+this.renting.Customers.lastName + "\n", FontFactory.GetFont(FontFactory.COURIER, 10));
            p.Add(chunk);
           
            chunk = new Chunk(this.renting.Customers.address + "\n", FontFactory.GetFont(FontFactory.COURIER, 10));
            p.Add(chunk);
            chunk = new Chunk(this.renting.Customers.phoneNumber + "\n", FontFactory.GetFont(FontFactory.COURIER, 10));
            p.Add(chunk);
            chunk = new Chunk(this.renting.Customers.mailAddress + "\n", FontFactory.GetFont(FontFactory.COURIER, 10));
            p.Add(chunk);                        

            p.SpacingAfter = 12;
            MyPdf.Add(p);

            //Date et lieu
            p = new Paragraph();            

            chunk = new Chunk("Fait à Grenoble le "+DateTime.Today.ToString("dd/MM/yyyy")+"\n", FontFactory.GetFont(FontFactory.COURIER, 10));
            p.Add(chunk);            

            p.Alignment = Element.ALIGN_RIGHT;
            p.SpacingAfter = 12;
            MyPdf.Add(p);

            //Date de l'emprunt
            p = new Paragraph();

            chunk = new Chunk("Emprunt fait par "+renting.Users.firstName+" "+renting.Users.lastName+" le " + renting.RentingDetails.First().dateStart.ToString("dd/MM/yyyy") + "\n", FontFactory.GetFont(FontFactory.COURIER, 10));
            p.Add(chunk);

            p.Alignment = Element.ALIGN_CENTER;
            p.SpacingAfter = 12;
            MyPdf.Add(p);


            //Table dvd
             p = new Paragraph();
             PdfPTable tab = new PdfPTable(2);
             tab.AddCell(new Phrase(new Chunk("Film", FontFactory.GetFont(FontFactory.COURIER, 14, Font.BOLD))));

             tab.AddCell(new Phrase(new Chunk("Prix", FontFactory.GetFont(FontFactory.COURIER, 14, Font.BOLD))));
           

            foreach (var rd in this.renting.RentingDetails)
            {
                tab.AddCell(rd.DVD.Movies.title);
                tab.AddCell(rd.price.ToString());
            }
            tab.AddCell("Total");
            tab.AddCell(this.renting.cost.ToString());
            p.Add(tab);
            p.SpacingAfter = 12;
            MyPdf.Add(p);

            MyPdf.Close();
           
        }
    }
}