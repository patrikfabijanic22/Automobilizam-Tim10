DROP DATABASE IF EXISTS automobilizam;
CREATE DATABASE automobilizam;
USE automobilizam;

CREATE TABLE sponzor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    drzava VARCHAR(50) NOT NULL
);

CREATE TABLE mehanicar (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    datum_rodenja DATE NOT NULL
);

CREATE TABLE staza (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    duzina DECIMAL(10, 3) NOT NULL,
    drzava VARCHAR(50) NOT NULL
);
ALTER TABLE staza ADD COLUMN kategorija VARCHAR(50);

CREATE TABLE prvenstvo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(150) NOT NULL,
    budzet DECIMAL(15, 2) NOT NULL,
    organizator VARCHAR(100) NOT NULL,
    datum_pocetka DATE NOT NULL,
    datum_zavrsetka DATE NOT NULL,
    lokacija VARCHAR(100) NOT NULL,
    broj_timova INT NOT NULL CHECK (broj_timova > 0)
);
ALTER TABLE prvenstvo ADD COLUMN timovi_bez_nagrada VARCHAR(255);

CREATE TABLE tim (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    drzava VARCHAR(50) NOT NULL,
    vlasnik VARCHAR(100) NOT NULL,
    godina_osnivanja YEAR NOT NULL
);
ALTER TABLE tim ADD COLUMN status_nagrada BOOLEAN DEFAULT TRUE;
ALTER TABLE tim ADD COLUMN bonus DECIMAL(10, 2) DEFAULT 0;
ALTER TABLE tim ADD COLUMN kazna DECIMAL(10, 2) DEFAULT 0;
ALTER TABLE tim ADD COLUMN aktivnost VARCHAR(2);
ALTER TABLE tim ADD COLUMN broj_pobjeda INT DEFAULT 0;

CREATE TABLE timski_mehanicar (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_tim INT NOT NULL,
    id_mehanicar INT NOT NULL,
    godina_zaposlenja YEAR NOT NULL,
    FOREIGN KEY (id_tim) REFERENCES tim(id),
    FOREIGN KEY (id_mehanicar) REFERENCES mehanicar(id)
);

CREATE TABLE trener (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_tim INT NOT NULL,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    drzava VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_tim) REFERENCES tim(id)
);
ALTER TABLE trener ADD COLUMN ucinkovitost VARCHAR(20);

CREATE TABLE timski_sponzor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_tim INT NOT NULL,
    id_sponzor INT NOT NULL,
    FOREIGN KEY (id_tim) REFERENCES tim(id),
    FOREIGN KEY (id_sponzor) REFERENCES sponzor(id)
);

CREATE TABLE nagrada (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    oblik VARCHAR(50) NOT NULL,
    iznos DECIMAL(15, 2) NOT NULL
);

CREATE TABLE utrka (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_prvenstvo INT NOT NULL,
    id_staza INT NOT NULL,
    id_nagrada INT NOT NULL,
    naziv_eventa VARCHAR(150) NOT NULL,
    broj_utrke VARCHAR(50) NOT NULL,
    datum_pocetak DATE NOT NULL,
    datum_kraj DATE NOT NULL,
    vrijeme TIME NOT NULL,
    temperatura INT,
    FOREIGN KEY (id_prvenstvo) REFERENCES prvenstvo(id),
    FOREIGN KEY (id_staza) REFERENCES staza(id),
    FOREIGN KEY (id_nagrada) REFERENCES nagrada(id)
);

CREATE TABLE automobil (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_tim INT NOT NULL,
    model VARCHAR(50) NOT NULL,
    drzava VARCHAR(50) NOT NULL,
    boja VARCHAR(30) NOT NULL,
    gume VARCHAR(30) NOT NULL,
    godina_proizvodnje YEAR NOT NULL,
    maksimalna_brzina INT NOT NULL CHECK (maksimalna_brzina > 0),
    FOREIGN KEY (id_tim) REFERENCES tim(id)
);
ALTER TABLE automobil ADD COLUMN status VARCHAR(50) DEFAULT 'Ispravan';

CREATE TABLE motor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_automobil INT NOT NULL,
    model VARCHAR(50) NOT NULL,
    tip_oznake VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_automobil) REFERENCES automobil(id)
);

CREATE TABLE automobil_kod_mehanicara (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_mehanicar INT NOT NULL,
    id_automobil INT NOT NULL,
    FOREIGN KEY (id_mehanicar) REFERENCES mehanicar(id),
    FOREIGN KEY (id_automobil) REFERENCES automobil(id)
);

CREATE TABLE vozac (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tim_id INT NOT NULL,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    drzava VARCHAR(50) NOT NULL,
    datum_rodenja DATE NOT NULL,
    FOREIGN KEY (tim_id) REFERENCES tim(id)
);

CREATE TABLE rezultat (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_utrka INT NOT NULL,
    id_prvenstvo INT NOT NULL,
    id_vozac INT NOT NULL,
    mjesto INT NOT NULL CHECK (mjesto > 0),
    bodovi INT NOT NULL,
    broj_krugova INT NOT NULL CHECK (broj_krugova > 0),
    vrijeme_kruga TIME NOT NULL,
    FOREIGN KEY (id_utrka) REFERENCES utrka(id),
    FOREIGN KEY (id_prvenstvo) REFERENCES prvenstvo(id),
    FOREIGN KEY (id_vozac) REFERENCES vozac(id)
);

CREATE TABLE vozacev_automobil (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_automobil INT NOT NULL,
    id_vozac INT NOT NULL,
    FOREIGN KEY (id_automobil) REFERENCES automobil(id),
    FOREIGN KEY (id_vozac) REFERENCES vozac(id)
);

CREATE TABLE vozi_krug (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_vozac INT NOT NULL,
    id_utrka INT NOT NULL,
    vrijeme_kruga TIME NOT NULL,
    broj_kruga INT NOT NULL CHECK (broj_kruga > 0),
    FOREIGN KEY (id_vozac) REFERENCES vozac(id),
    FOREIGN KEY (id_utrka) REFERENCES utrka(id)
);

CREATE TABLE se_kvalificira (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_vozac INT NOT NULL,
    id_utrka INT NOT NULL,
    vrijeme_kruga TIME NOT NULL,
    broj_kruga INT NOT NULL CHECK (broj_kruga > 0),
    FOREIGN KEY (id_vozac) REFERENCES vozac(id),
    FOREIGN KEY (id_utrka) REFERENCES utrka(id)
);

CREATE TABLE ostvaruje_rezultat (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_tim INT NOT NULL,
    id_prvenstvo INT NOT NULL,
    ukupan_broj_bodova INT,
    broj_najbrzih_krugova INT NOT NULL,
    FOREIGN KEY (id_tim) REFERENCES tim(id),
    FOREIGN KEY (id_prvenstvo) REFERENCES prvenstvo(id)
);


INSERT INTO staza (id, naziv, duzina, drzava) VALUES
(600, 'Bahrain International Circuit', 5.412, 'Bahrein'),
(601, 'Jeddah Corniche Circuit', 6.175, 'Saudijska Arabija'),
(602, 'Melbourne Grand Prix Circuit', 5.303, 'Australija'),
(603, 'Baku City Circuit', 6.003, 'Azerbejdžan'),
(604, 'Miami International Autodrome', 4.203, 'Amerika'),
(605, 'Autodromo Enzo e Dino Ferrari', 4.909, 'Italija'),
(606, 'Circuit de Monaco', 3.337, 'Monaco'),
(607, 'Circuit de Barcelona-Catalunya', 4.655, 'Španjolska'),
(608, 'Circuit Gilles Villeneuve', 4.361, 'Kanada'),
(609, 'Red Bull Ring', 4.318, 'Austrija'),
(610, 'Silverstone Circuit', 5.891, 'Velika Britanija'),
(611, 'Hungaroring', 4.381, 'Mađarska'),
(612, 'Circuit de Spa-Francorchamps', 7.004, 'Belgija'),
(613, 'Zandvoort Circuit', 4.259, 'Nizozemska'),
(614, 'Autodromo Nazionale Monza', 5.793, 'Italija'),
(615, 'Marina Bay Street Circuit', 5.063, 'Singapur'),
(616, 'Suzuka International Racing Course', 5.807, 'Japan'),
(617, 'Lusail International Circuit', 5.257, 'Katar'),
(618, 'Circuit of the Americas', 5.513, 'Sjedinjene Američke Države'),
(619, 'Autódromo Hermanos Rodríguez', 4.304, 'Meksiko'),
(620, 'Autódromo José Carlos Pace', 4.309, 'Brazil'),
(621, 'Las Vegas Strip Circuit', 4.700, 'Sjedinjene Američke Države'),
(622, 'Yas Marina Circuit', 5.554, 'Ujedinjeni Arapski Emirati');


INSERT INTO tim (id, naziv, drzava, vlasnik, godina_osnivanja) VALUES
(1, 'Oracle Red Bull Racing', 'Velika Britanija', 'Dietrich Mateschitz', 2005), 
(2, 'Mercedes-AMG PETRONAS F1 Team', 'Velika Britanija', 'Toto Wolff', 2010), 
(3, 'Scuderia Ferrari', 'Italija', 'Fiat Agnelli', 1929), 
(4, 'McLaren Formula 1 Team', 'Velika Britanija', 'Zak Brown', 1963), 
(5, 'Scuderia AlphaTauri RB', 'Italija', 'Franz Tost', 2006), 
(6, 'Aston Martin Aramco Cognizant F1 Team', 'Velika Britanija', 'Lawrence Stroll', 1958), 
(7, 'BWT Alpine F1 Team', 'Velika Britanija', 'Luca de Meo', 1977), 
(8, 'Alfa Romeo F1 Team Stake', 'Švicarska', 'Peter Sauber', 1950), 
(9, 'Williams Racing', 'Velika Britanija', 'Dorilton Capital', 1977), 
(10, 'MoneyGram Haas F1 Team', 'Velika Britanija', 'Gene Haas', 2016);


INSERT INTO vozac (id, tim_id, ime, prezime, drzava, datum_rodenja) VALUES
(101, 1, 'Max', 'Verstappen', 'Nizozemska', STR_TO_DATE('1997-09-30', '%Y-%m-%d')),
(102, 1, 'Sergio', 'Perez', 'Meksiko', STR_TO_DATE('1990-01-26', '%Y-%m-%d')),
(103, 2,'Lewis', 'Hamilton', 'Velika Britanija', STR_TO_DATE('1985-01-07', '%Y-%m-%d')),
(104, 2,'George', 'Russell', 'Velika Britanija', STR_TO_DATE('1998-02-15', '%Y-%m-%d')),
(105, 3,'Charles', 'Leclerc', 'Monako', STR_TO_DATE('1997-10-16', '%Y-%m-%d')),
(106, 3,'Carlos', 'Sainz', 'Španjolska', STR_TO_DATE('1994-09-01', '%Y-%m-%d')),
(107, 4,'Lando', 'Norris', 'Velika Britanija', STR_TO_DATE('1999-11-13', '%Y-%m-%d')),
(108, 4,'Oscar', 'Piastri', 'Australija', STR_TO_DATE('2001-04-06', '%Y-%m-%d')),
(109, 6,'Fernando', 'Alonso', 'Španjolska', STR_TO_DATE('1981-07-29', '%Y-%m-%d')),
(110, 6,'Lance', 'Stroll', 'Kanada', STR_TO_DATE('1998-10-29', '%Y-%m-%d')),
(111, 7,'Pierre', 'Gasly', 'Francuska', STR_TO_DATE('1996-02-07', '%Y-%m-%d')),
(112, 7,'Esteban', 'Ocon', 'Francuska', STR_TO_DATE('1996-09-17', '%Y-%m-%d')),
(113, 9,'Alexander', 'Albon', 'Tajland', STR_TO_DATE('1996-03-23', '%Y-%m-%d')),
(114, 9,'Logan', 'Sargeant', 'Sjedinjene Američke Države', STR_TO_DATE('2001-12-31', '%Y-%m-%d')),
(115, 5,'Yuki', 'Tsunoda', 'Japan', STR_TO_DATE('2000-05-11', '%Y-%m-%d')),
(116, 5,'Daniel', 'Ricciardo', 'Australija', STR_TO_DATE('1989-07-01', '%Y-%m-%d')),
(117, 8,'Valtteri', 'Bottas', 'Finska', STR_TO_DATE('1989-08-28', '%Y-%m-%d')),
(118, 8,'Zhou', 'Guanyu', 'Kina', STR_TO_DATE('1999-05-30', '%Y-%m-%d')),
(119, 10,'Kevin', 'Magnussen', 'Danska', STR_TO_DATE('1992-10-05', '%Y-%m-%d')),
(120, 10,'Nico', 'Hulkenberg', 'Njemačka', STR_TO_DATE('1987-08-19', '%Y-%m-%d'));


