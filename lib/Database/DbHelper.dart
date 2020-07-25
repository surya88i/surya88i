import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'Employee.dart';
class DbHelper
{
  static Database database;
  Future<Database> get db async{
    if(database!=null)
    {
      return database;
    }
    database=await initDb();
    return database;
  }
  initDb() async
  {
    var directory=await getApplicationDocumentsDirectory();
    var path=join(directory.path,'employee.db');
    var db=await openDatabase(path,version: 1,onCreate: onCreate);
    return db;
  }
  onCreate(Database db,int version) async
  {
    return await db.execute('CREATE TABLE Employee (id INTEGER PRIMARY KEY,title TEXT,subtitle TEXT)');
  }
  Future<Employee> save(Employee employee) async{
    var dbClient=await db;
    employee.id=await dbClient.insert('Employee', employee.toMap());
    return employee;
  }
  Future<List<Employee>> getEmployee() async{
     var dbClient=await db;
     List<Map> map=await dbClient.query('Employee',columns: ['id','title','subtitle']);
     List<Employee> employee=[];
     if(map.length>0)
     {
      for(int i=0;i<map.length;i++)
      {
         employee.add(Employee.fromMap(map[i]));
      }
     }
     return employee;
  }
  Future<int> delete(int id) async
  {
    var dbClient=await db;
    return await dbClient.delete('Employee',where: 'id=?',whereArgs: [id]);
  }
  Future<int> update(Employee employee) async
  {
    var dbClient=await db;
    return await dbClient.update('Employee',employee.toMap(),where: 'id=?',whereArgs: [employee.id]);
  }
  Future close() async{
    var dbClient=await db;
    return await dbClient.close();
  }
}