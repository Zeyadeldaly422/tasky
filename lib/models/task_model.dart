class TaskModel {
  final int id;
  final String taskName;
  final String taskDescription;
  final bool isHighpriority;
  bool isDone ;

  TaskModel({
    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.isHighpriority,
    this.isDone = false
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      taskName: json["taskName"],
      taskDescription: json["taskDescription"],
      isHighpriority: json["isHighpriority"],
      isDone: json["isDone"] ?? false
    ); //بتحول الداتا من جيسون لابجكت
  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighpriority": isHighpriority,
      "isDone": isDone
      //[(ket , value)ماب]بتحول الابجكت لجيسون
    };
  }
}
