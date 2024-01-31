String? nonEmpty(String? input) {
  if (input != null && input.isNotEmpty) {
    return null;
  } else {
    return 'Обязательное поле';
  }
}
