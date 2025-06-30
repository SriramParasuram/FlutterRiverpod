import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo/data/iporesponse.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo/data/ipomodel.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo/domain/ipo_repository.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/bloc/ipo_bloc.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/bloc/ipo_event.dart';
import 'package:flutter_hooks_riverpod_app/features/ipo_screen_bloc/bloc/ipo_state.dart';
import 'package:mocktail/mocktail.dart';

class MockIpoRepository extends Mock implements IpoRepository {}

void main() {
  late MockIpoRepository mockRepository;
  late IpoBloc ipoBloc;

  final mockActiveIpos = [
    IpoModel(
      companyName: 'ABC Ltd',
      iPOInfo: 'IPO Info A',
      listingDate: '2025-07-01',
      maxPrice: 120,
      minPrice: 100,
      startDate: '2025-06-25',
      status: 'Active',
      symbol: 'ABC',
    ),
  ];

  final mockClosedIpos = [
    IpoModel(
      companyName: 'XYZ Corp',
      iPOInfo: 'IPO Info X',
      listingDate: '2025-06-01',
      maxPrice: 170,
      minPrice: 150,
      startDate: '2025-05-20',
      status: 'Closed',
      symbol: 'XYZ',
    ),
  ];

  final ipoResponse = IpoResponse(
    active: mockActiveIpos,
    listed: [],
    upcoming: [],
    closed: mockClosedIpos,
  );

  setUp(() {
    mockRepository = MockIpoRepository();
    ipoBloc = IpoBloc(ipoRepository: mockRepository);
  });

  tearDown(() {
    ipoBloc.close();
  });

  blocTest<IpoBloc, IpoState>(
    'emits [IpoLoading, IpoLoaded] when FetchIpoData is added',
    build: () {
      when(() => mockRepository.getIpoDataFromRepository())
          .thenAnswer((_) async => ipoResponse);
      return ipoBloc;
    },
    act: (bloc) => bloc.add(FetchIpoData()),
    expect: () => [
      isA<IpoLoading>(),
      isA<IpoLoaded>()
          .having((s) => s.filteredList, 'filteredList', equals(mockActiveIpos))
          .having((s) => s.selectedFilter, 'selectedFilter', IpoFilter.active),
    ],
  );

  blocTest<IpoBloc, IpoState>(
    'emits [IpoLoading, IpoLoaded, IpoLoaded] when FetchIpoData then FilterIpoData is added',
    build: () {
      when(() => mockRepository.getIpoDataFromRepository())
          .thenAnswer((_) async => ipoResponse);
      return ipoBloc;
    },
    act: (bloc) async {
      bloc.add(FetchIpoData());
      await Future.delayed(Duration.zero); // let first emit complete
      bloc.add(FilterIpoData(IpoFilter.closed));
    },
    expect: () => [
      isA<IpoLoading>(),
      isA<IpoLoaded>().having((s) => s.selectedFilter, 'selectedFilter', IpoFilter.active),
      isA<IpoLoaded>()
          .having((s) => s.filteredList, 'filteredList', equals(mockClosedIpos))
          .having((s) => s.selectedFilter, 'selectedFilter', IpoFilter.closed),
    ],
  );

  blocTest<IpoBloc, IpoState>(
    'emits [IpoLoading, IpoError] when FetchIpoData fails',
    build: () {
      when(() => mockRepository.getIpoDataFromRepository())
          .thenThrow(Exception('Network Error'));
      return ipoBloc;
    },
    act: (bloc) => bloc.add(FetchIpoData()),
    expect: () => [
      isA<IpoLoading>(),
      isA<IpoError>().having((e) => e.message, 'message', contains('Network Error')),
    ],
  );
}