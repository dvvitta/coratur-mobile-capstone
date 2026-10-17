import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/breakpoints.dart';
import '../controllers/onboarding_controller.dart';
import '../models/onboarding_page_data.dart';
import '../widgets/onboarding_colors.dart';
import '../widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.controller = const OnboardingController(),
  });

  final OnboardingController controller;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int index) {
    return _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _finish() {
    Navigator.of(context)
        .pushReplacementNamed(widget.controller.completedRoute);
  }

  void _onLanjut() {
    if (widget.controller.isLastPage(_index)) {
      _finish();
      return;
    }
    _goToPage(_index + 1);
  }

  void _onSkip() => _finish();

  @override
  Widget build(BuildContext context) {
    final pages = OnboardingPages.pages;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: _index == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop || _index == 0) {
            return;
          }
          _goToPage(_index - 1);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.compact,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          key: const Key('onboarding_skip'),
                          onPressed: _onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: OnboardingColors.accent,
                            minimumSize: const Size(64, 44),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: const Text('Lewati'),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: pages.length,
                          onPageChanged: (index) {
                            setState(() => _index = index);
                          },
                          itemBuilder: (context, index) {
                            return OnboardingPageContent(page: pages[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pages[_index].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: OnboardingColors.title,
                          fontSize: 26,
                          height: 1.25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pages[_index].body,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: OnboardingColors.body,
                          fontSize: 15,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _PageDots(count: pages.length, currentIndex: _index),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          key: const Key('onboarding_next'),
                          onPressed: _onLanjut,
                          style: FilledButton.styleFrom(
                            backgroundColor: OnboardingColors.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Lanjut'),
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == currentIndex
                  ? OnboardingColors.accent
                  : OnboardingColors.inactiveDot,
            ),
          ),
        ],
      ],
    );
  }
}
