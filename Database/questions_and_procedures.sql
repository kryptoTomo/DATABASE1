-- zdarzenie i ilość powiązanych przestępstw
select zd.id_zdarzenie as "ID ZDARZENIA", zd.nazwa as "OPIS ZDARZENIA", count(prz.rodzaj_przewinienia) as "LICZBA POWIĄZANYCH PRZESTĘPSTW"
from db."zdarzenie" zd , db."przewinienie" prz
where zd.id_zdarzenie = prz.id_zdarzenie
group by zd.id_zdarzenie;

-- zgrupuj sprawę z nieznanym przestępcą i wybierz dla każdego dowody  
select distinct(zd.id_zdarzenie) as "ID ZDARZENIA",
prz.id_przewinienie as "ID PRZEWINIENIE", 
zd.nazwa as "OPIS ZDARZENIA", prz.data_przewinienia as "DATA PRZESTĘPSTWA", prz.rodzaj_przewinienia as "RODZAJ PRZESTĘPSTWA",
d.rodzaj as "RODZAJ DOWODU", d.opis as "OPIS DOWODU"
from "zdarzenie" zd , "przewinienie" prz , "dowod" d ,"uczestnik" ucz
where zd.id_zdarzenie = prz.id_zdarzenie 
and zd.id_zdarzenie= d.id_zdarzenie
and ucz.id_przewinienie = prz.id_przewinienie
and id_osoba is NULL;

-- wymień przestępców i liczbę przestępstw, które popełnili 
Select os.id_osoba as "ID OSOBA",
	   os.imie as "IMIE",
       os.nazwisko as "NAZWISKO", 
       count(ucz.id_uczestnik) as "ILOŚĆ UCZESTNICTWA W PRZESTĘPSTWACH",
       count(k.id_kara) as "ILOŚĆ DOSTANYCH KAR"
       
from "osoba" os 
left join "uczestnik" ucz on os.id_osoba=ucz.id_osoba 
left join "przewinienie" przew on przew.id_przewinienie=ucz.id_przewinienie
left join "sad" s on s.id_przestepstwo = przew.id_przewinienie
left join "kara" k on k.id_sad = s.id_sad
where ucz.rodzaj_wmieszania='Przestępca'
and s.data_rozprawy= (select max(data_rozprawy)        
			  from "sad" sad
			  where sad.id_przestepstwo=s.id_przestepstwo)
GROUP BY os.id_osoba;

-- lista osób obecnie przebywających w więzieniu, koniec kary 
Select distinct(o.id_osoba),
		o.imie as "IMIE", 
        o.nazwisko as "NAZWISKO", 
        w.nazwa as "NAZWA WIEZIENIA",
        koniec_kary as "DATA PLANOWANEGO WYJŚCIA Z WIĘZIENIA"

from "osoba" o , "uczestnik" ucz, "przewinienie" przew, "wiezienie" w, "kara" k, "sad" s
Where o.id_osoba=ucz.id_osoba
and ucz.rodzaj_wmieszania='Przestępca'
and przew.id_przewinienie=ucz.id_przewinienie
and s.id_przestepstwo=przew.id_przewinienie
and k.id_sad=s.id_sad
and w.id_wiezienie= k.id_wiezienie
and s.data_rozprawy= (select max(data_rozprawy)         
			  from "sad" sa
			  where sa.id_przestepstwo=s.id_przestepstwo) ;

-- lista osób majaca karę, które nie sa w więzieniu
Select 
		distinct (o.id_osoba) as "ID OSOBY",
		o.imie as "IMIE", 
        o.nazwisko as "NAZWISKO", 
        ucz.rodzaj_wmieszania as "Rodzaj uczestnictwa w zdarzeniu", 
        k.rodzaj_kary as "RODZAJ KARY",
        k.opis as "OPIS KARY",
        s.id_sad as "ID SĄDU", 
        s.data_rozprawy as "DATA ROZPRAWY"

from "osoba" o , "uczestnik" ucz, "przewinienie" przew, "wiezienie" w, "kara" k, "sad" s
Where o.id_osoba=ucz.id_osoba
and ucz.rodzaj_wmieszania='Przestępca'
and przew.id_przewinienie=ucz.id_przewinienie
and s.id_przestepstwo=przew.id_przewinienie
and k.id_sad=s.id_sad
and k.rodzaj_kary != 'Więzienie'
and s.data_rozprawy= (select max(data_rozprawy)
			  from "sad" sa
			  where sa.id_przestepstwo=s.id_przestepstwo);

-- rodzaj wyroku za przestępstwo i POWIAZANY RODZAJ KARY
Select przew.id_przewinienie as "ID PRZESTĘPSTWA",
	przew.rodzaj_przewinienia as "RODZAJ PRZESTĘPSTWA",
    s.decyzja as "DECYZJA SĄDU",
    s.instancja as "INSTANCJA SĄDU",
    k.rodzaj_kary as "RODZAJ KARY"
From "przewinienie" as przew, "sad" as s , "uczestnik" as ucz , "kara" k
where przew.id_przewinienie=s.id_przestepstwo
and przew.id_przewinienie = ucz.id_przewinienie
and k.id_sad = s.id_sad
and ucz.rodzaj_wmieszania = 'Przestępca'
and s.data_rozprawy= (select max(data_rozprawy)
			  from "sad" sa
			  where sa.id_przestepstwo=s.id_przestepstwo);

