import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/viewmodel/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => BirthdayScreenState();
}

class BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  final DateTime _birthday = DateTime.now();

  final DateTime initialDate = DateTime.now();
  DateTime maximumDate = DateTime.now();

  final int maximumOld = 12;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    maximumDate = maximumDate.add(Duration(days: -365 * maximumOld));
    _setTextFieldDate(maximumDate);
    // print(maximumDate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    ref.read(signUpProvider.notifier).signUp(context);
    // print(ref.read(signUpForm));

    //context.pushReplacementNamed(InterestsScreen.routeName);
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = (date.toString().split(" ").first);
    _birthdayController.value = TextEditingValue(text: textDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Gaps.v40,
          const Text(
            "When's your birthday?",
            style: TextStyle(
              fontSize: Sizes.size24,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v8,
          const Text(
            "Your birthday won't be shown publicly",
            style: TextStyle(
              color: Colors.black54,
              fontSize: Sizes.size16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v16,
          TextField(
            enabled: false,
            controller: _birthdayController,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            cursorColor: Theme.of(context).primaryColor,
          ),
          Gaps.v16,
          GestureDetector(
            onTap: _onNextTap,
            child: FormButton(disabled: ref.watch(signUpProvider).isLoading),
          )
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
          child: SizedBox(
        height: 300,
        child: CupertinoDatePicker(
          maximumDate: maximumDate,
          initialDateTime: maximumDate,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: _setTextFieldDate,
        ),
      )),
    );
  }
}
