import 'package:flutter/material.dart';
import 'drawer_menu.dart';

// Pelanggan Class
class Pelanggan {
  // Properties
  String kode;
  String nama;

  // Constructor
  Pelanggan(this.kode, this.nama);

  // Optional: Method to display customer information
  @override
  String toString() {
    return 'Pelanggan(Kode: $kode, Nama: $nama)';
  }
}

// TransactionScreen Class
class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _kodeTransaksiController = TextEditingController();
  final _namaPelangganController = TextEditingController();
  final _jenisPelangganController = TextEditingController();
  final _tglMasukController = TextEditingController(); // New field for date
  final _jamMasukController = TextEditingController();
  final _jamKeluarController = TextEditingController();

  double _tarif = 10000; // Default rate per hour
  double _lama = 0; // Time spent in hours
  double _diskon = 0; // Discount based on customer type and time spent
  double _totalBayar = 0; // Final amount to be paid

  // Variables to store transaction details
  String _kodeTransaksi = '';
  String _namaPelanggan = '';
  String _jenisPelanggan = '';
  String _tglMasuk = '';
  String _jamMasuk = '';
  String _jamKeluar = '';

  void _calculateTarif() {
    if (_formKey.currentState!.validate()) {
      // Parsing input values
      _kodeTransaksi = _kodeTransaksiController.text;
      _namaPelanggan = _namaPelangganController.text;
      _jenisPelanggan = _jenisPelangganController.text;
      _tglMasuk = _tglMasukController.text; // Get the date
      _jamMasuk = _jamMasukController.text;
      _jamKeluar = _jamKeluarController.text;

      // Parse and convert input times to double
      final double jamMasuk = double.tryParse(_jamMasukController.text) ?? 0;
      final double jamKeluar = double.tryParse(_jamKeluarController.text) ?? 0;

      // Calculate the time spent (Lama)
      _lama = jamKeluar - jamMasuk;

      // Reset discount for recalculation
      _diskon = 0;

      // Calculate the total cost before discount
      double totalCost = _lama * _tarif;

      // Check for discount eligibility based on customer type and time spent
      if (_lama > 2) {
        if (_jenisPelanggan.toUpperCase() == "VIP") {
          _diskon = totalCost * 0.02; // 2% discount for VIP
        } else if (_jenisPelanggan.toUpperCase() == "GOLD") {
          _diskon = totalCost * 0.05; // 5% discount for GOLD
        }
      }

      // Calculate total amount to be paid after discount
      setState(() {
        _totalBayar = totalCost - _diskon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Transaction'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _kodeTransaksiController,
                decoration: InputDecoration(labelText: 'Kode Transaksi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the transaction code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaPelangganController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jenisPelangganController,
                decoration: InputDecoration(
                    labelText: 'Jenis Pelanggan (VIP/GOLD/REGULAR)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tglMasukController,
                decoration:
                    InputDecoration(labelText: 'Tgl Masuk (DD/MM/YYYY)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the entry date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jamMasukController,
                decoration: InputDecoration(
                    labelText: 'Jam Masuk (in hours, e.g., 14.00)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jamKeluarController,
                decoration: InputDecoration(
                    labelText: 'Jam Keluar (in hours, e.g., 16.00)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateTarif,
                child: Text('Calculate Tarif'),
              ),
              SizedBox(height: 20),

              // Displaying the transaction details
              Text('Transaction Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Kode Transaksi: $_kodeTransaksi'),
              Text('Nama Pelanggan: $_namaPelanggan'),
              Text('Jenis Pelanggan: $_jenisPelanggan'),
              Text('Tgl Masuk: $_tglMasuk'),
              Text('Jam Masuk: $_jamMasuk'),
              Text('Jam Keluar: $_jamKeluar'),
              Text('Lama (Time Spent): ${_lama.toStringAsFixed(2)} hours'),
              Text('Tarif per Hour: Rp ${_tarif.toStringAsFixed(0)}'),
              Text('Diskon (Discount): Rp ${_diskon.toStringAsFixed(2)}'),
              SizedBox(height: 20),

              // Displaying the final total payment
              Text(
                'Total Bayar: Rp ${_totalBayar.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
