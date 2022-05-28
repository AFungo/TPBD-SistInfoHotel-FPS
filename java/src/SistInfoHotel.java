
import java.io.BufferedReader;
import java.sql.*;

public class SistInfoHotel{
  public static void main(String[] args){
    try {
      String driver = "com.mysql.cj.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/gestion_hotel_sc?serverTimezone=UTC";
      String username = "root";
      String password = "root";

      // Load database driver if not already loaded.
      Class.forName(driver);
      // Establish network connection to database.
      Connection connection =
      DriverManager.getConnection(url, username, password);
      addNewClient(connection);
    }catch(ClassNotFoundException cnfe) {
      System.err.println("Error loading driver: " + cnfe);
      cnfe.printStackTrace();
    } catch(SQLException sqle) {
    	sqle.printStackTrace();
      System.err.println("Error connecting: " + sqle);
    }catch(Exception sqle) {
  	  sqle.printStackTrace();
      System.err.println("Error connecting: " + sqle);
    }

  }
  private static boolean addNewClient(Connection connection){
    // para trabajar con transacciones
    try{
      connection.setAutoCommit(false); 
      String query = "insert into cliente (dni_cliente,fecha_1ra_vez) values(?,?)";

      PreparedStatement statement = connection.prepareStatement(query);
      // Send query to database and store results.
      /*try
        {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        String sTexto = br.readLine();
        System.out.println(sTexto);
      } catch(Exception e) {
      }*/
      statement.setString(1,"42788292");
      statement.setString(2,Date.valueOf("1783-05-31").toString());
      statement.executeUpdate();
      // cierro la transaccion
      connection.commit();
      return true;             
    }catch(Exception sqle){
      System.err.println("Ups!! algos salio mal :/ " + sqle);
    }
    return false;
  }
}