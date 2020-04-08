import 'package:flutter/material.dart';

class EmailAuthForm extends StatefulWidget {
  EmailAuthForm({Key key}) : super(key: key);

  @override
  EmailAuthFormState createState() => EmailAuthFormState();
}

class EmailAuthFormState extends State<EmailAuthForm> with SingleTickerProviderStateMixin {
  bool isLogin = true;

  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _emptyEmail = true;
  bool _emptyPassword = true;
  bool _emptyConfirm = true;

  AnimationController _AnimController;
  Animation<double> _sizeAnim;

  @override
  void initState() {
    _AnimController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _sizeAnim = Tween<double>(begin: 0, end: 1).animate(_AnimController);

    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _AnimController.dispose();
    super.dispose();
  }

  void toSignUpMode() {
    _AnimController.forward().then((_) {
      setState(() {
        isLogin = false;
      });
    });
  }

  void toLoginMode() {
    _AnimController.reverse().then((_) {
      setState(() {
        isLogin = true;
      });
    });
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._buildEmailInput(),
              const SizedBox(height: 20),
              ..._buildPasswordInput(),
              _buildConfirmInput(),
              const SizedBox(height: 70),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          isLogin ? "Login" : "Sign Up",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        onPressed: () {},
      ),
    );
  }

  List<Widget> _buildEmailInput() {
    return [
      const Text("Email", style: TextStyle(color: Colors.white70, fontSize: 15)),
      const SizedBox(height: 5),
      TextFormField(
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
            borderSide: BorderSide(color: Colors.amber[700]),
          ),
          prefixIcon: const Icon(Icons.email, color: Colors.white60),
          suffixIcon: (_emptyEmail)
              ? const SizedBox(width: 0)
              : GestureDetector(
                  child: const Icon(Icons.cancel, color: Colors.white54),
                  onTap: () {
                    _emailController.text = "";
                    setState(() => _emptyEmail = true);
                  },
                ),
          errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
          errorText: null,
        ),
        controller: _emailController,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
        onChanged: (val) {
          if (val.length > 1) return;
          setState(() => _emptyEmail = val.isEmpty);
        },
      ),
    ];
  }

  List<Widget> _buildPasswordInput() {
    return [
      const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 15)),
      const SizedBox(height: 5),
      TextFormField(
        obscureText: true,
        cursorColor: Colors.white70,
        style: const TextStyle(color: Colors.white70, fontSize: 17),
        textInputAction: (isLogin) ? TextInputAction.done : TextInputAction.next,
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
            borderSide: BorderSide(color: Colors.amber[700]),
          ),
          prefixIcon: const Icon(Icons.vpn_key, color: Colors.white60),
          suffixIcon: (_emptyPassword)
              ? const SizedBox(width: 0)
              : GestureDetector(
                  child: const Icon(Icons.cancel, color: Colors.white54),
                  onTap: () {
                    _passwordController.text = "";
                    setState(() => _emptyPassword = true);
                  },
                ),
          errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
          errorText: null,
        ),
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        onEditingComplete:
            isLogin ? null : () => FocusScope.of(context).requestFocus(_confirmFocusNode),
        onChanged: (val) {
          if (val.length > 1) return;
          setState(() => _emptyPassword = val.isEmpty);
        },
      ),
    ];
  }

  Widget _buildConfirmInput() {
    return SizeTransition(
      sizeFactor: _sizeAnim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Text("Confirm", style: TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 5),
          TextFormField(
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
                borderSide: BorderSide(color: Colors.amber[700]),
              ),
              prefixIcon: const Icon(Icons.beenhere, color: Colors.white60),
              suffixIcon: (_emptyConfirm)
                  ? const SizedBox(width: 0)
                  : GestureDetector(
                      child: const Icon(Icons.cancel, color: Colors.white54),
                      onTap: () {
                        _confirmController.text = "";
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
          ),
        ],
      ),
    );
  }
}
