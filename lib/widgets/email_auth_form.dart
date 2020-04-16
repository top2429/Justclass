import 'package:flutter/material.dart';
import 'package:justclass/utils/validator.dart';

class EmailAuthForm extends StatefulWidget {
  final Function changeLoadingStatus;

  EmailAuthForm({this.changeLoadingStatus, Key key}) : super(key: key);

  @override
  EmailAuthFormState createState() => EmailAuthFormState();
}

class EmailAuthFormState extends State<EmailAuthForm> with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  bool _isSigningIn = true;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _emptyEmail = true;
  bool _emptyPassword = true;
  bool _emptyConfirm = true;

  AnimationController _animController;
  Animation<double> _sizeAnim;
  Animation<double> _fadeAnim;

  bool _autoValidate = false;

  @override
  void initState() {
    _animController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _sizeAnim = Tween<double>(begin: 0, end: 1).animate(_animController);
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animController,
      curve: Interval(0.4, 1),
    ));

    super.initState();
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
    _setFormToInitState();
    _animController.forward().then((_) {
      setState(() => _isSigningIn = false);
    });
  }

  void toSignInMode() {
    _setFormToInitState();
    _animController.reverse().then((_) {
      setState(() => _isSigningIn = true);
    });
  }

  void _setFormToInitState() {
    _unFocus();
    setState(() => _autoValidate = false);
    _form.currentState.reset();
  }

  void _unFocus() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _confirmFocusNode.unfocus();
  }

  void signIn() {
    if (!_form.currentState.validate()) return;
    // TODO add sign in code
  }

  void signUp() {
    if (!_form.currentState.validate()) return;
    // TODO add sign in code
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: (orientation == Orientation.portrait) ? width * 0.7 : width * 0.6,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._buildEmailInput(),
              const SizedBox(height: 20),
              ..._buildPasswordInput(),
              _buildConfirmInput(),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        onPressed: () {
          _isSigningIn ? signIn() : signUp();
          setState(() => _autoValidate = true);
        },
      ),
    );
  }

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
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amberAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.5)),
          ),
          prefixIcon: const Icon(Icons.email, color: Colors.white60),
          suffixIcon: (_emptyEmail)
              ? const SizedBox(width: 0)
              : IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white54),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _emailController.clear());
                    setState(() => _emptyEmail = true);
                  },
                ),
          errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
          errorText: null,
        ),
        focusNode: _emailFocusNode,
        controller: _emailController,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
        onChanged: (val) {
          if (val.length > 1) return;
          setState(() => _emptyEmail = val.isEmpty);
        },
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
        obscureText: true,
        cursorColor: Colors.white70,
        style: const TextStyle(color: Colors.white70, fontSize: 17),
        textInputAction: (_isSigningIn) ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding: const EdgeInsets.all(0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amberAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.5)),
          ),
          prefixIcon: const Icon(Icons.vpn_key, color: Colors.white60),
          suffixIcon: (_emptyPassword)
              ? const SizedBox(width: 0)
              : IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white54),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _passwordController.clear());
                    setState(() => _emptyPassword = true);
                  },
                ),
          errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
          errorText: null,
        ),
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        onEditingComplete: _isSigningIn ? null : () => FocusScope.of(context).requestFocus(_confirmFocusNode),
        onChanged: (val) {
          if (val.length > 1) return;
          setState(() => _emptyPassword = val.isEmpty);
        },
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
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.5)),
                ),
                prefixIcon: const Icon(Icons.beenhere, color: Colors.white60),
                suffixIcon: (_emptyConfirm)
                    ? const SizedBox(width: 0)
                    : IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.white54),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) => _confirmController.clear());
                          setState(() => _emptyConfirm = true);
                        },
                      ),
                errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
                errorText: null,
              ),
              focusNode: _confirmFocusNode,
              controller: _confirmController,
              onChanged: (val) {
                if (val.length > 1) return;
                setState(() => _emptyConfirm = val.isEmpty);
              },
              validator: (val) {
                return EmailPassValidator.validateConfirm(val, _passwordController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
