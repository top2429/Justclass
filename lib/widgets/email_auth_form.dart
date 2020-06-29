import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/home_screen.dart';
import 'package:justclass/utils/validators.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

class EmailAuthForm extends StatefulWidget {
  final Function setLoadingStatus;

  EmailAuthForm({this.setLoadingStatus, Key key}) : super(key: key);

  @override
  EmailAuthFormState createState() => EmailAuthFormState();
}

class EmailAuthFormState extends State<EmailAuthForm> with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();

  // a flag used in switching between sign in and sign up mode
  bool _isSigningIn = true;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // flags indicating whether the inputs are empty, this is needed to hide or show trailing buttons
  bool _isEmailEmpty = true;
  bool _isPasswordEmpty = true;
  bool _isConfirmEmpty = true;

  bool _isPasswordVisible = false;

  // after the user presses the sign button once, the auto-validation feature will be on
  bool _autoValidate = false;

  // show or hide confirm input to/from [_form], so _form.currentState.validate() can work with both modes
  bool _isConfirmVisible = false;

  AnimationController _animController;
  Animation<double> _sizeAnim;
  Animation<double> _fadeAnim;

  @override
  void initState() {
    _animController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _sizeAnim = Tween<double>(begin: 0, end: 1).animate(_animController);
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.4, 1)),
    );

    super.initState();
  }

  void _toHomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void toSignUpMode() {
    _isConfirmVisible = true;
    _setFormToInitState();
    _animController.forward().then((_) {
      setState(() {
        _isSigningIn = false;
      });
    });
  }

  void toSignInMode() {
    _setFormToInitState();
    _animController.reverse().then((_) {
      setState(() {
        _isSigningIn = true;
        _isConfirmVisible = false;
      });
    });
  }

  void _setFormToInitState() {
    _unFocus();
    setState(() {
      _autoValidate = false;
      _isPasswordVisible = false;
      _isEmailEmpty = true;
      _isPasswordEmpty = true;
      _isConfirmEmpty = true;
    });
    _form.currentState.reset();
    _emailController.clear();
    _passwordController.clear();
    _confirmController.clear();
  }

  void _unFocus() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _confirmFocusNode.unfocus();
  }

  Future<void> signIn() async {
    if (!_form.currentState.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      this.widget.setLoadingStatus(true);
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signInEmailPasswordFirebase(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (auth.user != null) _toHomeScreen(context);
    } catch (error) {
      AppSnackBar.showContextError(context, message: error.toString());
    } finally {
      this.widget.setLoadingStatus(false);
    }
  }

  Future<void> signUp() async {
    if (!_form.currentState.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      this.widget.setLoadingStatus(true);
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signUpEmailPasswordFirebase(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (auth.user != null) _toHomeScreen(context);
    } catch (error) {
      AppSnackBar.showContextError(context, message: error.toString());
    } finally {
      this.widget.setLoadingStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: (isPortrait) ? width * 0.7 : width * 0.6,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._buildEmailInput(),
              const SizedBox(height: 20),
              ..._buildPasswordInput(),
              Visibility(visible: _isConfirmVisible, child: _buildConfirmInput()),
              const SizedBox(height: 70),
              _buildAuthButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton() {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          _isSigningIn ? "Sign In" : "Sign Up",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        elevation: 5,
        color: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
        onPressed: () {
          _isSigningIn ? signIn() : signUp();
          setState(() => _autoValidate = true);
        },
      ),
    );
  }

  final enableBorder = const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
  final focusedBorder = const OutlineInputBorder(borderSide: BorderSide(color: Colors.white70));
  final focusedErrorBorder = const OutlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent));
  final errorBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.5)));

  List<Widget> _buildEmailInput() {
    return [
      const Text("Email", style: TextStyle(color: Colors.white70, fontSize: 15)),
      const SizedBox(height: 5),
      TextFormField(
        autovalidate: _autoValidate,
        cursorColor: Colors.white70,
        style: const TextStyle(color: Colors.white70, fontSize: 17),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding: const EdgeInsets.all(0),
          enabledBorder: enableBorder,
          focusedBorder: focusedBorder,
          focusedErrorBorder: focusedErrorBorder,
          errorBorder: errorBorder,
          prefixIcon: const Icon(Icons.email, color: Colors.white60),
          suffixIcon: (_isEmailEmpty)
              ? const SizedBox(width: 0)
              : IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white54),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _emailController.clear());
                    setState(() => _isEmailEmpty = true);
                  },
                ),
          errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
          errorText: null,
        ),
        focusNode: _emailFocusNode,
        controller: _emailController,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
        onChanged: (val) => setState(() => _isEmailEmpty = val.isEmpty),
        validator: EmailPassValidator.validateEmail,
      ),
    ];
  }

  List<Widget> _buildPasswordInput() {
    return [
      const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 15)),
      const SizedBox(height: 5),
      TextFormField(
        autovalidate: _autoValidate,
        obscureText: !_isPasswordVisible,
        cursorColor: Colors.white70,
        style: const TextStyle(color: Colors.white70, fontSize: 17),
        textInputAction: (_isSigningIn) ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding: const EdgeInsets.all(0),
          enabledBorder: enableBorder,
          focusedBorder: focusedBorder,
          focusedErrorBorder: focusedErrorBorder,
          errorBorder: errorBorder,
          prefixIcon: const Icon(Icons.vpn_key, color: Colors.white60),
          suffixIcon: (_isPasswordEmpty)
              ? const SizedBox(width: 0)
              : IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white54),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
          errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
          errorMaxLines: 2,
        ),
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        onEditingComplete: _isSigningIn ? null : () => FocusScope.of(context).requestFocus(_confirmFocusNode),
        onChanged: (val) => setState(() => _isPasswordEmpty = val.isEmpty),
        validator: EmailPassValidator.validatePassword,
      ),
    ];
  }

  Widget _buildConfirmInput() {
    return SizeTransition(
      sizeFactor: _sizeAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text("Confirm Password", style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 5),
            TextFormField(
              autovalidate: _autoValidate,
              obscureText: true,
              cursorColor: Colors.white70,
              style: const TextStyle(color: Colors.white70, fontSize: 17),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: const EdgeInsets.all(0),
                enabledBorder: enableBorder,
                focusedBorder: focusedBorder,
                focusedErrorBorder: focusedErrorBorder,
                errorBorder: errorBorder,
                prefixIcon: const Icon(Icons.beenhere, color: Colors.white60),
                suffixIcon: (_isConfirmEmpty)
                    ? const SizedBox(width: 0)
                    : IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.white54),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) => _confirmController.clear());
                          setState(() => _isConfirmEmpty = true);
                        },
                      ),
                errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
                errorMaxLines: 2,
              ),
              focusNode: _confirmFocusNode,
              controller: _confirmController,
              onChanged: (val) => setState(() => _isConfirmEmpty = val.isEmpty),
              validator: (val) => EmailPassValidator.validateConfirm(val, _passwordController.text),
            ),
          ],
        ),
      ),
    );
  }
}
