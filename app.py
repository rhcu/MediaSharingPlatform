from flask import Flask, render_template, request, json, session
from werkzeug.security import generate_password_hash, check_password_hash
from flaskext.mysql import MySQL
from werkzeug.utils import redirect

app = Flask(__name__)
app.secret_key = 'Why would I tell you my secret key?'
mysql = MySQL()
# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'ran21Dom03!'
app.config['MYSQL_DATABASE_DB'] = 'media_sharing_platform'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)


@app.route("/")
def main():
    return render_template('index.html')


@app.route("/showSignUp")
def showSignUp():
    return render_template('signup.html')


@app.route('/signUp', methods=['POST', 'GET'])
def signUp():
    try:
        _email = request.form['inputEmail']
        _username = request.form['inputName']
        _password = request.form['inputPassword']
        # validate the received values
        if _username and _email and _password:
            conn = mysql.connect()
            cursor = conn.cursor()
            _hashed_password = generate_password_hash(_password)
            cursor.callproc('sp_createUser', (_email, _username, _hashed_password))
            data = cursor.fetchall()
            if len(data) is 0:
                conn.commit()
                return json.dumps({'message': 'User created successfully !'})
            else:
                return json.dumps({'error': str(data[0])})
        else:
            return json.dumps({'html': '<span>Enter the required fields</span>'})

    except Exception as e:
        return json.dumps({'error': str(e)})
    finally:
        cursor.close()
        conn.close()


@app.route('/showSignin')
def showSignin():
    return render_template('signin.html')


@app.route('/validateLogin', methods=['POST'])
def validateLogin():
    try:
        _email = request.form['inputEmail']
        _password = request.form['inputPassword']
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.callproc('sp_validateLogin', (_email,))
        data = cursor.fetchall()
        if len(data) > 0:
            if check_password_hash(str(data[0][3]), _password):
                session['user'] = data[0][0]
                return redirect('/userHome')
            else:
                return render_template('error.html', error='Wrong Email address or Password.')
        else:
            return render_template('error.html', error='Wrong Email address or Password.')

    except Exception as e:
        return render_template('error.html', error=str(e))
    finally:
        cursor.close()
        conn.close()


@app.route('/userHome')
def userHome():
    if session.get('user'):
        return render_template('userHome.html')
    else:
        return render_template('error.html', error = 'Unauthorized Access')


@app.route('/logout')
def logout():
    session.pop('user',None)
    return redirect('/')


@app.route('/showAddWish')
def showAddWish():
    return render_template('addWish.html')


@app.route('/addWish', methods=['POST'])
def addWish():
    try:
        if session.get('user'):
            _title = request.form['inputTitle']
            _description = request.form['inputDescription']
            _user_id = session.get('user')

            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_addItem', (_title, _description, _user_id))
            data = cursor.fetchall()

            if len(data) is 0:
                conn.commit()
                return redirect('/userHome')
            else:
                return render_template('error.html', error='An error occurred!')

        else:
            return render_template('error.html', error='Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error=str(e))
    finally:
        cursor.close()
        conn.close()


@app.route('/getItem')
def getItem():
    try:
        print("here")
        if session.get('user'):

            _user_id = session.get('user')

            print("HERE")

            con = mysql.connect()
            cursor = con.cursor()
            cursor.callproc('sp_GetItemByUser', (_user_id,))
            items = cursor.fetchall()

            items_dict = []
            for item in items:
                item_dict = {'Id': item[0], 'Title': item[1], 'Description': item[2], 'Date': item[4]}
                items_dict.append(item_dict)

            return json.dumps(items_dict)
        else:
            return render_template('error.html', error='Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error=str(e))


@app.route('/getItemById', methods=['POST'])
def getItemById():
    try:
        if session.get('user'):

            _id = request.form['id']
            _user = session.get('user')

            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_GetItemById', (_id, _user))
            result = cursor.fetchall()

            wish = [{'Id': result[0][0], 'Title': result[0][1], 'Description': result[0][2]}]

            return json.dumps(wish)
        else:
            return render_template('error.html', error='Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error=str(e))


@app.route('/updateItem', methods=['POST'])
def updateItem():
    try:
        if session.get('user'):
            _user = session.get('user')
            _title = request.form['title']
            _description = request.form['description']
            _item_id = request.form['id']

            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_updateItem', (_title, _description, _item_id, _user))
            data = cursor.fetchall()

            if len(data) is 0:
                conn.commit()
                return json.dumps({'status': 'OK'})
            else:
                return json.dumps({'status': 'ERROR'})
    except Exception as e:
        return json.dumps({'status': 'Unauthorized access'})
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    app.run(port=5002)
