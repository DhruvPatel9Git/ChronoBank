document.addEventListener("DOMContentLoaded", function () {
    const userId = 1; // Static for now, replace with dynamic authentication if needed
    const accountsList = document.getElementById("accounts-list");
    const accountSelect = document.getElementById("account-id");
    const createAccountForm = document.getElementById("create-account-form");
    const transactionForm = document.getElementById("transaction-form");
    const transactionResult = document.getElementById("transaction-result");

    // Fetch and display user accounts
    function loadAccounts() {
        fetch(`http://localhost:5000/api/accounts?user_id=${userId}`)
            .then(response => response.json())
            .then(accounts => {
                accountsList.innerHTML = "";
                accountSelect.innerHTML = '<option value="">Select Account</option>';

                if (accounts.length === 0) {
                    accountsList.innerHTML = "<p>No accounts found. Create one below.</p>";
                    return;
                }

                accounts.forEach(account => {
                    const accountItem = document.createElement("div");
                    accountItem.className = "account";
                    accountItem.innerHTML = `
                        <h3>${account.account_type.toUpperCase()} Account</h3>
                        <p>Balance: $${account.balance.toFixed(2)}</p>
                        <p>Interest Rate: ${(account.interest_rate * 100).toFixed(2)}%</p>
                    `;
                    accountsList.appendChild(accountItem);

                    const option = document.createElement("option");
                    option.value = account.id;
                    option.textContent = `${account.account_type} - $${account.balance.toFixed(2)}`;
                    accountSelect.appendChild(option);
                });

                accountSelect.disabled = accounts.length === 0;
            })
            .catch(error => console.error("Error fetching accounts:", error));
    }

    // Handle account creation
    createAccountForm.addEventListener("submit", function (event) {
        event.preventDefault();
        const accountType = document.getElementById("account-type").value;
        const initialBalance = parseFloat(document.getElementById("initial-balance").value) || 0;

        fetch("http://localhost:5000/api/accounts", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ user_id: userId, account_type: accountType, initial_balance: initialBalance }),
        })
            .then(response => response.json())
            .then(data => {
                document.getElementById("account-message").innerHTML = `<p class="success">${data.message}</p>`;
                loadAccounts();
            })
            .catch(error => {
                document.getElementById("account-message").innerHTML = `<p class="error">Error creating account.</p>`;
            });
    });

    // Handle transactions
    transactionForm.addEventListener("submit", function (event) {
        event.preventDefault();
        const accountId = accountSelect.value;
        const transactionType = document.getElementById("transaction-type").value;
        const amount = parseFloat(document.getElementById("amount").value);

        if (!accountId) {
            transactionResult.innerHTML = `<p class="error">Please select an account.</p>`;
            return;
        }

        fetch("http://localhost:5000/api/transactions", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ account_id: accountId, amount, transaction_type: transactionType }),
        })
            .then(response => response.json())
            .then(data => {
                transactionResult.innerHTML = `<p class="success">${data.message}. New Balance: $${data.new_balance.toFixed(2)}</p>`;
                loadAccounts();
            })
            .catch(error => {
                transactionResult.innerHTML = `<p class="error">Transaction failed.</p>`;
            });
    });

    // Load accounts on page load
    loadAccounts();
});
