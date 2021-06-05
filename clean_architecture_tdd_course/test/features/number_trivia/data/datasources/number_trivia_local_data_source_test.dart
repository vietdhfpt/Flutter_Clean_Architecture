import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia_cached.json')),
    );
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      //Arrange - Setup facts, Put Expected outputs or Initilize
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      //Act - Call the function that is to be tested
      final result = await dataSource.getLastNumberTrivia();
      //Assert - Compare the actual result and expected result
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      //Arrange - Setup facts, Put Expected outputs or Initilize
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //Act - Call the function that is to be tested
      final call = dataSource.getLastNumberTrivia;
      //Assert - Compare the actual result and expected result
      // ignore: deprecated_member_use
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 1,
    );
    test(
      'should call SharedPreferences to cache the data',
      () async {
        //Act - Call the function that is to be tested
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        //Assert - Compare the actual result and expected result
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA,
          expectedJsonString,
        ));
      },
    );
  });
}
