String? convertToString(dynamic val) {
  if (val == null) return null;
  return val.toString(); // Turns 0 into "0", and "1" stays "1"
}
