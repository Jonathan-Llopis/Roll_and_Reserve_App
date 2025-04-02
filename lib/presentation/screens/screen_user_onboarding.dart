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

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
    LoginBloc loginBloc = context.read<LoginBloc>();
    user = loginBloc.state.user!;
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
  /// Builds the onboarding screen for the user.
  ///
  /// This screen is built using the IntroductionScreen widget from the
  /// introduction_screen package. It shows five pages with an image and a
  /// title and body text. The pages are:
  /// - Welcome to Roll and Reserve
  /// - Discover nearby shops
  /// - Reserve in few steps
  /// - Manage your experience
  ///
  /// The screen has a skip button that can be used to skip the onboarding and
  /// go to the user home page.
  ///
  /// When the user finishes the onboarding, it saves the user as having finished
  /// the onboarding by setting the 'isFirstTime' field of the user in the
  /// SharedPreferences to false. It also saves the user in the repository as
  /// having finished the onboarding. Finally, it navigates to the user home page.
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
          title: AppLocalizations.of(context)!
              .welcome_to_roll_and_reserve(user.name),
          body: AppLocalizations.of(context)!.find_your_ideal_game_table,
          image: _buildImage('assets/icon/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.discover_nearby_shops,
          body: AppLocalizations.of(context)!.explore_shops_with_tables,
          image: _buildImage('assets/onBoarding/onboarding2.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.reserve_in_few_steps,
          body: AppLocalizations.of(context)!.select_date_time_materials,
          image: _buildImage('assets/onBoarding/onboarding3.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.manage_your_experience,
          body: AppLocalizations.of(context)!
              .control_reservations_reviews_settings,
          image: _buildImage('assets/onBoarding/onboarding4.jpeg'),
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
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Color(0xFF00FF88))),
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
