package billing;

public class Billing {
    private final int patientId;
    private final double consultationFees;
    private final double roomCharges;
    private final double otherServicesCharges;
    private double totalAmount;
    private boolean isPaid;

    public Billing(int patientId, double consultationFees, double roomCharges, double otherServicesCharges) {
        this.patientId = patientId;
        this.consultationFees = consultationFees;
        this.roomCharges = roomCharges;
        this.otherServicesCharges = otherServicesCharges;
        calculateTotalAmount();
        this.isPaid = false; // Default: unpaid
    }

    private void calculateTotalAmount() {
        this.totalAmount = consultationFees + roomCharges + otherServicesCharges;
    }

    public void markAsPaid() {
        this.isPaid = true;
    }

    public void displayBill() {
        System.out.println("Billing Details:");
        System.out.println("Patient ID: " + patientId);
        System.out.println("Consultation Fees: " + consultationFees);
        System.out.println("Room Charges: " + roomCharges);
        System.out.println("Other Services: " + otherServicesCharges);
        System.out.println("Total Amount: " + totalAmount);
        System.out.println("Status: " + (isPaid ? "Paid" : "Unpaid"));
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public boolean isPaid() {
        return isPaid;
    }
}
