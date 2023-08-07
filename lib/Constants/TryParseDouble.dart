double tryParseDouble(dynamic value) {
  try {
    return double.parse(value.toString());
  } catch (e) {
    return 0.0;
  }
}
