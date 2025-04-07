package model;

public class Staff {
    private String name;
    private String role;
    private double salary;

    public Staff(String name, String role, double salary) {
        this.name = name;
        this.role = role;
        this.salary = salary;
    }

    // Getters and setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    @Override
    public String toString() {
        return "Staff{name='" + name + "', role='" + role + "', salary=" + salary + "}";
    }
}
