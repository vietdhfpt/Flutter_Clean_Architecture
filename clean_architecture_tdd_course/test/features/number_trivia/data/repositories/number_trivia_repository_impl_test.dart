import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'Test Text',
      number: tNumber,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        when(mockNetworkInfo.isConnected())
            .thenAnswer((_) => Future.value(true));
        //Act - Call the function that is to be tested
        repository.getConcreteNumberTrivia(tNumber);
        //Assert - Compare the actual result and expected result
        verify(mockNetworkInfo.isConnected());
      },
    );

    void runTestsOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected())
              .thenAnswer((_) => Future.value(true));
        });

        body();
      });
    }

    void runTestsOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected())
              .thenAnswer((_) => Future.value(false));
        });

        body();
      });
    }

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          //Act - Call the function that is to be tested
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //Assert - Compare the actual result and expected result
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          //Act - Call the function that is to be tested
          await repository.getConcreteNumberTrivia(tNumber);
          //Assert - Compare the actual result and expected result
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          //Act - Call the function that is to be tested
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //Assert - Compare the actual result and expected result
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when cached data is present',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //Act - Call the function that is to be tested
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //Assert - Compare the actual result and expected result
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //Act - Call the function that is to be tested
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //Assert - Compare the actual result and expected result
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'Test Text',
      number: 123,
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        when(mockNetworkInfo.isConnected())
            .thenAnswer((_) => Future.value(true));
        //Act - Call the function that is to be tested
        repository.getRandomNumberTrivia();
        //Assert - Compare the actual result and expected result
        verify(mockNetworkInfo.isConnected());
      },
    );

    void runTestsOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected())
              .thenAnswer((_) => Future.value(true));
        });

        body();
      });
    }

    void runTestsOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected())
              .thenAnswer((_) => Future.value(false));
        });

        body();
      });
    }

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          //Act - Call the function that is to be tested
          final result = await repository.getRandomNumberTrivia();
          //Assert - Compare the actual result and expected result
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          //Act - Call the function that is to be tested
          await repository.getRandomNumberTrivia();
          //Assert - Compare the actual result and expected result
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          //Act - Call the function that is to be tested
          final result = await repository.getRandomNumberTrivia();
          //Assert - Compare the actual result and expected result
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when cached data is present',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //Act - Call the function that is to be tested
          final result = await repository.getRandomNumberTrivia();
          //Assert - Compare the actual result and expected result
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          //Arrange - Setup facts, Put Expected outputs or Initilize
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //Act - Call the function that is to be tested
          final result = await repository.getRandomNumberTrivia();
          //Assert - Compare the actual result and expected result
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
