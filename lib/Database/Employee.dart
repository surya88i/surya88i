class Employee
{
  int id;
  String title;
  String subtitle;
  Employee(this.id,this.title,this.subtitle);

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'id':id,
      'title':title,
      'subtitle':subtitle,
    };
    return map;
  }
  Employee.fromMap(Map<String,dynamic> map){
    Employee(
      id=map['id'],
      title=map['title'],
      subtitle=map['subtitle'],
    );
  }
}