import 'package:antlabs_assignment/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('')),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Dynamic horizontal padding
            vertical: screenHeight * 0.05, // Dynamic vertical padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Log in",
                style: TextStyle(
                  fontSize: screenWidth * 0.08, // Dynamic font size
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.07),
              GestureDetector(
                onTap: () {
                  final email = emailController.text;
                  final password = passwordController.text;

                  if (email == 'customer@gmail.com' && password == 'client123') {
                    authProvider.login(email, 'customer');
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  } else if (email == 'support@gmail.com' && password == 'support123') {
                    authProvider.login(email, 'support');
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  } else if (email == 'admin@gmail.com' && password == 'admin123') {
                    authProvider.login(email, 'admin');
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Login Failed'),
                        content: const Text('Invalid credentials!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.07, // Dynamic height
                  width: screenWidth * 0.9, // Dynamic width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue[700],
                  ),
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Dynamic font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
