import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/ipo_data_provider.dart';

class IpoScreen extends HookConsumerWidget {
  const IpoScreen({super.key});




  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipoData = ref.watch(iPODataProvider);

    useEffect(()  {
      print("widget mounted");
        return () {
      print("widget unmounted");
    };
    },[]);

    final selectedTypes = useState<Set<String>>({'Active'});
    final allTypes = ['Active', 'Listed', 'Upcoming', 'Closed'];

    return Scaffold(
      appBar: AppBar(title: const Text('IPO Listings')),
      body: ipoData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (ipo) {
          final typeMap = {
            'Active': ipo.active,
            'Listed': ipo.listed,
            'Upcoming': ipo.upcoming,
            'Closed': ipo.closed,
          };

          final filteredIpos = selectedTypes.value
              .expand((type) => typeMap[type]!)
              .toList();

          Widget buildCheckbox(String label) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: selectedTypes.value.contains(label),
                  onChanged: (checked) {
                    final newSet = Set<String>.from(selectedTypes.value);
                    checked! ? newSet.add(label) : newSet.remove(label);
                    selectedTypes.value = newSet;
                  },
                ),
                Text(label),
              ],
            );
          }

          Widget buildSelectAllCheckbox() {
            final allSelected = selectedTypes.value.length == allTypes.length;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: allSelected,
                  onChanged: (checked) {
                    selectedTypes.value =
                    checked! ? Set<String>.from(allTypes) : {};
                  },
                ),
                const Text("Select All"),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Checkbox section (always visible)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    buildSelectAllCheckbox(),
                    ...allTypes.map(buildCheckbox),
                  ],
                ),
              ),
              const Divider(),

              // ✅ IPO list section
              Expanded(
                child: filteredIpos.isEmpty
                    ? const Center(child: Text("No IPOs to display"))
                    : ListView.builder(
                  itemCount: filteredIpos.length,
                  itemBuilder: (_, index) {
                    final ipoItem = filteredIpos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(ipoItem.companyName),
                        subtitle: Text(ipoItem.iPOInfo),
                        trailing: ipoItem.maxPrice != null
                            ? Text('₹${ipoItem.minPrice} - ₹${ipoItem.maxPrice}')
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }



}
