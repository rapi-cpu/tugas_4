import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Registrasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, 
      ),
      home: const RegistrationScreen(),
    );
  }
}

// Instruksi 1: Gunakan StatefulWidget
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Instruksi 2: GlobalKey untuk FormState
  final _formKey = GlobalKey<FormState>();

  // Controller untuk membaca teks inputan
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instruksi 3: FocusNode untuk perpindahan otomatis
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  // Variabel state untuk Radio, Dropdown, dan Checkbox
  String? _jenisKelamin;
  String? _programStudi;
  bool _setujuSyarat = false;

  final List<String> _listProdi = ['Sistem Informasi', 'Teknik Informatika', 'Bisnis Digital'];

  @override
  void dispose() {
    // Pastikan membuang controller dan focus node untuk mencegah memory leak
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Instruksi 4: Cek checkbox syarat & ketentuan sebelum validasi form
    if (!_setujuSyarat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan!'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Hentikan proses jika belum dicentang
    }

    // Instruksi 2: Cek validasi minimal
    if (_formKey.currentState!.validate()) {
      // Instruksi 5: Jika lolos validasi, tampilkan AlertDialog ringkasan data
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi Registrasi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Nama: ${_namaController.text}'),
                  Text('Email: ${_emailController.text}'),
                  Text('Jenis Kelamin: ${_jenisKelamin ?? '-'}'),
                  Text('Program Studi: ${_programStudi ?? '-'}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Tutup dialog
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  // Proses submit sebenarnya bisa diletakkan di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registrasi Berhasil Disubmit!')),
                  );
                },
                child: const Text('Submit Data'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Registrasi')),
      // Menggunakan SingleChildScrollView agar tidak overflow saat keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Pasang GlobalKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Text Field: Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                // Pindah fokus ke email saat tekan next
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Text Field: Email
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus, // Pasang FocusNode
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                // Pindah fokus ke password saat tekan next
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung "@"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Text Field: Password
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus, // Pasang FocusNode
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Radio Button: Jenis Kelamin
              const Text('Jenis Kelamin:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: _jenisKelamin,
                      onChanged: (value) => setState(() => _jenisKelamin = value),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: _jenisKelamin,
                      onChanged: (value) => setState(() => _jenisKelamin = value),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 5. DropdownButton: Program Studi
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  border: OutlineInputBorder(),
                ),
                value: _programStudi,
                items: _listProdi.map((String prodi) {
                  return DropdownMenuItem<String>(
                    value: prodi,
                    child: Text(prodi),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _programStudi = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih program studi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 6. Checkbox: Setuju Syarat & Ketentuan
              CheckboxListTile(
                title: const Text('Saya setuju dengan Syarat & Ketentuan yang berlaku'),
                value: _setujuSyarat,
                onChanged: (value) {
                  setState(() {
                    _setujuSyarat = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Daftar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}