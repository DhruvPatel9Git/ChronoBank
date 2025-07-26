⏱️ Installation Guide for ChronoBank System

ChronoBank is a time-based banking system built with Flask. This guide will walk you through setting up the project locally.

📋 Prerequisites

Make sure the following are installed:

Python 3.9+

MySQL Server (e.g., XAMPP, WAMP, MAMP, or standalone MySQL)

Git

🧽 Steps to Install and Run

1. Clone the Repository

git clone https://github.com/your-username/chronobank-system.git
cd chronobank-system

Replace your-username with your actual GitHub username.

2. Create and Activate Virtual Environment

Create a virtual environment to isolate dependencies.

python -m venv env

Activate it:

Windows:

env\Scripts\activate

macOS/Linux:

source env/bin/activate

3. Install Dependencies

Install all required Python packages:

pip install -r requirements.txt

4. Database Setup

A. Start MySQL server via your preferred environment (e.g., XAMPP)

B. Create the database:

CREATE DATABASE chronobank_db;

C. Import the schema (if provided):

mysql -u root -p chronobank_db < schema.sql

Modify the database name or credentials if necessary.

5. Configure Environment Variables

Create a .env file in the root of the project and add the following:

FLASK_APP=app.py
FLASK_ENV=development

SECRET_KEY=your_secret_key
SESSION_TYPE=filesystem

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=chronobank_db

Update the values to match your system setup.

6. Run the Application

Start the Flask development server:

python app.py

You should see output like:

 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)

7. Access the Application

User Site: http://localhost:5000

Admin Panel: http://localhost:5000/adminPanel

8. Initial Login Credentials

👤 User Login:

Username: user

Password: @user@

🛠️ Admin Login:

Username: admin

Password: admin

⚙️ Project Structure Overview

chronobank-system/
│
├— app.py
├— requirements.txt
├— .env
├— schema.sql (if available)
├— templates/
│   ├— admin/
│   └— user/
├— static/
├— routes/
├— models/
├— utils/
├— decorators/
└— INSTALLATION.md

🤝 Contributing

Fork the repository.

Create a new branch:

git checkout -b feature/your-feature-name

Make your changes and commit:

git commit -am "Add your feature"

Push to your branch:

git push origin feature/your-feature-name

Open a Pull Request.

📄 License

This project is licensed under the MIT License.

