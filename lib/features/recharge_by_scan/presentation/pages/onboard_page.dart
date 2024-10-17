  import "package:flutter/material.dart";
  import "package:flutter/services.dart";
  import "package:recharge_by_scan/core/constants/app_images.dart";
  import "package:recharge_by_scan/features/recharge_by_scan/domain/entities/onboard_entity.dart";

  import "../../../../config/routes/routes.dart";
  import "../../../../core/util/custom_navigation_helper.dart";

  class OnBoardPage extends StatefulWidget {
    const OnBoardPage({super.key});

    @override
    State<OnBoardPage> createState() => _OnBoardPageState();
  }

  class _OnBoardPageState extends State<OnBoardPage> {

    final List<OnBoardEntity> demoData = [
      OnBoardEntity(
        image: AppImages.onBoard1Image,
        title: "Operator",
        description: "choose your operator by selecting orange for example ",
      ),
      OnBoardEntity(
        image: AppImages.onBoard2Image,
        title: "Offer",
        description: "choose the offer (*1,*3,*6,...) that you want",
      ),
      OnBoardEntity(
        image: AppImages.onBoard3Image,
        title: "Scan",
        description: "Scan the 14 or 16 hidden number from your recharge card after filling it !",
      ),
    ];

    int currentIndex = 0;
    @override
    void initState() {
      super.initState();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }

    @override
    void dispose() {
      super.dispose();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }

    goToRechargePage(){
        CustomNavigationHelper.router.push(AppRoutes.rechargePath);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _buildBody(),
      );
    }

    _buildBody(){
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              PageView.builder(
                  itemCount: demoData.length,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index){
                      setState((){
                        currentIndex = index;
                      });
                  },
                  itemBuilder: (context,index){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height:demoData.length == index + 1? 10:50),
                        Container(
                          height:MediaQuery.of(context).size.height/2,
                          child:Image.asset(demoData[index].image),
                        ),
                        const SizedBox(height: 40),
                        Text(
                            demoData[index].title,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.onPrimary
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          demoData[index].description,
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.onSecondary
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        if(demoData.length == index + 1)
                        InkWell(
                          onTap: ()=>goToRechargePage(),
                          child: Container(
                            height:50,
                            width: MediaQuery.of(context).size.width*2/3,
                            decoration:BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:BorderRadius.circular(50),
                            ),
                            child:Center(
                                child: Text(
                                    "START",
                                    style:TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).colorScheme.onPrimary
                                    )
                                )
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    );
                  },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      demoData.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 5,
                        width: currentIndex==index?15:5,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: currentIndex==index?Colors.black:Colors.grey,
                            borderRadius: BorderRadius.circular(5)
                        ),
                      )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: ()=>goToRechargePage(),
                  child:Text(
                      "Skip",
                      style: TextStyle(
                        letterSpacing:2,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                  ),
                ),
              ),
            ],
          ),
      );
    }
  }
