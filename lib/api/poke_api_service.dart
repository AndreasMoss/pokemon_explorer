import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_explorer/models/pokemon.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  /// Φέρνει τα ονόματα όλων των Pokémon για έναν συγκεκριμένο τύπο
  Future<List<String>> getPokemonNamesByType(PokemonType type) async {
    final typeName = type.title.toLowerCase();

    if (typeName == 'any') {
      final url = Uri.parse('$baseUrl/pokemon?limit=100');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((e) => e['name'] as String).toList();
      } else {
        throw Exception('Failed to fetch Pokémon list');
      }
    }

    final url = Uri.parse('$baseUrl/type/$typeName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pokemonList = data['pokemon'] as List;
      return pokemonList
          .map((entry) => entry['pokemon']['name'] as String)
          .toList();
    } else {
      throw Exception('Failed to fetch Pokémon of type $typeName');
    }
  }

  /// Παίρνει βασικά στοιχεία για ένα Pokémon (όνομα + εικόνα)
  Future<PokemonBasic> getPokemonBasic(String name) async {
    final url = Uri.parse('$baseUrl/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final imageUrl =
          data['sprites']['other']['official-artwork']['front_default'];
      return PokemonBasic(name: name, imageUrl: imageUrl ?? '');
    } else {
      throw Exception('Failed to fetch Pokémon details for $name');
    }
  }
}
