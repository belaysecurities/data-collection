import 'package:belay/components/single_page_input.dart';
import 'package:belay/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../root.dart';

class ManualLogin extends StatelessWidget {
  final void Function() onContinue;
  ManualLogin({required this.onContinue});
  Widget build(BuildContext context) {
    return SinglePageInput(
      headerText: "Manual Login",
      form: ManualLoginForm(
        onContinue: onContinue,
      ),
    );
  }
}

class ManualLoginForm extends HookWidget {
  final void Function() onContinue;
  ManualLoginForm({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final jwtController = useTextEditingController();
    final isSubmitting = useState(false);
    final error = useState('');
    final notifier = Provider.of<ValueNotifier<UserWrapper>>(context, listen: true);
    void submit() async {
      final form = Form.of(context);

      if (!form!.validate()) {
        return;
      }

      isSubmitting.value = true;
      try {
        await auth.signInWithCustomToken(jwtController.value.text);
        while (notifier.value.user == null) {
          await Future.delayed(Duration(milliseconds: 100));
        }
        onContinue();
      } catch (ex) {
        error.value = 'If this screen is not updating, please reload the page.';
      }
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            autofocus: true,
            controller: jwtController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'JWT Token',
            ),
            enabled: !isSubmitting.value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
            },
          ),
        ),
        if (error.value.isNotEmpty)
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              error.value,
              textAlign: TextAlign.center,
              style: textTheme.caption!.copyWith(color: Colors.red),
            ),
          ),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: ElevatedButton(
            child: Text(
              'Continue',
            ),
            style: Style.btn1,
            onPressed: isSubmitting.value ? null : submit,
          ),
        ),
      ],
    );
  }
}
