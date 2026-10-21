# 📊 Elektromax Retail Analysis

## 📌 1. Konteks Bisnis (Business Context)
Elektromax adalah perusahaan retail elektronik dengan 10 cabang toko. Meskipun memiliki data transaksi selama 3 tahun (56.728 transaksi), data tersebut masih berserakan di 7 tabel database yang berbeda dan belum pernah dianalisis. 
**Tujuan Proyek:** Memberikan visibilitas kepada manajemen mengenai performa tiap toko, efektivitas promosi, preferensi pelanggan, dan kontribusi produk untuk pengambilan keputusan strategis.

## 🛠️ 2. Data & Tools
*   **Database:** PostgreSQL (Data Extraction & Aggregation)
*   **Visualization:** Power BI (Star Schema, Data Cleaning via Power Query, DAX)
*   **Dataset:** 7 Tabel (1 Fact Table, 6 Dimension Tables)

## 🧹 3. Data Cleaning (Power Query)
Data mentah tidak bisa langsung dianalisis. Beberapa penanganan krusial yang dilakukan:
1.  **Standarisasi Harga:** Mengubah format teks mata uang (contoh: "Rp 5.000.000") menjadi format *Integer* (angka murni).
2.  **Penyelarasan Metode Bayar:** Menyeragamkan penulisan (misal: "Cash" & "Tf" menjadi "Tunai" & "Transfer Bank").
3.  **Penyelarasan Status:** Menyeragamkan sinonim status transaksi (misal: "Done", "Sukses" menjadi "Selesai").
4.  **Penanganan Null & Duplikat:** Mengisi data kosong dan menghapus baris ganda berdasarkan *Primary Key*.
*   *(Untuk detail kode transformasi, lihat [Cleaning_Transformdata_powerquery_Elektromax.txt](./03_Data_Cleaning/Cleaning_Transformdata_powerquery_Elektromax.txt))*

## 🎯 4. Pertanyaan Bisnis & Insight Utama

Berikut adalah beberapa pertanyaan bisnis yang berhasil dijawab melalui analisis SQL dan Visualisasi Power BI:

**A. Performa Toko**
*   **Pertanyaan:** Toko mana yang performanya di atas rata-rata?
*   **Insight:** Toko Palembang Indah menjadi *top performer* dengan total penjualan Rp 25,22 Miliar, sekitar 20% di atas rata-rata total penjualan perusahaan (Rp 24,7 Miliar).

**B. Kontribusi Produk**
*   **Pertanyaan:** Merek apa yang paling menyumbang omzet?
*   **Insight:** Terjadi fenomena *Pareto Principle*. Samsung (23,63%) dan LG (22,82%) mendominasi hampir setengah dari total omzet perusahaan.

**C. Efektivitas Promosi**
*   **Pertanyaan:** Apakah promosi menaikkan penjualan atau menggerus margin?
*   **Insight:** Promosi meningkatkan volume transaksi, **TETAPI** menggerus margin keuntungan hingga 8,5%. Margin tanpa promosi adalah 33,7%, sedangkan dengan promosi hanya 25,1%.

**D. Perilaku Pelanggan (Segmen)**
*   **Pertanyaan:** Apakah nilai transaksi Member berbeda dengan Non-Member?
*   **Insight:** Segmen **Gold** memiliki rata-rata nilai belanja (AOV) tertinggi (Rp 5,27 Juta), lebih tinggi dari segmen Platinum. Hal ini menunjukkan pelanggan Gold adalah *sweet spot* untuk strategi *upselling*.

## 💡 5. Rekomendasi (Actionable Advice)
1.  **Evaluasi Kebijakan Diskon:** Hentikan diskon untuk produk *best-seller* (Samsung/LG) dan alihkan diskon hanya untuk produk *slow-moving* agar margin profit kembali sehat.
2.  **Benchmarking Cabang:** Lakukan audit operasional pada toko dengan penjualan terendah (Trans Studio) dan terapkan *best practice* dari Toko Palembang Indah.
3.  **Loyalty Program:** Fokuskan *campaign* untuk menaikkan tier pelanggan Regular ke Silver/Gold, karena kelompok ini memiliki *loyalty* dan nilai belanja yang lebih tinggi.

---
## 📂 Struktur Folder Proyek
*   `01_SQL_Queries/` : Kumpulan *query* PostgreSQL untuk menjawab pertanyaan bisnis.
*   `02_PowerBI_Dashboard/` : File `.pbix` dan *screenshot dashboard*.
*   `03_Data_Cleaning/` : Dokumentasi proses pembersihan data (Power Query).
