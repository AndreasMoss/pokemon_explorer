import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' show ClientException;
import 'package:pokemon_explorer/api/poke_api_service.dart';
import 'package:pokemon_explorer/functions/general.dart';
import 'package:pokemon_explorer/models/pokemon.dart';
import 'package:pokemon_explorer/models/pokemon_type.dart';
import 'package:pokemon_explorer/screens/is_loading_screen.dart';
import 'package:pokemon_explorer/screens/no_internet_screen.dart';
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
  bool internetConnected = true;

  // Search
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  Timer? _debounce;

  // Anti-race
  int _queryVersion = 0; // aujanei se kathe neo filtro
  bool _isLoadingBatch = false; //gia na mi trexoun paralila batches

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

  //  helper
  bool _isValidHttpUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  bool _isOfflineError(Object e) {
    if (e is TimeoutException) return true;
    if (e is SocketException) return true;
    if (e is ClientException) {
      final m = e.message.toLowerCase();
      return m.contains('failed host lookup') ||
          m.contains('no address associated');
    }
    final s = e.toString().toLowerCase();
    return s.contains('socketexception') || s.contains('failed host lookup');
  }

  // data fetch
  Future<void> fetchAllNamesForType() async {
    setState(() {
      // reset flags ώστε το Retry να δουλεύει σωστά
      internetConnected = true;
      isLoading = true;
    });

    try {
      // timeout gia na mi kollaei sto searching screen
      allNames = await pokeApi
          .getPokemonNamesByType(widget.selectedType)
          .timeout(const Duration(seconds: 5));

      filteredNames = List.of(allNames);
      currentOffset = 0;
      pokemons.clear();

      _queryVersion++;
      await loadNextBatch(_queryVersion);

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      if (_isOfflineError(e)) {
        setState(() {
          internetConnected = false;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Server error. Please try again later.',
              style: TextStyle(color: Colors.white, fontFamily: 'NexaRegular'),
            ),
          ),
        );
      }
    }
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
        nextNames.map(
          (name) =>
              pokeApi.getPokemonBasic(name).timeout(const Duration(seconds: 5)),
        ),
      );

      if (localVersion != _queryVersion) return;

      final withImages = fetched
          .where((p) => _isValidHttpUrl(p.imageUrl))
          .toList();

      if (!mounted) return;
      setState(() {
        pokemons.addAll(withImages);
        currentOffset += pageSize;
      });
    } catch (e) {
      if (!mounted) return;
      if (_isOfflineError(e)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Network timeout. Check your connection.',
              style: TextStyle(color: Colors.white, fontFamily: 'NexaRegular'),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Server error. Please try again later.',
              style: TextStyle(color: Colors.white, fontFamily: 'NexaRegular'),
            ),
          ),
        );
      }
    } finally {
      _isLoadingBatch = false;
    }
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final q = val.trim().toLowerCase();
      _query = val;

      if (q.isEmpty) {
        filteredNames = List.of(allNames);
      } else {
        filteredNames = allNames.where((raw) {
          final pretty = pokemonNameFormatter(raw).toLowerCase();
          return pretty.contains(q);
        }).toList();
      }

      _queryVersion++;

      setState(() {
        currentOffset = 0;
        pokemons.clear();
      });

      await loadNextBatch(_queryVersion);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int rowCount = (pokemons.length / 2).ceil();
    final bool hasMore = currentOffset < filteredNames.length;
    final int totalCount = hasMore ? rowCount + 1 : rowCount;

    // states
    if (!internetConnected) {
      return NoInternetScreen(onRetry: fetchAllNamesForType);
    }
    if (isLoading) {
      return const IsLoadingScreen();
    }

    return Scaffold(
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 23.sp,
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

              // Search bar
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
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
                                  onPressed: () => loadNextBatch(_queryVersion),
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
