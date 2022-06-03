import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.*;

public class SistInfoHotel{
  private static Connection connection;




  public static void main(String[] args){
    createConnection();
    logicView();//addNewClient(connection);
  }


/**
 * Este metodo establece una coneccion con la base datos.
 */
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

/* 
 * Este metodo lee la opcion escrita por terminal y ejecuta el metodo correspondiente.
 */
  private static void logicView(){
    try{
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in)); 

      
      boolean exit = false;

      while(!exit){
        view();
        String sTexto = br.readLine();
        switch(sTexto){
          case "0": if(addNewClient(connection)) System.out.println("---Cliente añadido correctamente---\n");
                  break;
          case "1": if(addNewRoom(connection)) System.out.println("---Habitacion añadida correctamente---\n");
                  break;
          case "2": if(addClientInRoom(connection)) System.out.println("---Alojamiento cargado correctamente--- \n"); ;
          break;

          case "3": if(viewRoomHistory(connection)) System.out.println("---Alojamiento cargado correctamente---\n") ;
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

/*
 * Menu visual.
 */
  private static void view(){
    System.out.println("Sistema de informacion Hotelera");
    System.out.println("0- Añadir cliente");
    System.out.println("1- Añadir habitacion");
    System.out.println("2- Añadir alojamiento");
    System.out.println("3- Ver historial de la habitacion");
    System.out.println("9- Salir");
    System.out.print("Opcion: ");
  }
/*
 * Es un metodo que agrega un nuevo cliente a la base de datos
 */
  private static boolean addNewClient(Connection connection){
    String name = "";
    String surname = "";
    String dni = "";
    String birthDate = "";
    String firstTimeDate = "";

    //Pide los datos por consola
    try{
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));//declarar lector para la consola
      System.out.println("---Complete los datos personales del cliente---");
      System.out.print("Nombre: ");
      name = br.readLine();//devuelve lo ingresado por consola
      System.out.print("Apellido: ");
      surname = br.readLine();
      System.out.print("DNI: ");
      dni = br.readLine();
      System.out.println("-Fecha de nacimiento-");
      System.out.println("El formato de la fecha es  AA-MM-DD");
      System.out.print("Fecha: ");
      birthDate = br.readLine();
      System.out.println("---Ingrese la fecha del primer alojamiento---");
      System.out.println("El formato de la fecha es  AA-MM-DD");
      System.out.print("Fecha: ");
      firstTimeDate = br.readLine();
    } catch(Exception e) {
      System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------\n");
    }
    //carga la base de datos
    try{
      connection.setAutoCommit(false);
      //añadir una nueva persona a la base de datos
      String query = "insert into persona (dni_persona,nombre,apellido,fecha_nac) values(?,?,?,?)";//tener en cuenta q values(?,?,..,?) segun cuantos atributos cargues
      PreparedStatement statement = connection.prepareStatement(query);
      statement.setString(1,dni);//los values empiezan de 1y matchean con el orden del insert
      statement.setString(2,name);
      statement.setString(3,surname);
      statement.setString(4, birthDate);
      statement.executeUpdate();
    
      query = "insert into cliente (dni_cliente,fecha_1ra_vez) values(?,?)";
      statement = connection.prepareStatement(query);
      statement.setString(1,dni);
      statement.setString(2,firstTimeDate);
      statement.executeUpdate();
      // cierro la transaccion
      connection.commit();
      
      //Para limpiar la consola
      for (int i = 0; i < 15; i++) {
        System.out.println("\n");
      }

      return true;             
    }catch(SQLException sqle){
      try{
        System.err.println("\n Ups algo salio mal :/ \n" + "--------- \n" + sqle + "\n---------\n");
        connection.rollback();
      }catch(Exception e){
        System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------\n");  
      }
    }
    return false;
  }

/*
 * Metodo que añade una nueva habitacion a la base de datos
 */
  private static boolean addNewRoom(Connection connection){
    // para trabajar con transacciones
    String nro_hab = "";
    String cant_camas = "";
    String cod_tipo = "";
    //Pide los datos por consola
    try{
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));//declarar lector para la consola
      System.out.println("---Complete los datos de la habitacion---");
      System.out.print("Numero habitacion: ");
      nro_hab = br.readLine();//devuelve lo ingresado por consola
      System.out.print("Cantidad de camas: ");
      cant_camas = br.readLine();
      System.out.println("---Tipos de habitacion---");
      System.out.println("   Cod   |||  precio ");
      System.out.println("   001   |||  $2500");
      System.out.println("   002   |||  $3500");
      System.out.println("   003   |||  $4000");
      System.out.println("   004   |||  $5900");
      System.out.println("-------------------------");
      System.out.print("Codigo del tipo: ");
      cod_tipo = br.readLine();
     } catch(Exception e) {
      System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------\n");
    }

    //se cargan los datos obtenidos a la base de datos
    try{
      connection.setAutoCommit(false); 
      String query = "insert into habitacion (nro_habitacion, cant_camas, cod_tipo) values(?,?,?)";

      PreparedStatement statement = connection.prepareStatement(query);
      
      statement.setString(1,nro_hab);
      statement.setString(2, cant_camas);
      statement.setString(3,cod_tipo);
      statement.executeUpdate();
      // cierro la transaccion
      connection.commit();
      for (int i = 0; i < 15; i++) {
        System.out.println("\n");
      }
      return true;             
    }catch(SQLException sqle){
      try{
        System.err.println("\n Ups algo salio mal :/ \n" + "--------- \n" + sqle + "\n---------\n");
        connection.rollback();
      }catch(Exception e){
        System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------\n");  
      }
    }
    return false;
  
  }

  /*
   * añade un alojamiento de un cliente a una habitacion en una fecha determinada
   */
  private static boolean addClientInRoom(Connection connection){
    String dni_cli = "";
    String nro_hab = "";
    String fecha_oc = "";
    String pre_n = "";
    String cant_d = "";

    //pide los datos por consola
    try{
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));//declarar lector para la consola
      System.out.println("---Ingrese los datos de la estadia---");
      System.out.print("DNI cliente: ");
      dni_cli = br.readLine();//devuelve lo ingresado por consola
      System.out.print("Nro habitacion: ");
      nro_hab = br.readLine();
      System.out.println("-Fecha en la que se alojo-");
      System.out.println("El formato de la fecha es  AA-MM-DD");
      System.out.print("Fecha: ");
      fecha_oc = br.readLine();
      System.out.print("Cantiad de dias: ");
      cant_d = br.readLine();
      System.out.print("Precio por noche: ");
      pre_n = br.readLine();
    } catch(Exception e) {
      System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------\n");
    }

    //carga los datos a la base de datos
    try{
      connection.setAutoCommit(false); 
      String query = "insert into ocupada (dni_cliente, nro_habitacion, fecha_ocup, precio_noche, cant_dias) values(?,?,?,?,?)";

      PreparedStatement statement = connection.prepareStatement(query);
      
      statement.setString(1,dni_cli);
      statement.setString(2, nro_hab);
      statement.setString(3,fecha_oc);
      statement.setString(4,pre_n);
      statement.setString(5,cant_d);
      statement.executeUpdate();
      // cierro la transaccion
      connection.commit();
      for (int i = 0; i < 15; i++) {
        System.out.println("\n");
      }
      return true;             
    }catch(SQLException sqle){
      try{
        System.err.println("\n Ups algo salio mal :/ \n" + "--------- \n" + sqle + "\n---------\n");
        connection.rollback();
      }catch(Exception e){
        System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------\n");  
      }
    }
    return false;
  }

  /*
   * Muestra los datos de alojamiento de una habitacion en especifico
   */
  private static boolean viewRoomHistory(Connection connection){
    String nro_hab = "";
    //pide los datos por consola
    try{
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));//declarar lector para la consola
      System.out.println("\n---Ingrese el numero de habitacion---");
      System.out.print("Numero habitacion: ");
      nro_hab = br.readLine();//devuelve lo ingresado por consola
    }catch(Exception e) {
      System.err.println("\n ERROR \n" + "--------- \n" + e + "\n ---------\n");
    }
    
    //consulta a la base de datos y da por salidala info obtenida
    try{
      String query = "select * from cliente cli inner join persona pe on (cli.dni_cliente = pe.dni_persona) inner join ocupada oc on (oc.dni_cliente = cli.dni_cliente and oc.nro_habitacion =" + nro_hab + ")";
      PreparedStatement statement = connection.prepareStatement(query);
      ResultSet resultSet = statement.executeQuery();
      System.out.println("\n \n Registro historico de la habitacion " + nro_hab);
      System.out.println("Nombre  |  Apellido  |  DNI  |  Fecha");
      while(resultSet.next()){
        System.out.print(resultSet.getString("nombre")+ "  |");
        System.out.print(resultSet.getString("apellido")+ "  |");
        System.out.print(resultSet.getString("dni_cliente")+ "  |");
        System.out.println(resultSet.getString("fecha_ocup"));
      }
      System.out.println("\n\n");
      return true;
    }catch(SQLException e){
      System.err.println("Ups!! algos salio mal :/ " + e + "\n");     
    }
    return false;
  }
}