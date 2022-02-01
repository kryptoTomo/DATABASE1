CREATE SCHEMA db;
SET SEARCH_PATH to db;
--- STWORZENIE BAZY DANYCH ORAZ WPROWADZENIE PRZYKŁADOWYCH DANYCH
CREATE TABLE "zdarzenie"(
    "id_zdarzenie" INTEGER NOT NULL,
    "nazwa" VARCHAR(50) NOT NULL,
    "policjant" VARCHAR(25) NOT NULL,
    "data_rozpoczecia" CHAR(10) NOT NULL,
    "data_zakonczenia" CHAR(10) DEFAULT NULL
);
ALTER TABLE
    "zdarzenie" ADD PRIMARY KEY("id_zdarzenie");

INSERT INTO "zdarzenie" VALUES 
(1,'Sąsiedzka sprzeczka','Arek','02/02/2016','05/02/2020'),
(2,'Morderstwo na święta','Mariusz','08/04/2013','16/01/2021'),
(3,'Gwałt podczas czegoś xD','Arek','08/04/2013','16/01/2021'),
(4,'Zabójstwo','Mateusz','02/03/2018',NULL),
(5,'Szalony ojciec','Arek','09/04/2019','15/01/2021'),
(6,'Tajemnicza noc','Tomek','01/01/2021',NULL),
(7,'Bez alkoholu :)','Mariusz','09/04/2020','10/05/2020'),
(8,'COVID/owa impreza','Tomek','12/12/2020','12/12/2020'),
(9,'Beeee niedobre te narkotyki','Arek','08/04/2013','05/02/2020'),
(10,'Nocny zbir','Mateusz','09/04/2014',NULL);

CREATE TABLE "przewinienie"(
    "id_przewinienie" INTEGER NOT NULL,
    "rodzaj_przewinienia" VARCHAR(35) CHECK
        ("rodzaj_przewinienia" IN('Morderstwo','Gwałt','Kradzież','Napaść','Nieakceptowalne wydarzenie','Nakłanianie','Sprzedaż Narkotyków')) NOT NULL,
        "data_przewinienia" CHAR(10) NOT NULL,
        "id_zdarzenie" INTEGER NOT NULL
);
ALTER TABLE
    "przewinienie" ADD PRIMARY KEY("id_przewinienie");
CREATE INDEX "przewinienie_id_zdarzenie_index" ON
    "przewinienie"("id_zdarzenie");

INSERT INTO "przewinienie" VALUES 
(1,'Morderstwo','31/01/2016',1),
(2,'Kradzież','31/01/2016',1),
(3,'Kradzież','31/01/2016',1),
(4,'Gwałt','08/04/2013',2),
(5,'Morderstwo','08/04/2013',2),
(6,'Napaść','08/04/2013',3),
(7,'Napaść','08/04/2013',3),
(8,'Napaść','08/04/2013',3),
(9,'Napaść','08/04/2013',3),
(10,'Morderstwo','02/03/2018',4),
(11,'Morderstwo','09/03/2019',5),
(12,'Morderstwo','09/03/2019',5),
(13,'Morderstwo','09/03/2019',5),
(14,'Morderstwo','01/01/2021',6),
(15,'Kradzież','01/01/2021',6),
(16,'Gwałt','01/01/2021',6),
(17,'Nakłanianie','04/09/2020',7),
(18,'Nieakceptowalne wydarzenie','12/12/2020',8),
(19,'Sprzedaż Narkotyków','08/04/2013',9),
(20,'Gwałt','09/04/2014',10),
(21,'Gwałt','13/04/2014',10),
(22,'Gwałt','18/04/2014',10),
(23,'Gwałt','22/04/2014',10),
(24,'Gwałt','25/04/2014',10);

CREATE TABLE "dowod"(
    "id_dowod" INTEGER NOT NULL,
    "rodzaj" VARCHAR(25) CHECK
        ("rodzaj" IN('Broń','Dowody biologiczne','Odciski','Narkotyki') ) NOT NULL,
    "data_wplyniecia" CHAR(10) NOT NULL,
    "opis" VARCHAR(50) NOT NULL,
    "id_zdarzenie" INTEGER NOT NULL
);
ALTER TABLE
    "dowod" ADD PRIMARY KEY("id_dowod");
