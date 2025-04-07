import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class StudentDAO {
    public void registerStudent(Student student) {
        String sql = "INSERT INTO students (name, age, email, course) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, student.getName());
            stmt.setInt(2, student.getAge());
            stmt.setString(3, student.getEmail());
            stmt.setString(4, student.getCourse());

            stmt.executeUpdate();
            System.out.println("Student registered successfully!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
