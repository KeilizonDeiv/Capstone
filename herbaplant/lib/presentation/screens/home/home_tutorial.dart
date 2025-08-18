import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeTutorial {
  final GlobalKey profileIconKey;
  final GlobalKey homeButtonKey;
  final GlobalKey scannerButtonKey;
  final GlobalKey herbyButtonKey;

  HomeTutorial({
    required this.profileIconKey,
    required this.homeButtonKey,
    required this.scannerButtonKey,
    required this.herbyButtonKey,
  });

  late List<TargetFocus> _targets;
  late TutorialCoachMark _tutorialCoachMark;

  void _initTargets(BuildContext context) {
    _targets = [
      TargetFocus(
        identify: "ProfileIcon",
        targetPosition: _createTargetPosition(context, profileIconKey),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              "Tap here to view and edit your profile.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "HomeButton",
        targetPosition: _createTargetPosition(context, homeButtonKey),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "This is the Home button. Tap to return to the main screen.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "ScannerButton",
        targetPosition: _createTargetPosition(context, scannerButtonKey),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "Tap here to scan a plant for identification.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "HerbyButton",
        targetPosition: _createTargetPosition(context, herbyButtonKey),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "Meet Herby, your herbal assistant!",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    ];
  }

  TargetPosition _createTargetPosition(BuildContext context, GlobalKey key) {
    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    return TargetPosition(
      size,
      Offset(offset.dx, offset.dy - MediaQuery.of(context).padding.top),
    );
  }

  Future<void> showTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool shown = prefs.getBool("tutorial_shown") ?? false;

    if (!shown) {
      _initTargets(context);

      _tutorialCoachMark = TutorialCoachMark(
        targets: _targets,
        colorShadow: Colors.black,
        textSkip: "SKIP",
        paddingFocus: 8,
        opacityShadow: 0.8,
        onFinish: () => debugPrint("Tutorial finished"),
        onClickTarget: (target) => debugPrint("Clicked on ${target.identify}"),
        onSkip: () {
          debugPrint("Tutorial skipped");
          return true;
        },
      );

      _tutorialCoachMark.show(context: context);
      await prefs.setBool("tutorial_shown", true);
    }
  }
}
