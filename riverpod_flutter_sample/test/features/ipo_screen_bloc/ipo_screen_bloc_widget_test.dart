import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo/data/ipomodel.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo/data/iporesponse.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/bloc/ipo_bloc.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/bloc/ipo_event.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/bloc/ipo_state.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/ui/ipo_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIpoBloc extends MockBloc<IpoEvent, IpoState> implements IpoBloc {}

void main() {
  late MockIpoBloc mockBloc;

  setUp(() {
    mockBloc = MockIpoBloc();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<IpoBloc>.value(value: mockBloc, child: child),
    );
  }

  testWidgets('shows CircularProgressIndicator when state is IpoLoading',
          (tester) async {
        when(() => mockBloc.state).thenReturn(IpoLoading());

        await tester.pumpWidget(makeTestableWidget(const IpoScreenBloc()));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('shows IPO list when state is IpoLoaded', (tester) async {
    final mockIpo = IpoModel(
      companyName: 'Test Co',
      iPOInfo: 'Some Info',
      maxPrice: 150,
      minPrice: 100,
      status: 'Active',
      listingDate: '2025-06-30',
      startDate: '2025-06-20',
      symbol: 'TCO',
    );

    final ipoResponse = IpoResponse(
      active: [mockIpo],
      closed: [],
      listed: [],
      upcoming: [],
    );

    when(() => mockBloc.state).thenReturn(
      IpoLoaded(
        ipoResponse: ipoResponse,
        filteredList: [mockIpo],
        selectedFilter: IpoFilter.active,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const IpoScreenBloc()));

    expect(find.text('Test Co'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('shows error message when state is IpoError', (tester) async {
    when(() => mockBloc.state).thenReturn(IpoError('Something went wrong'));

    await tester.pumpWidget(makeTestableWidget(const IpoScreenBloc()));

    expect(find.textContaining('Failed to fetch IPOs'), findsOneWidget);
    expect(find.textContaining('Something went wrong'), findsOneWidget);
  });
}