import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/api/poke_api_service.dart';
import 'package:pokemon_explorer/models/pokemon.dart';
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
  List<String> allNames = []; // ola ta onomata gia ton typo
  List<PokemonBasic> pokemons = [];
  int currentOffset = 0; // apo pou jekiname kathe neo fetch
  final int pageSize = 10;
  bool isLoading = true;
  final pokeApi = PokeApiService();

  @override
  void initState() {
    super.initState();
    fetchAllNamesForType();
  }

  Future<void> fetchAllNamesForType() async {
    try {
      allNames = await pokeApi.getPokemonNamesByType(widget.selectedType);
      currentOffset = 0;
      pokemons = [];
      await loadNextBatch(); // φόρτωσε το πρώτο batch αμέσως
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching Pokémon names: $e');
    }
  }

  Future<void> loadNextBatch() async {
    final nextNames = allNames.skip(currentOffset).take(pageSize).toList();

    final basicList = await Future.wait(
      nextNames.map((name) => pokeApi.getPokemonBasic(name)),
    );

    setState(() {
      pokemons.addAll(basicList);
      currentOffset += pageSize;
    });
  }

  // Future<void> fetchSelectedTypePokemons() async {
  //   try {
  //     final names = await pokeApi.getPokemonNamesByType(widget.selectedType);

  //     final basicList = await Future.wait(
  //       names.map((name) async {
  //         final basic = await pokeApi.getPokemonBasic(name);
  //         return {
  //           'name': basic.name,
  //           'image': basic.imageUrl,
  //           'type': widget.selectedType.title,
  //           'color': widget.selectedType.color,
  //         };
  //       }),
  //     );

  //     setState(() {
  //       pokemons = basicList;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching fire pokemons: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final int rowCount = (pokemons.length / 2).ceil();
    final bool hasMore = currentOffset < allNames.length;
    final int totalCount = hasMore ? rowCount + 1 : rowCount;

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
                        itemCount: totalCount,
                        itemBuilder: (context, index) {
                          if (index == rowCount) {
                            // Είμαστε στο τελευταίο index → δείξε το κουμπί
                            return Center(
                              child: ElevatedButton(
                                onPressed: loadNextBatch,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.all(14.w),
                                  backgroundColor: widget.selectedType.color,
                                  elevation: 4,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            );
                          }

                          final firstIndex = index * 2;
                          final secondIndex = firstIndex + 1;

                          final PokemonBasic first = pokemons[firstIndex];
                          final PokemonBasic? second =
                              secondIndex < pokemons.length
                              ? pokemons[secondIndex]
                              : null;

                          return Row(
                            children: [
                              Expanded(
                                child: PokemonCard(
                                  name: first.name,
                                  imageUrl: first.imageUrl,
                                  type: widget.selectedType.title,
                                  typeColor: widget.selectedType.color,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              second != null
                                  ? Expanded(
                                      child: PokemonCard(
                                        name: second.name,
                                        imageUrl: second.imageUrl,
                                        type: widget.selectedType.title,
                                        typeColor: widget.selectedType.color,
                                      ),
                                    )
                                  : const SizedBox(),
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
