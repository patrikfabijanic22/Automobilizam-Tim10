from flask import Flask, redirect, request, jsonify,render_template, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['JSON_AS_ASCII'] = False

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'organizator'
app.config['MYSQL_PASSWORD'] = 'organizator'
app.config['MYSQL_DB'] = 'automobilizam'

mysql = MySQL(app)

@app.route('/')
def home():
    return "ovo je samo kod"


@app.route('/sponzor', methods=['GET'])
def get_sponzor():
    
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM sponzor")
    sponzorirani = curr.fetchall()
    curr.close()
    
    return jsonify(sponzorirani)

# $response = Invoke-WebRequest -Uri 'http://localhost:5000/sponzor' -Method POST -Body @{id=30; naziv='buildin'; drzava='hrvatska'}
# $response.Content


@app.route('/sponzor', methods=['POST'])
def insert_sponzor():
    data = request.form
    print(data)

    id = data['id']
    naziv = data['naziv']
    drzava = data['drzava']

    curr = mysql.connection.cursor()
    curr.execute('INSERT INTO sponzor (id, naziv, drzava) VALUES (%s, %s, %s)', (id, naziv, drzava))
    mysql.connection.commit()
    curr.close()

    return jsonify({'msg': 'sponzor ' + naziv + ' uspijesno spremljen!'})






# curl -X DELETE http://localhost:5000/delete_sponzor/30

@app.route('/delete_sponzor/<int:id>', methods=['POST'])
def delete_sponzor(id):
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM sponzor WHERE id=%s", (id,))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('show_sponsor'))  
   






if __name__ == '__main__':
    app.run(debug=True, port=5000)