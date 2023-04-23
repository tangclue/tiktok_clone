import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/viewmodel/login_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginFormScreen> createState() => LoginFormScreenState();
}

class LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref
            .read(loginProvider.notifier)
            .login(formData["email"]!, formData["password"]!, context);
        // print(formData);
        // context.goNamed(InterestsScreen.routeName);
      }
    }
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log in")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['email'] = newValue;
                    }
                  },
                ),
                Gaps.v16,
                TextFormField(
                  decoration: const InputDecoration(hintText: "Password"),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['password'] = newValue;
                    }
                  },
                ),
                Gaps.v28,
                GestureDetector(
                    onTap: _onSubmitTap,
                    child: FormButton(
                        disabled: ref.watch(loginProvider).isLoading,
                        buttonText: "Log in")),
              ],
            )),
      ),
    );
  }
}
