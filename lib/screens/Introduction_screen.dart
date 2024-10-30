import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/introduction_image.png', height: 200),
            SizedBox(height: 30),
            Text(
              'Controle seu dinheiro de forma fácil e inteligente',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nosso app te ajuda a acompanhar seus gastos, organizar seu orçamento e planejar suas finanças.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
