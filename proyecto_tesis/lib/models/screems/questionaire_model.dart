class Option {
  final int id;
  final String optionText;
  final int order;

  Option(this.id, this.optionText, this.order);
}

class Question {
  final int id;
  final String questionText;
  final int order;
  final List<Option> options;

  Question(this.id, this.questionText, this.order, this.options);
}

class CuestionarioModel{
  final String answerText;
  final int optionId;
  final int questionId;

  CuestionarioModel({
    required this.answerText,
    required this.optionId,
    required this.questionId,
  });

  Map<String,dynamic> toJson(){
    return {
      'answerText': answerText,
      'optionId':  optionId,
      'questionId': questionId
    };
  }
}