package service;

import model.Staff;
import java.util.ArrayList;
import java.util.List;

public class StaffService {
    private final List<Staff> staffList;

    public StaffService() {
        this.staffList = new ArrayList<>();
    }

    public void addStaff(Staff staff) {
        staffList.add(staff);
    }

    public List<Staff> getAllStaff() {
        return staffList;
    }

    public Staff findStaffByName(String name) {
        for (Staff staff : staffList) {
            if (staff.getName().equalsIgnoreCase(name)) {
                return staff;
            }
        }
        return null;
    }

    public boolean removeStaff(String name) {
        return staffList.removeIf(staff -> staff.getName().equalsIgnoreCase(name));
    }
}
