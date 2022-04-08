void main(List<String> args) {
  var s = "";
  for (var i = 0; i <= 5; i++) {
    for (var j = i; j < 5; j++) {
      if ((j > 5 - i) && (j < 5 + i)) {
        s += "*";
      } else {
        s += " ";
      }
    }
    print(s);
  }
}
