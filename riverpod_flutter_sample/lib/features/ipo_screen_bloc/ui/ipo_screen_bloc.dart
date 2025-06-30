import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo/data/ipomodel.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';

class IpoScreenBloc extends StatefulWidget {
  const IpoScreenBloc({super.key});

  @override
  State<IpoScreenBloc> createState() => _IpoScreenBlocState();
}

class _IpoScreenBlocState extends State<IpoScreenBloc> {
  @override
  void initState() {
    super.initState();
    context.read<IpoBloc>().add(FetchIpoData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IPO Listings (Bloc)'),
        actions: [
          BlocBuilder<IpoBloc, IpoState>(
            builder: (context, state) {
              if (state is IpoLoaded) {
                return DropdownButton<IpoFilter>(
                  value: state.selectedFilter,
                  underline: const SizedBox(),
                  onChanged: (filter) {
                    if (filter != null) {
                      context.read<IpoBloc>().add(FilterIpoData(filter));
                    }
                  },
                  items: IpoFilter.values.map((filter) {
                    return DropdownMenuItem(
                      value: filter,
                      child: Text(_filterToString(filter)),
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<IpoBloc, IpoState>(
        builder: (context, state) {
          if (state is IpoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IpoLoaded) {
            return ListView.builder(
              itemCount: state.filteredList.length,
              itemBuilder: (context, index) {
                final IpoModel ipo = state.filteredList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(ipo.companyName),
                    subtitle: Text('${ipo.status} | ₹${ipo.minPrice} - ₹${ipo.maxPrice}'),
                  ),
                );
              },
            );
          } else if (state is IpoError) {
            return Center(
              child: Text(
                'Failed to fetch IPOs\n${state.message}',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  String _filterToString(IpoFilter filter) {
    switch (filter) {
      case IpoFilter.active:
        return 'Active';
      case IpoFilter.closed:
        return 'Closed';
      case IpoFilter.listed:
        return 'Listed';
      case IpoFilter.upcoming:
        return 'Upcoming';
      case IpoFilter.all:
        return 'All';
    }
  }
}