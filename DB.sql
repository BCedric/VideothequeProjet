USE ProjetVideo
GO

if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.RentingDetails') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."RentingDetails"
GO

if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.ActorsMovie') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."ActorsMovie"
GO

if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.DirectorsMovie') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."DirectorsMovie"
GO

if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.TypeMovie') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."TypeMovie"
GO
if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.DVD') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."DVD"
GO
if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Movies') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Movies"
GO

if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Actors') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Actors"
GO

if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Directors') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Directors"
GO

if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.FilmTypes') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."FilmTypes"
GO
if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Rentings') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Rentings"
GO
if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Customers') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Customers"
GO
if exists (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Users') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Users"
GO




--CREATION DES TABLES
CREATE TABLE Movies (movieID int NOT NULL IDENTITY(1,1), 
					title VARCHAR(30) NOT NULL,
					synopsis VARCHAR(1000) NOT NULL,
					duration int,
					year int,
					note decimal,
					price decimal NOT NULL,
					CONSTRAINT "PK_Movies" PRIMARY KEY CLUSTERED ("movieID") 
					);

CREATE TABLE Actors (actorID int NOT NULL IDENTITY(1,1),
					firstName VARCHAR(30) NOT NULL,
					lastName VARCHAR(30) NOT NULL,
					iconURL VARCHAR(100),
					CONSTRAINT "PK_Actors" PRIMARY KEY CLUSTERED ("actorID")
					);

CREATE TABLE Directors (directorID int NOT NULL IDENTITY(1,1),
					firstName VARCHAR(30) NOT NULL,
					lastName VARCHAR(30) NOT NULL,
					iconURL VARCHAR(100),
					CONSTRAINT "PK_Directors" PRIMARY KEY CLUSTERED ("directorID")
					);

CREATE TABLE FilmTypes (typeID int NOT NULL IDENTITY(1,1),
					filmType VARCHAR(30) NOT NULL,
					CONSTRAINT "PK_FilmTypes" PRIMARY KEY CLUSTERED ("typeID")					
					);

CREATE TABLE Customers (customerID int  NOT NULL IDENTITY(1,1),
					firstName VARCHAR(30) NOT NULL,
					lastName VARCHAR(30) NOT NULL,
					address VARCHAR(100) NOT NULL,
					phoneNumber VARCHAR(10) NOT NULL,
					mailAddress VARCHAR(100) NOT NULL,
					CONSTRAINT "PK_Customers" PRIMARY KEY CLUSTERED ("customerID")
					);

CREATE TABLE Users (userID int NOT NULL IDENTITY(1,1),
					login VARCHAR(30) NOT NULL,
					password VARCHAR(32) NOT NULL,
					firstName VARCHAR(30) NOT NULL,
					lastName VARCHAR(30) NOT NULL,
					CONSTRAINT "PK_Admins" PRIMARY KEY CLUSTERED ("userID")
					);

CREATE TABLE Rentings (rentingID int NOT NULL IDENTITY(1,1),
					customerID int NOT NULL,
					userID int NOT NULL,
					
					cost decimal,
					CONSTRAINT "PK_Renting" PRIMARY KEY CLUSTERED ("rentingID"),
					CONSTRAINT "FK_RentingsAdmin" FOREIGN KEY ("userID") REFERENCES Users("userID"),
					CONSTRAINT "FK_RentingsCustomer" FOREIGN KEY (customerID) REFERENCES Customers("customerID")
					);

CREATE TABLE DVD (DVDID int NOT NULL IDENTITY(1,1),
					movieID int NOT NULL,
					available  bit NOT NULL DEFAULT 1,										
					CONSTRAINT "PK_DVD" PRIMARY KEY CLUSTERED ("DVDID"),
					CONSTRAINT "FK_DVDMovie" FOREIGN KEY ("movieID") REFERENCES Movies("movieID")
					);


--RELATIONS



CREATE TABLE RentingDetails (RentingDetailsID int NOT NULL IDENTITY(1,1),
					DVDID int NOT NULL,
					rentingID int NOT NULL,					
					price decimal NOT NULL,
					back bit NOT NULL DEFAULT 0,
					dateStart date NOT NULL,
					dateEnd date ,
					CONSTRAINT "PK_RentingDetails" PRIMARY KEY CLUSTERED ("RentingDetailsID"),
					CONSTRAINT "FK_RentingDetailsDVD" FOREIGN KEY ("DVDID") REFERENCES DVD("DVDID"),
					CONSTRAINT "FK_RentingDetailsRenting" FOREIGN KEY ("rentingID") REFERENCES Rentings(rentingID)
					);

CREATE TABLE ActorsMovie (MovieID int NOT NULL,
					ActorID int NOT NULL,										
					CONSTRAINT "PK_ActorsMovie" PRIMARY KEY CLUSTERED (MovieID, ActorID),
					CONSTRAINT "FK_ActorsMovieMovie" FOREIGN KEY (MovieID) REFERENCES Movies("MovieID") ON DELETE CASCADE,
					CONSTRAINT "FK_ActorsMovieActor" FOREIGN KEY (ActorID) REFERENCES Actors("ActorID") ON DELETE CASCADE
					);

CREATE TABLE DirectorsMovie (MovieID int NOT NULL,
					DirectorID int NOT NULL,										
					CONSTRAINT "PK_DirectorsMovie" PRIMARY KEY CLUSTERED (MovieID, DirectorID),
					CONSTRAINT "FK_DirectorsMovieMovie" FOREIGN KEY (MovieID) REFERENCES Movies("MovieID") ON DELETE CASCADE,
					CONSTRAINT "FK_DirectorsMovieDirector" FOREIGN KEY (DirectorID) REFERENCES Directors("DirectorID") ON DELETE CASCADE
					);

CREATE TABLE TypeMovie (MovieID int NOT NULL,
					typeID int NOT NULL,										
					CONSTRAINT "PK_TypeMovie" PRIMARY KEY CLUSTERED (MovieID, typeID),
					CONSTRAINT "FK_TypeMovieMovie" FOREIGN KEY (MovieID) REFERENCES Movies("MovieID") ON DELETE CASCADE,
					CONSTRAINT "FK_TypeMovieType" FOREIGN KEY (typeID) REFERENCES FilmTypes("typeID") ON DELETE CASCADE
					);


--Jeu de données
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Alabama Monroe', 'Didier et Élise vivent une histoire d amour passionnée et rythmée par la musique. Lui, joue du banjo dans un groupe de Bluegrass Country et vénère l Amérique. Elle, tient un salon de tatouage et chante dans le groupe de Didier. De leur union fusionnelle naît une fille, Maybelle.', '109', '2013', '4.5', '4');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Sound of noise', 'L’officier de police Amadeus Warnebring est né dans une illustre famille de musiciens. Ironie du sort, il déteste la musique.
Sa vie bascule le jour où un groupe de musiciens déjantés décide d’exécuter une œuvre musicale apocalyptique en utilisant la ville comme instrument de musique…
Il s’engage alors dans sa première enquête policière musicale... ', '102', '2010', '4', '5');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Incendies', 'A la lecture du testament de leur mère, Jeanne et Simon Marwan se voient remettre deux enveloppes : l’une destinée à un père qu’ils croyaient mort et l‘autre à un frère dont ils ignoraient l’existence.
Jeanne voit dans cet énigmatique legs la clé du silence de sa mère, enfermée dans un mutisme inexpliqué les dernières semaines précédant sa mort. Elle décide immédiatement de partir au Moyen Orient exhumer le passé de cette famille dont elle ne sait presque rien…
Simon, lui, n’a que faire des caprices posthumes de cette mère qui s’est toujours montrée distante. Mais son amour pour sa sœur jumelle le poussera bientôt à rejoindre Jeanne et à sillonner avec elle le pays de leurs ancêtres sur la piste d’une mère bien loin de celle qu’ils ont connue. ', '123', '2011', '4.4', '8');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Whiplash', 'Andrew, 19 ans, rêve de devenir l’un des meilleurs batteurs de jazz de sa génération. Mais la concurrence est rude au conservatoire de Manhattan où il s’entraîne avec acharnement. Il a pour objectif d’intégrer le fleuron des orchestres dirigé par Terence Fletcher, professeur féroce et intraitable. Lorsque celui-ci le repère enfin, Andrew se lance, sous sa direction, dans la quête de l’excellence... ', '107', '2014', '4.5', '7');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Jackie Brown', 'Jackie Brown, hôtesse de l air, arrondit ses fins de mois en convoyant de l argent liquide pour le compte d un trafiquant d armes, Ordell Robbie. Un jour, un agent federal et un policier de Los Angeles la cueillent à l aéroport. Ils comptent sur elle pour faire tomber le trafiquant. Jackie échafaude alors un plan audacieux pour doubler tout le monde lors d un prochain transfert qui porte sur la modeste somme de cinq cent mille dollars. Mais il lui faudra compter avec les complices d Ordell, qui ont des méthodes plutôt expéditives.', '150', '1998', '4', '9');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Scoop', 'L''enquête du célèbre journaliste d''investigation Joe Strombel, consacrée au "Tueur au Tarot" de Londres, tourne court quand il meurt de façon aussi soudaine qu''inexplicable. Mais rien, pas même la mort, ne peut arrêter Joe.
A peine arrivé au purgatoire, il décide de transmettre ses toutes dernières informations à la plus charmante des étudiantes en journalisme : Sondra Pransky.
De passage à Londres, Sondra entend le fantôme de Joe s''adresser à elle durant un numéro de magie de l''Américain Splendini, alias Sid Waterman. Bouleversée et folle de joie à l''idée d''avoir déniché le scoop du siècle, l''effervescente créature se lance avec Sid dans une
enquête échevelée, qui les mène droit au fringant aristocrate et politicien Peter Lyman. Une idylle se noue en dépit de troublants indices semblant désigner le beau Peter comme le "Tueur au Tarot".
Le scoop de Sondra lui sera-t-il fatal ? ', '96', '2006', '3.6', '12');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Mustang', 'C''est le début de l''été.
Dans un village reculé de Turquie, Lale et ses quatre sœurs rentrent de l’école en jouant avec des garçons et déclenchent un scandale aux conséquences inattendues.
La maison familiale se transforme progressivement en prison, les cours de pratiques ménagères remplacent l’école et les mariages commencent à s’arranger.
Les cinq sœurs, animées par un même désir de liberté, détournent les limites qui leur sont imposées.', '93', '2015', '4.4', '7');

