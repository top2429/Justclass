import 'package:flutter/material.dart';

class EmailAuthForm extends StatefulWidget {
  EmailAuthForm({Key key}) : super(key: key);

  @override
  _EmailAuthFormState createState() => _EmailAuthFormState();
}

class _EmailAuthFormState extends State<EmailAuthForm> {
  final _passwordFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _emptyEmail = true;
  bool _emptyPassword = true;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;

    return IntrinsicWidth(
      child: Padding(
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
                const SizedBox(height: 80),
                _buildLoginButton(),
              ],
            ),
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
          "Login",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        elevation: 3,
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
        onChanged: (val) {
          if (val.length > 1) return;
          setState(() => _emptyPassword = val.isEmpty);
        },
      ),
    ];
  }
}
