import 'package:belay/utils/style.dart';
import 'package:flutter/material.dart';

class SinglePageInput extends StatelessWidget {
  final headerText;
  final void Function()? handleBack;
  final form;
  final String? info;

  SinglePageInput({
    required this.headerText,
    required this.form,
    this.info,
    this.handleBack,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (this.handleBack != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 12, top: 40, bottom: 25),
                    child: BackButton(onPressed: handleBack),
                  ),
                ),
              Container(
                padding: EdgeInsets.only(
                  // should be 88 pixels for top padding
                  top: this.handleBack == null ? 50 : 5,
                  bottom: 20 * Style.ratioV!,
                ),
                child: Text(
                  headerText,
                  textAlign: TextAlign.center,
                  style: Style.h2,
                ),
              ),
              if (info != null)
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50, bottom: 50 * Style.ratioV!),
                  child: Text(
                    info!,
                    textAlign: TextAlign.center,
                    style: Style.h4,
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  child: form,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
