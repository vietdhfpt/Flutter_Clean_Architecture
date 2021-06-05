import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );

    test(
      '''should perform a GET request on a URL with number
      being endpoint and with application/json header''',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        setUpMockHttpClientSuccess200();
        //Act - Call the function that is to be tested
        dataSource.getConcreteNumberTrivia(tNumber);
        //Assert - Compare the actual result and expected result
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200 (success)',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        setUpMockHttpClientSuccess200();
        //Act - Call the function that is to be tested
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        //Assert - Compare the actual result and expected result
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        setUpMockHttpClientFailure404();
        //Act - Call the function that is to be tested
        final call = dataSource.getConcreteNumberTrivia;
        //Assert - Compare the actual result and expected result
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );

    test(
      '''should perform a GET request on a URL random
      number and with application/json header''',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        setUpMockHttpClientSuccess200();
        //Act - Call the function that is to be tested
        dataSource.getRandomNumberTrivia();
        //Assert - Compare the actual result and expected result
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return random NumberTriviaModel when the response code is 200 (success)',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        setUpMockHttpClientSuccess200();
        //Act - Call the function that is to be tested
        final result = await dataSource.getRandomNumberTrivia();
        //Assert - Compare the actual result and expected result
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        setUpMockHttpClientFailure404();
        //Act - Call the function that is to be tested
        final call = dataSource.getRandomNumberTrivia;
        //Assert - Compare the actual result and expected result
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
