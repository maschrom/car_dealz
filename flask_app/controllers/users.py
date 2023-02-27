from flask import render_template, request, session, redirect, flash
from flask_app import app
from flask_app.models.user import User
from flask_app.models.car import Car
from flask_bcrypt import Bcrypt

bcrypt = Bcrypt(app)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/dashboard")
def dashboard():
    if "user_id" not in session:
        return redirect("/logout")
    data = {
        "id": session["user_id"]
    }

    user = User.get_by_id(data)
    all_cars = Car.get_all_cars()
    seller_info = Car.get_seller()
    purchases = Car.get_purchases(data)

    return render_template("dashboard.html", purchases=purchases, user=user, all_cars=all_cars, seller_info=seller_info)

@app.route("/register", methods=["post"])
def register():
    if not User.validate_register(request.form):
        return redirect('/')
    pw_hash = bcrypt.generate_password_hash(request.form["password"])
    data = {
        "first_name": request.form["first_name"],
        "last_name": request.form["last_name"],
        "email": request.form["email"],
        "password": pw_hash
    }
    email_data = {
        "email": request.form["email"]
    }
    if User.get_by_email(email_data):
        flash("An account with this email address already exists. Please try logging in instead.")
        return redirect('/')
    print(pw_hash)
    user_id = User.save(data)
    session["user_id"] = user_id
    return redirect("/dashboard")

@app.route("/login", methods=["post"])
def login():
    email_data = {
        "email": request.form["email-login"]
    }
    user = User.get_by_email(email_data)
    if not user:
        flash("E-Mail not Found. Please Register")
        return redirect("/")
    if not bcrypt.check_password_hash(user.password, request.form["password-login"]):
        flash("Email/Password combination is incorrect.")
        return redirect("/")
    
    session["user_id"] = user.id
    return redirect("/dashboard")


@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")