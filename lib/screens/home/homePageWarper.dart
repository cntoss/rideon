import 'package:flutter/material.dart';
import 'package:rideon/screens/home/homePage.dart';
import 'package:rideon/screens/setting/settingScreen.dart';

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
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animController.addListener(() {
      isTouchable.value = animController.status != AnimationStatus.completed;
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
          drawer(),
          //dashboard page
          AnimatedBuilder(
            animation: animController,
            builder: (c, child) {
              return drawerTransition(child);
            },
            child: Scaffold(
              appBar: buildAppBar(),
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
                            child: HomePage(),
                          ),
                        ),
                        
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

 

  Container untouchableFilter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Row(
            children: [
              Text('Rideon', style: Theme.of(context).textTheme.headline6,),
              Image.asset('assets/logo.png', height: 55,),
             //Text('Tapaiko Sawari Sathi')
             
            ],
          ) ,
          
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              animController.status == AnimationStatus.completed
                  ? animController.reverse()
                  : animController.forward();
            },
            icon: SizedBox(
                width: 22,
                height: 50,
                child: FittedBox(fit: BoxFit.contain, child: menu())),
          ),
        ],
      ),
      actions: [IconButton(icon: Icon(Icons.notifications, color: Colors.red,),onPressed: (){},)],
    );
  }

  Widget drawer() {
    return Material(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: AnimatedBuilder(
            builder: (BuildContext context, Widget child) {
              return ScaleTransition(
                scale: scaleReverce,
                child: child,
              );
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: SettingScreen(),
            ),
            animation: scale,
          ),
        ),
      ),
    );
  }


Widget menu() {
  var height = 12.0;
  var width = 80.0;
  return Center(
      child: Container(
        width: width,
        height: height * 3 + 15.0,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: width * .6,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: Colors.black),
              ),
            ),
            Center(
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: Colors.black),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: width * .6,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: Colors.black),
              ),
            ),
          ],
        ),
      ));
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
            end: Offset(MediaQuery.of(context).size.width * .68, 0),
            begin: Offset.zero)
        .animate(
            CurvedAnimation(parent: animController, curve: Curves.easeInExpo));
    scale = Tween<double>(end: .8, begin: 1.0).animate(
        CurvedAnimation(parent: animController, curve: Curves.easeOutExpo));
    scaleReverce = Tween<double>(end: 1, begin: .6).animate(
        CurvedAnimation(parent: animController, curve: Curves.easeInCubic));
  }
}
