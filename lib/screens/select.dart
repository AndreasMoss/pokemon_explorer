import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/api/poke_api_service.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';
import 'package:pokemon_explorer/screens/is_loading.dart';
import 'package:pokemon_explorer/widgets/pokemon_card.dart';

class Select extends StatefulWidget {
  const Select({super.key, required this.selectedType, required this.test});

  final PokemonType selectedType;
  final String test;

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  List<Map<String, dynamic>> pokemons = [];
  bool isLoading = true;
  final pokeApi = PokeApiService();

  @override
  void initState() {
    super.initState();
    fetchFirePokemons();
  }

  Future<void> fetchFirePokemons() async {
    try {
      final names = await pokeApi.getPokemonNamesByType(widget.selectedType);

      final basicList = await Future.wait(
        names.map((name) async {
          final basic = await pokeApi.getPokemonBasic(name);
          return {
            'name': basic.name,
            'image': basic.imageUrl,
            'type': widget.selectedType.title,
            'color': widget.selectedType.color,
          };
        }),
      );

      setState(() {
        pokemons = basicList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching fire pokemons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("The selected type is: ${widget.test}");
    // const List<Map<String, dynamic>> pokemons = [
    //   {
    //     'name': 'Bulbasaur',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    //     'type': 'Grass',
    //     'color': Color(0xFFB9FBC0),
    //   },
    //   {
    //     'name': 'Charmander',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
    //     'type': 'Fire',
    //     'color': Color(0xFFFFA07A),
    //   },
    //   {
    //     'name': 'Squirtle',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
    //     'type': 'Water',
    //     'color': Color(0xFF87CEFA),
    //   },
    //   {
    //     'name': 'Pikachu',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
    //     'type': 'Electric',
    //     'color': Color(0xFFF9F871),
    //   },
    //   {
    //     'name': 'Gengar',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/94.png',
    //     'type': 'Ghost',
    //     'color': Color(0xFF9B5DE5),
    //   },
    //   {
    //     'name': 'Eevee',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png',
    //     'type': 'Normal',
    //     'color': Color(0xFFEDEDED),
    //   },
    //   {
    //     'name': 'Snorlax',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png',
    //     'type': 'Normal',
    //     'color': Color(0xFFB0BEC5),
    //   },
    //   {
    //     'name': 'Lucario',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/448.png',
    //     'type': 'Fighting',
    //     'color': Color(0xFFB388FF),
    //   },
    //   {
    //     'name': 'Mewtwo',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/150.png',
    //     'type': 'Psychic',
    //     'color': Color(0xFFCE93D8),
    //   },
    //   {
    //     'name': 'Rayquaza',
    //     'image':
    //         'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/384.png',
    //     'type': 'Dragon',
    //     'color': Color(0xFF80CBC4),
    //   },
    // ];
    final int rowCount = (pokemons.length / 2).ceil();

    return isLoading
        ? IsLoadingScreen()
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF000000),
            ),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select your ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'NexaRegular',
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Pokémon',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NexaX',
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Image.asset(
                          'assets/images/pokeball.png',
                          width: 27.w,
                          height: 27.h,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rowCount,
                        itemBuilder: (context, index) {
                          final firstIndex = index * 2;
                          final secondIndex = firstIndex + 1;

                          final first = pokemons[firstIndex];
                          final second = secondIndex < pokemons.length
                              ? pokemons[secondIndex]
                              : null;

                          return Row(
                            children: [
                              Expanded(
                                child: PokemonCard(
                                  name: first['name'],
                                  imageUrl: first['image'],
                                  type: first['type'],
                                  typeColor: first['color'],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: second != null
                                    ? PokemonCard(
                                        name: second['name'],
                                        imageUrl: second['image'],
                                        type: second['type'],
                                        typeColor: second['color'],
                                      )
                                    : const SizedBox(), // κενή θέση αν μονός αριθμός
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