INSERT INTO nagrada VALUES
(201, 'Gladiator', 'Trofej prvenstva', 1000000),
(202, 'Magnum', 'Zlatna medalja utrke', 750000),
(203, 'Sunner', 'Srebrna medalja utrke', 500000),
(204, 'Checker', 'Broncana medalja utrke', 250000),
(205, 'Revolt', 'Trofej najbolji vozač prvenstva', 100000);


INSERT INTO automobil (id, id_tim, model, drzava, boja, gume, godina_proizvodnje, maksimalna_brzina) VALUES
(301, 1, 'RB19', 'Austrija', 'Crna', 'Pirelli', 2019, 350),
(302, 2, 'W14', 'Velika Britanija', 'Crna', 'Pirelli', 2020, 345),
(303, 3, 'SF-23', 'Italija', 'Crvena', 'Pirelli', 2023, 355),
(304, 4, 'MCL60', 'Velika Britanija', 'Narančasta', 'Pirelli', 2022, 340),
(305, 5, 'AMR23', 'Velika Britanija', 'Tirkizna', 'Pirelli', 2023, 335),
(306, 6, 'A523', 'Francuska', 'Roza', 'Pirelli', 2022, 330),
(307, 7, 'FW45', 'Francuska', 'Plava', 'Pirelli', 2022, 325),
(308, 8, 'AT04', 'Švicarska', 'Bijela', 'Pirelli', 2023, 340),
(309, 9, 'C43', 'Velika Britanija', 'Crvena', 'Pirelli', 2023, 335),
(310, 10, 'VF-23', 'Amerika', 'Bijela', 'Pirelli', 2023, 330);


INSERT INTO motor VALUES
(701, 301, 'Honda', 'RBPTH001'),
(702, 302, 'Mercedes-AMG', 'M14'), 
(703, 303, 'Ferrari', '066/10'),
(704, 304, 'Mercedes', 'M14'),
(705, 305, 'Mercedes', 'V6'),
(706, 306, 'Renault', 'RE23'),
(707, 307, 'Mercedes', 'M14'),
(708, 308, 'Honda', 'RA620H'),
(709, 309, 'Ferrari', '066/10'),
(710, 310, 'Ferrari', '066/7');


INSERT INTO prvenstvo (id, naziv, budzet, organizator, datum_pocetka, datum_zavrsetka, lokacija, broj_timova) VALUES
(5000, 'F1 Championship Grande Cup', 3000000, 'Franz Hellen', STR_TO_DATE('2024-05-05', '%Y-%m-%d'), STR_TO_DATE('2024-05-08', '%Y-%m-%d'), 'Miami International Autodrome', 10),
(5001, 'F1 Championship Holiday Play Low League', 3000000, 'Jerome Stringer', STR_TO_DATE('2024-12-19', '%Y-%m-%d'),STR_TO_DATE('2024-12-23', '%Y-%m-%d'), 'Yas Marina Circuit', 10);


INSERT INTO utrka VALUES
(1000, 5000, 600, 201, 'GULF AIR BAHRAIN GRAND PRIX', '1-2023', STR_TO_DATE('2023-03-03', '%Y-%m-%d'), STR_TO_DATE('2023-03-05', '%Y-%m-%d'), '15:00:00', 25),
(1001, 5000, 601, 205, 'STC SAUDI ARABIAN GRAND PRIX', '2-2023', STR_TO_DATE('2023-03-17', '%Y-%m-%d'), STR_TO_DATE('2023-03-19', '%Y-%m-%d'), '12:30:00', 32),
(1002, 5000, 602, 203, 'ROLEX AUSTRALIAN GRAND PRIX', '3-2023', STR_TO_DATE('2023-03-31', '%Y-%m-%d'), STR_TO_DATE('2023-04-02', '%Y-%m-%d'), '17:00:00', 29),
(1003, 5000, 603, 205, 'AZERBAIJAN GRAND PRIX', '4-2023', STR_TO_DATE('2023-04-28', '%Y-%m-%d'), STR_TO_DATE('2023-04-30', '%Y-%m-%d'), '12:00:00', 28),
(1004, 5000, 604, 202, 'CRYPTO.COM MIAMI GRAND PRIX', '5-2023', STR_TO_DATE('2023-05-05', '%Y-%m-%d'), STR_TO_DATE('2023-05-07', '%Y-%m-%d'), '15:30:00', 30),
(1005, 5000, 605, 204, 'QATAR AIRWAYS GRAN PREMIO DEL MADE IN ITALY E DELL EMILIA-ROMAGNA', '6-2023', STR_TO_DATE('2023-05-19', '%Y-%m-%d'), STR_TO_DATE('2023-05-21', '%Y-%m-%d'), '16:00:00', 18),
(1006, 5000, 606, 203, 'GRAND PRIX DE MONACO', '7-2023', STR_TO_DATE('2023-05-26', '%Y-%m-%d'), STR_TO_DATE('2023-05-28', '%Y-%m-%d'), '11:00:00', 22),
(1007, 5000, 607, 201, 'AWS GRAN PREMIO DE ESPAÑA', '8-2023', STR_TO_DATE('2023-06-02', '%Y-%m-%d'), STR_TO_DATE('2023-06-04', '%Y-%m-%d'), '13:00:00', 32),
(1008, 5000, 608, 201, 'PIRELLI GRAND PRIX DU CANADA', '9-2023', STR_TO_DATE('2023-06-16', '%Y-%m-%d'), STR_TO_DATE('2023-06-18', '%Y-%m-%d'), '10:00:00', 22),
(1009, 5000, 609, 204, 'ROLEX GROSSER PREIS VON ÖSTERREICH', '10-2023', STR_TO_DATE('2023-06-30', '%Y-%m-%d'), STR_TO_DATE('2023-07-02', '%Y-%m-%d'), '16:00:00', 24),
(1010, 5000, 610, 205, 'ARAMCO BRITISH GRAND PRIX', '11-2023', STR_TO_DATE('2023-07-07', '%Y-%m-%d'), STR_TO_DATE('2023-07-09', '%Y-%m-%d'), '09:00:00', 21),
(1011, 5000, 611, 203, 'QATAR AIRWAYS HUNGARIAN GRAND PRIX', '12-2023', STR_TO_DATE('2023-07-21', '%Y-%m-%d'), STR_TO_DATE('2023-07-23', '%Y-%m-%d'), '12:00:00', 29),
(1012, 5000, 612, 202, 'MSC CRUISES BELGIAN GRAND PRIX', '13-2023', STR_TO_DATE('2023-07-28', '%Y-%m-%d'), STR_TO_DATE('2023-07-30', '%Y-%m-%d'), '13:00:00', 26),
(1013, 5000, 613, 203, 'HEINEKEN DUTCH GRAND PRIX', '14-2023', STR_TO_DATE('2023-08-25', '%Y-%m-%d'), STR_TO_DATE('2023-08-27', '%Y-%m-%d'), '13:30:00', 23),
(1014, 5000, 614, 201, 'PIRELLI GRAN PREMIO D’ITALIA', '15-2023', STR_TO_DATE('2023-09-01', '%Y-%m-%d'), STR_TO_DATE('2023-09-03', '%Y-%m-%d'), '15:00:00', 19),
(1015, 5000, 615, 205, 'SINGAPORE AIRLINES SINGAPORE GRAND PRIX', '16-2023', STR_TO_DATE('2023-09-15', '%Y-%m-%d'), STR_TO_DATE('2023-09-17', '%Y-%m-%d'), '12:00:00', 15),
(1016, 5000, 616, 205, 'LENOVO JAPANESE GRAND PRIX', '17-2023', STR_TO_DATE('2023-09-22', '%Y-%m-%d'), STR_TO_DATE('2023-09-24', '%Y-%m-%d'), '17:00:00', 9),
(1017, 5000, 617, 203, 'QATAR AIRWAYS QATAR GRAND PRIX', '18-2023', STR_TO_DATE('2023-10-06', '%Y-%m-%d'), STR_TO_DATE('2023-10-08', '%Y-%m-%d'), '14:00:00', 20),
(1018, 5000, 618, 202, 'LENOVO UNITED STATES GRAND PRIX', '19-2023', STR_TO_DATE('2023-10-20', '%Y-%m-%d'), STR_TO_DATE('2023-10-22', '%Y-%m-%d'), '15:00:00', 13),
(1019, 5000, 619, 201, 'GRAN PREMIO DE LA CIUDAD DE MÉXICO', '20-2023', STR_TO_DATE('2023-10-27', '%Y-%m-%d'), STR_TO_DATE('2023-10-29', '%Y-%m-%d'), '09:00:00', 14),
(1020, 5000, 620, 204, 'ROLEX GRANDE PRÊMIO DE SÃO PAULO', '21-2023', STR_TO_DATE('2023-11-03', '%Y-%m-%d'), STR_TO_DATE('2023-11-05', '%Y-%m-%d'), '12:00:00', 10),
(1021, 5000, 621, 205, 'HEINEKEN SILVER LAS VEGAS GRAND PRIX', '22-2023', STR_TO_DATE('2023-11-16', '%Y-%m-%d'), STR_TO_DATE('2023-11-18', '%Y-%m-%d'), '13:00:00', 6),
(1022, 5000, 622, 201, 'ETIHAD AIRWAYS ABU DHABI GRAND PRIX ', '23-2023', STR_TO_DATE('2023-11-24', '%Y-%m-%d'), STR_TO_DATE('2023-11-26', '%Y-%m-%d'), '17:00:00', 22),
(1023, 5001, 600, 201, 'GULF AIR BAHRAIN GRAND PRIX', '1-2023', STR_TO_DATE('2023-03-03', '%Y-%m-%d'), STR_TO_DATE('2023-03-05', '%Y-%m-%d'), '15:00:00', 25),
(1024, 5001, 601, 205, 'STC SAUDI ARABIAN GRAND PRIX', '2-2023', STR_TO_DATE('2023-03-17', '%Y-%m-%d'), STR_TO_DATE('2023-03-19', '%Y-%m-%d'), '12:30:00', 32),
(1025, 5001, 602, 203, 'ROLEX AUSTRALIAN GRAND PRIX', '3-2023', STR_TO_DATE('2023-03-31', '%Y-%m-%d'), STR_TO_DATE('2023-04-02', '%Y-%m-%d'), '17:00:00', 29),
(1026, 5001, 603, 205, 'AZERBAIJAN GRAND PRIX', '4-2023', STR_TO_DATE('2023-04-28', '%Y-%m-%d'), STR_TO_DATE('2023-04-30', '%Y-%m-%d'), '12:00:00', 28),
(1027, 5001, 604, 202, 'CRYPTO.COM MIAMI GRAND PRIX', '5-2023', STR_TO_DATE('2023-05-05', '%Y-%m-%d'), STR_TO_DATE('2023-05-07', '%Y-%m-%d'), '15:30:00', 30),
(1028, 5001, 605, 204, 'QATAR AIRWAYS GRAN PREMIO DEL MADE IN ITALY E DELL EMILIA-ROMAGNA', '6-2023', STR_TO_DATE('2023-05-19', '%Y-%m-%d'), STR_TO_DATE('2023-05-21', '%Y-%m-%d'), '16:00:00', 18),
(1029, 5001, 606, 203, 'GRAND PRIX DE MONACO', '7-2023', STR_TO_DATE('2023-05-26', '%Y-%m-%d'), STR_TO_DATE('2023-05-28', '%Y-%m-%d'), '11:00:00', 22),
(1030, 5001, 607, 201, 'AWS GRAN PREMIO DE ESPAÑA', '8-2023', STR_TO_DATE('2023-06-02', '%Y-%m-%d'), STR_TO_DATE('2023-06-04', '%Y-%m-%d'), '13:00:00', 32),
(1031, 5001, 608, 201, 'PIRELLI GRAND PRIX DU CANADA', '9-2023', STR_TO_DATE('2023-06-16', '%Y-%m-%d'), STR_TO_DATE('2023-06-18', '%Y-%m-%d'), '10:00:00', 22),
(1032, 5001, 609, 204, 'ROLEX GROSSER PREIS VON ÖSTERREICH', '10-2023', STR_TO_DATE('2023-06-30', '%Y-%m-%d'), STR_TO_DATE('2023-07-02', '%Y-%m-%d'), '16:00:00', 24),
(1033, 5001, 610, 205, 'ARAMCO BRITISH GRAND PRIX', '11-2023', STR_TO_DATE('2023-07-07', '%Y-%m-%d'), STR_TO_DATE('2023-07-09', '%Y-%m-%d'), '09:00:00', 21),
(1034, 5001, 611, 203, 'QATAR AIRWAYS HUNGARIAN GRAND PRIX', '12-2023', STR_TO_DATE('2023-07-21', '%Y-%m-%d'), STR_TO_DATE('2023-07-23', '%Y-%m-%d'), '12:00:00', 29),
(1035, 5001, 612, 202, 'MSC CRUISES BELGIAN GRAND PRIX', '13-2023', STR_TO_DATE('2023-07-28', '%Y-%m-%d'), STR_TO_DATE('2023-07-30', '%Y-%m-%d'), '13:00:00', 26),
(1036, 5001, 613, 203, 'HEINEKEN DUTCH GRAND PRIX', '14-2023', STR_TO_DATE('2023-08-25', '%Y-%m-%d'), STR_TO_DATE('2023-08-27', '%Y-%m-%d'), '13:30:00', 23),
(1037, 5001, 614, 201, 'PIRELLI GRAN PREMIO D’ITALIA', '15-2023', STR_TO_DATE('2023-09-01', '%Y-%m-%d'), STR_TO_DATE('2023-09-03', '%Y-%m-%d'), '15:00:00', 19),
(1038, 5001, 615, 205, 'SINGAPORE AIRLINES SINGAPORE GRAND PRIX', '16-2023', STR_TO_DATE('2023-09-15', '%Y-%m-%d'), STR_TO_DATE('2023-09-17', '%Y-%m-%d'), '12:00:00', 15),
(1039, 5001, 616, 205, 'LENOVO JAPANESE GRAND PRIX', '17-2023', STR_TO_DATE('2023-09-22', '%Y-%m-%d'), STR_TO_DATE('2023-09-24', '%Y-%m-%d'), '17:00:00', 9),
(1040, 5001, 617, 203, 'QATAR AIRWAYS QATAR GRAND PRIX', '18-2023', STR_TO_DATE('2023-10-06', '%Y-%m-%d'), STR_TO_DATE('2023-10-08', '%Y-%m-%d'), '14:00:00', 20),
(1041, 5001, 618, 202, 'LENOVO UNITED STATES GRAND PRIX', '19-2023', STR_TO_DATE('2023-10-20', '%Y-%m-%d'), STR_TO_DATE('2023-10-22', '%Y-%m-%d'), '15:00:00', 13),
(1042, 5001, 619, 201, 'GRAN PREMIO DE LA CIUDAD DE MÉXICO', '20-2023', STR_TO_DATE('2023-10-27', '%Y-%m-%d'), STR_TO_DATE('2023-10-29', '%Y-%m-%d'), '09:00:00', 14),
(1043, 5001, 620, 204, 'ROLEX GRANDE PRÊMIO DE SÃO PAULO', '21-2023', STR_TO_DATE('2023-11-03', '%Y-%m-%d'), STR_TO_DATE('2023-11-05', '%Y-%m-%d'), '12:00:00', 10),
(1044, 5001, 621, 205, 'HEINEKEN SILVER LAS VEGAS GRAND PRIX', '22-2023', STR_TO_DATE('2023-11-16', '%Y-%m-%d'), STR_TO_DATE('2023-11-18', '%Y-%m-%d'), '13:00:00', 6),
(1045, 5001, 622, 201, 'ETIHAD AIRWAYS ABU DHABI GRAND PRIX ', '23-2023', STR_TO_DATE('2023-11-24', '%Y-%m-%d'), STR_TO_DATE('2023-11-26', '%Y-%m-%d'), '17:00:00', 22);


