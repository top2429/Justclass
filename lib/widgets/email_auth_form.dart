import 'package:flutter/material.dart';

class EmailAuthForm extends StatefulWidget {
  @override
  _EmailAuthFormState createState() => _EmailAuthFormState();
}

class _EmailAuthFormState extends State<EmailAuthForm> {
  final _passwordFocusNode = FocusNode();

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
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Email", style: TextStyle(color: Colors.white70, fontSize: 15)),
                  TextFormField(
                    cursorColor: Colors.white70,
                    style: const TextStyle(color: Colors.white70, fontSize: 17),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      contentPadding: const EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber[700]),
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.white60),
                      suffix: const SizedBox(width: 0),
                      errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
//                        errorText: "Invalid email",
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 15)),
                  TextFormField(
                    obscureText: true,
                    cursorColor: Colors.white70,
                    style: const TextStyle(color: Colors.white70, fontSize: 17),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      contentPadding: const EdgeInsets.all(0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber[700]),
                      ),
                      prefixIcon: const Icon(Icons.vpn_key, color: Colors.white60),
                      suffix: const SizedBox(width: 0),
                      errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 14),
//                        errorText: "Invalid email",
                    ),
                    focusNode: _passwordFocusNode,
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    height: 40,
                    width: (orientation == Orientation.portrait) ? width * 0.7 : width * 0.6,
                    child: RaisedButton(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
