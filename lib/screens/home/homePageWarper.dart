import 'package:flutter/material.dart';
import 'package:rideon/screens/history/historyScreen.dart';
import 'package:rideon/screens/home/customNavigationButton.dart';
import 'package:rideon/screens/home/homePage.dart';
import 'package:rideon/screens/setting/settingScreen.dart';

class HomePageWrapper extends StatefulWidget {
  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper>
   {
  PageController _pageController;
  int currentpage = 0;
  ValueNotifier<int> op = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true, initialPage: 0)
      ..addListener(pagePositionListner);    
  }

  pagePositionListner() {
    if(op.value != (_pageController.page + .5).toInt())
         op.value = (_pageController.page + 0.5).toInt();
        
    print(currentpage);
    setState(() {
      currentpage = op.value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [         
        Scaffold(
          body: Container(
            height: height(context),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child:pageContent()  ),
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
      ],
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


  double height(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }
}
