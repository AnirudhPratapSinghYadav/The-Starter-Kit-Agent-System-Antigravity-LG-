import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LGService extends ChangeNotifier {
  SSHClient? _client;
  bool _isConnected = false;
  String _host = '';
  String _port = '';
  String _username = '';
  String _passwordOrKey = '';
  String _numberOfRigs = '';

  bool get isConnected => _isConnected;

  // --- CONNECTION MANAGEMENT ---

  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? '192.168.0.1';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool> connect() async {
    await initConnectionDetails();
    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port), timeout: const Duration(seconds: 5));
      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
      );
      _isConnected = true;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) print('Failed to connect: $e');
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> disconnect() async {
    _client?.close();
    _client = null;
    _isConnected = false;
    notifyListeners();
  }

  // --- CORE COMMANDS ---

  Future<SSHSession?> run(String command) async {
    if (_client == null) return null;
    try {
      return await _client!.execute(command);
    } catch (e) {
      if (kDebugMode) print('Command failed: $e');
      return null;
    }
  }

  // --- KML PRIMITIVES ---

  Future<void> sendKML(String content, String filename) async {
    if (!_isConnected) return;
    String encoded = base64Encode(utf8.encode(content));
    await run("echo '$encoded' | base64 -d > /var/www/html/kmls/$filename");
    await run("chmod 777 /var/www/html/kmls/$filename");
    
    // Link to Master (kmls.txt) is often required for the master logic to pick it up
    // But for modularity, let's keep it separate or have a specific method.
  }

  Future<void> sendToSlave(int slaveNumber, String kmlContent) async {
    if (!_isConnected) return;
    // Slaves 2 and 3 usually have specific KML paths or sync logic.
    // Standard approach: Write to Master, Master syncs to Slaves via `driver.kml` or `kmls.txt` updates.
    // DIRECT INJECTION approach (used in advanced setups):
    // Requires SSH access to slave IPs or mapped ports.
    // Here we assume Master-Managed Slaves (standard GSoC setup).
    // We upload to a specific file that the slave is configured to read.
    
    await sendKML(kmlContent, 'slave_$slaveNumber.kml');
    await _refreshSlave(slaveNumber);
  }

  Future<void> _refreshSlave(int slaveNumber) async {
      // Logic to force refresh on slave. 
      // Usually involves sed command on master to update kml links.
      // Keeping it simple for Starter Kit: Just upload. 
      // Real sync logic would go here.
  }
  
  Future<void> query(String query) async {
    if (!_isConnected) return;
    await run('echo "$query" > /tmp/query.txt');
  }

  Future<void> flyTo(double lat, double lon, double range, double tilt, double heading) async {
    await query('flytoview=<LookAt><longitude>$lon</longitude><latitude>$lat</latitude><altitude>0</altitude><heading>$heading</heading><tilt>$tilt</tilt><range>$range</range><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>');
  }

  Future<void> clear() async {
    String blank = '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://www.opengis.net/kml/2.2"><Document></Document></kml>';
    await sendKML(blank, 'master_layer.kml');
    await query(''); // Clear query.txt
  }

  // --- SYSTEM CONTROL ---

  Future<void> reboot() async {
    if (!_isConnected) return;
    int rigs = int.tryParse(_numberOfRigs) ?? 3;
    for (var i = 1; i <= rigs; i++) {
      // Loop through rigs. Note: reliable reboot requires keys or sshpass for other rigs.
      // This is a placeholder for the master reboot logic.
      await run('echo $_passwordOrKey | sudo -S reboot');
    }
  }
}
