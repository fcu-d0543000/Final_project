from flask import Flask, render_template, redirect, url_for, session, request
from flask_bootstrap import Bootstrap
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, validators, SubmitField, ValidationError
from wtforms.fields.html5 import EmailField
from flask_sqlalchemy  import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
import os

pjdir = os.path.abspath(os.path.dirname(__file__))
app = Flask(__name__)
app.config['SECRET_KEY'] = 'QWERTYUIOP!'
app.config['SQLALCHEMY_DATABASE_URI'] =  'sqlite:///' + os.path.join(pjdir, 'static\\data\\database.sqlite')
bootstrap = Bootstrap(app)
db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(15), unique=True)
    email = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(80))

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

class LoginForm(FlaskForm):
    username = StringField('使用者名稱', validators=[
        validators.InputRequired(), 
        validators.Length(min=4, max=15)])
    password = PasswordField('密碼', validators=[
        validators.InputRequired(), 
        validators.Length(min=4, max=80)])
    remember = BooleanField('記住我')

class RegisterForm(FlaskForm):
    username = StringField('使用者名稱', validators=[
        validators.DataRequired(),
        validators.Length(4, 15)
    ])
    email = EmailField('電子郵件', validators=[
        validators.DataRequired(),
        validators.Length(1, 50),
        validators.Email()
    ])
    password = PasswordField('密碼', validators=[
        validators.DataRequired(),
        validators.Length(4, 80),
        validators.EqualTo('password2', message='PASSWORD NEED MATCH')
    ])
    password2 = PasswordField('確認密碼', validators=[
        validators.DataRequired()
    ])
    submit = SubmitField('Register New Account')

    def validate_email(self, field):
        if User.query.filter_by(email=field.data).first():
            raise ValidationError('Email already register by somebody')

    def validate_username(self, field):
        if User.query.filter_by(username=field.data).first():
            raise ValidationError('UserName already register by somebody')

@app.route('/')
def index():
    return render_template('index.html', name=session.get('username'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if session.get('username') is not None:
        return redirect(url_for('dashboard')+'?view=user_info')

    form = LoginForm()

    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user:
            if check_password_hash(user.password, form.password.data):
                login_user(user, remember=form.remember.data)
                session['username'] = form.username.data 
                return redirect(url_for('dashboard',tab='user_info'))

        #return '<h1>Invalid username or password</h1>'
        return '<h1>' + form.username.data + ' ' + form.password.data + '</h1>'

    return render_template('login.html', form=form)

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if session.get('username') is not None:
        return redirect(url_for('dashboard',tab='user_info'))

    form = RegisterForm()

    if form.validate_on_submit():
        hashed_password = generate_password_hash(form.password.data, method='sha256')
        new_user = User(username=form.username.data, email=form.email.data, password=hashed_password)
        db.session.add(new_user)
        db.session.commit()

        return '<h1>New user has been created!</h1>'
        #return '<h1>' + form.username.data + ' ' + form.email.data + ' ' + form.password.data + '</h1>'

    return render_template('signup.html', form=form)

@app.route('/dataset')
@login_required
def dataset():
    return render_template('dataset.html')

@app.route('/dashboard')
@login_required
def dashboard():
    view = request.args.get('view')
    user = User.query.filter_by(username=session.get('username')).first()
    return render_template('dashboard.html', name=session.get('username'), email=user.email, view=request.args.get('view'))

@app.route('/logout')
@login_required
def logout():
    logout_user()
    session.pop('username')
    return redirect(url_for('index'))

@app.route('/build')
def build():
    return render_template('build.html', name=session.get('username'))

@app.route('/predict')
def predict():
    return render_template('predict.html', name=session.get('username'))

if __name__ == '__main__':
    app.run(debug=True)
