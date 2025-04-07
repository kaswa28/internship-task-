package reports;

import billing.Billing;
import model.Patient;
import java.util.List;

public class ReportService {

    public void listAdmittedPatients(List<Patient> patients) {
        System.out.println("Admitted Patients:");
        if (patients == null || patients.isEmpty()) {
            System.out.println("No patients available.");
            return;
        }
        for (Patient patient : patients) {
            if (patient.getStatus() != null && "Admitted".equalsIgnoreCase((String) patient.getStatus())) {
                System.out.println("Patient ID: " + patient.getId() + ", Name: " + patient.getName());
            }
        }
    }

    public void listDischargedPatients(List<Patient> patients) {
        System.out.println("Discharged Patients:");
        if (patients == null || patients.isEmpty()) {
            System.out.println("No patients available.");
            return;
        }
        for (Patient patient : patients) {
            if (patient.getStatus() != null && "Discharged".equalsIgnoreCase((String) patient.getStatus())) {
                System.out.println("Patient ID: " + patient.getId() + ", Name: " + patient.getName());
            }
        }
    }

    public void listAppointmentsForDay(List<Patient> patients, String date) {
        System.out.println("Appointments on " + date + ":");
        if (patients == null || patients.isEmpty()) {
            System.out.println("No patients available.");
            return;
        }
        for (Patient patient : patients) {
            if (patient.getAppointmentDate() != null && patient.getAppointmentDate().equals(date)) {
                System.out.println("Patient ID: " + patient.getId() + ", Name: " + patient.getName());
            }
        }
    }

    public double calculateTotalEarnings(List<Billing> bills) {
        if (bills == null || bills.isEmpty()) {
            return 0.0;
        }
        double total = 0;
        for (Billing bill : bills) {
            if (bill.isPaid()) {
                total += bill.getTotalAmount();
            }
        }
        return total;
    }
}