INSERT INTO trener (id, id_tim, ime, prezime, drzava) VALUES
(501, 1, 'Christian', 'Horner', 'Velika Britanija'),
(502, 2, 'Toto', 'Wolff', 'Austrija'),
(503, 3, 'Frederic', 'Vasseur', 'Francuska'),
(504, 4, 'Zak', 'Brown', 'Sjedinjene Američke Države'),
(505, 6, 'Henry', 'Howe', 'Velika Britanija'),
(506, 7, 'Marin', 'Szafnauer', 'Rumunjska'),
(507, 9, 'Jost', 'Capito', 'Njemačka'),
(508, 5, 'Peter', 'Bayer', 'Austrija'),
(509, 8, 'Alessandro', 'Bravi', 'Italija'),
(510, 10, 'Guenther', 'Steiner', 'Italija');


INSERT INTO mehanicar VALUES
(401, 'Pierre', 'Waché', STR_TO_DATE('1991-07-02', '%Y-%m-%d')),
(402, 'James', 'Allison', STR_TO_DATE('1993-12-09', '%Y-%m-%d')),
(403, 'Enrico', 'Cardile', STR_TO_DATE('1992-02-15', '%Y-%m-%d')),
(404, 'Peter', 'Prodromou', STR_TO_DATE('1970-04-23', '%Y-%m-%d')),
(405, 'Dan', 'Fallows', STR_TO_DATE('1975-08-17', '%Y-%m-%d')),
(406, 'Matt', 'Harman', STR_TO_DATE('1974-06-30', '%Y-%m-%d')),
(407, 'Pat', 'Fry', STR_TO_DATE('1977-03-12', '%Y-%m-%d')),
(408, 'Jody', 'Egginton', STR_TO_DATE('1973-09-25', '%Y-%m-%d')),
(409, 'Simone', 'Resta', STR_TO_DATE('1977-11-08', '%Y-%m-%d')),
(410, 'Chris', 'Anderson', STR_TO_DATE('1999-02-19', '%Y-%m-%d'));


INSERT INTO timski_mehanicar VALUES
(7000, 1, 401, 2009),
(7001, 2, 402, 2008),
(7002, 3, 403, 2016),
(7003, 4, 404, 2012),
(7004, 5, 405, 2017),
(7005, 6, 406, 2009),
(7006, 7, 407, 2020),
(7007, 8, 408, 2010),
(7008, 9, 409, 2023),
(7009, 10, 410, 2011);


INSERT INTO sponzor VALUES 
(9000, 'Pure Storage', 'Sjedinjene Američke Države'),
(9001, 'AMD (Advanced Micro Devices)', 'Sjedinjene Američke Države'),
(9002, 'Bose', 'Sjedinjene Američke Države'),
(9003, 'Hewlett Packard Enterprise (HPE)', 'Sjedinjene Američke Države'),
(9004, 'AT&T', 'Sjedinjene Američke Države'),
(9005, 'Acronis', 'Švicarska'),
(9006, 'Huski Chocolate', 'Švedska'),
(9007, 'Meggitt', 'Velika Britanija'),
(9008, 'Ineos', 'Velika Britanija'),
(9009, 'Nexa3D', 'Sjedinjene Američke Države'),
(9010, 'Oracle', 'Sjedinjene Američke Države');


INSERT INTO timski_sponzor VALUES
(8000,1, 9003),
(8001,2, 9007),
(8002,3, 9009),
(8003,4, 9001),
(8004,5, 9005),
(8005,6, 9006),
(8006,7, 9002),
(8007,8, 9004),
(8008,9, 9008),
(8009,10,9010),
(8010,1, 9007),
(8011,2, 9002),
(8012,5, 9005),
(8013,7, 9006),
(8014,9, 9003),
(8015,10,9004);


INSERT INTO automobil_kod_mehanicara VALUES
(6000, 401, 301),
(6001, 402, 302),
(6002,403, 303),
(6003,404, 304),
(6004,405, 305),
(6005,406, 306),
(6006,407, 307),
(6007,408, 308),
(6008,409, 309),
(6009,410, 310);


INSERT INTO vozacev_automobil VALUES
(250,301,101),
(251,301,102),
(252,302,103),
(253,302,104),
(254,303,105),
(255,303,106),
(256,304,107),
(257,304,108),
(258,305,109),
(259,305,110),
(260,306,111),
(261,306,112),
(262,307,113),
(263,307,114),
(264,308,115),
(265,308,116),
(266,309,117),
(267,309,118),
(268,310,119),
(269,310,120);


INSERT INTO se_kvalificira VALUES
(1201, 101, 1000, '01:01:15', 5),
(1202, 108, 1000, '01:03:30', 5),
(1203, 103, 1000, '01:08:45', 5),
(1204, 105, 1000, '01:10:20', 5),
(1205, 106, 1000, '01:12:40', 5),
(1206, 102, 1000, '01:15:55', 5),
(1207, 104, 1000, '01:20:10', 4),
(1208, 107, 1000, '01:25:25', 4),
(1209, 110, 1000, '01:27:50', 4),
(1210, 109, 1000, '01:30:05', 3),
(1211, 105, 1001, '01:04:30', 5),
(1212, 107, 1001, '01:05:45', 5),
(1213, 109, 1001, '01:08:10', 5),
(1214, 101, 1001, '01:09:25', 5),
(1215, 102, 1001, '01:11:50', 5),
(1216, 104, 1001, '01:14:15', 5),
(1217, 106, 1001, '01:17:40', 5),
(1218, 108, 1001, '01:25:55', 5),
(1219, 103, 1001, '01:29:10', 4),
(1220, 110, 1001, '01:33:25', 4),
(1221, 110, 1002, '01:00:45', 5),
(1222, 102, 1002, '01:04:10', 5),
(1223, 101, 1002, '01:05:35', 5),
(1224, 109, 1002, '01:07:00', 5),
(1225, 107, 1002, '01:11:25', 5),
(1226, 103, 1002, '01:13:50', 5),
(1227, 104, 1002, '01:17:15', 5),
(1228, 105, 1002, '01:19:40', 5),
(1229, 106, 1002, '01:21:05', 4),
(1230, 108, 1002, '01:23:30', 4),
(1231, 105, 1003, '01:05:55', 5),
(1232, 107, 1003, '01:06:20', 5),
(1233, 108, 1003, '01:09:45', 5),
(1234, 102, 1003, '01:12:10', 5),
(1235, 104, 1003, '01:14:35', 5),
(1236, 101, 1003, '01:16:00', 5),
(1237, 109, 1003, '01:19:25', 5),
(1238, 106, 1003, '01:22:50', 5),
(1239, 110, 1003, '01:24:15', 5),
(1240, 103, 1003, '01:26:40', 4),
(1241, 101, 1004, '01:01:15', 5),
(1242, 109, 1004, '01:03:30', 5),
(1243, 107, 1004, '01:08:45', 5),
(1244, 104, 1004, '01:10:20', 5),
(1245, 103, 1004, '01:12:40', 5),
(1246, 110, 1004, '01:15:55', 5),
(1247, 108, 1004, '01:20:10', 4),
(1248, 106, 1004, '01:25:25', 4),
(1249, 105, 1004, '01:27:50', 4),
(1250, 102, 1004, '01:30:05', 3),
(1251, 107, 1005, '01:01:01', 5),
(1252, 103, 1005, '01:02:38', 5),
(1253, 105, 1005, '01:04:12', 5),
(1254, 104, 1005, '01:06:42', 5),
(1255, 109, 1005, '01:10:12', 5),
(1256, 110, 1005, '01:13:55', 5),
(1257, 108, 1005, '01:16:20', 5),
(1258, 102, 1005, '01:20:09', 5),
(1259, 106, 1005, '01:22:10', 4),
(1260, 101, 1005, '01:26:15', 4),
(1261, 105, 1006, '01:05:42', 5),
(1262, 109, 1006, '01:12:25', 5),
(1263, 104, 1006, '01:13:50', 5),
(1264, 102, 1006, '01:17:22', 5),
(1265, 110, 1006, '01:19:15', 5),
(1266, 107, 1006, '01:23:40', 5),
(1267, 106, 1006, '01:27:05', 5),
(1268, 101, 1006, '01:28:30', 5),
(1269, 108, 1006, '01:31:50', 4),
(1270, 103, 1006, '01:34:25', 4),
(1271, 107, 1007, '01:04:10', 5),
(1272, 105, 1007, '01:06:25', 5),
(1273, 108, 1007, '01:11:40', 5),
(1274, 104, 1007, '01:15:00', 5),
(1275, 101, 1007, '01:18:20', 5),
(1276, 110, 1007, '01:20:35', 5),
(1277, 109, 1007, '01:25:50', 5),
(1278, 106, 1007, '01:28:10', 5),
(1279, 103, 1007, '01:30:55', 5),
(1280, 102, 1007, '01:34:30', 4),
(1281, 104, 1008, '01:01:25', 5),
(1282, 109, 1008, '01:04:40', 5),
(1283, 101, 1008, '01:09:55', 5),
(1284, 102, 1008, '01:13:15', 5),
(1285, 107, 1008, '01:16:35', 5),
(1286, 103, 1008, '01:19:50', 5),
(1287, 110, 1008, '01:24:05', 5),
(1288, 108, 1008, '01:26:25', 5),
(1289, 106, 1008, '01:29:40', 5),
(1290, 105, 1008, '01:33:05', 4),
(1291, 108, 1009, '01:01:20', 5),
(1292, 109, 1009, '01:04:35', 5),
(1293, 106, 1009, '01:09:50', 5),
(1294, 102, 1009, '01:13:10', 5),
(1295, 107, 1009, '01:16:30', 5),
(1296, 103, 1009, '01:19:45', 5),
(1297, 110, 1009, '01:24:00', 5),
(1298, 105, 1009, '01:26:20', 5),
(1299, 104, 1009, '01:29:35', 5),
(1300, 101, 1009, '01:33:00', 4);


