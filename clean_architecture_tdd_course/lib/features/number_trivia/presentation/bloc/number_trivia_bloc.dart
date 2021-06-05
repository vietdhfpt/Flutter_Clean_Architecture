import 'dart:async';

import 'package:bloc/bloc.dart';

import 'bloc.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  @override
  NumberTriviaState get initialState => throw UnimplementedError();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {}
}
