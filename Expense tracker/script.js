document.addEventListener("DOMContentLoaded", loadTransactions);

document.getElementById("addTransaction").addEventListener("click", function () {
    let desc = document.getElementById("desc").value.trim();
    let type = document.getElementById("type").value;
    let category = document.getElementById("category").value;
    let amountInput = document.getElementById("amount").value.trim();
    let amount = parseFloat(amountInput);

    // Debugging: Log values to the console
    console.log("Description:", desc);
    console.log("Amount:", amount);

    // Validation check
    if (!desc || isNaN(amount) || amount <= 0) {
        alert("Please enter a valid description and a positive amount.");
        return;
    }

    let transaction = { desc, type, category, amount };
    let transactions = JSON.parse(localStorage.getItem("transactions")) || [];
    transactions.push(transaction);
    localStorage.setItem("transactions", JSON.stringify(transactions));

    // Clear input fields
    document.getElementById("desc").value = "";
    document.getElementById("amount").value = "";

    loadTransactions();
});

function loadTransactions() {
    let transactions = JSON.parse(localStorage.getItem("transactions")) || [];
    let transactionList = document.getElementById("transactionList");
    transactionList.innerHTML = "";

    let totalIncome = 0, totalExpenses = 0;

    transactions.forEach((t, index) => {
        let li = document.createElement("li");
        li.classList.add("transaction", t.type);
        li.innerHTML = `
            <span>${getCategoryIcon(t.category)} ${t.desc}</span>
            <span>${t.type === "income" ? "+" : "-"} ₹${t.amount}</span>
            <button onclick="deleteTransaction(${index})">❌</button>
        `;

        if (t.type === "income") totalIncome += t.amount;
        else totalExpenses += t.amount;

        transactionList.appendChild(li);
    });

    document.getElementById("totalIncome").innerText = `₹${totalIncome}`;
    document.getElementById("totalExpenses").innerText = `₹${totalExpenses}`;
    document.getElementById("balance").innerText = `₹${totalIncome - totalExpenses}`;
}

function deleteTransaction(index) {
    let transactions = JSON.parse(localStorage.getItem("transactions")) || [];
    transactions.splice(index, 1);
    localStorage.setItem("transactions", JSON.stringify(transactions));
    loadTransactions();
}

function getCategoryIcon(category) {
    const icons = {
        "salary": "💼",
        "transport": "🚗",
        "food": "🍔",
        "shopping": "🛍️",
        "entertainment": "🎬",
        "other": "📌"
    };
    return icons[category] || "📌";
}

document.getElementById("filterCategory").addEventListener("change", function () {
    let selectedCategory = this.value;
    let transactions = JSON.parse(localStorage.getItem("transactions")) || [];

    let filtered = transactions.filter(t => selectedCategory === "all" || t.category === selectedCategory);
    
    document.getElementById("transactionList").innerHTML = "";
    filtered.forEach((t, index) => {
        let li = document.createElement("li");
        li.classList.add("transaction", t.type);
        li.innerHTML = `
            <span>${getCategoryIcon(t.category)} ${t.desc}</span>
            <span>${t.type === "income" ? "+" : "-"} ₹${t.amount}</span>
            <button onclick="deleteTransaction(${index})">❌</button>
        `;
        document.getElementById("transactionList").appendChild(li);
    });
});
