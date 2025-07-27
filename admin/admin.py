from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from flask_admin import Admin, AdminIndexView, expose
from flask_admin.contrib.sqla import ModelView
from sqlalchemy.orm import joinedload
from admin.models import db, AdminUser, User, Account, Transaction
from datetime import datetime, time

admin_blueprint = Blueprint('admin_bp', __name__, template_folder='templates/admin')


def init_admin(app):
    admin = Admin(
        app,
        name='ChronoBank Admin',
        template_mode='bootstrap4',
        index_view=AuthAdminIndexView(url='/admin', endpoint='admin_home')
    )
    admin.add_view(UserModelView(User, db.session))
    admin.add_view(AccountModelView(Account, db.session))
    admin.add_view(TransactionModelView(Transaction, db.session))


def time_string_to_minutes(time_str):
    """
    Converts a time string (HH:MM) into total minutes.
    """
    if isinstance(time_str, str):
        
        time_obj = datetime.strptime(time_str, '%H:%M').time()  
        total_minutes = time_obj.hour * 60 + time_obj.minute
        return total_minutes
    return 0  

def minutes_to_time_string(minutes):
    """
    Converts total minutes into a time string in HH:MM format.
    """
    hours = minutes // 60
    mins = minutes % 60
    return f"{hours:02}:{mins:02}"



class AuthAdminIndexView(AdminIndexView):
    @expose('/')
    @expose('/admin')
    def index(self):
        if not session.get('admin_logged_in'):
            return redirect(url_for('admin_bp.admin_login'))
        return self.render('admin/admin_index.html')


class SecureModelView(ModelView):
    def is_accessible(self):
        return session.get('admin_logged_in')


class UserModelView(SecureModelView):
    can_create = False
    can_edit = True
    can_delete = True
    column_list = ['id', 'username', 'total_balance']


class AccountModelView(SecureModelView):
    can_create = True
    can_edit = True
    can_delete = True
    column_list = ['id', 'user_id', 'account_number', 'account_type', 'balance', 'interest_rate', 'transaction_limit', 'account_status']


class TransactionModelView(SecureModelView):
    can_create = False
    can_edit = False
    can_delete = False
    column_list = ['id', 'sender', 'receiver', 'time_amount', 'transaction_type', 'tax', 'bonus', 'timestamp']


@admin_blueprint.route('/transfer', methods=['GET'])
def transfer():
    if not session.get('admin_logged_in'):
        return redirect(url_for('admin_bp.admin_login'))

   
    page = request.args.get('page', 1, type=int)
    per_page = 10
    pagination = Transaction.query.options(
        joinedload(Transaction.sender),
        joinedload(Transaction.receiver)
    ).order_by(Transaction.timestamp.desc()).paginate(page=page, per_page=per_page, error_out=False)

    transactions = pagination.items
    return render_template('admin/transfer.html', transactions=transactions, pagination=pagination)

@admin_blueprint.route('/admin/login', methods=['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        admin_user = AdminUser.query.filter_by(username=username).first()

        if admin_user and admin_user.password == password:
            session['admin_logged_in'] = True
            return redirect(url_for('admin_home.index'))
        else:
            flash('Invalid credentials', 'danger')

    return render_template('admin/admin_login.html')


@admin_blueprint.route('/admin-logout')
def admin_logout():
    session.pop('admin_logged_in', None)
    flash("Logged out successfully.", "success")
    return redirect(url_for('admin_bp.admin_login'))


@admin_blueprint.route('/admin/manage-users')
def manage_users():
    if not session.get('admin_logged_in'):
        return redirect(url_for('admin_bp.admin_login'))
    users = User.query.all()
    return render_template('admin/manage_users.html', users=users)


@admin_blueprint.route('/admin/edit-user/<int:user_id>', methods=['GET', 'POST'])
def edit_user(user_id):
    if not session.get('admin_logged_in'):
        return redirect(url_for('admin_bp.admin_login'))

    user = User.query.get_or_404(user_id)

    if request.method == 'POST':
        new_total_balance_minutes = int(request.form['total_balance_minutes'])
        new_total_balance_str = minutes_to_time_string(new_total_balance_minutes)

        user.total_balance_minutes = new_total_balance_minutes
        user.total_balance = new_total_balance_str

        eligible_accounts = [acct for acct in user.accounts if acct.account_type in ['Savings', 'Investment']]
        
        if eligible_accounts:
            per_account_minutes = new_total_balance_minutes // len(eligible_accounts)
            for account in eligible_accounts:
                account.balance = minutes_to_time_string(per_account_minutes)

        db.session.commit()
        flash("User and account balances updated successfully", "success")
        return redirect(url_for('admin_bp.manage_users'))

    return render_template('admin/edit_user.html', user=user)



@admin_blueprint.route('/admin/delete-user/<int:user_id>')
def delete_user(user_id):
    if not session.get('admin_logged_in'):
        return redirect(url_for('admin_bp.admin_login'))
    user = User.query.get_or_404(user_id)
    db.session.delete(user)
    db.session.commit()
    flash("User deleted", "success")
    return redirect(url_for('admin_bp.manage_users'))
