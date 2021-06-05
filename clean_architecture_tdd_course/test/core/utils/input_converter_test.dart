import 'package:clean_architecture_tdd_course/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('8: stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        final str = '123';
        //Act - Call the function that is to be tested
        final result = inputConverter.stringToUnsignedInteger(str);
        //Assert - Compare the actual result and expected result
        expect(result, Right(123));
      },
    );

    test(
      'should return a Failure when the string is not an integer',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        final str = 'abc';
        //Act - Call the function that is to be tested
        final result = inputConverter.stringToUnsignedInteger(str);
        //Assert - Compare the actual result and expected result
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a Failure when the string is a negative integer',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        final str = '-1';
        //Act - Call the function that is to be tested
        final result = inputConverter.stringToUnsignedInteger(str);
        //Assert - Compare the actual result and expected result
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
