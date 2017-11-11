from flask import Flask, render_template, request, json

app = Flask(__name__)
@app.route("/")
def main():
    #return signUp()
    return render_template('index.html')
if __name__ == "__main__":
    app.run()
@app.route('/showSignUp')
def showSignUp():
    return render_template('signup.html')

@app.route('/signUp',methods=['POST'])
def signUp():
    # create user code will be here !!
    _email = request.form['inputEmail']
    _username = request.form['inputName']
    _password = request.form['inputPassword']
    # validate the received values
    if _username and _email and _password:
        return json.dumps({'html':'<span>All fields good !!</span>'})
    else:
        return json.dumps({'html':'<span>Enter the required fields</span>'})
