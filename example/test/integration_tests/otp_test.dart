import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:otpinputexample/main.dart' as app;

Future _enterOtpData(WidgetTester tester) async {
  for (var index = 0; index < 6; index++) {
    await tester.enterText(
      find.byKey(Key("otp-${index + 1}")),
      (index + 1).toString(),
    );
    await delay(tester);
  }
  await delay(tester);
}

Future _testEnteredOtp({required String expectedValue}) async {
  Finder otpTextFinder = find.byKey(const Key("otp-value"));
  Text otp = otpTextFinder.evaluate().single.widget as Text;
  expect(otp.data, expectedValue);
}

Future endTest(WidgetTester tester) async {
  await delay(tester);
  await tester.pump();
}

Future _tapClearButton(WidgetTester tester) async {
  await delay(tester);
  await tester.tap(find.byKey(const Key("clear-key")));
  await delay(tester);
}

Future _changeOtpValue(WidgetTester tester) async {
  // change second otp field value from 1 to 2
  await tester.enterText(find.byKey(const Key("otp-2")), "1");
  await delay(tester);
}

Future delay(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    "otp testing",
    (tester) async {
      await tester.pumpWidget(const app.MyApp());
      // enter OTP Data - 123456
      await _enterOtpData(tester);
      await _testEnteredOtp(expectedValue: "123456");
      // changing otp value in second position from 1 to 2
      await _changeOtpValue(tester);
      await _testEnteredOtp(expectedValue: "113456");
      // finally clear the otp values and check the expected value by tapping on the clear button
      await _tapClearButton(tester);
      await _testEnteredOtp(expectedValue: "");
      await endTest(tester);
    },
  );
}