-- spisani przestepcy oraz przebieg ich sprawy w sadzie
Select o.id_osoba as "ID OSOBA",
	o.imie as "IMIE", 
    o.nazwisko as "NAZWISKO", 
    o.data_urodzenia as "DATA URODZENIA", przew.id_przewinienie AS "ID PRZEWINIENIA", 
    przew.rodzaj_przewinienia AS "RODZAJ PRZEWINIENIA",
    s.instancja AS "INSTANCJA SĄDU", s.decyzja as "DECYZJA SĄÐU", 
    k.rodzaj_kary as "RODZAJ KARY"
       
from "osoba" o 
left join "uczestnik" ucz on o.id_osoba=ucz.id_osoba 
left join "przewinienie" przew on przew.id_przewinienie=ucz.id_przewinienie
left join "sad" s on s.id_przestepstwo = przew.id_przewinienie
left join "kara" k on k.id_sad = s.id_sad
where ucz.rodzaj_wmieszania='Przestępca';

-- sprawy otwarte .
select zd.id_zdarzenie as "ID ZDARZENIE", zd.policjant as "PROWADZĄCY SPRAWĘ POLICJANT", 
    zd.nazwa as "NAZWA SPRAWY", zd.data_rozpoczecia as "DATA ROZPOCZĘCIA ŚLEDZTWA",
		count(przew.id_przewinienie) as "ILOŚĆ PRZESTĘPSTW",
        count(distinct(ucz.id_osoba)) as "ILOŚĆ ZNANYCH PRZESTĘPCÓW"
        
from "zdarzenie" zd , "przewinienie" przew , "uczestnik" ucz
where zd.id_zdarzenie = przew.id_zdarzenie
and ucz.id_przewinienie = przew.id_przewinienie
and zd.data_zakonczenia is null
and ucz.rodzaj_wmieszania = 'Przestępca'
group by zd.id_zdarzenie;

-- zeznania świadków 
select zd.id_zdarzenie "ID SPRAWY", zd.nazwa as "NAZWA SPRAWY" , s.id_swiadek as "ID ŚWIADKA", 
		o.imie as "IMIE ŚWIADKA" , o.nazwisko as "NAZWISKO ŚWIADKA",
        s.zeznania as "ZEZNANIA"
from "zdarzenie" zd ,"swiadek" s,"osoba" o
where  s.id_zdarzenie = zd.id_zdarzenie
and o.id_osoba = s.id_osoba;

-- połączenie sprawy z rozprawa sądową
select  zd.id_zdarzenie "ID SPRAWY", zd.nazwa as "NAZWA ZDARZENIA" , przew.id_przewinienie as "ID PRZEWINIENIE",
    s.sedzia  "SĘDZIA PROWADZĄCY SPRAWĘ", s.instancja as "INSTANCJA SĄDU" ,
		data_rozpoczecia as "DATA ROZPOCZĘCIA SPRAWY" , data_rozprawy as "DATA ROZPRAWY" 
from "zdarzenie" zd
left join "przewinienie" przew on zd.id_zdarzenie = przew.id_zdarzenie
left join "sad" s on  s.id_przestepstwo = przew.id_przewinienie
and s.data_rozprawy= (select max(data_rozprawy)
			  from "sad" sa
			  where sa.id_przestepstwo=s.id_przestepstwo);
-- stworzenie procedury sprawdzającej wynik rozprawy przestepcy
CREATE OR REPLACE FUNCTION db.getATrialOfACriminal (inImie VARCHAR(25),inNazwisko VARCHAR(25))  
RETURNS TABLE (ID_OSOBA integer, IMIE varchar, NAZWISKO varchar,
DATA_URODZENIA char(10), ID_PRZESTEPSTWA integer, RODZAJ_PRZEWINIENIA varchar,
INSTANCJA_SADU varchar, DECYZJA_SADU varchar, RODZAJ_KARY varchar)  
LANGUAGE SQL   
AS   
$$  
   select o.id_osoba, o.imie, o.nazwisko , 
       o.data_urodzenia , przew.id_przewinienie , przew.rodzaj_przewinienia,
       s.instancja, s.decyzja , k.rodzaj_kary 
    from db."osoba" o
    left join db."uczestnik" ucz on o.id_osoba=ucz.id_osoba 
    left join db."przewinienie" przew on przew.id_przewinienie=ucz.id_przewinienie
    left join db."sad" s on s.id_przestepstwo = przew.id_przewinienie
    left join db."kara" k on k.id_sad = s.id_sad
    where imie = inImie
    and nazwisko = inNazwisko
    and ucz.rodzaj_wmieszania='Przestępca';
$$;

select * from db.getATrialOfACriminal('Adolf','Stalin');

-- stworzenie procedury która zwraca ilosc przestepstw danej osoby
CREATE OR REPLACE FUNCTION db.getCountCrime(inIdOsoba integer)  
RETURNS TABLE (imie  varchar(45), nazwisko varchar(45), data_urodzenia char(10),count_przestepstwa bigint)  
LANGUAGE SQL   
AS   
$$  
   select o.imie, o.nazwisko, o.data_urodzenia, count(przew.id_przewinienie)
    from db."osoba" o
    left join db."uczestnik" ucz on ucz.id_osoba = o.id_osoba
    left join db."przewinienie" przew on przew.id_przewinienie = ucz.id_przewinienie
    where o.id_osoba = inIdOsoba
    group by o.id_osoba;
$$;
select * from db.getCountCrime(1);