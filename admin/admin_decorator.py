class BaseTransaction:
    def __init__(self, amount):
        self.amount = amount

    def get_final_amount(self):
        return self.amount

    def get_tax(self):
        return 0 

    def get_bonus(self):
        return 0  


class TransactionDecorator(BaseTransaction):
    def __init__(self, transaction):
        self.transaction = transaction  

    def get_final_amount(self):
        return self.transaction.get_final_amount()

    def get_tax(self):
        return self.transaction.get_tax()

    def get_bonus(self):
        return self.transaction.get_bonus()


class TaxDecorator(TransactionDecorator):
    def get_final_amount(self):
        tax = self.transaction.amount * 0.10
        return self.transaction.get_final_amount() + tax

    def get_tax(self):
        return self.transaction.amount * 0.10


class BonusDecorator(TransactionDecorator):
    def get_final_amount(self):
        bonus = self.transaction.get_final_amount() * 0.05
        return self.transaction.get_final_amount() - bonus

    def get_bonus(self):
        return self.transaction.get_final_amount() * 0.05
