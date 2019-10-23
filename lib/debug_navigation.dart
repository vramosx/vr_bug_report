import 'package:flutter/material.dart';
import 'package:vr_bug_report/configuration.dart';
import 'package:vr_bug_report/vr_bug_report.dart';

class DebugNavigation {
  static Duration transitionDuration = Duration(milliseconds: 300);
  static Function onTransition;

  static bool pop(BuildContext context) {
    return Navigator.pop(context);
  }

  static Future<T> push<T extends Object>(BuildContext context, Widget page) {
    return Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => page,
          transitionsBuilder: (c, anim, a2, child) {
            if (DebugNavigation.onTransition != null) {
              return DebugNavigation.onTransition(c, anim, a2, child);
            }
            return FadeTransition(
                child: VRBugReport(
                    bugReportServer: Configuration.bugReportServer,
                    bugReportKey: Configuration.bugReportKey,
                    child: child),
                opacity: anim);
          },
          transitionDuration: DebugNavigation.transitionDuration,
        ));
  }

  static Future<T> pushReplacement<T extends Object>(
      BuildContext context, Widget page) {
    return Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => page,
          transitionsBuilder: (c, anim, a2, child) {
            if (DebugNavigation.onTransition != null) {
              return DebugNavigation.onTransition(c, anim, a2, child);
            }
            return FadeTransition(
                child: VRBugReport(
                    bugReportServer: Configuration.bugReportServer,
                    bugReportKey: Configuration.bugReportKey,
                    child: child),
                opacity: anim);
          },
          transitionDuration: DebugNavigation.transitionDuration,
        ));
  }
}
