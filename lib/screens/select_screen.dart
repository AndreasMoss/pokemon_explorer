import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemon_explorer/api/poke_api_service.dart';
import 'package:pokemon_explorer/functions/general.dart';
import 'package:pokemon_explorer/models/pokemon.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';
import 'package:pokemon_explorer/screens/is_loading_screen.dart';
import 'package:pokemon_explorer/widgets/pokemon_card.dart';

class Select extends StatefulWidget {
  const Select({super.key, required this.selectedType});

  final PokemonType selectedType;

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  List<String> allNames = [];
  List<String> filteredNames = [];
  List<PokemonBasic> pokemons = [];

  int currentOffset = 0;
  final int pageSize = 10;
  bool isLoading = true;

  // Search
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  Timer? _debounce;

  // Anti-race
  int _queryVersion = 0; // αυξάνει σε κάθε νέο φίλτρο
  bool _isLoadingBatch = false; // για να μη τρέχουν παράλληλα batches

  final pokeApi = PokeApiService();

  @override
  void initState() {
    super.initState();
    fetchAllNamesForType();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> fetchAllNamesForType() async {
    try {
      allNames = await pokeApi.getPokemonNamesByType(widget.selectedType);
      filteredNames = List.of(allNames);
      currentOffset = 0;
      pokemons.clear();

      // νέο version για το αρχικό load
      _queryVersion++;
      await loadNextBatch(_queryVersion);

      setState(() => isLoading = false);
    } catch (e) {
      print('Error fetching Pokémon names: $e');
    }
  }

  bool _isValidHttpUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> loadNextBatch([int? version]) async {
    final int localVersion = version ?? _queryVersion;
    if (_isLoadingBatch) return;
    _isLoadingBatch = true;

    try {
      final nextNames = filteredNames
          .skip(currentOffset)
          .take(pageSize)
          .toList();
      if (nextNames.isEmpty) return;

      final fetched = await Future.wait(
        nextNames.map((name) => pokeApi.getPokemonBasic(name)),
      );

      if (localVersion != _queryVersion) return;

      // 👇 Κρατάμε μόνο όσα έχουν σωστή εικόνα
      final withImages = fetched
          .where((p) => _isValidHttpUrl(p.imageUrl))
          .toList();

      setState(() {
        pokemons.addAll(withImages);
        currentOffset += pageSize;
      });
    } finally {
      _isLoadingBatch = false;
    }
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final q = val.trim().toLowerCase();
      _query = val;

      // Υπολογίζουμε το νέο filtered set
      if (q.isEmpty) {
        filteredNames = List.of(allNames);
      } else {
        filteredNames = allNames.where((raw) {
          final pretty = pokemonNameFormatter(raw).toLowerCase();
          // διάλεξε ένα:
          return pretty.contains(q); // αρχίζει με το query (strict)
          // return pretty.contains(q);  // ή περιέχει το query (χαλαρό)
        }).toList();
      }

      // bump version για να ακυρώσουμε παλιές async απαντήσεις
      _queryVersion++;

      // reset pagination & UI πριν φορτώσεις
      setState(() {
        currentOffset = 0;
        pokemons.clear();
      });

      // Φόρτωσε με το τρέχον version
      await loadNextBatch(_queryVersion);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int rowCount = (pokemons.length / 2).ceil();
    final bool hasMore = currentOffset < filteredNames.length;
    final int totalCount = hasMore ? rowCount + 1 : rowCount;

    return isLoading
        ? const IsLoadingScreen()
        : Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.only(
                bottom: 25.0,
                left: 25.0,
                right: 25.0,
                top: 10.0,
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        color: Colors.black,
                        width: 50.w,
                        height: 35.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 23.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
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
                    SizedBox(height: 10.h),

                    // Search bar (με theme για selection/cursor)
                    Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: const TextSelectionThemeData(
                          cursorColor: Colors.white,
                          selectionColor: Color(0x80FFFFFF),
                          selectionHandleColor: Colors.white,
                        ),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: _onSearchChanged,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'NexaX',
                          fontSize: 16,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'Search by name…',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'NexaRegular',
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 18,
                          ),
                          suffixIcon: _query.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white.withAlpha(150),
                                    size: 24,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    _searchCtrl.clear();
                                    _onSearchChanged('');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 15.0,
                                      left: 15.0,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white.withAlpha(150),
                                    ),
                                  ),
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    // List
                    Expanded(
                      child: filteredNames.isEmpty
                          ? Center(
                              child: Text(
                                'No Pokémon found',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'NexaRegular',
                                  fontSize: 18.sp,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(top: 10.h),
                              itemCount: totalCount,
                              itemBuilder: (context, index) {
                                if (index == rowCount) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            loadNextBatch(_queryVersion),
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          padding: EdgeInsets.all(14.w),
                                          backgroundColor:
                                              widget.selectedType.color,
                                          elevation: 4,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 22,
                                        ),
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
                                              typeColor:
                                                  widget.selectedType.color,
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
