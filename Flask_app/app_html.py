from flask import Flask, flash, redirect, request, jsonify, render_template, session, url_for
from flask_mysqldb import MySQL


app = Flask(__name__)
app.secret_key = 'organizator'

app.config['JSON_AS_ASCII'] = False
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'organizator1'
app.config['MYSQL_PASSWORD'] = 'organizator1'
app.config['MYSQL_DB'] = 'automobilizam'
mysql = MySQL(app)


@app.route('/')
def home():
    return render_template('home.html')

#sponzor

@app.route('/show_sponzor', methods=['GET'])
def show_sponzor():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM sponzor")
    sponzor_data = curr.fetchall()
    curr.close()

    return render_template('show_sponzor.html', sponzor_data=sponzor_data)

@app.route('/insert_sponzor_form', methods=['GET'])
def insert_sponzor_form():
    return render_template('insert_sponzor.html')


@app.route('/insert_sponzor', methods=['POST'])
def insert_sponzor():
    naziv=request.form['naziv']
    drzava=request.form['drzava']

    curr = mysql.connection.cursor()
    curr.execute('INSERT INTO sponzor ( naziv, drzava) VALUES ( %s, %s)', ( naziv, drzava))
    mysql.connection.commit()
    curr.close()

    return redirect(url_for('show_sponzor'))

@app.route('/delete_sponzor/<int:id>', methods=['POST'])
def delete_sponzor(id):
    
        cur = mysql.connection.cursor()
        
        cur.execute("DELETE FROM timski_sponzor WHERE id_sponzor=%s", (id,))
        
        cur.execute("DELETE FROM sponzor WHERE id=%s", (id,))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('show_sponzor'))
    

    #tim

@app.route('/show_tim', methods=['GET'])
def show_tim():

    cur = mysql.connection.cursor()
    cur.callproc('promijeni_aktivnost_timova')
    cur.execute("SELECT tim.id, tim.naziv, tim.drzava, tim.vlasnik, tim.godina_osnivanja, CONCAT(trener.ime, ' ', trener.prezime) FROM tim LEFT JOIN trener ON tim.id = trener.id_tim;")
    tim_data = cur.fetchall()
    cur.execute("SELECT id, naziv, aktivnost FROM tim;")
    aktivnost_tima_data = cur.fetchall()
    mysql.connection.commit()
    cur.close()
    

    return render_template('show_tim.html', tim_data=tim_data, aktivnost_tima_data=aktivnost_tima_data)


@app.route('/insert_tim_form', methods=['GET'])
def insert_tim_form():
    return render_template('insert_tim.html')


@app.route('/insert_tim', methods=['POST'])
def insert_tim():
    naziv = request.form['naziv']
    drzava = request.form['drzava']
    vlasnik = request.form['vlasnik']
    godina_osnivanja = request.form['godina_osnivanja']

    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO tim ( naziv, drzava, vlasnik, godina_osnivanja) VALUES ( %s, %s, %s, %s)', ( naziv, drzava, vlasnik, godina_osnivanja))
    session['nedavno_dodani_tim_id'] = cur.lastrowid
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_tim'))



@app.route('/delete_tim/<int:id>', methods=['POST'])
def delete_tim(id):
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM tim WHERE id = %s', (id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_tim'))




#vozac

@app.route('/show_vozaci', methods=['GET'])
def show_vozaci():
    cur = mysql.connection.cursor()
    cur.execute("SELECT vozac.*, tim.naziv FROM vozac LEFT JOIN tim ON vozac.tim_id = tim.id; ")
    vozaci_data = cur.fetchall()
    cur.close()
    return render_template('show_vozaci.html', vozaci_data=vozaci_data)


@app.route('/insert_vozac_form', methods=['GET'])
def insert_vozac_form():
    return render_template('insert_vozac.html')

@app.route('/insert_vozac', methods=['POST'])
def insert_vozac():
    ime = request.form['ime']
    prezime = request.form['prezime']
    drzava = request.form['drzava']
    datum_rodenja = request.form['datum_rodenja']
    
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO vozac ( ime, prezime, drzava, datum_rodenja, tim_id) VALUES ( %s, %s, %s, %s,NULL)', ( ime, prezime, drzava, datum_rodenja))
    session['nedavno_dodani_vozac_id'] = cur.lastrowid
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_vozaci'))

@app.route('/delete_vozac/<int:id>', methods=['POST'])
def delete_vozac(id):
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM vozac WHERE id = %s', (id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_vozaci'))

#automobil

@app.route('/show_automobil', methods=['GET'])
def show_automobili():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM automobil")
    automobili_data = cur.fetchall()
    cur.close()
    return render_template('show_automobil.html', automobili_data=automobili_data)