INSERT INTO Users(login, password, firstName, lastName) VALUES ('coucou', '721a9b52bfceacc503c056e3b9b93cfa', 'francis', 'durand');
INSERT INTO Users(login, password, firstName, lastName) VALUES ('c', '4a8a08f09d37b73795649038408b5f33', 'Francis', 'Huster');

INSERT INTO Customers VALUES ('Sébastien','Patrick',  '26 rue du Sentier 75002 Paris', '0632456532', 'patrick.sebastien@gmail.com');
INSERT INTO Customers VALUES ('Gilbert','Montagnier',  'une adresse', '0678965412', 'gilbert.montagnier@caramail.com');
INSERT INTO Customers VALUES ('Francky','Vincent',  'la bas', '0645786352', 'vasyfrancky@laposte.net');
INSERT INTO Customers VALUES ('Super','Didier',  'nulle part', '0745895612', 'petitcaniche@hotmail.fr');

INSERT INTO Directors (firstName, lastName) VALUES ('Félix', 'Van Groeningen');
INSERT INTO Directors (firstName, lastName) VALUES ('Quentin', 'Tarantino');
INSERT INTO Directors (firstName, lastName) VALUES ('Damien', 'Chazelle');
INSERT INTO Directors (firstName, lastName) VALUES ('Ola', 'Simonsson');
INSERT INTO Directors (firstName, lastName) VALUES ('Johanes', 'Stjarne Nilsson');
INSERT INTO Directors (firstName, lastName) VALUES ('Woody', 'Allen');

