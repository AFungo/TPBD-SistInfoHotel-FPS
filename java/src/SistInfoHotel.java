import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.*;

public class SistInfoHotel{
  private static Connection connection;
  public static void main(String[] args){
    
    try {
      String driver = "com.mysql.cj.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/gestion_hotel_sc?serverTimezone=UTC";
      String username = "root";
      String password = "root";

      // Load database driver if not already loaded.
      Class.forName(driver);
      // Establish network connection to database.
      connection =
      DriverManager.getConnection(url, username, password);
      logicView();//addNewClient(connection);
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
  private static void logicView(){
    try{
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

      
      boolean exit = false;
      view();
      while(!exit){
        String sTexto = br.readLine();
        switch(sTexto){
          case "0": addNewClient(connection);
                  break;
          case "1": addNewRoom(connection);
                  break;
          case "2": viewRoomHistory(connection);
                  break;
          case "9": exit = true;
                  break;
          default: break;
        }
      }
  }catch(Exception e) {
    System.err.println("ERROR" + e);  
  }
  }
  private static void view(){
    System.out.println("Sistema de informacion Hotelera");
    System.out.println("0- Añadir cliente");
    System.out.println("1- Añadir habitacion");
    System.out.println("2- Ver historial de la habitacion");
    System.out.println("9- Salir");
    System.out.println("Opcion");
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
  private static boolean addNewRoom(Connection connection){
    throw new IllegalStateException("metodo no implementado");
  }
  private static boolean viewRoomHistory(Connection connection){
    throw new IllegalAccessError("Falta implenetar");
  }
}