INSERT INTO vozi_krug VALUES
(1201, 101, 1000, '01:01:15', 5),
(1202, 108, 1000, '01:03:30', 5),
(1203, 103, 1000, '01:08:45', 5),
(1204, 105, 1000, '01:10:20', 5),
(1205, 106, 1000, '01:12:40', 5),
(1206, 102, 1000, '01:15:55', 5),
(1207, 104, 1000, '01:20:10', 4),
(1208, 107, 1000, '01:25:25', 4),
(1209, 110, 1000, '01:27:50', 4),
(1210, 109, 1000, '01:30:05', 3),
(1211, 105, 1001, '01:04:30', 5),
(1212, 107, 1001, '01:05:45', 5),
(1213, 109, 1001, '01:08:10', 5),
(1214, 101, 1001, '01:09:25', 5),
(1215, 102, 1001, '01:11:50', 5),
(1216, 104, 1001, '01:14:15', 5),
(1217, 106, 1001, '01:17:40', 5),
(1218, 108, 1001, '01:25:55', 5),
(1219, 103, 1001, '01:29:10', 4),
(1220, 110, 1001, '01:33:25', 4),
(1221, 110, 1002, '01:00:45', 5),
(1222, 102, 1002, '01:04:10', 5),
(1223, 101, 1002, '01:05:35', 5),
(1224, 109, 1002, '01:07:00', 5),
(1225, 107, 1002, '01:11:25', 5),
(1226, 103, 1002, '01:13:50', 5),
(1227, 104, 1002, '01:17:15', 5),
(1228, 105, 1002, '01:19:40', 5),
(1229, 106, 1002, '01:21:05', 4),
(1230, 108, 1002, '01:23:30', 4),
(1231, 105, 1003, '01:05:55', 5),
(1232, 107, 1003, '01:06:20', 5),
(1233, 108, 1003, '01:09:45', 5),
(1234, 102, 1003, '01:12:10', 5),
(1235, 104, 1003, '01:14:35', 5),
(1236, 101, 1003, '01:16:00', 5),
(1237, 109, 1003, '01:19:25', 5),
(1238, 106, 1003, '01:22:50', 5),
(1239, 110, 1003, '01:24:15', 5),
(1240, 103, 1003, '01:26:40', 4),
(1241, 101, 1004, '01:01:15', 5),
(1242, 109, 1004, '01:03:30', 5),
(1243, 107, 1004, '01:08:45', 5),
(1244, 104, 1004, '01:10:20', 5),
(1245, 103, 1004, '01:12:40', 5),
(1246, 110, 1004, '01:15:55', 5),
(1247, 108, 1004, '01:20:10', 4),
(1248, 106, 1004, '01:25:25', 4),
(1249, 105, 1004, '01:27:50', 4),
(1250, 102, 1004, '01:30:05', 3),
(1251, 107, 1005, '01:01:01', 5),
(1252, 103, 1005, '01:02:38', 5),
(1253, 105, 1005, '01:04:12', 5),
(1254, 104, 1005, '01:06:42', 5),
(1255, 109, 1005, '01:10:12', 5),
(1256, 110, 1005, '01:13:55', 5),
(1257, 108, 1005, '01:16:20', 5),
(1258, 102, 1005, '01:20:09', 5),
(1259, 106, 1005, '01:22:10', 4),
(1260, 101, 1005, '01:26:15', 4),
(1261, 105, 1006, '01:05:42', 5),
(1262, 109, 1006, '01:12:25', 5),
(1263, 104, 1006, '01:13:50', 5),
(1264, 102, 1006, '01:17:22', 5),
(1265, 110, 1006, '01:19:15', 5),
(1266, 107, 1006, '01:23:40', 5),
(1267, 106, 1006, '01:27:05', 5),
(1268, 101, 1006, '01:28:30', 5),
(1269, 108, 1006, '01:31:50', 4),
(1270, 103, 1006, '01:34:25', 4),
(1271, 107, 1007, '01:04:10', 5),
(1272, 105, 1007, '01:06:25', 5),
(1273, 108, 1007, '01:11:40', 5),
(1274, 104, 1007, '01:15:00', 5),
(1275, 101, 1007, '01:18:20', 5),
(1276, 110, 1007, '01:20:35', 5),
(1277, 109, 1007, '01:25:50', 5),
(1278, 106, 1007, '01:28:10', 5),
(1279, 103, 1007, '01:30:55', 5),
(1280, 102, 1007, '01:34:30', 4),
(1281, 104, 1008, '01:01:25', 5),
(1282, 109, 1008, '01:04:40', 5),
(1283, 101, 1008, '01:09:55', 5),
(1284, 102, 1008, '01:13:15', 5),
(1285, 107, 1008, '01:16:35', 5),
(1286, 103, 1008, '01:19:50', 5),
(1287, 110, 1008, '01:24:05', 5),
(1288, 108, 1008, '01:26:25', 5),
(1289, 106, 1008, '01:29:40', 5),
(1290, 105, 1008, '01:33:05', 4),
(1291, 108, 1009, '01:01:20', 5),
(1292, 109, 1009, '01:04:35', 5),
(1293, 106, 1009, '01:09:50', 5),
(1294, 102, 1009, '01:13:10', 5),
(1295, 107, 1009, '01:16:30', 5),
(1296, 103, 1009, '01:19:45', 5),
(1297, 110, 1009, '01:24:00', 5),
(1298, 105, 1009, '01:26:20', 5),
(1299, 104, 1009, '01:29:35', 5),
(1300, 101, 1009, '01:33:00', 4);


-- 1. VIEW ---------------------------------------------------------------------------------------------
-- pruža detaljan pregled vozača u pojedinim utrkama

DROP VIEW IF EXISTS rezultat_vozaca_utrka;

CREATE VIEW rezultat_vozaca_utrka AS
SELECT 
    u.naziv_eventa AS naziv_utrke, 
    CASE 
        WHEN vk.id_utrka BETWEEN 1000 AND 1004 THEN 5000
        WHEN vk.id_utrka BETWEEN 1005 AND 1009 THEN 5001
        ELSE u.id_prvenstvo
    END AS id_prvenstvo, 
    vk.id_utrka AS id_utrka, 
    vk.id_vozac AS id_vozac, 
    v.ime AS ime, 
    v.prezime AS prezime,
    SEC_TO_TIME(SUM(TIME_TO_SEC(vk.vrijeme_kruga))) AS ukupno_vrijeme,
    SUM(vk.broj_kruga) AS ukupno_krugova
FROM vozi_krug vk
JOIN vozac v ON vk.id_vozac = v.id
JOIN utrka u ON vk.id_utrka = u.id
GROUP BY vk.id_vozac, vk.id_utrka
ORDER BY u.broj_utrke, ukupno_vrijeme ASC;

SELECT id_prvenstvo, id_utrka, ime, prezime, ukupno_vrijeme, ukupno_krugova
FROM rezultat_vozaca_utrka
WHERE id_utrka = 1000;

-- 2. VIEW ---------------------------------------------------------------------------------------------
-- omogućava brzo i jednostavno identificiranje najbržih vozača u svakoj utrci

DROP VIEW IF EXISTS najbrzi_vozac_po_utrci;

CREATE VIEW najbrzi_vozac_po_utrci AS
SELECT vk.id_utrka,
       v.ime AS ime_vozaca,
       v.prezime AS prezime_vozaca,
       vk.vrijeme_kruga AS najbrzi_krug,
       u.naziv_eventa AS naziv_utrke
FROM vozi_krug vk
JOIN vozac v ON vk.id_vozac = v.id
JOIN utrka u ON vk.id_utrka = u.id
WHERE vk.vrijeme_kruga = (
    SELECT MIN(vk_inner.vrijeme_kruga)
    FROM vozi_krug vk_inner
    WHERE vk_inner.id_utrka = vk.id_utrka
);

SELECT *
FROM najbrzi_vozac_po_utrci;

-- 3. VIEW ---------------------------------------------------------------------------------------------
-- view za ukupne bodove vozaca u utrkama

DROP VIEW IF EXISTS ukupni_bodovi_vozaca;

CREATE VIEW ukupni_bodovi_vozaca AS
SELECT v.id AS id_vozac, v.ime AS ime_vozaca, v.prezime AS prezime_vozaca, SUM(r.bodovi) AS ukupni_bodovi
FROM vozac v
JOIN rezultat r ON v.id = r.id_vozac
GROUP BY v.id, v.ime, v.prezime
ORDER BY ukupni_bodovi DESC;

SELECT * FROM ukupni_bodovi_vozaca;

-- 4. VIEW ---------------------------------------------------------------------------------------------
-- view za pregled prosjecnog vremena na stazi

DROP VIEW IF EXISTS prosjecno_vrijeme_po_stazi;

CREATE VIEW prosjecno_vrijeme_po_stazi AS
SELECT s.id AS id_staze, s.naziv AS naziv_staze, s.duzina AS duzina_staze,
       SEC_TO_TIME(AVG(TIME_TO_SEC(vk.vrijeme_kruga))) AS prosjecno_vrijeme_kruga
FROM staza s
JOIN utrka u ON s.id = u.id_staza
JOIN vozi_krug vk ON u.id = vk.id_utrka
GROUP BY s.id, s.naziv, s.duzina;

SELECT id_staze, naziv_staze, duzina_staze, prosjecno_vrijeme_kruga
FROM prosjecno_vrijeme_po_stazi;

-- 5.VIEW --------------------------------------------------------------------------------------------------------
-- pruža informacije o najbržim vremenima kruga koje su vozači postigli tijekom kvalifikacija za svaku utrku

DROP VIEW IF EXISTS pogled_pocetnih_pozicija;

CREATE VIEW pogled_pocetnih_pozicija AS
SELECT se_kvalificira.id_utrka, vozac.id AS id_vozac, vozac.ime, vozac.prezime, MIN(se_kvalificira.vrijeme_kruga) AS najkrace_vrijeme
FROM se_kvalificira
JOIN vozac ON se_kvalificira.id_vozac = vozac.id
GROUP BY se_kvalificira.id_utrka, vozac.id, vozac.ime, vozac.prezime
ORDER BY se_kvalificira.id_utrka, MIN(se_kvalificira.vrijeme_kruga);

SELECT * FROM pogled_pocetnih_pozicija WHERE id_utrka = 1000;

-- 1. PROCEDURA ---------------------------------------------------------------------------------------------
-- popunjava tablicu rezultat

DELETE FROM rezultat;

DROP PROCEDURE IF EXISTS popuni_rezultate_za_utrku;

