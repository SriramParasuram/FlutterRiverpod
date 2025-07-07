import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/ui/ipo_screen_bloc.dart';
import 'package:flutter_hooks_riverpod_app/screens/price_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../features/clean_arch_products/presentation/screens/product_screen.dart';
import '../features/ipo/domain/ipo_repository.dart';
import '../features/ipo/presentation/screens/ipo_screen_riverpod.dart';
import '../features/ipo_screen_bloc/bloc/ipo_bloc.dart';
import '../features/my_location/trial_screens/google_maps_screen.dart';
import '../features/my_location/trial_screens/live_navigation_screen.dart';
import '../features/my_location/live_route_screen.dart';
import '../features/watchlist/screens/watchlist_screen.dart';
import 'my_detail_page.dart';
// import 'ipo_screen.dart'; // you'll create this
import '../constants/app_constants.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipoRepository = ref.read(ipoRepositoryProvider);
    final List<_LandingTile> tiles = [
      _LandingTile(
        title: 'IPO Listings',
        icon: Icons.business_center,
        onTap:
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IpoScreenRiverPod()), // you'll create this
        ),
      ),
      _LandingTile(
        title: 'Watchlist Streaming Mock',
        icon: Icons.business_center,
        onTap:
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WatchlistScreen()), // you'll create this
        ),
      ),
      _LandingTile(
        title: 'Price Stream Web Sockets',
        icon: Icons.stream,
        onTap:
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PriceScreen()), // you'll create this
        ),
      ),

      _LandingTile(
        title: 'IPO Bloc Screen',
        icon: Icons.account_balance,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => IpoBloc(ipoRepository: ipoRepository),
              child: const IpoScreenBloc(),
            ),
          ),
        ),
      ),

      _LandingTile(
        title: 'Uber Map Screen',
        icon: Icons.stream,
        onTap:
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  LocationSearchMapScreen()), // you'll create this
        ),
      ),


      _LandingTile(
        title: 'Clean Arch Products',
        icon: Icons.stream,
        onTap:
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  ProductListScreen()), // you'll create this
        ),
      ),

      // Add more tiles here if needed
    ];

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.landingTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: tiles.map((tile) => tile.buildCard(context)).toList(),
        ),
      ),
    );
  }
}

class _LandingTile {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _LandingTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  Widget buildCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