CREATE INDEX "dowod_id_zdarzenie_index" ON
    "dowod"("id_zdarzenie");

INSERT INTO "dowod" VALUES 
(1,'Broń','02/02/2020','Pistolet',1),
(2,'Broń','04/03/2019','Nóż',2),
(3,'Dowody biologiczne','03/04/2020','Resztki Krwi',3),
(4,'Broń','03/03/2018','Pistolet',4),
(5,'Dowody biologiczne','03/03/2018','Resztki Krwi',4),
(6,'Broń','09/04/2019','Pistolet',5),
(7,'Dowody biologiczne','02/01/2021','Resztki Krwi',6),
(8,'Narkotyki','04/09/2013','marihuana',9),
(9,'Narkotyki','04/09/2013','Kokaina',9),
(10,'Dowody biologiczne','09/06/2014','Resztki Krwi',10);

CREATE TABLE "sad"(
    "id_sad" INTEGER NOT NULL,
    "instancja" VARCHAR(25) CHECK
        ("instancja" IN('Pierwsza','Druga')) NOT NULL,
    "sedzia" VARCHAR(25) NOT NULL,
    "decyzja" VARCHAR(25) CHECK
        ("decyzja" IN('Winny','Nie winny')) NOT NULL,
    "data_rozprawy" CHAR(10) NOT NULL,
    "id_przestepstwo" INTEGER NOT NULL
);
ALTER TABLE
    "sad" ADD PRIMARY KEY("id_sad");
CREATE INDEX "sad_id_przestepstwo_index" ON
    "sad"("id_przestepstwo");

INSERT INTO "sad" VALUES 
(1,'Pierwsza','Anna','Winny','04/02/2020',1),
(2,'Druga','Maria','Nie winny','05/02/2020',1),
(3,'Pierwsza','Anna','Winny','04/02/2020',2),
(4,'Druga','Maria','Nie winny','05/02/2020',2),
(5,'Pierwsza','Anna','Nie winny','04/02/2020',3),
(6,'Pierwsza','Anna','Winny','04/02/2020',4),
(7,'Pierwsza','Wesołowska','Winny','04/03/2020',5),
(8,'Pierwsza','Wesołowska','Winny','04/03/2020',6),
(9,'Pierwsza','Arek','Winny','09/07/2020',7),
(10,'Pierwsza','Arek','Nie winny','19/01/2021',8),
(11,'Pierwsza','Arek','Nie winny','05/02/2020',9),
(12,'Pierwsza','Wesołowska','Winny','20/01/2021',11),
(13,'Pierwsza','Wesołowska','Winny','20/01/2021',12),
(14,'Pierwsza','Wesołowska','Winny','20/01/2021',13),
(15,'Pierwsza','Wesołowska','Winny','09/10/2020',17),
(16,'Pierwsza','Wesołowska','Winny','03/02/2021',18),
(17,'Pierwsza','Wesołowska','Winny','05/03/2020',19),
(18,'Druga','Maria','Winny','25/01/2021',17);



CREATE TABLE "kara"(
    "id_kara" INTEGER NOT NULL,
    "rodzaj_kary" VARCHAR(255) CHECK
        ("rodzaj_kary" IN('Więzienie','Grzywna')) NOT NULL,
    "opis" VARCHAR(50) NOT NULL,
    "koniec_kary" CHAR(10) DEFAULT NULL,
    "id_wiezienie" INTEGER DEFAULT NULL,
    "id_sad" INTEGER DEFAULT NULL
);
ALTER TABLE
    "kara" ADD PRIMARY KEY("id_kara");
CREATE INDEX "kara_id_wiezienie_index" ON
    "kara"("id_wiezienie");
CREATE INDEX "kara_id_sad_index" ON
    "kara"("id_sad");