DELIMITER //
CREATE PROCEDURE popuni_rezultate_za_utrku(IN p_id_utrka INTEGER)
BEGIN
    DECLARE p_id_vozac INTEGER;
    DECLARE p_naziv_utrke VARCHAR(255);
    DECLARE p_id_prvenstvo INTEGER;
    DECLARE p_id_utrka_cursor INTEGER;
    DECLARE p_ime VARCHAR(30);
    DECLARE p_prezime VARCHAR(30);
    DECLARE p_ukupno_vrijeme TIME;
    DECLARE p_ukupno_krugova INTEGER;
    DECLARE p_mj INT DEFAULT 0;
    DECLARE kraj INT DEFAULT 0;
    DECLARE p_bodovi INT;
 
	DECLARE cur_rezultati CURSOR FOR
        SELECT naziv_utrke, id_prvenstvo, id_utrka, id_vozac, ime, prezime, ukupno_vrijeme, ukupno_krugova
        FROM rezultat_vozaca_utrka
        WHERE id_utrka = p_id_utrka;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET kraj = 1;

    OPEN cur_rezultati;
    petlja_loop: LOOP
        FETCH cur_rezultati INTO p_naziv_utrke, p_id_prvenstvo, p_id_utrka_cursor, p_id_vozac, p_ime, p_prezime, p_ukupno_vrijeme, p_ukupno_krugova;

        IF kraj THEN
            LEAVE petlja_loop;
        END IF;

        SET p_mj := p_mj + 1;

        SET p_id_prvenstvo = CASE
            WHEN p_id_utrka_cursor BETWEEN 1000 AND 1004 THEN 5000
            WHEN p_id_utrka_cursor BETWEEN 1005 AND 1009 THEN 5001
            ELSE 0 
        END;

        SET p_bodovi = CASE
            WHEN p_mj = 1 THEN 25
            WHEN p_mj = 2 THEN 23
            WHEN p_mj = 3 THEN 20
            WHEN p_mj = 4 THEN 17
            WHEN p_mj = 5 THEN 15
            WHEN p_mj = 6 THEN 12
            WHEN p_mj = 7 THEN 9
            WHEN p_mj = 8 THEN 5
            WHEN p_mj = 9 THEN 1
            ELSE 0
        END;

        INSERT INTO rezultat (id_utrka, id_prvenstvo, id_vozac, mjesto, bodovi, broj_krugova, vrijeme_kruga)
        VALUES (p_id_utrka_cursor, p_id_prvenstvo, p_id_vozac, p_mj, p_bodovi, p_ukupno_krugova, p_ukupno_vrijeme);
	
    END LOOP;

    CLOSE cur_rezultati;
END //
DELIMITER ;

CALL popuni_rezultate_za_utrku(1004);

SELECT 
    DISTINCT r.mjesto,r.id_utrka, r.id_prvenstvo,v.id, v.ime, v.prezime, t.naziv AS 'Naziv Tima', r.bodovi, r.vrijeme_kruga,r.broj_krugova, u.naziv_utrke
FROM rezultat r
JOIN rezultat_vozaca_utrka u ON r.id_utrka = u.id_utrka
JOIN vozac v ON r.id_vozac = v.id
JOIN tim t ON v.tim_id = t.id
WHERE u.id_vozac = r.id_vozac;

-- 2. PROCEDURA ---------------------------------------------------------------------------------------------
-- popunjava tablicu ostvaruje_rezultat

DELETE FROM ostvaruje_rezultat;

DROP PROCEDURE IF EXISTS popuni_ostvaruje_rezultat;

DELIMITER //
CREATE PROCEDURE popuni_ostvaruje_rezultat(IN prvenstvo_id INT)
BEGIN
  DECLARE kraj INT DEFAULT 0;
  DECLARE tim_id INT;
  DECLARE ukupan_broj_bodova INT;
  DECLARE broj_najbrzih_krugova INT;
  DECLARE min_vrijeme_kruga TIME;
  DECLARE postoji_red INT DEFAULT 0;

  DECLARE cur_tim CURSOR FOR
    SELECT id FROM tim;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET kraj = 1;

  OPEN cur_tim;

  petlja_loop: LOOP						
    FETCH cur_tim INTO tim_id;
    IF kraj THEN
      LEAVE petlja_loop;
    END IF;

    SELECT MIN(r.vrijeme_kruga), SUM(r.bodovi), COUNT(r.broj_krugova)
    INTO min_vrijeme_kruga, ukupan_broj_bodova, broj_najbrzih_krugova
    FROM rezultat r
    JOIN vozac v ON r.id_vozac = v.id
    WHERE v.tim_id = tim_id AND r.id_prvenstvo = prvenstvo_id;
    
    SELECT COUNT(*) INTO postoji_red
    FROM ostvaruje_rezultat
    WHERE id_tim = tim_id AND id_prvenstvo = prvenstvo_id;

    IF postoji_red > 0 THEN
	
      UPDATE ostvaruje_rezultat
      SET ukupan_broj_bodova = ukupan_broj_bodova,
          broj_najbrzih_krugova = broj_najbrzih_krugova
      WHERE id_tim = tim_id AND id_prvenstvo = prvenstvo_id;
    ELSE
      
      INSERT INTO ostvaruje_rezultat (id_tim, id_prvenstvo, ukupan_broj_bodova, broj_najbrzih_krugova)
      VALUES (tim_id, prvenstvo_id, ukupan_broj_bodova, broj_najbrzih_krugova);
    END IF;
  END LOOP;

  CLOSE cur_tim;

END //
DELIMITER ;

CALL popuni_ostvaruje_rezultat(5000); 

SELECT tim.naziv, o_r.ukupan_broj_bodova, o_r.broj_najbrzih_krugova, id_prvenstvo
FROM ostvaruje_rezultat o_r
JOIN tim ON o_r.id_tim = tim.id
WHERE o_r.id_prvenstvo = 5000
  AND (o_r.ukupan_broj_bodova IS NOT NULL OR o_r.broj_najbrzih_krugova > 0)
LIMIT 5;

-- 3. PROCEDURA ---------------------------------------------------------------------------------------------
-- provjerava jesu li dobro uneseni bodovi i po maksimum broj bodova odreduje je li sve unešeno ispravno

DROP PROCEDURE IF EXISTS provjeri_unos_rezultata_bodova;

DELIMITER //
CREATE PROCEDURE provjeri_unos_rezultata_bodova(IN p_id_utrka INTEGER)
BEGIN
    DECLARE ukupno_bodova INT;
    DECLARE realisticki_max_bodova INT; 
    DECLARE poruka VARCHAR(255);
    DECLARE naziv_utrke VARCHAR(255);

    SET realisticki_max_bodova = 127;

    SELECT naziv_eventa INTO naziv_utrke FROM utrka WHERE id = p_id_utrka;

    SELECT SUM(bodovi) INTO ukupno_bodova FROM rezultat WHERE id_utrka = p_id_utrka;

    IF ukupno_bodova IS NULL OR ukupno_bodova != realisticki_max_bodova THEN
        SET poruka = CONCAT('Neispravan unos bodova za utrku "', naziv_utrke, '" (ID: ', p_id_utrka, '). Ukupan broj bodova ne odgovara realističnom maksimumu. mozda nije utrka odvozena');
        DELETE FROM rezultat WHERE id_utrka = p_id_utrka;
        CALL popuni_rezultate_za_utrku(p_id_utrka);
    ELSE
        SET poruka = CONCAT('Unos bodova za utrku "', naziv_utrke, '" (ID: ', p_id_utrka, ') je ispravan.');
    END IF;

    SELECT poruka AS Status;
END //
DELIMITER ;

CALL provjeri_unos_rezultata_bodova(1000);

-- 4. PROCEDURA ---------------------------------------------------------------------------------------------
-- ažurira nazive kategorije za stazu po prosječnom vremenu

DROP PROCEDURE IF EXISTS azuriraj_kategoriju_staza;

DELIMITER //
CREATE PROCEDURE azuriraj_kategoriju_staza()
BEGIN
    DECLARE v_id_staze INT;
    DECLARE v_prosjecno_vrijeme TIME;
    DECLARE kraj INT DEFAULT 0;

    DECLARE cur_staze CURSOR FOR
        SELECT s.id AS id_staze, SEC_TO_TIME(AVG(TIME_TO_SEC(vk.vrijeme_kruga))) AS prosjecno_vrijeme_kruga
        FROM staza s
        LEFT JOIN utrka u ON s.id = u.id_staza
        LEFT JOIN vozi_krug vk ON u.id = vk.id_utrka
        GROUP BY s.id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET kraj = 1;

    OPEN cur_staze;

    read_loop: LOOP
        FETCH cur_staze INTO v_id_staze, v_prosjecno_vrijeme;
        IF kraj THEN
            LEAVE read_loop;
        END IF;

        IF v_prosjecno_vrijeme IS NULL THEN
            UPDATE staza SET kategorija = 'Nepoznata' WHERE id = v_id_staze;
        ELSE
            IF v_prosjecno_vrijeme < '01:15:30' THEN
                UPDATE staza SET kategorija = 'Brza' WHERE id = v_id_staze;
            ELSEIF v_prosjecno_vrijeme BETWEEN '01:16:30' AND '01:19:00' THEN
                UPDATE staza SET kategorija = 'Srednja' WHERE id = v_id_staze;
            ELSE
                UPDATE staza SET kategorija = 'Spora' WHERE id = v_id_staze;
            END IF;
        END IF;
    END LOOP;

    CLOSE cur_staze;
END //
DELIMITER ;

CALL azuriraj_kategoriju_staza();

SELECT * FROM staza;

-- 5. PROCEDURA ------------------------------------------------------------------------------------------------
-- dodavanje novih utrka za određenu sezonu

DROP PROCEDURE IF EXISTS planiraj_utrku_za_sezonu;

DELIMITER //
CREATE PROCEDURE planiraj_utrku_za_sezonu(sezonska_godina INT)
BEGIN
    DECLARE p_prvenstvo_id INT;
    DECLARE p_nagrada_id INT; 
    DECLARE p_staza_id INT;
    DECLARE p_naziv_staze VARCHAR(100);
    DECLARE p_broj_utrka INT DEFAULT 0;
    DECLARE p_datum_pocetak DATE;
    DECLARE p_vrijeme TIME;
   
    SELECT COUNT(*) INTO p_broj_utrka FROM utrka WHERE YEAR(datum_pocetak) = sezonska_godina;

    IF p_broj_utrka >= 5 THEN
        SET p_prvenstvo_id = 5001;
    ELSE
        SELECT id INTO p_prvenstvo_id FROM prvenstvo WHERE YEAR(datum_pocetka) = sezonska_godina LIMIT 1;
    END IF;

    SET p_nagrada_id = 201 + MOD(p_broj_utrka, 5);
    SET p_staza_id = 600 + MOD(p_broj_utrka, 23); 

    SELECT naziv INTO p_naziv_staze FROM staza WHERE id = p_staza_id;
  
    SET p_datum_pocetak = ADDDATE('2024-01-01', INTERVAL p_broj_utrka * 14 DAY);

    SET p_vrijeme = ADDTIME('12:00:00', SEC_TO_TIME(FLOOR(RAND() * (6 * 3600) / 300) * 300));
    
    INSERT INTO utrka (id_prvenstvo, id_staza, id_nagrada, naziv_eventa, broj_utrke, datum_pocetak, datum_kraj, vrijeme)
    VALUES (p_prvenstvo_id, p_staza_id, p_nagrada_id, CONCAT( UPPER(p_naziv_staze)), CONCAT(sezonska_godina, '-01'), p_datum_pocetak, ADDDATE(p_datum_pocetak, INTERVAL 2 DAY), p_vrijeme);
END //

DELIMITER ;

CALL planiraj_utrku_za_sezonu(2024);

SELECT * FROM utrka;

DELETE FROM utrka;

-- 6. PROCEDURA ------------------------------------------------------------------------------------------------
-- procedura za azuriranje bodova prvenstva za prvo i zadnje mjesto

DROP PROCEDURE IF EXISTS  azuriraj_bodove_prvenstva;

DELIMITER //
CREATE PROCEDURE azuriraj_bodove_prvenstva(IN id_prvenstvo_param INTEGER)
BEGIN
  
    UPDATE rezultat
    SET bodovi = bodovi + 2
    WHERE id_prvenstvo = id_prvenstvo_param AND mjesto = 1;

    SET @max_mjesto = (SELECT MAX(mjesto) FROM rezultat WHERE id_prvenstvo = id_prvenstvo_param);

    UPDATE rezultat
    SET bodovi = bodovi - 1
    WHERE id_prvenstvo = id_prvenstvo_param AND mjesto = @max_mjesto;
END //
DELIMITER ;

CALL azuriraj_bodove_prvenstva(5000);

SELECT * FROM rezultat;

-- 7. PROCEDURA --------------------------------------------------------------------------------------------
-- procedura koja ažurira motore za automobile

DROP PROCEDURE IF EXISTS azuriraj_motor_u_automobilu;

DELIMITER //
CREATE PROCEDURE azuriraj_motor_u_automobilu(IN automobil_id INT, IN novi_model_motor VARCHAR(50), IN nova_tip_oznake_motor VARCHAR(50))
BEGIN

    DECLARE automobil_postoji INT;
    DECLARE motor_id INT;
    
    SELECT COUNT(*) INTO automobil_postoji
    FROM automobil
    WHERE id = automobil_id;
        
    SELECT id INTO motor_id
    FROM motor
    WHERE id_automobil = automobil_id;
    
    IF automobil_postoji = 1 AND motor_id IS NOT NULL THEN
        
        UPDATE motor
        SET model = novi_model_motor, tip_oznake = nova_tip_oznake_motor
        WHERE id = motor_id;
        
        SELECT 'Motor uspješno ažuriran.' AS Poruka;
    ELSE
        SELECT 'Automobil ili motor nije pronađen.' AS Poruka;
    END IF;
