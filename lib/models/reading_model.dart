class Reading {
  final String date;
  final String title;
  final String reference;
  final String content;
  bool isBookmarked;

  Reading({
    required this.date,
    required this.title,
    required this.reference,
    required this.content,
    this.isBookmarked = false,
  });

  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      date: map['date'] ?? '',
      title: map['title'] ?? '',
      reference: map['reference'] ?? '',
      content: map['content'] ?? '',
      isBookmarked: map['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'reference': reference,
      'content': content,
      'isBookmarked': isBookmarked,
    };
  }
}