INSERT INTO "kara" VALUES 
(1,'Więzienie','10 Lat','04/02/2030',1,1),
(2,'Więzienie','10 Lat','04/02/2030',1,3),
(3,'Więzienie','20 Lat','04/02/2030',5,6),
(4,'Więzienie','20 Lat','04/02/2030',5,7),
(5,'Więzienie','20 Lat','04/02/2030',5,8),
(6,'Więzienie','20 Lat','04/02/2030',5,9),
(7,'Więzienie','99 Lat','20/01/2120',10,12),
(8,'Więzienie','99 Lat','20/01/2120',10,13),
(9,'Więzienie','99 Lat','20/01/2120',10,14),
(10,'Więzienie','6 Miesiecy','03/10/2021',2,15),
(11,'Grzywna','10000 Złotych',NULL,NULL,16),
(12,'Więzienie','20 Lat','05/03/2040',2,17),
(13,'Grzywna','10000 Złotych',NULL,NULL,18);


CREATE TABLE "osoba"(
    "id_osoba" INTEGER NOT NULL,
    "imie" VARCHAR(255) NOT NULL,
    "nazwisko" VARCHAR(255) NOT NULL,
    "narodowosc" VARCHAR(255) NOT NULL,
    "plec" CHAR(255) NOT NULL,
    "adress" VARCHAR(50) NOT NULL,
    "data_urodzenia" CHAR(10) NOT NULL
);
ALTER TABLE
    "osoba" ADD PRIMARY KEY("id_osoba");

INSERT INTO "osoba" VALUES 
(1,'Adolf','Stalin','PL','F','777 ADA','23/04/1996'),
(2,'EWA','Nwm','UK','F','30 AWA','14/05/1986'),
(3,'Marian','Ernac','PL','M','250 ARA','02/03/1998'),
(4,'Juke','Dacner','PL','M','700 AQA','03/04/1996'),
(5,'EWA','EWA','UK','F','66 ALA','14/03/1956'),
(6,'May','Ancerd','USA','M','591 AHA','12/02/1998'),
(7,'Maxou','Maxi','PL','M','55 ALA','28/02/1996'),
(8,'Jeanne','Dutrieux','PO','F','137 AVX','1946/05/14'),
(9,'Paul','David','BE','M','42 ZAW','1978/03/11'),
(10,'Juan','Dustin','IT','M','374 ZAF','1989/02/03'),
(11,'Denise','Reynard','USA','F','121 ZAS','04/03/1974'),
(12,'Pascal','Pearson','FR','M','677 ZAM','03/12/1988'),
(13,'Christian ','Durein ','MA','M','337 EAW','27/02/1945'),
(14,'Evelyne','Fournier','FR','F','295 ESW','05/02/1970'),
(15,'Bob','Marchert','USA','M','1775 EFS','04/03/1983'),
(16,'Caroll','Studt','JN','F','280 KIA','21/03/1969'),
(17,'Cristian','Brown','CH','M','20 SAS','23/04/1989'),
(18,'Laurin','Pant','AN','F','11 SAR','02/03/1999'),
(19,'Yse','Aiello','ES','F','301 ASAS','03/04/1997'),
(20,'Jenny','Jahangir','GE','F','780 AFAS','14/03/1955'),
(21,'Lars','Morfin','UK','M','70 QEQ','12/02/1999'),
(22,'Chris','Nemec','USA','M','830 FAF','28/02/1990'),
(23,'Rocio','Nazarian','SW','F','1470 DAD','14/05/1935'),
(24,'Laura','Morfin','PO','F','506 DAR','11/03/1989'),
(25,'Mudabbir','Morfin','BE','M','742 DAS','03/02/1961'),
(26,'Toni','Zhang','IT','M','72 MDA','04/03/1978'),
(27,'Fredrik','Nemec','USA','M','200 FSDAS','03/12/1963'),
(28,'Hannah','Pant','FR','F','180 asd','11/03/1978'),
(29,'Khaja','Wang','MA','M','555 aWF','03/02/1989'),
(30,'Julia','Kromer','FR','F','555 FSAA','04/03/1974'),
(31,'Valentina','Chabanel','USA','F','300 asdSD','03/12/1988'),
(32,'Sebastian','Chabanel','USA','M','301 fasSF','27/02/1945'),
(33,'Frida','Chabanel','USA','F','36 afsF','05/02/1970'),
(34,'Costanza','Chabanel','USA','F','450 GASF','04/03/1983'),
(35,'Costantin','Lopez','ES','M','1180 asf','21/03/1969'),
(36,'Kyra','Resag','GE','F','1105 Bos','23/04/1989'),
(37,'Raafi','Khawaja','SW','M','100 Char','02/03/1999'),
(38,'Sair','Duro','PO','M','262 Swan','03/04/1997'),
(39,'Paolo','Mellbye','BE','M','36 Param','14/03/1955'),
(40,'Costantin','Fournier','USA','M','550 Provi','03/04/1997'),
(41,'Kyra','Marchert','ES','F','352 Palme','14/03/1955'),
(42,'Raafi','Studt','GE','M','300 Cranb','12/02/1999'),
(43,'Sair','Brown','SW','M','250 Rt','28/02/1990'),
(44,'Paolo','Pant','PO','M','141 Wash','01/03/1990');

