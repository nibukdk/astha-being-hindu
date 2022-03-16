import 'package:astha/widgets/app_bar/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  late TextEditingController _searchFormController;

  late FocusNode _searchFormFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFormController = TextEditingController();
    _searchFormFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _searchFormController.dispose();
    _searchFormFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SerachBar(_searchFormController, _searchFormFocusNode),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [Text("This is events screen")],
        ),
      ),
    );
  }
}