END //
DELIMITER ;

CALL azuriraj_motor_u_automobilu(302, 'Honda', 'G22');

SELECT a.model AS naziv_bolida, m.*
FROM motor m
JOIN automobil a ON m.id_automobil = a.id;

DELETE FROM motor WHERE id_automobil=302;

-- 8. PROCEDURA ---------------------------------------------------------------------------------------
-- postavljanje aktivnosti tima pregledom u tablici ostvaruje_rezultat

DROP PROCEDURE IF EXISTS promijeni_aktivnost_timova;

DELIMITER //
CREATE PROCEDURE promijeni_aktivnost_timova()
BEGIN
    UPDATE tim AS t
    LEFT JOIN (
        SELECT DISTINCT id_tim
        FROM ostvaruje_rezultat
        WHERE ukupan_broj_bodova IS NOT NULL) AS o ON t.id = o.id_tim
		SET t.aktivnost = IF(o.id_tim IS NOT NULL, 'DA', 'NE');
    SELECT 'Status timova uspješno postavljen.' AS Poruka;
END //
DELIMITER ;

CALL promijeni_aktivnost_timova(); 

SELECT id, naziv, aktivnost FROM tim;

-- 9. PROCEDURE -----------------------------------------------------------------------------------------------------------
-- procedura ocijenjuje učinkovitost trenera u timu

DROP PROCEDURE IF EXISTS ocijeni_ucinkovitost_trenera;

DELIMITER //
CREATE PROCEDURE ocijeni_ucinkovitost_trenera()
BEGIN
    
    DROP TEMPORARY TABLE IF EXISTS trener_rezultati;
    CREATE TEMPORARY TABLE trener_rezultati (
        trener_id INT,
        tim_id INT,
        naziv_tima VARCHAR(100),
        ukupni_bodovi INT
    );

    INSERT INTO trener_rezultati (trener_id, tim_id, naziv_tima, ukupni_bodovi)
    SELECT t.id, tm.id, tm.naziv, SUM(r.bodovi)
    FROM trener t
    JOIN tim tm ON t.id_tim = tm.id
    JOIN vozac v ON v.tim_id = tm.id
    JOIN rezultat r ON r.id_vozac = v.id
    GROUP BY t.id, tm.id;

    UPDATE trener t
    INNER JOIN trener_rezultati tr ON t.id = tr.trener_id
    SET t.ucinkovitost = CASE
        WHEN tr.ukupni_bodovi > 100 THEN 'Visoka'
        WHEN tr.ukupni_bodovi BETWEEN 50 AND 75 THEN 'Srednja'
        ELSE 'Niska'
    END;

END //

DELIMITER ;

CALL ocijeni_ucinkovitost_trenera();

SELECT * FROM trener;

-- 10. PROCEDURE -------------------------------------------------------------------------------------------
-- procedura koja unosi status osvojene ili ne osvojene nagrade

DROP PROCEDURE IF EXISTS status_nagrada;

DELIMITER //
CREATE PROCEDURE status_nagrada (IN prvenstvo_id INT)
BEGIN
    DECLARE p_id_tima INT;
    DECLARE kraj INT DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR
        SELECT t.id
        FROM tim t
        WHERE NOT EXISTS (
            SELECT 1
            FROM rezultat r
            JOIN utrka u ON r.id_utrka = u.id
            JOIN vozac v ON r.id_vozac = v.id
            WHERE u.id_prvenstvo = prvenstvo_id AND r.mjesto IN (1, 2, 3) AND v.tim_id = t.id
        );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET kraj = TRUE;

    UPDATE tim SET status_nagrada = TRUE;

    OPEN cur;

    petlja_loop: LOOP
        FETCH cur INTO p_id_tima;
        IF kraj THEN
            LEAVE petlja_loop;
        END IF;

        UPDATE tim SET status_nagrada = FALSE WHERE id = p_id_tima;

        UPDATE prvenstvo
        SET timovi_bez_nagrada = CONCAT(IFNULL(timovi_bez_nagrada, ''), p_id_tima, ',')
        WHERE id = prvenstvo_id;
    END LOOP;

    CLOSE cur;
    
    SELECT naziv, 
           CASE 
               WHEN status_nagrada THEN 'Osvojio' 
               ELSE 'Nije osvojio' 
           END AS status_nagrada
    FROM tim;
END //
DELIMITER ;

CALL status_nagrada(5000);

SELECT id, naziv, broj_timova, timovi_bez_nagrada
FROM prvenstvo;

-- 11. PROCEDURA ---------------------------------------------------------------------------------------------------------
-- procedura koja odreduje bonuse i kazne za tim

DROP PROCEDURE IF EXISTS tim_bonusi_i_kazne;

DELIMITER //
CREATE PROCEDURE tim_bonusi_i_kazne(IN prvenstvo_id INT)
BEGIN
    DECLARE t_id INT;
    DECLARE t_bodovi INT;
    DECLARE kraj INT DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR
    
        SELECT t.id, SUM(r.bodovi) AS ukupni_bodovi
        FROM tim t
        JOIN vozac v ON t.id = v.tim_id
        JOIN rezultat r ON v.id = r.id_vozac
        JOIN utrka u ON r.id_utrka = u.id
        WHERE u.id_prvenstvo = prvenstvo_id
        GROUP BY t.id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET kraj = TRUE;

    UPDATE tim SET bonus = 0, kazna = 0;

    OPEN cur;

    tim_loop: LOOP
        FETCH cur INTO t_id, t_bodovi;
        IF kraj THEN
            LEAVE tim_loop;
        END IF;

        IF t_bodovi > 35 THEN
            UPDATE tim SET bonus = 20000 WHERE id = t_id;
        ELSEIF t_bodovi < 30 THEN
            UPDATE tim SET kazna = 10000 WHERE id = t_id;
        END IF;
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

CALL tim_bonusi_i_kazne(5000);

SELECT t.naziv, t.bonus, t.kazna, o_s.ukupan_broj_bodova
FROM tim t
JOIN ostvaruje_rezultat o_s ON t.id = o_s.id_tim;

-- 12. PROCEDURA --------------------------------------------------------------------------------------------------------
-- procedura koja izracunava prosjek bodova za tim

DROP PROCEDURE IF EXISTS prosjek_bodova;

DELIMITER //
CREATE PROCEDURE prosjek_bodova()
BEGIN
    IF NOT EXISTS (
        SELECT *
        FROM information_schema.COLUMNS
        WHERE
            TABLE_SCHEMA = 'automobilizam' AND
            TABLE_NAME = 'tim' AND
            COLUMN_NAME = 'prosjek_bodova'
    )
    THEN
        ALTER TABLE tim ADD COLUMN prosjek_bodova DECIMAL(10, 2) DEFAULT 0;
    END IF;

    UPDATE tim t
    SET t.prosjek_bodova = (
        SELECT AVG(r.bodovi)
        FROM rezultat r
        JOIN vozac v ON r.id_vozac = v.id
        WHERE v.tim_id = t.id
        GROUP BY v.tim_id
    );
END //
DELIMITER ;

CALL prosjek_bodova();

SELECT naziv, prosjek_bodova
FROM tim;

-- 1. OKIDAC ------------------------------------------------------------------------------------------------
-- okidac koji ne dopusta da se unese manji datum kraja utrke od datuma pocetka 

DROP TRIGGER IF EXISTS datum_utrke;

DELIMITER //
CREATE TRIGGER datum_utrke
BEFORE UPDATE ON utrka
FOR EACH ROW
BEGIN
  DECLARE datum_pocetak_validan BOOLEAN;
  DECLARE datum_kraj_validan BOOLEAN;

  SET datum_pocetak_validan = NEW.datum_pocetak <= NEW.datum_kraj;
  SET datum_kraj_validan = NEW.datum_kraj >= NEW.datum_pocetak;
 
  IF NOT datum_pocetak_validan OR NOT datum_kraj_validan THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Nevaljani datumi: datum_pocetak mora biti manji ili jednak datum_kraj.';
  END IF;
END;
//
DELIMITER ;

INSERT INTO utrka (id,id_prvenstvo, id_staza, id_nagrada, naziv_eventa, broj_utrke, datum_pocetak, datum_kraj, vrijeme, temperatura)
VALUES (125, 5000, 600, 201, 'GULF AIR BAHRAIN GRAND PRIX', '1-2023', STR_TO_DATE('2023-12-01', '%Y-%m-%d'), STR_TO_DATE('2023-12-02', '%Y-%m-%d'), '15:00:00', 25);

UPDATE utrka
SET datum_pocetak = '2023-12-03', datum_kraj = '2023-12-02'
WHERE id = 125;

DELETE FROM utrka WHERE id = 125;

-- 2. OKIDAC ------------------------------------------------------------------------------------------------
-- okidac za provjeru dobne granice mehanicara (vise od 18 i manje od 35)

DROP TRIGGER IF EXISTS provjera_godina_mehanicara;

DELIMITER //
CREATE TRIGGER provjera_godina_mehanicara
BEFORE INSERT ON mehanicar
FOR EACH ROW
BEGIN
    DECLARE trenutni_datum INT;
    DECLARE godina_rod INT;

    SET trenutni_datum = YEAR(CURDATE());
    SET godina_rod = YEAR(NEW.datum_rodenja);

    IF trenutni_datum - godina_rod < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mehanicar mora biti stariji od 18 godina.';
    ELSEIF trenutni_datum - godina_rod > 35 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mehanicar stariji od 35 godina ne moze biti dodan.';
    END IF;
END;
//
DELIMITER ;

INSERT INTO mehanicar (id, ime, prezime, datum_rodenja) VALUES (1, 'Ivan', 'Ivić', STR_TO_DATE('2010-01-01', '%Y-%m-%d'));

INSERT INTO mehanicar (id, ime, prezime, datum_rodenja) VALUES (2, 'Marko', 'Markić', STR_TO_DATE('1980-01-01','%Y-%m-%d') );

INSERT INTO mehanicar (id, ime, prezime, datum_rodenja) VALUES (3, 'Ana', 'Anić', STR_TO_DATE('1990-01-01','%Y-%m-%d'));

SELECT * FROM mehanicar;

DELETE FROM mehanicar WHERE id=3;

-- 3. OKIDAC ------------------------------------------------------------------------------------------------
-- okidac za azuriranje brzine automobila pri promjeni motora

DROP TRIGGER IF EXISTS azuriraj_maksimalnu_brzinu;

DELIMITER //
CREATE TRIGGER azuriraj_maksimalnu_brzinu
AFTER UPDATE ON motor
FOR EACH ROW
BEGIN
    IF NEW.tip_oznake = 'Turbo' AND OLD.tip_oznake <> 'Turbo' THEN
        UPDATE automobil
        SET maksimalna_brzina = maksimalna_brzina + 20
        WHERE id = NEW.id_automobil;
    ELSEIF NEW.tip_oznake <> 'Turbo' AND OLD.tip_oznake = 'Turbo' THEN
        UPDATE automobil
        SET maksimalna_brzina = GREATEST(maksimalna_brzina - 20, 0)
        WHERE id = NEW.id_automobil;
    END IF;
END;
//
DELIMITER ;

INSERT INTO automobil (id, id_tim, model, drzava, boja, gume, godina_proizvodnje, maksimalna_brzina)
VALUES (1, 1, 'ATD1F2', 'Hrvatska', 'Crvena', 'Pirelli', STR_TO_DATE('2020-01-01', '%Y-%m-%d'), 200);

INSERT INTO motor (id, id_automobil, model, tip_oznake)
VALUES (1, 1, 'V12', 'Standard');

SELECT id, maksimalna_brzina FROM automobil WHERE id = 1;

UPDATE motor SET tip_oznake = 'Turbo' WHERE id = 1;

SELECT id, maksimalna_brzina FROM automobil WHERE id = 1;

SELECT * FROM automobil;

DELETE FROM motor WHERE id = 1;
DELETE FROM automobil WHERE id = 1;

-- 4. OKIDAC ----------------------------------------------------------------------------------------------
-- okidac za provjeru maksimalne brzine koja ne smije prelaziti 350 km/h

DROP TRIGGER IF EXISTS provjera_maksimalne_brzine;

