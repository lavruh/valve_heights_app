class MeasureSequence {
  MeasureSequence? subSequence;
  List<String> sequence;
  int currentIndex;

  MeasureSequence({this.subSequence, required this.sequence, String? currentId})
    : currentIndex = currentId == null ? 0 : sequence.indexOf(currentId);

  String get currentId => sequence[currentIndex];
  bool isRoundCompleted() {
    return currentId == sequence.last &&
        (subSequence?.isRoundCompleted() ?? true);
  }

  setCurrentPath(String path) {
    final sub = subSequence;
    String input = path;
    for (int i = 0; i < sequence.length; i++) {
      final id = sequence[i];
      if (input.startsWith(id)) {
        currentIndex = i;
        if(input.length < id.length + 1) return;
        input = input.substring(id.length + 1);
        break;
      }
    }
    if (sub != null) {
      sub.setCurrentPath(input);
    }
  }

  String getCurrentPath() {
    final sub = subSequence;
    String path = currentId;
    if (sub != null) {
      path = "$currentId.${sub.getCurrentPath()}";
    }
    return path;
  }

  String generateNextPath() {
    if (sequence.isEmpty) throw Exception("Sequence is empty");
    final sub = subSequence;

    String path = currentId;
    if (sub != null) {
      path = "$currentId.${sub.generateNextPath()}";
      if (sub.isRoundCompleted()) _setNextIndex();
      return path;
    }
    _setNextIndex();
    return currentId;
  }

  _setNextIndex() => currentIndex = (currentIndex + 1) % sequence.length;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() {
    return {
      'subSequence': subSequence?.toMap(),
      'sequence': sequence,
      'currentIndex': currentIndex,
    };
  }

  factory MeasureSequence.fromMap(Map<String, dynamic> map) {
    return MeasureSequence(
      subSequence: map['subSequence'] != null ? MeasureSequence.fromMap(map['subSequence']) : null,
      sequence: List<String>.from(map['sequence']),
      currentId: map['sequence'][map['currentIndex']],
    );
  }
}
