import 'package:flutter/material.dart';
import 'package:crud_sqlite_database/services/db_helper.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: crud(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class crud extends StatefulWidget {
  const crud({super.key});

  @override
  State<crud> createState() => _crudState();
}

class _crudState extends State<crud> {
TextEditingController crudcontroller= TextEditingController();

List<Map<String,dynamic>> data=[];
all()async{
  List<Map<String,dynamic>>datalist=
  await db_helper.instance.querydatabase();
  setState(() {
    data=datalist;
  });
}
 @override
 void initState() {
    // TODO: implement initState
    super.initState();
    all();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text("SQLite Local User Database"),
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 107, 129, 180),),
      floatingActionButton: FloatingActionButton(onPressed: (){
      crudcontroller.clear();
      crudwidget(0);
    },child: Icon(Icons.add),
    ),
    body: ListView.builder(
      itemCount: data.length,
      itemBuilder: (context,index){
        return 
        
  Card(
    margin: const EdgeInsets.all(8),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color(0xff76b5c5),
                      )),
          child: ListTile(
            title: Text(data[index]["name"]),
             subtitle:Row(
              children: [
              Text(data[index]["email"]),
              Text(data[index]["title"]),
              Text(data[index]["description"]),]),
          
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: (){
                  crudcontroller.text=data[index]["name"];
                  crudcontroller.text=data[index]["email"];
                  crudcontroller.text=data[index]["title"];
                  crudcontroller.text=data[index]["description"];
                  crudwidget(data[index]["id]"]);
          
                }, icon: Icon(Icons.edit)),
          
                IconButton(onPressed: (){
                 db_helper.instance.deleteRecord(data[index]["id"]);
                 all();
                  // crudwidget(data[index]["id]"]);
    
                }, icon: Icon(Icons.delete))
              ],
            ),
          ),
        );}),);}
        void crudwidget(int id){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: id==0 ? Center(child: Text("Add Data")): Text("Update Data"),
              content: Padding(padding: const EdgeInsets.all(12.0),
              child: Column(
              children: [
              TextField(
                controller: crudcontroller,
                decoration: InputDecoration(hintText: "Enter Your Name"),
              ),
              TextField(
                controller: crudcontroller,
                decoration: InputDecoration(hintText: "Enter Your Email"),
              ),
              TextField(
                controller: crudcontroller,
                decoration: InputDecoration(hintText: "Enter Title"),
              ),
              TextField(
                controller: crudcontroller,
                decoration: InputDecoration(hintText: "Enter Description"),
              ),
              ])),
              actions: [
                Center(
                  child: ElevatedButton(onPressed: (){
                    if(id==0){
                      String name=crudcontroller.text.toString();
                      String email=crudcontroller.text.toString();
                      String title=crudcontroller.text.toString();
                      String description=crudcontroller.text.toString();
                     db_helper.instance.insertRecord({db_helper.dt_name: name, db_helper.dt_email:email, db_helper.dt_title:title, db_helper.dt_desc:description });
                    } else {
                      String name = crudcontroller.text.toString();
                      String email=crudcontroller.text.toString();
                      String title=crudcontroller.text.toString();
                      String description=crudcontroller.text.toString();
                      db_helper.instance.updateRecord(
                          {db_helper.dt_name: name,db_helper.dt_email:email, db_helper.dt_title:title, db_helper.dt_desc:description, db_helper.dt_id: id});
                    }
                  all();
                    crudcontroller.clear();
                    Navigator.of(context).pop();  
                    
                  
                  }, child: id==0 ? Text("ADD"): Text("UPDATE")),
                )
              ],
              

            );

          });
        }
}