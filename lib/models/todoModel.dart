
class TodoModel{
 int id;
 String title;
 DateTime date;
 String description;
String urgency;
String get formattedDate{
String datez =date.toString();
return datez;
} 
 
TodoModel({this.date,this.description,this.id,this.title, this.urgency});
Map<String, dynamic> tomap(){
    return {'id':this.id,
    'title': this.title,
    'description':this.description,
    'urgency': this.urgency,
    'date': this.date};
  }
  TodoModel.totodolist(Map<String, dynamic> tomap){
    this.title=tomap['title'];
    this.id=tomap['id'];
    this.description=tomap['description'];
    this.date=DateTime.parse(tomap['date']);
    this.urgency=tomap['urgency'];
  }



}