@app.route('/insert_automobil_form', methods=['GET'])
def insert_automobil_form():
    return render_template('insert_automobil.html')


@app.route('/insert_automobil', methods=['POST'])
def insert_automobil():
    model = request.form['model']
    drzava = request.form['drzava']
    boja = request.form['boja']
    gume = request.form['gume']
    godina_proizvodnje = request.form['godina_proizvodnje']
    maksimalna_brzina = request.form['maksimalna_brzina']

    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO automobil (model, drzava, boja, gume, godina_proizvodnje, maksimalna_brzina) VALUES (%s, %s, %s, %s, %s, %s)', (model, drzava, boja, gume, godina_proizvodnje, maksimalna_brzina))
    session['nedavno_dodani_automobil_id'] = cur.lastrowid
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_automobili'))


@app.route('/delete_automobil/<int:id>', methods=['POST'])
def delete_automobil(id):
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM automobil WHERE id = %s', (id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_automobili'))



#utrka



@app.route('/show_utrka', methods=['GET'])
def show_utrka():
    cur = mysql.connection.cursor()
    cur.execute("SELECT utrka.id, utrka.naziv_eventa, utrka.datum_pocetak, utrka.datum_kraj, prvenstvo.naziv AS naziv_prvenstva, nagrada.naziv AS opis_nagrade, staza.naziv AS naziv_staze FROM utrka JOIN prvenstvo ON utrka.id_prvenstvo = prvenstvo.id JOIN  nagrada ON utrka.id_nagrada = nagrada.id JOIN  staza ON utrka.id_staza = staza.id ORDER BY id ASC;")
    utrka_data = cur.fetchall()
    cur.close()
    return render_template('show_utrka.html', utrka_data=utrka_data)



# staza


@app.route('/show_staza', methods=['GET'])
def show_staze():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM staza")
    staze_data = cur.fetchall()
    cur.close()
    return render_template('show_staza.html', staze_data=staze_data)


@app.route('/insert_staza_form', methods=['GET'])
def insert_staza_form():
    return render_template('insert_staza.html')


@app.route('/insert_staza', methods=['POST'])
def insert_staza():
    naziv = request.form['naziv']
    duzina = request.form['duzina']
    drzava = request.form['drzava']

    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO staza (naziv, duzina, drzava) VALUES (%s, %s, %s)', (naziv, duzina, drzava))
    session['nedavno_dodana_staza_id'] = cur.lastrowid
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_staze'))



@app.route('/delete_staza/<int:id>', methods=['POST'])
def delete_staza(id):
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM staza WHERE id = %s', (id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_staze'))

  
#nagrada

@app.route('/show_nagrada', methods=['GET'])
def show_nagrada():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM nagrada")
    nagrada_data = cur.fetchall()
    cur.close()
    return render_template('show_nagrada.html', nagrada_data=nagrada_data)

@app.route('/insert_nagrada_form', methods=['GET'])
def insert_nagrada_form():
    return render_template('insert_nagrada.html')

@app.route('/insert_nagrada', methods=['POST'])
def insert_nagrada():
    naziv = request.form['naziv']
    oblik = request.form['oblik']
    iznos = request.form['iznos']

    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO nagrada (naziv, oblik, iznos) VALUES (%s, %s, %s)', (naziv, oblik, iznos))
    session['nedavno_dodana_nagrada_id'] = cur.lastrowid
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_nagrada'))

@app.route('/delete_nagrada/<int:id>', methods=['POST'])
def delete_nagrada(id):
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM nagrada WHERE id = %s', (id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_nagrada'))


#prvenstvo

@app.route('/show_prvenstvo', methods=['GET'])
def show_prvenstvo():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM prvenstvo")
    prvenstvo_data = cur.fetchall()
    cur.close()
    return render_template('show_prvenstvo.html', prvenstvo_data=prvenstvo_data)

@app.route('/insert_prvenstvo_form', methods=['GET'])
def insert_prvenstvo_form():
    return render_template('insert_prvenstvo.html')

@app.route('/insert_prvenstvo', methods=['POST'])
def insert_prvenstvo():
    naziv = request.form['naziv']
    budzet = request.form['budzet']
    organizator = request.form['organizator']
    datum_pocetka = request.form['datum_pocetka']
    datum_zavrsetka = request.form['datum_zavrsetka']
    lokacija = request.form['lokacija']
    broj_timova = request.form['broj_timova']

    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO prvenstvo (naziv, budzet, organizator, datum_pocetka, datum_zavrsetka, lokacija, broj_timova) VALUES (%s, %s, %s, %s, %s, %s, %s)', (naziv, budzet, organizator, datum_pocetka, datum_zavrsetka, lokacija, broj_timova))
    session['nedavno_dodano_prvenstvo_id'] = cur.lastrowid
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_prvenstvo'))

