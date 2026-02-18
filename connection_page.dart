import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lg_starter_kit/services/lg_service.dart';
import 'package:lg_starter_kit/screens/home_screen.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('ipAddress') ?? '192.168.0.1';
      _usernameController.text = prefs.getString('username') ?? 'lg';
      _passwordController.text = prefs.getString('password') ?? 'lg';
      _portController.text = prefs.getString('sshPort') ?? '22';
      _rigsController.text = prefs.getString('numberOfRigs') ?? '3';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', _ipController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setString('sshPort', _portController.text);
    await prefs.setString('numberOfRigs', _rigsController.text);
  }

  Future<void> _connect() async {
    setState(() => _isLoading = true);
    await _saveSettings();
    
    final lg = Provider.of<LGService>(context, listen: false);
    bool success = await lg.connect();
    
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection Failed'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liquid Galaxy Connection")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _ipController, decoration: const InputDecoration(labelText: 'IP Address')),
              TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              TextField(controller: _portController, decoration: const InputDecoration(labelText: 'Port')),
              TextField(controller: _rigsController, decoration: const InputDecoration(labelText: 'Number of Rigs')),
              const SizedBox(height: 20),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _connect,
                    child: const Text('CONNECT TO RIG'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
