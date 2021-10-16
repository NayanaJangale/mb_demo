import 'package:flutter/material.dart';

class ListFilterBar extends StatelessWidget {
  final Function onCloseButtonTap;
  final TextEditingController searchFieldController;

  ListFilterBar({
    this.onCloseButtonTap,
    this.searchFieldController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          top: 8,
          bottom: 10.0,
          right: 10.0,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: TextFormField(
                  controller: searchFieldController,
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                        ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
                            behavior: HitTestBehavior.translucent,
              onTap: onCloseButtonTap,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
