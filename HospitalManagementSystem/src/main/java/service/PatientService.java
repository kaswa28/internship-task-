package service;

import model.Patient;
import java.util.ArrayList;
import java.util.List;

public class PatientService {
    private final List<Patient> patients;

    public PatientService() {
        this.patients = new ArrayList<>();
    }

    public void addPatient(Patient patient) {
        patients.add(patient);
    }

    public List<Patient> getAllPatients() {
        return patients;
    }

    public Patient findPatientByName(String name) {
        for (Patient patient : patients) {
            if (patient.getName().equalsIgnoreCase(name)) {
                return patient;
            }
        }
        return null;
    }

    public boolean removePatient(String name) {
        return patients.removeIf(patient -> patient.getName().equalsIgnoreCase(name));
    }
}
