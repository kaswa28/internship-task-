import java.io.*;
import java.util.*;

class BankSystem {
    static Scanner sc = new Scanner(System.in);
    static HashMap<String, Account> accounts = new HashMap<>();
    static final String FILE_NAME = "bank_data.ser";

    public static void main(String[] args) {
        loadAccounts();
        while (true) {
            System.out.println("\n1. Create Account  2. Login  3. Exit");
            System.out.print("Enter choice: ");
            int choice = sc.nextInt();
            sc.nextLine();
            switch (choice) {
                case 1 -> createAccount();
                case 2 -> login();
                case 3 -> {
                    saveAccounts();
                    System.exit(0);
                }
                default -> System.out.println("Invalid choice! Try again.");
            }
        }
    }

    static void createAccount() {
        System.out.print("Enter Account Number: ");
        String accNo = sc.nextLine();
        if (accounts.containsKey(accNo)) {
            System.out.println("❌ Account already exists!");
            return;
        }
        System.out.print("Enter PIN: ");
        String pin = sc.nextLine();
        System.out.print("Select Account Type (1. Checking  2. Savings): ");
        int type = sc.nextInt();
        System.out.print("Enter Initial Deposit: ");
        double balance = sc.nextDouble();
        sc.nextLine(); // Consume newline
        if (type == 2 && balance < 500) {
            System.out.println("⚠ Savings account requires minimum $500!");
            return;
        }
        Account acc = (type == 1) ? new CheckingAccount(accNo, pin, balance) : new SavingsAccount(accNo, pin, balance);
        accounts.put(accNo, acc);
        System.out.println("✅ Account Created Successfully!");
        saveAccounts();
    }

    static void login() {
        System.out.print("Enter Account Number: ");
        String accNo = sc.nextLine();
        if (!accounts.containsKey(accNo)) {
            System.out.println("❌ Account not found!");
            return;
        }
        int attempts = 3;
        while (attempts-- > 0) {
            System.out.print("Enter PIN: ");
            String pin = sc.nextLine();
            if (accounts.get(accNo).validatePIN(pin)) {
                System.out.println("✅ Login Successful!");
                accounts.get(accNo).accountMenu();
                return;
            }
            System.out.println("Incorrect PIN! Attempts left: " + attempts);
        }
        System.out.println("⚠️ Account Locked!");
    }

    static void saveAccounts() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE_NAME))) {
            oos.writeObject(accounts);
        } catch (IOException e) {
            System.out.println("⚠ Error saving data!");
        }
    }

    static void loadAccounts() {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(FILE_NAME))) {
            accounts = (HashMap<String, Account>) ois.readObject();
        } catch (Exception e) {
            System.out.println("No previous data found. Starting fresh.");
        }
    }
}

abstract class Account implements Serializable {
    String accNo, pin;
    double balance;
    List<String> transactions = new ArrayList<>();

    public Account(String accNo, String pin, double balance) {
        this.accNo = accNo;
        this.pin = pin;
        this.balance = balance;
    }

    boolean validatePIN(String enteredPIN) {
        return this.pin.equals(enteredPIN);
    }

    void accountMenu() {
        Scanner sc = new Scanner(System.in);
        while (true) {
            System.out.println("\n1. Deposit  2. Withdraw  3. Transfer  4. View Balance  5. View History  6. Change PIN  7. Export Statement  8. Logout");
            System.out.print("Enter choice: ");
            int choice = sc.nextInt();
            switch (choice) {
                case 1 -> deposit();
                case 2 -> withdraw();
                case 3 -> transfer();
                case 4 -> viewBalance();
                case 5 -> viewHistory();
                case 6 -> changePIN();
                case 7 -> exportStatement();
                case 8 -> {
                    BankSystem.saveAccounts();
                    return;
                }
                default -> System.out.println("Invalid choice! Try again.");
            }
        }
    }

    void deposit() {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter deposit amount: ");
        double amount = sc.nextDouble();
        balance += amount - (amount * 0.01); // 1% deposit fee
        transactions.add("Deposited: $" + amount);
        System.out.println("✅ Deposit Successful! New Balance: $" + balance);
    }

    abstract void withdraw();

    void transfer() {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter recipient Account No: ");
        String toAcc = sc.nextLine();
        if (!BankSystem.accounts.containsKey(toAcc)) {
            System.out.println("❌ Recipient account not found!");
            return;
        }
        System.out.print("Enter amount to transfer: ");
        double amount = sc.nextDouble();
        if (balance < amount) {
            System.out.println("❌ Insufficient Balance!");
            return;
        }
        balance -= amount;
        BankSystem.accounts.get(toAcc).balance += amount;
        transactions.add("Transferred: $" + amount + " to " + toAcc);
        BankSystem.accounts.get(toAcc).transactions.add("Received: $" + amount + " from " + accNo);
        System.out.println("✅ Transfer Successful!");
    }

    void viewBalance() {
        System.out.println("💰 Current Balance: $" + balance);
    }

    void changePIN() {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter new PIN: ");
        this.pin = sc.nextLine();
        System.out.println("✅ PIN changed successfully!");
    }

    void exportStatement() {
        String fileName = accNo + "_statement.txt";
        try (PrintWriter writer = new PrintWriter(new FileWriter(fileName))) {
            writer.println("📜 Transaction Statement for Account: " + accNo);
            transactions.forEach(writer::println);
            writer.println("Current Balance: $" + balance);
            System.out.println("✅ Statement exported successfully: " + fileName);
        } catch (IOException e) {
            System.out.println("⚠ Error exporting statement!");
        }
    }

    void viewHistory() {
        System.out.println("📜 Transaction History:");
        transactions.forEach(System.out::println);
    }
}

class CheckingAccount extends Account {
    public CheckingAccount(String accNo, String pin, double balance) {
        super(accNo, pin, balance);
    }

    void withdraw() {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter withdrawal amount: ");
        double amount = sc.nextDouble();
        if (balance - amount - 1 < -500) { // Overdraft limit $500
            System.out.println("❌ Overdraft limit exceeded!");
            return;
        }
        balance -= (amount + 1); // $1 fee
        transactions.add("Withdrew: $" + amount);
        System.out.println("✅ Withdrawal Successful! New Balance: $" + balance);
    }
}

class SavingsAccount extends Account {
    public SavingsAccount(String accNo, String pin, double balance) {
        super(accNo, pin, balance);
    }

    void withdraw() {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter withdrawal amount: ");
        double amount = sc.nextDouble();
        if (balance - amount - 1 < 0) {
            System.out.println("❌ Insufficient funds!");
            return;
        }
        balance -= (amount + 1);
        transactions.add("Withdrew: $" + amount);
        System.out.println("✅ Withdrawal Successful! New Balance: $" + balance);
    }
}
