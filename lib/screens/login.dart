import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universe_explorer/models/planetas_explorados.dart';
import 'package:universe_explorer/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Tela de login.
class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  /// Realiza a autenticação com o Google.
  Future<UserCredential> signInWithGoogle() async {
    // Inicia o fluxo de autenticação
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtém os detalhes da autenticação a partir do request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Cria uma credencial
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // retorna a credencial do usuário (UserCredential)
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    // var auth = context.read<LoggedUser>();
    var authService = context.read<AuthService>();
    // var username = null;
    // var password = null;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Explore!',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Para iniciar a exploração, faça login utilizando sua conta Google'),
                SizedBox(
                  height: 20,
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     hintText: 'Nome de usuário',
                //   ),
                //   onChanged: (value) {
                //     username = value;
                //   },
                // ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     hintText: 'Senha',
                //   ),
                //   obscureText: true,
                //   onChanged: (value) {
                //     password = value;
                //   },
                // ),
                // SizedBox(
                //   height: 24,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ElevatedButton(
                    //   child: Text('ENTRAR'),
                    //   onPressed: () {
                    //     auth.signIn(username, password);
                    //     if (auth.username != null) {
                    //       Navigator.pushReplacementNamed(context, '/planets');
                    //     } else {
                    //       showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return AlertDialog(
                    //             title: Text('Atenção!'),
                    //             content: Text(
                    //                 'Forneça as credenciais corretamente.'),
                    //             actions: [
                    //               TextButton(
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //                 child: Text('FECHAR'),
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.blue,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    ElevatedButton(
                      child: Text('GOOGLE'),
                      onPressed: () async {
                        try {
                          // chama o método signInWithGoogle() e obtém as credenciais
                          var credentials = await signInWithGoogle();
                          // armazena as credenciais no authService
                          authService.user = credentials.user;
                          // apresenta uma snackbar com informação do login
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Você logou como ${credentials.user.email}'),
                            ),
                          );
                          // navega para a tela de Planetas
                          Navigator.pushReplacementNamed(context, '/planets');
                        } catch (e) {
                          // se ocorrer erro, apresenta uma dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Atenção!'),
                                content: Text(
                                    'Ocorreu um erro na autenticação. Tente novamente dentro de alguns intantes.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('FECHAR'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