DELIMITER //
CREATE TRIGGER provjera_maksimalne_brzine
BEFORE INSERT ON automobil
FOR EACH ROW
BEGIN
    IF NEW.maksimalna_brzina > 350 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Maksimalna brzina automobila ne smije prelaziti 350 km/h.';
    END IF;
END;
//
DELIMITER ;

INSERT INTO automobil (id, id_tim, model, drzava, boja, gume, godina_proizvodnje, maksimalna_brzina) 
VALUES (1, 1, 'ModelX', 'Hrvatska', 'Crvena', 'Pirelli', 2020, 340);

INSERT INTO automobil (id, id_tim, model, drzava, boja, gume, godina_proizvodnje, maksimalna_brzina) 
VALUES (2, 1, 'ModelY', 'Hrvatska', 'Plava', 'Pirelli', 2021, 360);

DELETE FROM automobil WHERE id = 1;

-- 5. OKIDAC -------------------------------------------------------------------------------------------------
-- okidac provjerava dostupnost automobila za utrku

DROP TRIGGER IF EXISTS provjera_dostupnosti_automobila;

DELIMITER //
CREATE TRIGGER provjera_dostupnosti_automobila
BEFORE INSERT ON vozi_krug
FOR EACH ROW
BEGIN
    DECLARE automobil_dostupan INT;

    SELECT COUNT(*) INTO automobil_dostupan
    FROM vozacev_automobil
    WHERE id_vozac = NEW.id_vozac;

    IF automobil_dostupan = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Automobil nije dostupan za utrku.';
    END IF;
END;
//
DELIMITER ;

INSERT INTO vozi_krug (id_vozac, id_utrka, vrijeme_kruga, broj_kruga) 
VALUES (999, 1000, '01:02:00', 1);

INSERT INTO vozi_krug (id, id_vozac, id_utrka, vrijeme_kruga, broj_kruga) 
VALUES (1, 101, 1000, '01:01:15', 1);

SELECT *
FROM vozi_krug;

DELETE FROM vozi_krug WHERE id = 1;

-- 6. OKIDAC -----------------------------------------------------------------------------------------------
-- okidac azurira broj pobjeda u timu

DROP TRIGGER IF EXISTS azuriraj_broj_pobjeda_tima;

DELIMITER //
CREATE TRIGGER azuriraj_broj_pobjeda_tima
AFTER INSERT ON rezultat
FOR EACH ROW
BEGIN
    IF NEW.mjesto = 1 THEN
        UPDATE tim
        SET broj_pobjeda = broj_pobjeda + 1
        WHERE id = (SELECT tim_id FROM vozac WHERE id = NEW.id_vozac);
    END IF;
END//
DELIMITER ;

SELECT * FROM tim;
SELECT * FROM vozac;

INSERT INTO rezultat (id_utrka, id_prvenstvo, id_vozac, mjesto, bodovi, broj_krugova, vrijeme_kruga) VALUES (1000, 5000, 101, 1, 25, 5, '01:01:15');
INSERT INTO rezultat (id_utrka, id_prvenstvo, id_vozac, mjesto, bodovi, broj_krugova, vrijeme_kruga) VALUES (1000, 5000, 102, 1, 25, 5, '01:01:15');

SELECT * FROM tim WHERE id = 1;

-- 7. OKIDAC --------------------------------------------------------------------
-- osigurava da se u tablicu vozac ne mogu unijeti podaci o vozačima koji su mlađi od 18 godina

DROP TRIGGER IF EXISTS provjera_dobne_granice_vozaca;

DELIMITER //
CREATE TRIGGER provjera_dobne_granice_vozaca
BEFORE INSERT ON vozac
FOR EACH ROW
BEGIN
    IF YEAR(CURDATE()) - YEAR(NEW.datum_rodenja) < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vozač mora biti stariji od 18 godina.';
    END IF;
END//
DELIMITER ;

INSERT INTO vozac (id, tim_id, ime, prezime, drzava, datum_rodenja) VALUES (121, 1, 'Patrik', 'Fabijanić', 'Hrvatska', STR_TO_DATE('2009-07-19', '%Y-%m-%d'));

-- 8. OKIDAC ----------------------------------------------------------------------
-- osigurava da se nazivi timova u tablici tim ne mogu mijenjati nakon što su jednom postavljeni

DROP TRIGGER IF EXISTS zabrana_promjene_imena_tima;

DELIMITER //
CREATE TRIGGER zabrana_promjene_imena_tima
BEFORE UPDATE ON tim
FOR EACH ROW
BEGIN
    IF OLD.naziv <> NEW.naziv THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Promjena imena tima nije dozvoljena.';
    END IF;
END//
DELIMITER ;

SELECT * FROM tim;

UPDATE tim
SET naziv = 'Tramontana F1'
WHERE id = 3;

-- 9. OKIDAC -------------------------------------------------------------------------
-- automatski ažurira status automobila nakon svake utrke

DROP TRIGGER IF EXISTS azuriraj_status_automobila_poslije_utrke;

DELIMITER //
CREATE TRIGGER azuriraj_status_automobila_poslije_utrke
AFTER INSERT ON rezultat
FOR EACH ROW
BEGIN
    IF NEW.mjesto = 10 THEN 
        UPDATE automobil
        SET status = 'Potrebno servisiranje'
        WHERE id = (SELECT id_automobil FROM vozacev_automobil WHERE id_vozac = NEW.id_vozac);
    ELSE
        UPDATE automobil
        SET status = 'Ispravan'
        WHERE id = (SELECT id_automobil FROM vozacev_automobil WHERE id_vozac = NEW.id_vozac);
    END IF;
END//
DELIMITER ;

INSERT INTO rezultat (id_utrka, id_prvenstvo, id_vozac, mjesto, bodovi, broj_krugova, vrijeme_kruga)
VALUES (1000, 5000, 101, 10, 1, 1, '02:00:00'); 

SELECT id, model, status FROM automobil WHERE id = 301;

-- 10. OKIDAC -------------------------------------------------------------------------------------------------
-- automatski povećava iznos nagrada za 20% ako su manje od 500,000, i sprječava povećanje ako premašuju 750,000

DROP TRIGGER IF EXISTS povecanje_nagrade;

DELIMITER //
CREATE TRIGGER povecanje_nagrade
BEFORE UPDATE ON nagrada
FOR EACH ROW
BEGIN
    IF NEW.iznos <= 500000 THEN
        SET NEW.iznos = NEW.iznos * 1.20;
    ELSEIF NEW.iznos > 750000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nagrada je prevelika, nema povećanja.';
    END IF;
END//
DELIMITER ;

INSERT INTO nagrada (id, naziv, oblik, iznos) VALUES (1, 'Granslam', 'Medalja', 400000);
UPDATE nagrada SET iznos = iznos WHERE id = 1;

INSERT INTO nagrada (id, naziv, oblik, iznos) VALUES (3, 'Intruder', 'Plaketa', 800000);
UPDATE nagrada SET iznos = iznos WHERE id = 3; 

SELECT * FROM nagrada;

DELETE FROM nagrada WHERE id=1;
-- 1. FUNKCIJA --------------------------------------------------------------------------------------------------
-- funckija vraca najboljeg vozaca u timu u 2023. sezoni

DROP FUNCTION IF EXISTS najbolji_vozac_tima;

