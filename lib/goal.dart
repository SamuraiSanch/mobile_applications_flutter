class Goal {
  final int? id;
  final String text;
  final bool isCompleted;

  Goal({required this.text, this.id, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as int?, 
      text: map['text'] as String, 
      isCompleted: map['isCompleted'] == 1, 
  );
}

}
