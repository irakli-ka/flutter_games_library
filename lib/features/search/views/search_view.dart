import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/my_app_bar.dart';
import '../../../theme/app_theme.dart';
import '../../games/models/genre_model.dart';
import '../models/store_model.dart';
import '../providers/search_provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String _sortBy = 'rating';
  final List<int> _selectedGenreIds = [];
  final List<int> _selectedStoreIds = [];
  bool _preciseSearch = false;
  bool _exactMatch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SearchProvider>();
      if (provider.availableGenres.isEmpty) {
        provider.fetchFilters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: MyAppBar(
        onSearchChanged: (val) =>
            context.read<SearchProvider>().updateQuery(val),
        onLoginTap: () => Navigator.pushNamed(context, '/profile'),
      ),
      body: searchProvider.isLoadingFilters
          ? const Center(child: CircularProgressIndicator())
          : searchProvider.error != null &&
          searchProvider.availableGenres.isEmpty
          ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${searchProvider.error}',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => searchProvider.fetchFilters(),
              child: const Text('Retry')),
        ],
      ))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Sort By'),
            const SizedBox(height: 8),
            _buildSortDropdown(),
            const SizedBox(height: 32),
            _buildSectionTitle('Genres'),
            const SizedBox(height: 16),
            _buildFilterChips<Genre>(
                searchProvider.availableGenres, _selectedGenreIds, (g) =>
            g
                .id, (g) => g.name),
            const SizedBox(height: 32),
            _buildSectionTitle('Stores'),
            const SizedBox(height: 16),
            _buildFilterChips<Store>(
                searchProvider.availableStores, _selectedStoreIds, (s) =>
            s
                .id, (s) => s.name),
            const SizedBox(height: 32),
            _buildSwitchRow('Precise Search', _preciseSearch, (v) =>
                setState(() => _preciseSearch = v)),
            _buildSwitchRow('Exact Match', _exactMatch, (v) =>
                setState(() => _exactMatch = v)),
            const SizedBox(height: 40),
            _buildApplyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: AppColors.myDarkerBackground),
      child: DropdownButton<String>(
        value: _sortBy,
        isExpanded: true,
        underline: const SizedBox(),
        items: ['rating', 'release date', 'name'].map((String val) {
          return DropdownMenuItem(value: val,
              child: Text(val, style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 18)));
        }).toList(),
        onChanged: (val) => setState(() => _sortBy = val!),
      ),
    );
  }

  Widget _buildFilterChips<T>(List<T> items, List<int> selected,
      int Function(T) idGetter, String Function(T) labelGetter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final id = idGetter(item);
          final isSelected = selected.contains(id);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(labelGetter(item)),
              selected: isSelected,
              onSelected: (val) =>
                  setState(() => val ? selected.add(id) : selected.remove(id)),
              backgroundColor: Colors.transparent,
              selectedColor: AppColors.textSecondary.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.textSecondary)),
              labelStyle: TextStyle(
                  color: isSelected ? AppColors.textPrimary : AppColors
                      .textSecondary),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.myDarkerBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: const BorderSide(color: AppColors.textSecondary))),
        onPressed: () {
          context.read<SearchProvider>().updateFilters(sortBy: _sortBy,
              genreIds: _selectedGenreIds,
              storeIds: _selectedStoreIds,
              preciseSearch: _preciseSearch,
              exactMatch: _exactMatch);
          context.read<SearchProvider>().search();
          Navigator.pushNamed(context, '/search-result');
        },
        child: const Text('Apply Filters',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
      ),
    );
  }

  Widget _buildSectionTitle(String t) =>
      Text(t, style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary));

  Widget _buildSwitchRow(String t, bool v, ValueChanged<bool> fn) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t, style: const TextStyle(
              fontSize: 18, color: AppColors.textPrimary)),
          Switch(value: v, onChanged: fn)
        ],
      );
}