DELIMITER //
CREATE FUNCTION najbolji_vozac_tima(timID INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE najbolji_vozac VARCHAR(100);
    DECLARE sezona YEAR DEFAULT 2023;

    SELECT CONCAT(v.ime, ' ', v.prezime) INTO najbolji_vozac
    FROM vozac v
    JOIN rezultat r ON v.id = r.id_vozac
    JOIN utrka u ON r.id_utrka = u.id
    WHERE v.tim_id = timID AND YEAR(u.datum_pocetak) = sezona
    GROUP BY v.id
    ORDER BY SUM(r.bodovi) DESC
    LIMIT 1;

    RETURN najbolji_vozac;
END //
DELIMITER ;

SELECT najbolji_vozac_tima(1) AS najbolji_vozac;

-- 2. FUNKCIJA -----------------------------------------------------------------------------------------------------------------
-- funkcija koja vraca stabilnost automobila po njegovoj brzini

DROP FUNCTION IF EXISTS ocjena_brzine_automobila;

DELIMITER //
CREATE FUNCTION ocjena_brzine_automobila(p_id_automobil INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE ocjena VARCHAR(255);

    SELECT CASE
        WHEN a.maksimalna_brzina <= 320 THEN 'Stabilno'
        WHEN a.maksimalna_brzina > 320 AND a.maksimalna_brzina <= 350 THEN 'Nestabilno'
        ELSE 'Nepoznato'
    END INTO ocjena
    FROM automobil a
    WHERE a.id = p_id_automobil
    LIMIT 1;

    RETURN ocjena;
END //
DELIMITER ;

SELECT a.*, ocjena_brzine_automobila(a.id) AS ocjena_brzine
FROM automobil a
WHERE a.id = 302;
 
-- 3. FUNKCIJA --------------------------------------------------------
-- funkcija koja racuna prosjecnu starost mehaničara u timu

DROP FUNCTION IF EXISTS prosjecna_starost_mehanicara_u_timu;

DELIMITER //
CREATE FUNCTION prosjecna_starost_mehanicara_u_timu(p_tim_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE prosjecna_starost DECIMAL(10,2);
  SELECT AVG(YEAR(NOW()) - YEAR(datum_rodenja)) INTO prosjecna_starost
  FROM mehanicar
  WHERE id IN (SELECT id_mehanicar FROM timski_mehanicar WHERE id_tim = p_tim_id);                      
  RETURN prosjecna_starost;
END //
DELIMITER ;

SELECT prosjecna_starost_mehanicara_u_timu(1);

-- 4. FUNKCIJA --------------------------------------------------------------------
-- funkcija koja pretvara kmh u mph

DROP FUNCTION IF EXISTS maksimalna_brzina_u_mph;

DELIMITER //
CREATE FUNCTION maksimalna_brzina_u_mph(p_id_automobil INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE kmh DECIMAL(10, 2);
    SELECT maksimalna_brzina INTO kmh FROM automobil WHERE id = p_id_automobil;
    
    RETURN kmh * 0.621371;
END //
DELIMITER ;

SELECT maksimalna_brzina_u_mph(id) FROM automobil WHERE id = 302;

-- 5. FUNKCIJA ----------------------------------------------------------------------
-- vraca broj ucestvovanja vozaca na odvozenim utrkama

DROP FUNCTION IF EXISTS broj_trka_vozaca;

DELIMITER //
CREATE FUNCTION broj_trka_vozaca(p_id_vozac INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_trka INT;
    SELECT COUNT(*) INTO broj_trka FROM rezultat
    WHERE id_vozac = p_id_vozac;
    
    RETURN broj_trka;
END //
DELIMITER ;

SELECT broj_trka_vozaca(101);

-- 6. FUNKCIJA -------------------------------------------------------------------------
-- funkcija vraca najcescu boju automobila koja je sudjelovala na odvozenim utrkama 

DROP FUNCTION IF EXISTS najcesca_boja_automobila;

DELIMITER //

CREATE FUNCTION najcesca_boja_automobila() RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE boja VARCHAR(30);

    SELECT automobil.boja INTO boja
    FROM automobil
    JOIN vozac ON automobil.id_tim = vozac.tim_id
    JOIN rezultat ON vozac.id = rezultat.id_vozac
    GROUP BY automobil.boja
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    RETURN boja;
END //
DELIMITER ;

SELECT najcesca_boja_automobila();

-- 7. FUNKCIJA ----------------------------------------------------------------------------------------
-- funkcija vraca kontinent sponzora

DROP FUNCTION IF EXISTS kontinent_sponzora;

DELIMITER //
CREATE FUNCTION kontinent_sponzora(p_id_sponzor INT) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE kontinent VARCHAR(50);
    DECLARE drzava_sponzora VARCHAR(50);

    SELECT drzava INTO drzava_sponzora FROM sponzor WHERE id = p_id_sponzor;

        IF drzava_sponzora IN ('Sjedinjene Američke Države', 'Kanada', 'Meksiko') THEN
            SET kontinent = 'Amerika';
        ELSEIF drzava_sponzora IN ('Njemačka', 'Francuska', 'Italija', 'Španjolska', 'Velika Britanija','Švedska','Švicarska') THEN
            SET kontinent = 'Europa';
        ELSE
            SET kontinent = 'Drugi kontinent';
    END IF;
    RETURN kontinent;
END //
DELIMITER ;

SELECT s.naziv AS NazivSponzora, t.naziv AS NazivTima, kontinent_sponzora(ts.id_sponzor) AS KontinentSponzora
FROM timski_sponzor ts 
JOIN sponzor s ON ts.id_sponzor = s.id
JOIN tim t ON ts.id_tim = t.id
WHERE ts.id = 8004;

-- 8. FUNKCIJA ------------------------------------------------------------------------------------------
-- funkcija koja za sve automobile ispod 2021. godine vraca da su prosla generacija, a iznad vraca da su novija generacija

DROP FUNCTION IF EXISTS generacija_automobila;

DELIMITER //
CREATE FUNCTION generacija_automobila(p_id_automobil INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE generacija VARCHAR(100);
    DECLARE godina_proizvodnje_p YEAR;
    DECLARE naziv_modela VARCHAR(50);

    SELECT godina_proizvodnje, model INTO godina_proizvodnje_p, naziv_modela 
    FROM automobil 
    WHERE id = p_id_automobil;

    IF godina_proizvodnje_p < 2021 THEN
        SET generacija = CONCAT(naziv_modela, ' (', godina_proizvodnje_p, ') - Automobil je prošle generacije');
    ELSE
        SET generacija = CONCAT(naziv_modela, ' (', godina_proizvodnje_p, ') - Automobil je novije generacije');
    END IF;
    RETURN generacija;
END //
DELIMITER ;

SELECT generacija_automobila(302); 

-- 9. FUNKCIJA ------------------------------------------------------------------------------------------
-- funkcija koja vraca dobre i lose vremenske uvjete za voznju na utrkama

DROP FUNCTION IF EXISTS uvjeti_za_voznju;

DELIMITER //
CREATE FUNCTION uvjeti_za_voznju(p_id_utrka INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE temperatura INT;
    DECLARE vrijeme TIME;
    DECLARE naziv_staze VARCHAR(100);
    DECLARE rezultat_p VARCHAR(255);

    SELECT utrka.temperatura, utrka.vrijeme, staza.naziv INTO temperatura, vrijeme, naziv_staze
    FROM utrka
    JOIN staza ON utrka.id_staza = staza.id
    WHERE utrka.id = p_id_utrka;

    IF temperatura BETWEEN 15 AND 25 AND HOUR(vrijeme) BETWEEN 7 AND 19 THEN
        SET rezultat_p = CONCAT('Dobri uvjeti za vožnju na stazi ', naziv_staze, ' pri ', temperatura, ' °C i vremenu ', TIME_FORMAT(vrijeme, '%H:%i'));
    ELSE
        SET rezultat_p = CONCAT('Loši uvjeti za vožnju na stazi ', naziv_staze, ' pri ', temperatura, ' °C i vremenu ', TIME_FORMAT(vrijeme, '%H:%i'));
    END IF;

    RETURN rezultat_p;
END //
DELIMITER ;

SELECT uvjeti_za_voznju(1001); 

-- 10. FUNKCIJA----------------------------------------------------------------------------------------------
-- izračunava broj sponzorskih ugovora za odredenog vozaca

DROP FUNCTION IF EXISTS broj_sponzorskih_ugovora_vozaca;

DELIMITER //
CREATE FUNCTION broj_sponzorskih_ugovora_vozaca(p_id_vozac INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_ugovora INT;
    SELECT COUNT(*) INTO broj_ugovora FROM timski_sponzor
    WHERE id_tim = (SELECT tim_id FROM vozac WHERE id = p_id_vozac);
    RETURN broj_ugovora;
END //
DELIMITER ;

SELECT broj_sponzorskih_ugovora_vozaca(101);

-- 11. FUNKCIJA---------------------------------------------------------
-- funkcija koja vraca domace staze timova

DROP FUNCTION IF EXISTS domace_staze_tima;

DELIMITER //
CREATE FUNCTION domace_staze_tima(p_id_tim INT) RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE rezultat TEXT DEFAULT '';
    DECLARE drzava_tima VARCHAR(50);
    DECLARE cur_naziv VARCHAR(100);
    DECLARE kraj INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR 
        SELECT s.naziv 
        FROM staza s
        JOIN tim t ON s.drzava = t.drzava
        WHERE t.id = p_id_tim;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET kraj = TRUE;

    SELECT drzava INTO drzava_tima FROM tim WHERE id = p_id_tim;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cur_naziv;
        IF kraj THEN
            LEAVE read_loop;
        END IF;
        SET rezultat = CONCAT(rezultat, cur_naziv, ', ');
    END LOOP;
    CLOSE cur;

    IF LENGTH(rezultat) = 0 THEN
        SET rezultat = 'Nema domaćih staza';
    END IF;

    RETURN rezultat;
END //
DELIMITER ;

SELECT domace_staze_tima(10);

-- 1. TRANSAKCIJA ------------------------------------------------------------------------------------
-- provjerava postojanje odredenog tima i sponzora, te ako oba postoje, dodaje sponzora tom timu

DROP PROCEDURE IF EXISTS dodaj_sponzora_timu;

DELIMITER //
CREATE PROCEDURE dodaj_sponzora_timu(IN p_tim_id INT, IN p_sponzor_id INT)
BEGIN
    DECLARE postoji_tim INT;
    DECLARE postoji_sponzor INT;
   
    START TRANSACTION;
   
    SELECT COUNT(*) INTO postoji_tim FROM tim WHERE id = p_tim_id;
   
    SELECT COUNT(*) INTO postoji_sponzor FROM sponzor WHERE id = p_sponzor_id;
   
    IF postoji_tim = 0 OR postoji_sponzor = 0 THEN
        ROLLBACK;
        SELECT 'Tim ili sponzor ne postoji.' AS status;
    ELSE
    
        INSERT INTO timski_sponzor (id_tim, id_sponzor) VALUES (p_tim_id, p_sponzor_id);
        COMMIT;
        SELECT 'Sponzor dodan timu.' AS status;
    END IF;
   
END //
DELIMITER ;

CALL dodaj_sponzora_timu(2, 9001);

SELECT * FROM timski_sponzor WHERE id_tim = 2 AND id_sponzor = 9001;

-- 2. TRANSAKCIJA ------------------------------------------------------------------------------------
-- brise sve automobile iz baze podataka koji nemaju Mercedes motor

DROP PROCEDURE IF EXISTS brise_automobile_koji_nisu_mercedes;

DELIMITER //
CREATE PROCEDURE brise_automobile_koji_nisu_mercedes()
BEGIN
    DECLARE zavrsi INT DEFAULT 0;
    DECLARE automobil_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM automobil WHERE id NOT IN (SELECT id_automobil FROM motor WHERE model = 'Mercedes');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET zavrsi = 1;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;

    OPEN cur;

    obrisi_automobile: LOOP
        FETCH cur INTO automobil_id;
        IF zavrsi = 1 THEN
            LEAVE obrisi_automobile;
        END IF;

        DELETE FROM vozacev_automobil WHERE id_automobil = automobil_id;
        DELETE FROM automobil_kod_mehanicara WHERE id_automobil = automobil_id;
        DELETE FROM motor WHERE id_automobil = automobil_id;
       
        DELETE FROM automobil WHERE id = automobil_id;

    END LOOP obrisi_automobile;

    CLOSE cur;

    COMMIT;
END //
DELIMITER ;

CALL brise_automobile_koji_nisu_mercedes();

SELECT * FROM automobil;

-- 3. TRANSAKCIJA ---------------------------------------------------------------------------------------------------------------------
-- provjerava postoji li veza izmedu tima i sponzora, te ako postoji, dodaje novo vozilo u bazu podataka

DROP PROCEDURE IF EXISTS dodaj_novo_vozilo;

DELIMITER //
CREATE PROCEDURE dodaj_novo_vozilo(
    IN tim_id INT,
    IN sponzor_id INT,
    IN model_vozila VARCHAR(50),
    IN boja_vozila VARCHAR(30),
    IN drzava_Vozila VARCHAR(50),
    IN gume_vozila VARCHAR(30),
    IN godina_proizvodnje INT,
    IN maksimalna_brzina INT
)
BEGIN
    DECLARE postoji_sponzor_timu INT;

    START TRANSACTION;
   
    SELECT COUNT(*) INTO postoji_sponzor_timu
    FROM timski_sponzor
    WHERE id_tim = tim_id AND id_sponzor = sponzor_id;

    IF postoji_sponzor_timu > 0 THEN
        INSERT INTO automobil(id_tim, model, boja, drzava, gume, godina_proizvodnje, maksimalna_brzina)
        VALUES (tim_id, model_vozila, boja_vozila, drzava_vozila, gume_vozila, godina_proizvodnje, maksimalna_brzina);
    ELSE
        ROLLBACK;
        SELECT 'Tim ili sponzor ne postoji ili sponzor nije povezan s navedenim timom.' AS Status;
    END IF;

    COMMIT;
END;
//
DELIMITER ;

CALL dodaj_novo_vozilo(1, 9003, 'Model X', 'Crvena', 'Hrvatska', 'Gume', 2023, 350);

SELECT *
FROM automobil;

-- 4. TRANSAKCIJA -----------------------------------------------------------------------------------------------------------
-- provjerava postojanje automobila i vozaca povezanih s odredenim timom, ako tim nema povezanih automobila ni vozaca, procedura brise tim iz baze podataka

DROP PROCEDURE IF EXISTS obrisi_tim;

DELIMITER //
CREATE PROCEDURE obrisi_tim(IN tim_id INT)
BEGIN
    DECLARE broj_automobila INT;
    DECLARE broj_vozaca INT;

    START TRANSACTION;

    SELECT COUNT(*) INTO broj_automobila FROM automobil WHERE id_tim = tim_id;
    SELECT COUNT(*) INTO broj_vozaca FROM vozac WHERE tim_id = tim_id;

    IF broj_automobila = 0 AND broj_vozaca = 0 THEN
        DELETE FROM tim WHERE id = tim_id;
    ELSE
        ROLLBACK;
        SELECT 'Nije moguće izbrisati tim jer ima povezane automobile ili vozače.' AS Status;
    END IF;

    COMMIT;
END;
//
DELIMITER ;

CALL obrisi_tim(1);

SELECT *
FROM tim;

-- 5. TRANSAKCIJA ------------------------------------------------------------------------------------------------------------------
-- omogucuje premjestaj vozaca u novi tim, ali samo ako u tom timu ima manje od 3 vozaca

DROP PROCEDURE IF EXISTS prijenos_vozaca;

DELIMITER //
CREATE PROCEDURE prijenos_vozaca(
    IN vozac_id INT,
    IN novi_tim_id INT
)
BEGIN
    DECLARE broj_mjesta_u_timu INT;

    START TRANSACTION;

    SELECT COUNT(*) INTO broj_mjesta_u_timu FROM vozac WHERE tim_id = novi_tim_id;

    IF broj_mjesta_u_timu < 3 THEN
        UPDATE vozac SET tim_id = novi_tim_id WHERE id = vozac_id;
    ELSE
        ROLLBACK;
        SELECT 'Nema dovoljno mjesta u novom timu za premještaj vozača.' AS Status;
    END IF;
    COMMIT;
END;
//
DELIMITER ;

CALL prijenos_vozaca(104, 1);

SELECT *
FROM vozac;

-- 6. TRANSAKCIJA---------------------------------------------------------------------------------------------------------------------------
-- mijenja status tima u "suspendiran" ako tim ima jednu ili vise kazni

DROP PROCEDURE IF EXISTS promijeni_status_tima;

DELIMITER //
CREATE PROCEDURE promijeni_status_tima(IN tim_id INT)
BEGIN
    DECLARE broj_kazni INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Greška prilikom izvršavanja transakcije.' AS Status;
    END;

    START TRANSACTION;

    SELECT kazna INTO broj_kazni
    FROM tim
    WHERE id = tim_id;

    IF broj_kazni > 0 THEN
        UPDATE tim
        SET status_nagrada = FALSE
        WHERE id = tim_id;
        COMMIT;
        SELECT 'Status tima je promijenjen na "suspendiran".' AS Status;
    ELSE
        ROLLBACK;
        SELECT 'Broj kazni nije premašio prag za promjenu statusa.' AS Status;
    END IF;
END;
//
DELIMITER ;

CALL promijeni_status_tima(3);

-- -------------------------------------------------------------------------------------------------------
DROP USER organizator;
CREATE USER 'organizator'@'localhost' IDENTIFIED BY 'organizator';
GRANT ALL PRIVILEGES ON automobilizam.* TO 'organizator'@'localhost';
FLUSH PRIVILEGES;