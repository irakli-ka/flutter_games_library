import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/game_card_row.dart';
import '../../../theme/app_theme.dart';
import '../providers/search_user_provider.dart';

class SearchedProfileView extends StatefulWidget {
  const SearchedProfileView({super.key});

  @override
  State<SearchedProfileView> createState() => _SearchedProfileViewState();
}

class _SearchedProfileViewState extends State<SearchedProfileView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchUserProvider(),
      child: Consumer<SearchUserProvider>(
        builder: (context, searchProvider, _) {
          return Scaffold(
            backgroundColor: AppColors.myBackground,
            appBar: AppBar(
              title: const Text('Search User'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Enter username...',
                            filled: true,
                            fillColor: AppColors.myDarkerBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                            Icons.search, color: AppColors.iconColor),
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            searchProvider.searchUser(
                                _searchController.text.trim());
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (searchProvider.isLoading)
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                else
                  if (searchProvider.error != null)
                    Expanded(child: Center(child: Text(searchProvider.error!,
                        style: const TextStyle(color: Colors.red))))
                  else
                    if (searchProvider.searchedUser != null)
                      Expanded(child: _buildUserProfile(searchProvider))
                    else
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Search for a user to see their library',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfile(SearchUserProvider provider) {
    final user = provider.searchedUser!;
    final library = provider.userLibrary;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.myDarkerBackground,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
              const SizedBox(height: 16),
              Text(
                user.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Library',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (library.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Text(
                "Library is empty",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => GameCardRow(game: library[index]),
                childCount: library.length,
              ),
            ),
          ),
      ],
    );
  }
}