import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/model/ice_cream_Item.dart';

class IceCreamCart extends StatefulWidget {
  const IceCreamCart({super.key, required this.iceCreamItem});

  final IceCreamItem iceCreamItem;

  @override
  State<IceCreamCart> createState() => _IceCreamCartState();
}

class _IceCreamCartState extends State<IceCreamCart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.iceCreamItem.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '\$${widget.iceCreamItem.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
