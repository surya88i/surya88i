import 'package:flutter/material.dart';
import 'package:music/Database/DbHelper.dart';
import 'package:music/Database/Employee.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DbHelper dbHelper;
  Future<List<Employee>> employees;
  int currentId;
  String title;
  String subtitle;
  bool isUpdating;
  final formKey=GlobalKey<FormState>();
  TextEditingController controller1=TextEditingController();
  TextEditingController controller2=TextEditingController();
  @override
  void initState() { 
    super.initState();
    isUpdating=false;
    dbHelper=DbHelper();
    refreshList();
  }
  refreshList(){
    setState(() {
      employees=dbHelper.getEmployee();
    });
  }
  @override
  void dispose() { 
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Database"),
      ),
      body: Column(
        children:<Widget>[
          form(),
          list(),
        ],
      ),
    );
  }
validator(){
  if(formKey.currentState.validate())
  {
    formKey.currentState.save();
    if (isUpdating) {
      Employee e=Employee(currentId, title, subtitle);
      dbHelper.update(e);
      setState(() {
        isUpdating=false;
      });
    } else {
      Employee e=Employee(null, title, subtitle);
      dbHelper.save(e);
    }
    controller1.text='';
    controller2.text='';
    refreshList();
  }
}
  Widget form(){
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextFormField(
              controller: controller1,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              onSaved: (val)=>title=val,
              validator: (val)=>val.length==0?'Enter title':null,
            ),
            TextFormField(
              controller: controller2,
               decoration: InputDecoration(
                labelText: 'Subtitle',
              ),
              onSaved: (val)=>subtitle=val,
              validator: (val)=>val.length==0?'Enter subtitle':null,
            ),
            SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlineButton(onPressed: ()=>validator(),child: Text(isUpdating?'Update':'Add')),
                OutlineButton(onPressed: (){
                  setState(() {
                    isUpdating=false;
                  });
                },
                child: Text('CANCEL')),
              ],
            ),
          ],
        ),
      ),
    );
  }
  SingleChildScrollView dataTable(List<Employee> employee){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Subtitle')),
          DataColumn(label: Text('Delete')),
        ], 
        rows: employee.map((e) => DataRow(cells: [
          DataCell(Text(e.title),onTap: (){
            setState(() {
              isUpdating=true;
              currentId=e.id;
            });
            controller1.text=e.title;
            controller2.text=e.subtitle;
          }),
          DataCell(Text(e.subtitle),
          onTap: (){
            setState(() {
              isUpdating=true;
              currentId=e.id;
            });
            controller1.text=e.title;
            controller2.text=e.subtitle;
          }
          ),
          DataCell(Icon(Icons.delete_outline),onTap: (){
            setState(() {
              dbHelper.delete(e.id);
              refreshList();
            });
          }),
        ])).toList(),
      ),
    );
  }
  Widget list(){
    return Expanded(
      child: FutureBuilder(
        future: employees,
        builder: (context,snapshot){
          if(snapshot.hasData)
          {
            return dataTable(snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
      }),
    );
  }
}