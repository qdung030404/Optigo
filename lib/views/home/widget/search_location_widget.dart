import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:optigo/providers/search_provider.dart';
import 'package:optigo/models/place_model.dart';

class SearchLocationWidget extends StatefulWidget {
  final String hintText;
  final Function(PlaceModel)? onSelected;
  final SearchController? searchController;
  final String? initialText;

  const SearchLocationWidget({
    super.key,
    required this.hintText,
    this.onSelected,
    this.searchController,
    this.initialText,
  });

  @override
  State<SearchLocationWidget> createState() => _SearchLocationWidgetState();
}

class _SearchLocationWidgetState extends State<SearchLocationWidget> {
  SearchController? _internalController;

  SearchController get _effectiveController =>
      widget.searchController ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.searchController == null) {
      _internalController = SearchController();
      if (widget.initialText != null) {
        _internalController!.text = widget.initialText!;
      }
    } else if (widget.initialText != null) {
      widget.searchController!.text = widget.initialText!;
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return SearchAnchor(
          searchController: _effectiveController,
          builder: (context, controller) {
            return TextField(
              controller: controller,
              onTap: () {
                if (!controller.isOpen) {
                  controller.openView();
                }
              },
              onChanged: (value) {
                searchProvider.searchPlace(value);
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            );
          },
          suggestionsBuilder: (context, controller) {
            if (searchProvider.isSearching) {
              return const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              ];
            }

            if (searchProvider.searchResults.isEmpty &&
                controller.text.isNotEmpty) {
              return const [ListTile(title: Text('Không tìm thấy kết quả'))];
            }

            return searchProvider.searchResults.map((place) {
              return ListTile(
                title: Text(place.mainText),
                subtitle: Text(place.secondaryText),
                onTap: () {
                  controller.closeView(place.description);
                  if (widget.onSelected != null) {
                    widget.onSelected!(place);
                  }
                },
              );
            }).toList();
          },
        );
      },
    );
  }
}