@app.route('/delete_prvenstvo/<int:id>', methods=['POST'])
def delete_prvenstvo(id):
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM prvenstvo WHERE id = %s', (id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_prvenstvo'))


#rezultat


@app.route('/show_rezultat', methods=['GET','POST'])
def show_rezultat():
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT u.naziv_utrke, p.naziv AS 'Naziv Prvenstva', v.ime, v.prezime, t.naziv AS 'Naziv Tima', r.mjesto, r.bodovi, r.vrijeme_kruga, r.broj_krugova FROM rezultat r JOIN rezultat_vozaca_utrka u ON r.id_utrka = u.id_utrka JOIN vozac v ON r.id_vozac = v.id JOIN tim t ON v.tim_id = t.id JOIN prvenstvo p ON r.id_prvenstvo = p.id WHERE u.id_vozac = r.id_vozac ORDER BY u.id_utrka, r.mjesto;")
    rezultat_data = cur.fetchall()
    cur.execute("SELECT * FROM ukupni_bodovi_vozaca")
    bodovi_data = cur.fetchall()
    cur.close()
    return render_template('show_rezultat.html', rezultat_data=rezultat_data,bodovi_data=bodovi_data)




@app.route('/izracunaj_rezultate/<int:id_utrka>', methods=['GET'])
def izracunaj_rezultate(id_utrka):
    cur = mysql.connection.cursor()
    cur.execute("SELECT COUNT(*) FROM rezultat WHERE id_utrka = %s", (id_utrka,))
    count = cur.fetchone()[0]
    if count > 0:

        flash("Rezultati za ovu utrku su već uneseni.", "error")
        return redirect(url_for('show_rezultat'))
    cur.callproc('popuni_rezultate_za_utrku', (id_utrka,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('show_rezultat'))



@app.route('/izbrisi_rezultate', methods=['POST'])
def izbrisi_rezultate():
    sql_query = "DELETE FROM rezultat"
    try:
        cur = mysql.connection.cursor()
        cur.execute(sql_query)
        mysql.connection.commit()
        cur.close()
        flash("Svi rezultati su uspješno izbrisani.", "success")
    except Exception as e:
        mysql.connection.rollback()
        flash("Dogodila se greška prilikom brisanja rezultata: " + str(e), "error")
    return redirect(url_for('show_rezultat'))



@app.route('/pocetne_pozicije/<int:id_utrka>', methods=['GET'])
def pocetne_pozicije(id_utrka):
    cur = mysql.connection.cursor()

    cur.execute("SELECT naziv_eventa FROM utrka WHERE id = %s", (id_utrka,))
    naziv_utrke_red = cur.fetchone()
    naziv_utrke = naziv_utrke_red[0] if naziv_utrke_red else 'Nepoznato'
    cur.execute("SELECT * FROM pogled_pocetnih_pozicija WHERE id_utrka = %s", (id_utrka,))
    data = cur.fetchall()
    cur.close()

    return render_template('pocetne_pozicije.html', data=data, id_utrka=id_utrka, naziv_utrke=naziv_utrke)




@app.route('/obracun_bodova/<int:id_prvenstvo>', methods=['GET'])
def obracun_bodova(id_prvenstvo):
    cur = mysql.connection.cursor()
    cur.execute("SELECT naziv FROM prvenstvo WHERE id = %s", (id_prvenstvo,))
    naziv_prvenstva_red = cur.fetchone()
    naziv_prvenstva = naziv_prvenstva_red[0] if naziv_prvenstva_red else 'Nepoznato'

    cur.callproc('popuni_ostvaruje_rezultat', [id_prvenstvo])
    mysql.connection.commit()
    cur.execute("""
        SELECT tim.naziv, o_r.ukupan_broj_bodova, o_r.broj_najbrzih_krugova, id_prvenstvo
        FROM ostvaruje_rezultat o_r
        JOIN tim ON o_r.id_tim = tim.id
        WHERE o_r.id_prvenstvo = %s
          AND (o_r.ukupan_broj_bodova IS NOT NULL OR o_r.broj_najbrzih_krugova > 0)
        LIMIT 5;
    """, [id_prvenstvo])
    rezultati = cur.fetchall()
    cur.close()
    return render_template('rezultati_prvenstva.html', rezultati=rezultati, id_prvenstvo=id_prvenstvo,naziv_prvenstva=naziv_prvenstva)





if __name__ == '__main__':
    app.run(debug=True, port=5000)
