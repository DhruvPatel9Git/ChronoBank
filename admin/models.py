from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class AdminUser(db.Model):
    __tablename__ = 'admin_users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)  

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)
    total_balance = db.Column(db.String(5), nullable=False, default="00:00")  
    total_balance_minutes = db.Column(db.Integer, nullable=False, default=0) 

    def __repr__(self):
        return self.username



class Account(db.Model):
    __tablename__ = 'accounts'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    account_number = db.Column(db.BigInteger, unique=True, nullable=False)
    account_type = db.Column(db.Enum('Savings', 'Investment', 'Loan'), nullable=False)
    balance = db.Column(db.String(10), nullable=True, default='00:00') 
    interest_rate = db.Column(db.Numeric(5, 2), default=0.00)
    transaction_limit = db.Column(db.Numeric(10, 2), default=0.00)
    account_status = db.Column(db.Enum('active', 'suspended', 'closed'), default='active')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = db.relationship('User', backref='accounts')



# Transaction Model
class Transaction(db.Model):
    __tablename__ = 'transactions'

    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    receiver_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    sender_account_number = db.Column(db.String(20))
    receiver_account_number = db.Column(db.String(20))
    time_amount = db.Column(db.String(10)) 
    transaction_type = db.Column(db.String(50))
    tax = db.Column(db.String(10))
    bonus = db.Column(db.String(10))
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

    
    sender = db.relationship('User', foreign_keys=[sender_id], backref='sent_transactions')
    receiver = db.relationship('User', foreign_keys=[receiver_id], backref='received_transactions')
