import os
import uuid

from flask import Flask, render_template, request, json, session
from werkzeug.security import generate_password_hash, check_password_hash
from flaskext.mysql import MySQL
from werkzeug.utils import redirect
from werkzeug.wsgi import LimitedStream

app = Flask(__name__)
app.secret_key = 'Why would I tell you my secret key?'
mysql = MySQL()
# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'ran21Dom03!'
app.config['MYSQL_DATABASE_DB'] = 'media_sharing_platform'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['UPLOAD_FOLDER'] = 'static/Uploads'
mysql.init_app(app)
pageLimit = 5


@app.route("/")
def main():
    return render_template('index.html')


@app.route('/upload', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        file = request.files['file']
        extension = os.path.splitext(file.filename)[1]
        f_name = str(uuid.uuid4()) + extension
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], f_name))
        return json.dumps({'filename': f_name})


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
                return redirect('/showDashboard')
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
            if request.form.get('filePath') is None:
                _filePath = ''
            else:
                _filePath = request.form.get('filePath')

            if request.form.get('private') is None:
                _is_private = 0
            else:
                _is_private = 1

            if request.form.get('favorite') is None:
                _is_favorite = 0
            else:
                _is_favorite = 1

            _title = request.form['inputTitle']
            _description = request.form['inputDescription']
            _user_id = session.get('user')

            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_addItem', (_title, _description, _user_id, _filePath, _is_private, _is_favorite))
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


@app.route('/getItem', methods=['POST'])
def getItem():
    try:
        if session.get('user'):

            _user_id = session.get('user')
            _limit = pageLimit
            _offset = request.form['offset']
            _total = 0

            con = mysql.connect()
            cursor = con.cursor()
            cursor.callproc('sp_GetItemByUser', (_user_id, _limit, _offset, _total))
            items = cursor.fetchall()

            cursor.close()

            cursor = con.cursor()
            cursor.execute('select @_sp_GetItemByUser_3')

            outParam = cursor.fetchall()
            response = []
            items_dict = []
            for item in items:
                item_dict = {'Id': item[0], 'Title': item[1], 'Description': item[2], 'Date': item[4]}
                items_dict.append(item_dict)

            response.append(items_dict)
            response.append({'total': outParam[0][0]})

            return json.dumps(response)
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

            wish = [{'Id': result[0][0], 'Title': result[0][1], 'Description': result[0][2], 'FilePath': result[0][3],
                     'Private': result[0][4], 'Done': result[0][5]}]

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
            _filePath = request.form['filePath']
            _is_private = request.form['isPrivate']
            _is_favorite = request.form['isDone']

            conn = mysql.connect()
            cursor = conn.cursor()

            cursor.callproc('sp_updateItem', (str(_title), str(_description), int(_item_id), int(_user),
                                             str(_filePath), int(_is_private), int(_is_favorite)))

            data = cursor.fetchall()
            print(data)

            if len(data) is 0:
                conn.commit()
                return json.dumps({'status': 'OK'})
            else:
                return json.dumps({'status': 'ERROR'})
    except Exception as e:
        raise e

        return json.dumps({'status': 'Unauthorized access'})
    finally:
        cursor.close()
        conn.close()


@app.route('/deleteItem', methods=['POST'])
def deleteItem():
    try:
        if session.get('user'):
            _id = request.form['id']
            _user = session.get('user')

            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_deleteItem', (_id, _user))
            result = cursor.fetchall()

            if len(result) is 0:
                conn.commit()
                return json.dumps({'status': 'OK'})
            else:
                return json.dumps({'status': 'An Error occured'})
        else:
            return render_template('error.html', error='Unauthorized Access')
    except Exception as e:
        return json.dumps({'status': str(e)})
    finally:
        cursor.close()
        conn.close()


@app.route('/showDashboard')
def showDashboard():
    return render_template('dashboard.html')


@app.route('/getAllItems')
def getAllItems():
    try:
        if session.get('user'):
            _user = session.get('user')
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_GetAllItems', (_user,))
            result = cursor.fetchall()

            wishes_dict = []
            for wish in result:
                wish_dict = {
                    'Id': wish[0],
                    'Title': wish[1],
                    'Description': wish[2],
                    'FilePath': wish[3],
                    'Like': wish[4],
                    'HasLiked': wish[5]}
                wishes_dict.append(wish_dict)

            return json.dumps(wishes_dict)
        else:
            return render_template('error.html', error='Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error=str(e))


@app.route('/addUpdateLike', methods=['POST'])
def addUpdateLike():
    try:
        if session.get('user'):
            _wishId = request.form['wish']
            _like = request.form['like']
            _user = session.get('user')

            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.callproc('sp_AddUpdateLikes', (_wishId, _user, _like))

            data = cursor.fetchall()
            if len(data) is 0:
                conn.commit()
                cursor.close()
                conn.close()
                conn = mysql.connect()
                cursor = conn.cursor()
                cursor.callproc('sp_getLikeStatus', (_wishId, _user))
                result = cursor.fetchall()
                return json.dumps({'status': 'OK', 'total': result[0][0], 'likeStatus': result[0][1]})
            else:
                return render_template('error.html', error='An error occurred!')

        else:
            return render_template('error.html', error='Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error=str(e))
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    app.run(port=5002)