CREATE TABLE "wiezienie"(
    "id_wiezienie" INTEGER NOT NULL,
    "nazwa" VARCHAR(50) NOT NULL,
    "max_ilosc" INTEGER NOT NULL
);

ALTER TABLE
    "wiezienie" ADD PRIMARY KEY("id_wiezienie");

INSERT INTO "wiezienie" VALUES 
(1,'Wiezienie W Krakowie',1000),
(2,'Wiezienie W Warszawie',14000),
(3,'Wiezienie W Rzeszowie',5000),
(4,'Wiezienie W Przemyślu',2000),
(5,'Wiezienie W Sanok',1813),
(6,'Wiezienie W Lesko',2150),
(7,'Wiezienie W Wrocław',2000),
(8,'Wiezienie W Gdańsku',1700),
(9,'Wiezienie W Jakies',3302),
(10,'Wiezienie W Nwm',490);

CREATE TABLE "uczestnik"(
    "id_uczestnik" INTEGER NOT NULL,
    "rodzaj_wmieszania" VARCHAR(25) CHECK
        ("rodzaj_wmieszania" IN('Ofiara','Przestępca','Nieznany')) NOT NULL,
    "pytania" VARCHAR(50) NULL,
    "status" VARCHAR(25) CHECK
        ("status" IN('Martwy','Żywy','Zaginiony','Nieznany')) NOT NULL,
    "id_przewinienie" INTEGER NOT NULL,
    "id_osoba" INTEGER DEFAULT NULL
);
ALTER TABLE
    "uczestnik" ADD PRIMARY KEY("id_uczestnik");
CREATE INDEX "uczestnik_id_przewinienie_index" ON
    "uczestnik"("id_przewinienie");
CREATE INDEX "uczestnik_id_osoba_index" ON
    "uczestnik"("id_osoba");

INSERT INTO "uczestnik" VALUES 
(1,'Przestępca','','Żywy',1,9),
(2,'Przestępca','','Żywy',2,9),
(3,'Przestępca','','Żywy',3,1),
(4,'Ofiara','','Martwy',1,2),
(5,'Ofiara','','Martwy',2,2),
(6,'Ofiara','','Martwy',3,2),
(7,'Przestępca','','Żywy',4,6),
(8,'Przestępca','','Żywy',5,6),
(9,'Ofiara','','Martwy',4,3),
(10,'Ofiara','','Martwy',5,3),
(11,'Przestępca','','Żywy',6,10),
(12,'Przestępca','','Żywy',7,10),
(13,'Przestępca','','Żywy',8,13),
(14,'Przestępca','','Żywy',9,13),
(15,'Ofiara','','Żywy',6,14),
(16,'Ofiara','','Żywy',7,14),
(17,'Ofiara','','Żywy',8,17),
(18,'Ofiara','','Żywy',9,17),
(19,'Ofiara','','Martwy',10,37),
(20,'Przestępca','','Martwy',11,31),
(21,'Przestępca','','Martwy',12,31),
(22,'Przestępca','','Martwy',13,31),
(23,'Ofiara','','Martwy',11,32),
(24,'Ofiara','','Martwy',12,33),
(25,'Ofiara','','Martwy',13,34),
(26,'Przestępca','','Żywy',14,18),
(27,'Przestępca','','Żywy',15,18),
(28,'Przestępca','','Żywy',16,18),
(29,'Ofiara','','Martwy',14,19),
(30,'Ofiara','','Martwy',15,19),
(31,'Ofiara','','Martwy',16,19),
(32,'Przestępca','','Żywy',17,20),
(33,'Przestępca','','Żywy',18,21),
(34,'Przestępca','','Żywy',18,22),
(35,'Przestępca','','Żywy',18,23),
(36,'Przestępca','','Żywy',18,24),
(37,'Przestępca','','Żywy',18,25),
(38,'Przestępca','','Żywy',18,26),
(39,'Przestępca','','Żywy',19,27),
(40,'Ofiara','','Żywy',20,28),
(41,'Ofiara','','Żywy',21,29),
(42,'Ofiara','','Żywy',22,30),
(43,'Ofiara','','Żywy',23,35),
(44,'Ofiara','','Żywy',24,36),
(45,'Przestępca','','Nieznany',20,NULL),
(46,'Przestępca','','Nieznany',21,NULL),
(47,'Przestępca','','Nieznany',22,NULL),
(48,'Przestępca','','Nieznany',23,NULL),
(49,'Przestępca','','Nieznany',24,NULL),
(50,'Przestępca','','Nieznany',10,NULL);

