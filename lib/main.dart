import 'package:flutter/material.dart';

void main() {
  runApp(const MahasiswaApp());
}

class Mahasiswa {
  String nim;
  String nama;
  String programStudi;
  String kelas;

  Mahasiswa({
    required this.nim,
    required this.nama,
    required this.programStudi,
    required this.kelas,
  });
}

class MahasiswaApp extends StatelessWidget {
  const MahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Mahasiswa',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
          ),
        ),
      ),
      home: const MahasiswaHomePage(),
    );
  }
}

class MahasiswaHomePage extends StatefulWidget {
  const MahasiswaHomePage({super.key});

  @override
  State<MahasiswaHomePage> createState() => _MahasiswaHomePageState();
}

class _MahasiswaHomePageState extends State<MahasiswaHomePage> {
  final List<Mahasiswa> _mahasiswaList = [
    Mahasiswa(
      nim: '231001',
      nama: 'Andi Saputra',
      programStudi: 'Informatika',
      kelas: 'TI-3A',
    ),
    Mahasiswa(
      nim: '231002',
      nama: 'Budi Santoso',
      programStudi: 'Informatika',
      kelas: 'TI-3A',
    ),
    Mahasiswa(
      nim: '231003',
      nama: 'Citra Lestari',
      programStudi: 'Sistem Informasi',
      kelas: 'SI-3B',
    ),
    Mahasiswa(
      nim: '231004',
      nama: 'Dimas Pratama',
      programStudi: 'Teknik Komputer',
      kelas: 'TK-3A',
    ),
    Mahasiswa(
      nim: '231005',
      nama: 'Eka Putri',
      programStudi: 'Informatika',
      kelas: 'TI-3B',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterProgramStudi = 'Semua';

  List<Mahasiswa> get _filteredMahasiswa {
    final query = _searchQuery.trim().toLowerCase();
    return _mahasiswaList.where((m) {
      final matchesSearch = query.isEmpty ||
          m.nama.toLowerCase().contains(query) ||
          m.nim.toLowerCase().contains(query);
      final matchesFilter = _filterProgramStudi == 'Semua' ||
          m.programStudi == _filterProgramStudi;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openTambahMahasiswa() async {
    final result = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(builder: (_) => const TambahMahasiswaPage()),
    );

    if (!mounted || result == null) return;

    setState(() {
      _mahasiswaList.add(result);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data mahasiswa berhasil ditambahkan.')),
    );
  }

  void _updateMahasiswa(Mahasiswa oldValue, Mahasiswa updatedValue) {
    final index = _mahasiswaList.indexOf(oldValue);
    if (index == -1) return;

    setState(() {
      _mahasiswaList[index] = updatedValue;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data mahasiswa berhasil diperbarui.')),
    );
  }

  void _deleteMahasiswa(Mahasiswa mahasiswa) {
    setState(() {
      _mahasiswaList.remove(mahasiswa);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data mahasiswa berhasil dihapus.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMahasiswa;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTambahMahasiswa,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Mahasiswa'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari nama atau NIM...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.tune),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total Mahasiswa: ${_mahasiswaList.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filterProgramStudi,
                          items: const [
                            'Semua',
                            'Informatika',
                            'Sistem Informasi',
                            'Teknik Komputer',
                          ].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _filterProgramStudi = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const _EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final mahasiswa = filtered[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailMahasiswaPage(
                                    mahasiswa: mahasiswa,
                                    onUpdated: (updatedValue) {
                                      _updateMahasiswa(mahasiswa, updatedValue);
                                    },
                                    onDeleted: () {
                                      _deleteMahasiswa(mahasiswa);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Colors.indigo.withOpacity(.10),
                                    child: Text(
                                      mahasiswa.nama.substring(0, 1),
                                      style: const TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mahasiswa.nama,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${mahasiswa.nim} • ${mahasiswa.programStudi}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          'Kelas ${mahasiswa.kelas}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 76, color: Colors.grey.shade400),
            const SizedBox(height: 14),
            const Text(
              'Belum ada data mahasiswa',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              'Tambahkan data mahasiswa untuk mulai mengelola data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahMahasiswaPage extends StatefulWidget {
  const TambahMahasiswaPage({super.key});

  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _prodiController = TextEditingController();
  final _kelasController = TextEditingController();

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _prodiController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      Mahasiswa(
        nim: _nimController.text.trim(),
        nama: _namaController.text.trim(),
        programStudi: _prodiController.text.trim(),
        kelas: _kelasController.text.trim(),
      ),
    );
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mahasiswa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const _FormIntro(
              title: 'Form Tambah Mahasiswa',
              subtitle: 'Lengkapi data berikut sebelum menekan tombol simpan.',
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nimController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'NIM',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (value) => _requiredValidator(value, 'NIM'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => _requiredValidator(value, 'Nama'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _prodiController,
              decoration: const InputDecoration(
                labelText: 'Program Studi',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              validator: (value) =>
                  _requiredValidator(value, 'Program Studi'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _kelasController,
              decoration: const InputDecoration(
                labelText: 'Kelas',
                prefixIcon: Icon(Icons.groups_outlined),
              ),
              validator: (value) => _requiredValidator(value, 'Kelas'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailMahasiswaPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final ValueChanged<Mahasiswa> onUpdated;
  final VoidCallback onDeleted;

  const DetailMahasiswaPage({
    super.key,
    required this.mahasiswa,
    required this.onUpdated,
    required this.onDeleted,
  });

  @override
  State<DetailMahasiswaPage> createState() => _DetailMahasiswaPageState();
}

class _DetailMahasiswaPageState extends State<DetailMahasiswaPage> {
  Future<void> _edit() async {
    final result = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(
        builder: (_) => EditMahasiswaPage(mahasiswa: widget.mahasiswa),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      widget.mahasiswa.nim = result.nim;
      widget.mahasiswa.nama = result.nama;
      widget.mahasiswa.programStudi = result.programStudi;
      widget.mahasiswa.kelas = result.kelas;
    });
    widget.onUpdated(widget.mahasiswa);
  }

  Future<void> _hapus() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus data ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      widget.onDeleted();
      Navigator.pop(context);
    }
  }

  Widget _detailItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mahasiswa = widget.mahasiswa;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Colors.indigo.withOpacity(.10),
              child: Text(
                mahasiswa.nama.substring(0, 1),
                style: const TextStyle(
                  color: Colors.indigo,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              mahasiswa.nama,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          const SizedBox(height: 22),
          _detailItem('NIM', mahasiswa.nim, Icons.badge_outlined),
          _detailItem('Nama', mahasiswa.nama, Icons.person_outline),
          _detailItem(
            'Program Studi',
            mahasiswa.programStudi,
            Icons.school_outlined,
          ),
          _detailItem('Kelas', mahasiswa.kelas, Icons.groups_outlined),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _hapus,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Hapus'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _edit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditMahasiswaPage extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const EditMahasiswaPage({super.key, required this.mahasiswa});

  @override
  State<EditMahasiswaPage> createState() => _EditMahasiswaPageState();
}

class _EditMahasiswaPageState extends State<EditMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nimController;
  late final TextEditingController _namaController;
  late final TextEditingController _prodiController;
  late final TextEditingController _kelasController;

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.mahasiswa.nim);
    _namaController = TextEditingController(text: widget.mahasiswa.nama);
    _prodiController =
        TextEditingController(text: widget.mahasiswa.programStudi);
    _kelasController = TextEditingController(text: widget.mahasiswa.kelas);
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _prodiController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    return null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      Mahasiswa(
        nim: _nimController.text.trim(),
        nama: _namaController.text.trim(),
        programStudi: _prodiController.text.trim(),
        kelas: _kelasController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Mahasiswa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const _FormIntro(
              title: 'Form Edit Mahasiswa',
              subtitle: 'Data lama sudah diisi otomatis dan dapat diubah.',
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nimController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'NIM',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (value) => _requiredValidator(value, 'NIM'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => _requiredValidator(value, 'Nama'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _prodiController,
              decoration: const InputDecoration(
                labelText: 'Program Studi',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              validator: (value) =>
                  _requiredValidator(value, 'Program Studi'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _kelasController,
              decoration: const InputDecoration(
                labelText: 'Kelas',
                prefixIcon: Icon(Icons.groups_outlined),
              ),
              validator: (value) => _requiredValidator(value, 'Kelas'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormIntro extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FormIntro({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
