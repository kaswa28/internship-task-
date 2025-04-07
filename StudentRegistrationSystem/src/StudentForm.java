import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class StudentForm extends JFrame {
    private JTextField nameField, ageField, emailField, courseField;
    private JButton submitButton;
    private StudentDAO studentDAO;

    public StudentForm() {
        setTitle("Student Registration Form");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new GridLayout(5, 2));

        studentDAO = new StudentDAO();

        add(new JLabel("Name:"));
        nameField = new JTextField();
        add(nameField);

        add(new JLabel("Age:"));
        ageField = new JTextField();
        add(ageField);

        add(new JLabel("Email:"));
        emailField = new JTextField();
        add(emailField);

        add(new JLabel("Course:"));
        courseField = new JTextField();
        add(courseField);

        submitButton = new JButton("Register");
        add(submitButton);

        submitButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String name = nameField.getText();
                int age = Integer.parseInt(ageField.getText());
                String email = emailField.getText();
                String course = courseField.getText();

                Student student = new Student(name, age, email, course);
                studentDAO.registerStudent(student);

                JOptionPane.showMessageDialog(null, "Student Registered Successfully!");
            }
        });

        setVisible(true);
    }

    public static void main(String[] args) {
        new StudentForm();
    }
}
