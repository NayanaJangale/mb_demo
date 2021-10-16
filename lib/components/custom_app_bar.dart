import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String caption;
  final Function onIconPressed;
  final Function onBackPressed;
  final IconData icon;
  final backButtonVisibility ;
  const CustomAppbar({
    this.caption,
    this.onIconPressed,
    this.onBackPressed,
    this.icon,
    this.backButtonVisibility = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Scaffold.of(context).appBarMaxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: backButtonVisibility,
                child: Container(
                  width: AppBar().preferredSize.height - 8,
                  height: AppBar().preferredSize.height - 8,
                  //   color: Colors.white,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                        child: Icon(
                          Icons.arrow_back,
                          // color: Theme.of(context).primaryColorDark,
                        ),
                        onTap: onBackPressed
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4,left: 20),
                    child: Text(
                      caption,
                      style: Theme.of(context).textTheme.caption.copyWith(
                        // color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),

                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only( right: 8),
                child: Container(
                  width: AppBar().preferredSize.height - 8,
                  height: AppBar().preferredSize.height - 8,
                  //   color: Colors.white,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                        child: Icon(
                          icon,
                          // color: Theme.of(context).primaryColorDark,
                        ),
                        onTap: onIconPressed
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10 ),
        ),
      ],
    );
  }
}
