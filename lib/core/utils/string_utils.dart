String fillStringToLength(String data, int length, {String filler = " "}) {
  if (filler.length > 1) {
    throw new Exception("Filler can't be more then one character");
  }

  int diff = length - data.length;

  if (diff < 0 || diff == 0) {
    return data;
  }

  for (int i = 0; i < diff * 2; i++) {
    data += filler;
  }
  return data;
}
