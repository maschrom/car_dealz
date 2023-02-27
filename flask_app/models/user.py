from flask_app.config.mysqlconnection import connectToMySQL
from flask import flash
import re

EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$')
PASSWORD_REGEX = re.compile(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$')


class User:
    db = "car_dealz_schema"
    def __init__(self, data):
        self.id = data["id"]
        self.first_name = data["first_name"]
        self.last_name = data["last_name"]
        self.email = data["email"]
        self.password = data["password"]
        self.created_at = data["created_at"]
        self.updated_at = data["updated_at"]
    
    @classmethod
    def get_by_id(cls,data):
        query = "SELECT * FROM users WHERE id=%(id)s;"
        results = connectToMySQL(cls.db).query_db(query,data)
        if len(results) < 1:
            return False
        return cls(results[0])
    
    @classmethod
    def get_by_email(cls,data):
        query = "SELECT * FROM users WHERE email=%(email)s;"
        results = connectToMySQL(cls.db).query_db(query,data)
        if (len(results) < 1):
            return False
        return cls(results[0])

    @classmethod
    def save(cls,data):
        query = "INSERT INTO users (first_name, last_name, email, password) VALUES (%(first_name)s, %(last_name)s, %(email)s, %(password)s);"
        result = connectToMySQL(cls.db).query_db(query,data)
        return result
    
    @staticmethod
    def validate_register(user):
        is_valid = True
        query = "SELECT * FROM users WHERE email=%(email)s;"
        results = connectToMySQL(User.db).query_db(query,user)
        if len(results) >= 1:
            flash("Email already taken.")
            is_valid = False
        if len(user["first_name"]) < 3:
            flash("First name must be at least 3 alphabetic characters")
            is_valid = False
        if len(user["last_name"]) < 3:
            flash("Last name must be at least 3 alphabetic characters")
            is_valid = False
        if not EMAIL_REGEX.match(user["email"]):
            flash("This is an invalid email address!")
            is_valid = False
        if not PASSWORD_REGEX.match(user["password"]) or len(user["password"]) < 8:
            flash("Your password is invalid!, Password must be at least 8 characters, and contain uppercase, lowercase, numbers & special characters.")
            is_valid = False
        if not user["password"] == user["confirm_password"]:
            flash("Passwords do no match! Please re-enter password.")
            is_valid = False

        return is_valid
    