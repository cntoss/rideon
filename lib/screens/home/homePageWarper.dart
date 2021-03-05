import 'package:flutter/material.dart';
import 'package:rideon/screens/history/historyScreen.dart';
import 'package:rideon/screens/home/customNavigationButton.dart';
import 'package:rideon/screens/home/homePage.dart';
import 'package:rideon/screens/setting/settingScreen.dart';
import 'package:flutter/cupertino.dart';


class HomePageWrapper extends StatefulWidget {
  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> scale;
  Animation<double> scaleReverce;
  Animation<Offset> slide;
  PageController _pageController;
  int currentpage = 0;
  ValueNotifier<int> op = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true, initialPage: 0)
      ..addListener(pagePositionListner);
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animController.addListener(() {
      isTouchable.value = animController.status != AnimationStatus.completed;
    });
    print('pagesss');
    // print(_pageController.addListener(() { }));
  }

  pagePositionListner() {
    if(op.value != (_pageController.page + .5).toInt())
         op.value = (_pageController.page + 0.5).toInt();
        
    print(currentpage);
    setState(() {
      currentpage = op.value;
    });
  }

  ValueNotifier<bool> isTouchable = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    initializeAnimations();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          //drawer background filter
         
          //dashboard page
          AnimatedBuilder(
            animation: animController,
            builder: (c, child) {
              return drawerTransition(child);
            },
            child: Scaffold(
             // appBar: buildAppBar(),
              body: GestureDetector(
                onHorizontalDragUpdate: drawerSwipeHandler,
                child: SafeArea(
                  child: Container(
                    height: height(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ValueListenableBuilder(
                            valueListenable: isTouchable,
                            builder: (BuildContext context,
                                bool isDashboardTouchable, Widget child) {
                              return Stack(
                                children: [
                                  child,
                                  if (!isDashboardTouchable) untouchableFilter()
                                ],
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: pageContent(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomBottomNavigation(
                          selectedItemColor: Colors.white,
                          navItems: {
                            "Home": Icons.home,
                            "History": Icons.history,
                            "Setting": Icons.settings,
                          },
                          onTabChange: (page) {
                            _pageController.jumpToPage(page);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pageContent() {
    return Column(
      children: [
        Expanded(
            child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              HomePage(),
              HistoryScreen(),
              SettingScreen(),
            ],
          ),
        )
      ],
    );
  }

  Container untouchableFilter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
    );
  }

  double height(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }

  void drawerSwipeHandler(detail) {
    if (animController.status == AnimationStatus.completed &&
        detail.delta.dx < -10) animController.reverse();
  }

  Transform drawerTransition(Widget child) {
    return Transform.scale(
      scale: scale.value,
      child: Transform.translate(
          offset: slide.value,
          child: Material(
              color: Colors.white,
              elevation: slide.value.dx / 40,
              borderRadius: BorderRadius.circular(slide.value.dx / 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(slide.value.dx / 15),
                  child: child))),
    );
  }

  initializeAnimations() {
    slide = Tween<Offset>(
            end: Offset(MediaQuery.of(context).size.width * .65, 0),
            begin: Offset.zero)
        .animate(
            CurvedAnimation(parent: animController, curve: Curves.easeInExpo));
    scale = Tween<double>(end: .8, begin: 1.0).animate(
        CurvedAnimation(parent: animController, curve: Curves.easeOutExpo));
    scaleReverce = Tween<double>(end: 1, begin: .6).animate(
        CurvedAnimation(parent: animController, curve: Curves.easeInCubic));
  }
}
