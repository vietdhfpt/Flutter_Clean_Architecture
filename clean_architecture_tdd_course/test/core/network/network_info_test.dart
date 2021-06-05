import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  MockConnectivity mockConnectivity;
  NetworkInfoImpl networkInfo;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker connection status',
      () async {
        //Arrange - Setup facts, Put Expected outputs or Initilize
        final connectivityStatus = Future.value(ConnectivityResult.wifi);
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) => connectivityStatus);
        //Act - Call the function that is to be tested
        final result = await networkInfo.isConnected();
        //Assert - Compare the actual result and expected result
        verify(mockConnectivity.checkConnectivity());
        expect(result, true);
      },
    );
  });
}
