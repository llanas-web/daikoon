import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

import 'app_test.mocks.dart';

@GenerateMocks([
  User,
  UserRepository,
  ChallengeRepository,
  NotificationsRepository,
])
void main() {
  late UserRepository userRepository;
  late ChallengeRepository challengeRepository;
  late NotificationsRepository notificationsRepository;
  late User user;

  setUp(() {
    userRepository = MockUserRepository();
    challengeRepository = MockChallengeRepository();
    notificationsRepository = MockNotificationsRepository();
    user = MockUser();

    when(user.isAnonymous).thenReturn(false);
    when(user.isNewUser).thenReturn(false);

    when(userRepository.user)
        .thenAnswer((_) => BehaviorSubject<User>.seeded(user));
  });

  test('check user properties', () {
    when(user.isAnonymous).thenReturn(false);
    when(user.isNewUser).thenReturn(false);

    expect(user.isAnonymous, false);
    expect(user.isNewUser, false);
  });

  testWidgets('renders AppView inside Providers', (WidgetTester tester) async {
    await tester.pumpWidget(
      App(
        user: user,
        userRepository: userRepository,
        challengeRepository: challengeRepository,
        notificationsRepository: notificationsRepository,
      ),
    );

    expect(find.byType(App), findsOneWidget);
  });
}
