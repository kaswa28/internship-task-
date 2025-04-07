package com.mycompany.hospitalmanagementsystem;

import billing.Billing;
import model.Patient;
import model.Staff;
import reports.ReportService;
import service.PatientService;
import service.StaffService;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;


public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Services
        PatientService patientService = new PatientService();
        StaffService staffService = new StaffService();
        ReportService reportService = new ReportService();

        // Data storage
        List<Billing> billingRecords = new ArrayList<>();
        List<Patient> patients = new ArrayList<>();

        // Main Menu
        while (true) {
            System.out.println("\n--- Hospital Management System ---");
            System.out.println("1. Add Patient");
            System.out.println("2. View Patients");
            System.out.println("3. Remove Patient");
            System.out.println("4. Add Staff");
            System.out.println("5. View Staff");
            System.out.println("6. Remove Staff");
            System.out.println("7. Generate Bill");
            System.out.println("8. View Reports");
            System.out.println("9. Exit");
            System.out.print("Choose an option: ");

            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume the newline character

            switch (choice) {
                case 1 -> {
                    // Add Patient
                    System.out.print("Enter patient name: ");
                    String pName = scanner.nextLine();
                    System.out.print("Enter patient age: ");
                    int pAge = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Enter patient illness: ");
                    String pIllness = scanner.nextLine();
                    patientService.addPatient(new Patient(pName, pAge, pIllness));
                    System.out.println("Patient added successfully!");
                }

                case 2 -> {
                    // View Patients
                    System.out.println("\nPatients:");
                    for (Patient patient : patientService.getAllPatients()) {
                        System.out.println(patient);
                    }
                }

                case 3 -> {
                    // Remove Patient
                    System.out.print("Enter patient name to remove: ");
                    String removePatientName = scanner.nextLine();
                    if (patientService.removePatient(removePatientName)) {
                        System.out.println("Patient removed successfully!");
                    } else {
                        System.out.println("Patient not found!");
                    }
                }

                case 4 -> {
                    // Add Staff
                    System.out.print("Enter staff name: ");
                    String sName = scanner.nextLine();
                    System.out.print("Enter staff role: ");
                    String sRole = scanner.nextLine();
                    System.out.print("Enter staff salary: ");
                    double sSalary = scanner.nextDouble();
                    scanner.nextLine(); // Consume newline
                    staffService.addStaff(new Staff(sName, sRole, sSalary));
                    System.out.println("Staff added successfully!");
                }

                case 5 -> {
                    // View Staff
                    System.out.println("\nStaff:");
                    for (Staff staff : staffService.getAllStaff()) {
                        System.out.println(staff);
                    }
                }

                case 6 -> {
                    // Remove Staff
                    System.out.print("Enter staff name to remove: ");
                    String removeStaffName = scanner.nextLine();
                    if (staffService.removeStaff(removeStaffName)) {
                        System.out.println("Staff removed successfully!");
                    } else {
                        System.out.println("Staff not found!");
                    }
                }

                case 7 -> {
                    // Generate Bill
                    System.out.print("Enter Patient ID: ");
                    int patientId = scanner.nextInt();
                    System.out.print("Enter Consultation Fees: ");
                    double consultationFees = scanner.nextDouble();
                    System.out.print("Enter Room Charges: ");
                    double roomCharges = scanner.nextDouble();
                    System.out.print("Enter Other Services Charges: ");
                    double otherCharges = scanner.nextDouble();
                    scanner.nextLine(); // Consume newline

                    Billing bill = new Billing(patientId, consultationFees, roomCharges, otherCharges);
                    billingRecords.add(bill);
                    bill.displayBill();
                }

                case 8 -> {
                    // View Reports
                    System.out.println("\n--- Reports ---");
                    System.out.println("1. List Admitted Patients");
                    System.out.println("2. List Discharged Patients");
                    System.out.println("3. Appointments for Specific Day");
                    System.out.println("4. Total Earnings");
                    System.out.print("Choose an option: ");
                    int reportChoice = scanner.nextInt();
                    scanner.nextLine(); // Consume newline

                    switch (reportChoice) {
                        case 1 -> reportService.listAdmittedPatients(patients);
                        case 2 -> reportService.listDischargedPatients(patients);
                        case 3 -> {
                            System.out.print("Enter Date (YYYY-MM-DD): ");
                            String date = scanner.nextLine();
                            reportService.listAppointmentsForDay(patients, date);
                        }
                        case 4 -> {
                            double totalEarnings = reportService.calculateTotalEarnings(billingRecords);
                            System.out.println("Total Earnings: " + totalEarnings);
                        }
                        default -> System.out.println("Invalid Option!");
                    }
                }


                case 9 -> {
                    System.out.println("Exiting...");
                    scanner.close();
                    return;
                }

                default -> System.out.println("Invalid Option! Please try again.");
            }
        }
    }
}
