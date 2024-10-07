import "package:flutter/material.dart";

import "../../domain/entities/sim_card.dart";

class SimCardsList extends StatefulWidget {
  final List<SimCardEntity> simCards;
  final SimCardEntity? selectedSimCard;
  final Function(SimCardEntity) onSimCardSelected;

  const SimCardsList({
    super.key,
    required this.simCards,
    required this.selectedSimCard,
    required this.onSimCardSelected,
  });

  @override
  State<SimCardsList> createState() => _SimCardsListState();
}

class _SimCardsListState extends State<SimCardsList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap:true,
      itemCount: widget.simCards.length,
      itemBuilder: (context, index) {
        SimCardEntity simCard = widget.simCards[index];
        bool isSelected = simCard == widget.selectedSimCard;

        return GestureDetector(
          onTap: (){
            widget.onSimCardSelected(simCard);
          },
          child: Container(
            color: isSelected ? Colors.blue[100] : Colors.transparent, // Highlight selected item
            child: ListTile(
              title: Text(
                simCard.name,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text("Slot: ${simCard.slotNumber}"), // Optional: add more details
            ),
          ),
        );
      },
    );
  }
}
