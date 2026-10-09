import 'package:flutter/material.dart';
import 'package:restaurant_app/models/menu_item.dart';

class MenuItemCart extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onAddToCart;

  const MenuItemCart({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.horizontal(
              left: Radius.circular(16),
            ),
            child: Image.network(
              item.imageUrl,
              width: 110,
              height: 133,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 110,
                height: 133,
                color: Colors.grey.shade200,
                child: Icon(Icons.fastfood, size: 40, color: Colors.grey),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TM ${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton.filled(
                        onPressed: onAddToCart,
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
