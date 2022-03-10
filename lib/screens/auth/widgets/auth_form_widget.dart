import 'package:astha/screens/auth/provider/auth_state_provider.dart';
import 'package:astha/screens/auth/utils/auth_utils.dart';
import 'package:astha/screens/auth/utils/auth_validators.dart';
import 'package:astha/screens/auth/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget({Key? key}) : super(key: key);

  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  // Instantiate validator
  final AuthValidators authValidator = AuthValidators();

  // Define Form key
  final _formKey = GlobalKey<FormState>();
  // controllers
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

// create focus nodes
  late FocusNode emailFocusNode;
  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  bool obscureText = true;
  bool registerAuthMode = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    emailFocusNode = FocusNode();
    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

// Create a scaffold messanger
  SnackBar msgPopUp(msg) {
    return SnackBar(
        content: Text(
      msg,
      textAlign: TextAlign.center,
    ));
  }

  void _submitForm(
      AuthStateProvider authStateProvider, BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (isValid) {
      // Save current state if form is valid
      _formKey.currentState!.save();

      // Try Sigin Or Register
      if (registerAuthMode) {
        authStateProvider.register(email, password, username, context);
      }
    } else {
      authStateProvider.login(email, password, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthStateProvider authStateProvider =
        Provider.of<AuthStateProvider>(context);
    final ViewState viewState = authStateProvider.viewState;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email
            TextFormFieldWidget(
              controller: emailController,
              obscureText: false,
              focusNode: emailFocusNode,
              toggleObscureText: null,
              validator: authValidator.emailValidator,
              prefIcon: const Icon(Icons.mail),
              labelText: "Enter Email Address",
              textInputAction: TextInputAction.next,
              isEmailTextField: true,
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: registerAuthMode ? 65 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: registerAuthMode ? 1 : 0,
                child: TextFormFieldWidget(
                  controller: usernameController,
                  obscureText: false,
                  focusNode: usernameFocusNode,
                  toggleObscureText: null,
                  validator: null,
                  prefIcon: const Icon(Icons.person),
                  labelText: "Enter Username(Optional)",
                  textInputAction: TextInputAction.next,
                  isEmailTextField: true,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: registerAuthMode ? 1 : 0,
              child: const SizedBox(
                height: 20,
              ),
            ),
            TextFormFieldWidget(
              controller: passwordController,
              labelText: "Enter Password",
              obscureText: obscureText,
              focusNode: passwordFocusNode,
              toggleObscureText: toggleObscureText,
              validator: authValidator.passwordVlidator,
              prefIcon: const Icon(Icons.password),
              textInputAction: TextInputAction.done,
              isEmailTextField: false,
            ),

            const SizedBox(
              height: 20,
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: registerAuthMode ? 80 : 0,
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: registerAuthMode ? 1 : 0,
                  child: TextFormFieldWidget(
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    isEmailTextField: false,
                    labelText: "Confirm Password",
                    obscureText: obscureText,
                    prefIcon: const Icon(Icons.password),
                    textInputAction: TextInputAction.done,
                    toggleObscureText: toggleObscureText,
                    validator: (val) => authValidator.confirmPasswordValidator(
                        val, passwordController.text),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedOpacity(
              opacity: registerAuthMode ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: const SizedBox(
                height: 20,
              ),
            ),
            if (viewState == ViewState.busy) const CircularProgressIndicator(),
            if (viewState == ViewState.idle)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => _submitForm(authStateProvider, context),
                    child: Text(registerAuthMode ? 'Register' : 'Sign In'),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(8.0),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(registerAuthMode
                    ? AuthMode.register.titleText
                    : AuthMode.signin.titleText),
                TextButton(
                  onPressed: () =>
                      setState(() => registerAuthMode = !registerAuthMode),
                  child: Text(registerAuthMode
                      ? AuthMode.register.linkText
                      : AuthMode.signin.linkText),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
