import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.*;

public class SistInfoHotel{
  private static Connection connection;




  public static void main(String[] args){
    createConnection();
    logicView();//addNewClient(connection);
  }



  private static void createConnection(){
    try {
      String driver = "com.mysql.cj.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/gestion_hotel_sc?serverTimezone=UTC";
      String username = "root";
      String password = "root";

      // Load database driver if not already loaded.
      Class.forName(driver);
      // Establish network connection to database.
      connection = DriverManager.getConnection(url, username, password);
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

      while(!exit){
        view();
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
    try{
      String name = "";
      String surname = "";
      String dni = "";
      String firstTimeDate = "";
      try{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));//declarar lector para la consola
        System.out.println("---Complete los datos personales del cliente---");
        System.out.print("Nombre: ");
        name = br.readLine();//devuelve lo ingresado por consola
        System.out.print("Apellido: ");
        surname = br.readLine();
        System.out.print("DNI: ");
        dni = br.readLine();
        System.out.println("---Ingrese la fecha del primer alojamiento---");
        System.out.println("El formato de la fecha es  AA-MM-DD");
        System.out.print("Fecha: ");
        firstTimeDate = br.readLine();
      } catch(Exception e) {
        System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------");
      }
      connection.setAutoCommit(false);
      //añadir una nueva persona a la base de datos
      String query = "insert into persona (dni_persona,nombre,apellido) values(?,?,?)";//tener en cuenta q values(?,?,..,?) segun cuantos atributos cargues
      PreparedStatement statement = connection.prepareStatement(query);
      statement.setString(1,dni);//los values empiezan de 1y matchean con el orden del insert
      statement.setString(2,name);
      statement.setString(3,surname);
      statement.executeUpdate();

      query = "insert into cliente (dni_cliente,fecha_1ra_vez) values(?,?)";
      statement = connection.prepareStatement(query);
      statement.setString(1,dni);
      statement.setString(2,firstTimeDate);
      statement.executeUpdate();
      // cierro la transaccion
      connection.commit();
      return true;             
    }catch(Exception sqle){
      System.err.println("\n Ups algo salio mal :/ \n" + "--------- \n" + sqle + "\n---------");
    }
    return false;
  }
  private static boolean addNewRoom(Connection connection){
    // para trabajar con transacciones
    try{
      connection.setAutoCommit(false); 
      String query = "insert into habitacion (nro_habitacion, cant_camas, cod_tipo) values(?,?,?)";

      PreparedStatement statement = connection.prepareStatement(query);
      // Send query to database and store results.
      /*try
        {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        String sTexto = br.readLine();
        System.out.println(sTexto);
      } catch(Exception e) {
      }*/
      statement.setString(1,"99");
      statement.setString(2,Date.valueOf("2").toString());
      statement.setString(3,Date.valueOf("002").toString());
      statement.executeUpdate();
      // cierro la transaccion
      connection.commit();
      return true;             
    }catch(Exception sqle){
      System.err.println("Ups!! algos salio mal :/ " + sqle);
    }
    return false;
  
  }
  private static boolean viewRoomHistory(Connection connection){
    throw new IllegalAccessError("Falta implenetar");
  }
}