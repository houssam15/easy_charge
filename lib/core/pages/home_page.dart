import "package:flutter/material.dart";
import "package:recharge_by_scan/core/widgets/operator_item.dart";
import "../../config/routes/routes.dart";
import "../util/custom_navigation_helper.dart";
import "../widgets/service_item.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "H", // First letter of "Hello"
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary, // Make "H" green
                  ),
                ),
                TextSpan(
                  text: "ello, explore our ",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onPrimary, // Default text color
                  ),
                ),
                TextSpan(
                  text: "FREE", // "FREE" in green
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary, // Make "FREE" green
                  ),
                ),
                TextSpan(
                  text: " services !",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onPrimary, // Default text color
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  "Supported operators",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              const Expanded(
                flex: 7,
                  child: Row(
                    children: [
                        OperatorItem(image: "assets/imgs/tisalat.jpg"),
                        OperatorItem(image: "assets/imgs/orange.jpg"),
                        OperatorItem(image: "assets/imgs/inwi.jpg"),
                    ],
                  ),
              ),
              //OperatorsList()
            ],
          ),
        ),
        SizedBox(height: 20),
        /*Text(
            "Services",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 35,
                fontWeight: FontWeight.w900,
            ),
        ),
        SizedBox(height: 20),*/
        Container(
          height: 200,
          margin: EdgeInsets.only(left: 10),
          child:ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) => ServiceItem(
                index:index,
                onTap: ()=>CustomNavigationHelper.router.push(AppRoutes.rechargePath),
            ),
          ),
        )
      ],
    );
  }
}
