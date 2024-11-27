enum Operator{MAROC_TELECOM,ORANGE,INWI,UNKNOWN}

extension OperatorExtension on Operator {
  String get displayName {
    switch (this) {
      case Operator.MAROC_TELECOM:
        return "MAROC TELECOM";
      case Operator.ORANGE:
        return "ORANGE";
      case Operator.INWI:
        return "INWI";
      case Operator.UNKNOWN:
        return "UNKNOWN";
    }
  }
}