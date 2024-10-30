import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
      Navigator.of(context).pushReplacementNamed('/register');
    } catch (e) {
      print('Erro ao deletar conta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 20),
            Text('Nome: ${user?.displayName ?? 'Usuário'}'),
            Text('E-mail: ${user?.email ?? 'Email não encontrado'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _auth.sendPasswordResetEmail(email: user?.email ?? ''),
              child: Text('Redefinir Senha'),
            ),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: Text('Sair'),
            ),
            TextButton(
              onPressed: () => _deleteAccount(context),
              child: Text('Deletar Conta', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
