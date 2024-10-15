import "package:flutter/material.dart";
import "package:recharge_by_scan/features/recharge_by_scan/domain/entities/sim_card.dart";

import "../../../../../core/constants/app_images.dart";
import "../../../../../core/widgets/operator_item.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
class SimCardWidget extends StatefulWidget {
  const SimCardWidget({super.key,required this.simCard});
  final SimCardEntity simCard;
  @override
  State<SimCardWidget> createState() => _SimCardWidgetState();
}

class _SimCardWidgetState extends State<SimCardWidget> {
  late Operator operator;
  @override
  void initState() {
    operator = widget.simCard.getOperator().operator;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          height: 70,
          child: Card(
            child: Stack(
              children: [
                if(operator != Operator.UNKOWN)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child:Image.asset(
                             widget.simCard.getOperatorPicture(operator),
                             fit: BoxFit.fitWidth,
                             width: MediaQuery.of(context).size.width,
                        ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                                widget.simCard.slotNumber==0?AppImages.sim1Image:AppImages.sim2Image,
                                width: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.phone,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Text(
                                "0682749205",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500
                                ),
                            )
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