INSERT INTO Actors(firstName, lastName) VALUES('Johan','Heldenbergh');
INSERT INTO Actors(firstName, lastName) VALUES('Veerle','Baetens');
INSERT INTO Actors(firstName, lastName) VALUES('Nell','Cattrysse');
INSERT INTO Actors(firstName, lastName) VALUES('Scarlett','Johansson');
INSERT INTO Actors(firstName, lastName) VALUES('Hugh','Jackman');
INSERT INTO Actors(firstName, lastName) VALUES('Woody','Allen');

INSERT INTO FilmTypes (filmType) VALUES ('Action');
INSERT INTO FilmTypes (filmType) VALUES ('Animation');
INSERT INTO FilmTypes (filmType) VALUES ('Aventure');
INSERT INTO FilmTypes (filmType) VALUES ('Biopic');
INSERT INTO FilmTypes (filmType) VALUES ('Comédie');
INSERT INTO FilmTypes (filmType) VALUES ('Documentaire');
INSERT INTO FilmTypes (filmType) VALUES ('Drame');
INSERT INTO FilmTypes (filmType) VALUES ('Historique');
INSERT INTO FilmTypes (filmType) VALUES ('Musical');
INSERT INTO FilmTypes (filmType) VALUES ('Policier');
INSERT INTO FilmTypes (filmType) VALUES ('Romance');
INSERT INTO FilmTypes (filmType) VALUES ('Science-fiction');
INSERT INTO FilmTypes (filmType) VALUES ('Thriller');
INSERT INTO FilmTypes (filmType) VALUES ('Western');

