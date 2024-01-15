# Automobilizam

---

U ovoj dokumentaciji detaljno ćemo predstaviti naš projekt iz kolegija Baze podataka 2, pod nazivom 'Automobilizam'. Cilj projekta je razviti sveobuhvatnu i efikasnu bazu podataka specijaliziranu za automobilske utrke, koja obuhvaća sve ključne komponente ovog uzbuđujućeg sporta - od timova, vozača, staza, do sponzora i mehaničara.

---

## Funkcionalnosti web aplikacije

- **Sponzori**: Prikaz svih sponzora, dodavanje novih i brisanje postojećih.
- **Timovi**: Prikaz timova s promjenom njihove aktivnosti, dodavanje i brisanje.
- **Vozači**: Prikaz svih vozača, dodavanje novih i brisanje postojećih.
- **Automobili**: Prikaz svih automobila, dodavanje novih i brisanje.
- **Utrke**: Prikaz svih utrka.
- **Staze**: Prikaz svih staza, dodavanje novih i brisanje.
- **Nagrade**: Prikaz svih nagrada, dodavanje novih i brisanje.
- **Prvenstva**: Prikaz svih prvenstava, dodavanje novih i brisanje.
- **Rezultati**: Prikaz rezultata utrka i vozača, izračun rezultata za utrke i brisanje rezultata.

Svaki od ovih modula omogućuje korisniku interakciju s bazom podataka kroz jednostavne web forme, pružajući efikasno i prilagođeno sučelje za upravljanje podacima vezanim uz automobilizam. Aplikacija također podržava različite operacije poput prikaza, dodavanja i brisanja podataka, čineći je sveobuhvatnim alatom za upravljanje informacijama u ovom sektoru.

---

## Struktura aplikacije

### Frontend:
- Koristi HTML šablone (render_template) za interakciju s korisnikom. Svaka stranica, kao što su `show_xxx.html` i `insert_xxx.html`, dizajnirana je za prikazivanje i unos podataka.

### Backend:
- Flask rute (npr. `@app.route`) služe kao veza između frontenda i baze podataka. Svaka ruta obrađuje specifične zahtjeve kao što su GET za prikaz i POST za ažuriranje podataka.

### Baza podataka:
- Korištenjem `flask_mysqldb`, aplikacija se povezuje s MySQL bazom. Operacije nad bazom (npr. SELECT, INSERT, DELETE) izvršavaju se unutar funkcija ruta.

### Dodatne funkcije:
- Aplikacija uključuje složenije funkcionalnosti poput `promijeni_aktivnost_timova`, `popuni_rezultate_za_utrku`, što ukazuje na postojanje pohranjenih procedura i ostalih oblika unutar baze.

### Sigurnost i konfiguracija:
- Postavljanjem tajnog ključa (secret_key) i konfiguracijskih parametara za MySQL, aplikacija osigurava temeljnu sigurnost i pravilnu povezanost s bazom.

---

## Pokretanje web aplikacije

1. Potrebno je preuzeti sve datoteke koje se nalaze u Github repozitoriju.
2. Pokrenete aplikaciju u VSCODE-u i upišete ovaj link u svoj preglednik `http://127.0.0.1:5000`.
3. U Cmd-i: Pokrenete cmd i pomoću `cd` naredbe postavite se na datoteku di je aplikacija.
4. Sljedeće upišite `set FLASK_APP=app_html.py`.
5. Zatim startajte aplikaciju pomoću `python app_html.py`.
