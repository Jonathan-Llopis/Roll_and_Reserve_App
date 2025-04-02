import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:roll_and_reserve/config/router/routes.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/injection.dart' as di;

class OnboardingDuenioScreen extends StatefulWidget {
  const OnboardingDuenioScreen({super.key});

  @override
  _OnboardingDuenioScreenState createState() => _OnboardingDuenioScreenState();
}

class _OnboardingDuenioScreenState extends State<OnboardingDuenioScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  late UserEntity user;
  @override
  /// Called when the widget is inserted into the tree.
  ///
  /// This function uses the BuildContext to get the LoginBloc and add a
  /// CheckAuthentication event to check if the user is authenticated. After
  /// that, it gets the user from the LoginBloc and sets the user state.
  void initState() {
    BlocProvider.of<LoginBloc>(context).add(CheckAuthentication());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoginBloc loginBloc = context.read<LoginBloc>();
      setState(() {
        user = loginBloc.state.user!;
      });
    });
    super.initState();
  }

  /// Saves the user as having finished the onboarding, and navigates
  /// to the user home page.
  ///
  /// This function is called when the user finishes the onboarding.
  /// It saves the user as having finished the onboarding by setting
  /// the 'isFirstTime' field of the user in the SharedPreferences to
  /// false. It also saves the user in the repository as having finished
  /// the onboarding. Finally, it navigates to the user home page.
  void _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    await di.sl<UserRespository>().saveUserField(user.id, 'isFirstTime', false);
    router.go('/user');
  }

  /// Builds an image widget with a rounded corner and a shadow.
  ///
  /// The image is centered and covers the whole container.
  /// The container has a rounded corner and a shadow.
  /// The height and width of the container are set to 0.4 and 0.8 of
  /// the screen height and width respectively.
  Widget _buildImage(String assetPath) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  /// Builds the onboarding screen for the store owner.
  ///
  /// This screen is built using the IntroductionScreen widget from the
  /// introduction_screen package. It shows five pages with an image and a
  /// title and body text. The pages are:
  /// - Welcome to the store owner onboarding
  /// - Setup your store
  /// - Manage tables
  /// - Schedule events
  /// - Analyze and improve
  ///
  /// The screen has a skip button that can be used to skip the onboarding and
  /// go to the user home page.
  ///
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Color(0xFF2D2D2D),
      imagePadding: EdgeInsets.zero,
      imageFlex: 2,
      bodyFlex: 1,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: const Color(0xFF2D2D2D),
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.welcome_store_owner(user.name),
          body: AppLocalizations.of(context)!.manage_your_game_space,
          image: _buildImage('assets/icon/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.setup_your_store,
          body: AppLocalizations.of(context)!.add_location_and_details,
          image: _buildImage('assets/onBoarding/duenio2.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.manage_tables,
          body: AppLocalizations.of(context)!.create_and_edit_tables,
          image: _buildImage('assets/onBoarding/duenio3.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.schedule_events,
          body:
              AppLocalizations.of(context)!.organize_tournaments_and_activities,
          image: _buildImage('assets/onBoarding/duenio4.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.analyze_and_improve,
          body: AppLocalizations.of(context)!
              .monitor_reservations_reviews_statistics,
          image: _buildImage('assets/onBoarding/duenio5.jpeg'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: Text(AppLocalizations.of(context)!.skip,
          style: const TextStyle(color: Colors.grey)),
      next: const Icon(Icons.arrow_forward, color: Color(0xFF00FF88)),
      done: Text(AppLocalizations.of(context)!.get_started,
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF00FF88))),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: const Color(0xFF00FF88),
        color: Colors.grey[700]!,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      dotsContainerDecorator: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }
}