INSERT INTO DVD (movieID) VALUES ('1');
INSERT INTO DVD (movieID) VALUES ('1');
INSERT INTO DVD (movieID) VALUES ('1');
INSERT INTO DVD (movieID) VALUES ('1');
INSERT INTO DVD (movieID) VALUES ('2');
INSERT INTO DVD (movieID) VALUES ('3');
INSERT INTO DVD (movieID) VALUES ('4');

INSERT INTO Rentings(customerID, userID, cost) VALUES ('1', '1',  '12');
INSERT INTO Rentings(customerID, userID, cost) VALUES ('1', '1',  '12');

INSERT INTO RentingDetails(DVDID, RentingID, price,dateStart, dateEnd, back) VALUES ('1','1', '4','2012-09-15','2012-10-15', 'true');
INSERT INTO RentingDetails(DVDID, RentingID, price,dateStart, dateEnd, back) VALUES ('5','1', '8','2012-09-15','2012-09-21', 'true');
INSERT INTO RentingDetails(DVDID, RentingID, price,dateStart, dateEnd) VALUES ('1','1', '4','2014-06-13', '2014-06-28');

INSERT INTO DirectorsMovie (MovieID, DirectorID) VALUES ('1','1');

INSERT INTO ActorsMovie(MovieID, ActorID) VALUES ('1', '1');
INSERT INTO ActorsMovie(MovieID, ActorID) VALUES ('1', '2');
INSERT INTO ActorsMovie(MovieID, ActorID) VALUES ('1', '3');

INSERT INTO TypeMovie(MovieID, typeID) VALUES ('6', '5');
INSERT INTO TypeMovie(MovieID, typeID) VALUES ('6', '11');
INSERT INTO TypeMovie(MovieID, typeID) VALUES ('1', '7');


