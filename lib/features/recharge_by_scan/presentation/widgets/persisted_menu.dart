import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart";
import "package:recharge_by_scan/features/recharge_by_scan/presentation/pages/home_page.dart";
BuildContext? testContext;

class PersistedMenuWidget extends StatefulWidget {
  const PersistedMenuWidget({super.key});

  @override
  State<PersistedMenuWidget> createState() => _PersistedMenuWidgetState();
}

class _PersistedMenuWidgetState extends State<PersistedMenuWidget> {
  late PersistentTabController _controller;
  late bool _hideNavBar;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
  ];
  NavBarStyle _navBarStyle = NavBarStyle.simple;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 1);
    _hideNavBar = false;
  }

  @override
  void dispose() {
    for (final element in _scrollControllers) {
      element.dispose();
    }
    super.dispose();
  }


  List<Widget> _buildScreens() =>[
      HomeScreen(),
      HomeScreen()
  ];

  List<PersistentBottomNavBarItem> _navBarsItems()=>[
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: "Search",
      activeColorPrimary: Colors.teal,
      activeColorSecondary: _navBarStyle == NavBarStyle.style7 ||
          _navBarStyle == NavBarStyle.style10
          ? Colors.white
          : null,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: "Search",
      activeColorPrimary: Colors.teal,
      activeColorSecondary: _navBarStyle == NavBarStyle.style7 ||
          _navBarStyle == NavBarStyle.style10
          ? Colors.white
          : null,
      inactiveColorPrimary: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: false,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
        hideOnScrollSettings: HideOnScrollSettings(
          hideNavBarOnScroll: false,
          scrollControllers: _scrollControllers,
        ),
        padding: const EdgeInsets.only(top: 8),
        floatingActionButton: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.orange),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          onPressed: () {},
        ),
        onWillPop: (final context) async {
          await showDialog(
            context: context ?? this.context,
            useSafeArea: true,
            builder: (final context) => Container(
              height: 50,
              width: 50,
              color: Colors.white,
              child: ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
          return false;
        },
        selectedTabScreenContext: (final context) {
          testContext = context;
        },
        backgroundColor: Colors.grey.shade900,
        isVisible: !_hideNavBar,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            duration: Duration(milliseconds: 300),
            screenTransitionAnimationType:
            ScreenTransitionAnimationType.fadeIn,
          ),
          onNavBarHideAnimation: OnHideAnimationSettings(
            duration: Duration(milliseconds: 100),
            curve: Curves.bounceInOut,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: kBottomNavigationBarHeight,
        navBarStyle:
        _navBarStyle,
      );
  }
}
