public class Student {
    private String name;
    private int age;
    private String email;
    private String course;

    public Student(String name, int age, String email, String course) {
        this.name = name;
        this.age = age;
        this.email = email;
        this.course = course;
    }

    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getEmail() { return email; }
    public String getCourse() { return course; }
}
