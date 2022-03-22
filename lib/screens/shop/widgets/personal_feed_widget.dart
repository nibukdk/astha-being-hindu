import 'package:astha/screens/shop/provider/shop_provider.dart';
import 'package:astha/screens/shop/widgets/shop_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PersonalFeedWidget extends StatelessWidget {
  const PersonalFeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is device height
    final deviceHeight = MediaQuery.of(context).size.height;
    // Device width
    final deviceWidth = MediaQuery.of(context).size.width;
    // Subtract paddings to calculate available dimensions
    final availableHeight = deviceHeight -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    final availableWidth = deviceWidth -
        MediaQuery.of(context).padding.right -
        MediaQuery.of(context).padding.left;

    final shopItemLists = Provider.of<ShopProvider>(context).items;

    return SizedBox(
        height: 400,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 2 / 3,
          ),
          itemCount: shopItemLists.length,
          itemBuilder: (context, i) => ShopItemWidget(
              width: availableWidth,
              imgUrl: shopItemLists[i].imgUrl,
              itemType: shopItemLists[i].itemType,
              price: shopItemLists[i].price,
              title: shopItemLists[i].name,
              ratings: shopItemLists[i].ratings),
        ));
  }
}


// ListView.builder(
//         itemCount: shopItemLists.length,
//         itemBuilder: (context, i) => ShopItemWidget(
//             width: availableWidth,
//             imgUrl: shopItemLists[i].imgUrl,
//             itemType: shopItemLists[i].itemType,
//             price: shopItemLists[i].price,
//             title: shopItemLists[i].name,
//             ratings: shopItemLists[i].ratings),
//       ),