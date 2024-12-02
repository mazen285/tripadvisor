import 'package:flutter/material.dart';
import 'forgotpassword.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _scale = 1.0;
  String _passwordStrength = "";

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  // Password strength checker
  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length >= 8 &&
          RegExp(r'[A-Z]').hasMatch(password) &&
          RegExp(r'[0-9]').hasMatch(password)) {
        _passwordStrength = "Strong";
      } else if (password.length >= 6) {
        _passwordStrength = "Medium";
      } else {
        _passwordStrength = "Weak";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    suffixIcon: Tooltip(
                      message: 'Enter a valid email address',
                      child: Icon(Icons.info_outline),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),

              // Password Field
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Tooltip(
                      message: 'Password must be at least 6 characters',
                      child: Icon(Icons.info_outline),
                    ),
                  ),
                  obscureText: true,
                  onChanged: _checkPasswordStrength,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),

              // Password Strength Indicator
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _passwordStrength == "Strong"
                          ? 1.0
                          : (_passwordStrength == "Medium" ? 0.5 : 0.2),
                      backgroundColor: Colors.grey[300],
                      color: _passwordStrength == "Strong"
                          ? Colors.green
                          : (_passwordStrength == "Medium"
                          ? Colors.orange
                          : Colors.red),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _passwordStrength,
                    style: TextStyle(
                      color: _passwordStrength == "Strong"
                          ? Colors.green
                          : (_passwordStrength == "Medium"
                          ? Colors.orange
                          : Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Confirm Password Field
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),

              // Sign Up Button with Gradient
              GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: AnimatedScale(
                  scale: _scale,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Account created successfully!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      }
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Forgot Password and Login Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                  Text('|'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Already have an account? Login'),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Social Media Sign-Up Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook, color: Colors.blue, size: 30),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Facebook sign-up not implemented')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 30),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Google sign-up not implemented')),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Clear All Button
              TextButton(
                onPressed: () {
                  _emailController.clear();
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                  setState(() {
                    _passwordStrength = "";
                  });
                },
                child: Text('Clear All'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
