# Aplikasi Toko Digital Sederhana (Offline First)

Aplikasi mobile *e-commerce* berbasis **Flutter** yang dirancang untuk mengelola katalog produk gadget serta keranjang belanja secara lokal. Proyek ini dibuat untuk memenuhi tugas **Penilaian Tengah Semester (PTS)** mata pelajaran **Pemrograman Perangkat Bergerak**.

---

## 🚀 Fitur Utama
- **Katalog Produk (Offline First):** Menampilkan daftar produk gadget menggunakan `GridView` dan `Card` yang disajikan dari basis data lokal SQLite.
- **Keranjang Belanja Reaktif:** Menambahkan produk ke keranjang, menambah/mengurangi jumlah barang (*quantity*), serta menghapus item individual maupun mengosongkan seluruh keranjang.
- **Desain Responsif & Bebas Overflow:** Tampilan antarmuka yang rapi dan responsif di berbagai ukuran layar tanpa error *layout overflow*.
- **Persistensi Data:** Data produk dan keranjang belanja tersimpan secara permanen di SQLite sehingga tidak hilang saat aplikasi ditutup total (*app restart*).

---

## 🛠️ Teknologi & Pustaka
- **Framework:** Flutter (Dart)
- **State Management:** `provider`
- **Database Lokal:** `sqflite` & `path`
- **Pick Image / Media:** `image_picker`

---

## 📁 Struktur Folder Project
```text
lib/
├── helpers/       # Konfigurasi SQLite Database (db_helper.dart)
├── models/        # Model data (product.dart, cart_item.dart)
├── providers/     # State Management (cart_provider.dart)
├── screens/       # Tampilan UI (product_list_screen.dart, cart_screen.dart)
└── main.dart      # Entry point aplikasi