CREATE TABLE "swiadek"(
    "id_swiadek" INTEGER NOT NULL,
    "zeznania" VARCHAR(50) NOT NULL,
    "id_osoba" INTEGER NOT NULL,
    "id_zdarzenie" INTEGER NOT NULL
);
ALTER TABLE
    "swiadek" ADD PRIMARY KEY("id_swiadek");
CREATE INDEX "swiadek_id_osoba_index" ON
    "swiadek"("id_osoba");
CREATE INDEX "swiadek_id_index" ON
    "swiadek"("id_zdarzenie");

INSERT INTO "swiadek" VALUES 
(1,'bardoz wazne',7,1),
(2,'informacje',4,2),
(3,'co on zrobił',11,3),
(4,'baasdfgas',7,3),
(5,'asdfgsad',38,4),
(6,'sdg',39,8),
(7,'busadgsdgot',40,8),
(8,'sadg',41,8),
(9,'asfdg',42,6),
(10,'asdgsdgas',43,9);

ALTER TABLE
    "przewinienie" ADD CONSTRAINT "przewinienie_id_zdarzenie_foreign" FOREIGN KEY("id_zdarzenie") REFERENCES "zdarzenie"("id_zdarzenie");
ALTER TABLE
    "dowod" ADD CONSTRAINT "dowod_id_zdarzenie_foreign" FOREIGN KEY("id_zdarzenie") REFERENCES "zdarzenie"("id_zdarzenie");
ALTER TABLE
    "sad" ADD CONSTRAINT "sad_id_przestepstwo_foreign" FOREIGN KEY("id_przestepstwo") REFERENCES "przewinienie"("id_przewinienie");
ALTER TABLE
    "kara" ADD CONSTRAINT "kara_id_wiezienie_foreign" FOREIGN KEY("id_wiezienie") REFERENCES "wiezienie"("id_wiezienie");
ALTER TABLE
    "kara" ADD CONSTRAINT "kara_id_sad_foreign" FOREIGN KEY("id_sad") REFERENCES "sad"("id_sad");
ALTER TABLE
    "uczestnik" ADD CONSTRAINT "uczestnik_id_przewinienie_foreign" FOREIGN KEY("id_przewinienie") REFERENCES "przewinienie"("id_przewinienie");
ALTER TABLE
    "uczestnik" ADD CONSTRAINT "uczestnik_id_osoba_foreign" FOREIGN KEY("id_osoba") REFERENCES "osoba"("id_osoba");
ALTER TABLE
    "swiadek" ADD CONSTRAINT "swiadek_id_osoba_foreign" FOREIGN KEY("id_osoba") REFERENCES "osoba"("id_osoba");
ALTER TABLE
    "swiadek" ADD CONSTRAINT "swiadek_id_foreign" FOREIGN KEY("id_zdarzenie") REFERENCES "zdarzenie"("id_zdarzenie");


--- USUNIĘCIE BAZY DANYCH
-- DROP SCHEMA db CASCADE;

