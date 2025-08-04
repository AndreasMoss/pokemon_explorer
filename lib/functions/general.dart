String pokemonNameFormatter(String input) {
  if (input.isEmpty) return input;

  return input
      .split('-')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

/// xwrizei sto "-"
/// kanei capitalize
/// enwnei me keno " "
