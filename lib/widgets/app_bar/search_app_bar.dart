import 'package:flutter/material.dart';

class SerachBar extends StatelessWidget {
  SerachBar(this._searchFormController, this._searchFormFocusNode, {Key? key})
      : super(key: key);

  final TextEditingController _searchFormController;
  final FocusNode _searchFormFocusNode;
  // final Function autoCompleteSearch;
  final _inputKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final devicePadding = MediaQuery.of(context).padding.right +
        MediaQuery.of(context).padding.left;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      width: (MediaQuery.of(context).size.width - devicePadding) * .8,
      // height: 40,
      child: TextFormField(
        key: _inputKey,
        textInputAction: TextInputAction.search,
        controller: _searchFormController,
        focusNode: _searchFormFocusNode,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          label: Text("Search Temples & Venues"),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
