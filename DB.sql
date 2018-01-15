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


--Jeu de donn�es
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Alabama Monroe', 'Didier et �lise vivent une histoire d amour passionn�e et rythm�e par la musique. Lui, joue du banjo dans un groupe de Bluegrass Country et v�n�re l Am�rique. Elle, tient un salon de tatouage et chante dans le groupe de Didier. De leur union fusionnelle na�t une fille, Maybelle.', '109', '2013', '4.5', '4');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Sound of noise', 'L�officier de police Amadeus Warnebring est n� dans une illustre famille de musiciens. Ironie du sort, il d�teste la musique.
Sa vie bascule le jour o� un groupe de musiciens d�jant�s d�cide d�ex�cuter une �uvre musicale apocalyptique en utilisant la ville comme instrument de musique�
Il s�engage alors dans sa premi�re enqu�te polici�re musicale... ', '102', '2010', '4', '5');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Incendies', 'A la lecture du testament de leur m�re, Jeanne et Simon Marwan se voient remettre deux enveloppes : l�une destin�e � un p�re qu�ils croyaient mort et l�autre � un fr�re dont ils ignoraient l�existence.
Jeanne voit dans cet �nigmatique legs la cl� du silence de sa m�re, enferm�e dans un mutisme inexpliqu� les derni�res semaines pr�c�dant sa mort. Elle d�cide imm�diatement de partir au Moyen Orient exhumer le pass� de cette famille dont elle ne sait presque rien�
Simon, lui, n�a que faire des caprices posthumes de cette m�re qui s�est toujours montr�e distante. Mais son amour pour sa s�ur jumelle le poussera bient�t � rejoindre Jeanne et � sillonner avec elle le pays de leurs anc�tres sur la piste d�une m�re bien loin de celle qu�ils ont connue. ', '123', '2011', '4.4', '8');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Whiplash', 'Andrew, 19 ans, r�ve de devenir l�un des meilleurs batteurs de jazz de sa g�n�ration. Mais la concurrence est rude au conservatoire de Manhattan o� il s�entra�ne avec acharnement. Il a pour objectif d�int�grer le fleuron des orchestres dirig� par Terence Fletcher, professeur f�roce et intraitable. Lorsque celui-ci le rep�re enfin, Andrew se lance, sous sa direction, dans la qu�te de l�excellence... ', '107', '2014', '4.5', '7');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Jackie Brown', 'Jackie Brown, h�tesse de l air, arrondit ses fins de mois en convoyant de l argent liquide pour le compte d un trafiquant d armes, Ordell Robbie. Un jour, un agent federal et un policier de Los Angeles la cueillent � l a�roport. Ils comptent sur elle pour faire tomber le trafiquant. Jackie �chafaude alors un plan audacieux pour doubler tout le monde lors d un prochain transfert qui porte sur la modeste somme de cinq cent mille dollars. Mais il lui faudra compter avec les complices d Ordell, qui ont des m�thodes plut�t exp�ditives.', '150', '1998', '4', '9');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Scoop', 'L''enqu�te du c�l�bre journaliste d''investigation Joe Strombel, consacr�e au "Tueur au Tarot" de Londres, tourne court quand il meurt de fa�on aussi soudaine qu''inexplicable. Mais rien, pas m�me la mort, ne peut arr�ter Joe.
A peine arriv� au purgatoire, il d�cide de transmettre ses toutes derni�res informations � la plus charmante des �tudiantes en journalisme : Sondra Pransky.
De passage � Londres, Sondra entend le fant�me de Joe s''adresser � elle durant un num�ro de magie de l''Am�ricain Splendini, alias Sid Waterman. Boulevers�e et folle de joie � l''id�e d''avoir d�nich� le scoop du si�cle, l''effervescente cr�ature se lance avec Sid dans une
enqu�te �chevel�e, qui les m�ne droit au fringant aristocrate et politicien Peter Lyman. Une idylle se noue en d�pit de troublants indices semblant d�signer le beau Peter comme le "Tueur au Tarot".
Le scoop de Sondra lui sera-t-il fatal ? ', '96', '2006', '3.6', '12');
INSERT INTO Movies(title, synopsis, duration, year,	note, price) VALUES ('Mustang', 'C''est le d�but de l''�t�.
Dans un village recul� de Turquie, Lale et ses quatre s�urs rentrent de l��cole en jouant avec des gar�ons et d�clenchent un scandale aux cons�quences inattendues.
La maison familiale se transforme progressivement en prison, les cours de pratiques m�nag�res remplacent l��cole et les mariages commencent � s�arranger.
Les cinq s�urs, anim�es par un m�me d�sir de libert�, d�tournent les limites qui leur sont impos�es.', '93', '2015', '4.4', '7');

INSERT INTO Users(login, password, firstName, lastName) VALUES ('coucou', '721a9b52bfceacc503c056e3b9b93cfa', 'francis', 'durand');
INSERT INTO Users(login, password, firstName, lastName) VALUES ('c', '4a8a08f09d37b73795649038408b5f33', 'Francis', 'Huster');

INSERT INTO Customers VALUES ('S�bastien','Patrick',  '26 rue du Sentier 75002 Paris', '0632456532', 'patrick.sebastien@gmail.com');
INSERT INTO Customers VALUES ('Gilbert','Montagnier',  'une adresse', '0678965412', 'gilbert.montagnier@caramail.com');
INSERT INTO Customers VALUES ('Francky','Vincent',  'la bas', '0645786352', 'vasyfrancky@laposte.net');
INSERT INTO Customers VALUES ('Super','Didier',  'nulle part', '0745895612', 'petitcaniche@hotmail.fr');

INSERT INTO Directors (firstName, lastName) VALUES ('F�lix', 'Van Groeningen');
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
INSERT INTO FilmTypes (filmType) VALUES ('Com�die');
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


