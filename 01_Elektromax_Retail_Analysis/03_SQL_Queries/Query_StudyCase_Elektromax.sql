-- Total penjualan tiap toko
SELECT dp.nama_toko, SUM(fp.total_neto) AS total_penjualan
FROM fact_penjualan fp
JOIN dim_toko dp
ON fp.toko_id = dp.toko_id
WHERE status_transaksi = 'Selesai'
GROUP BY dp.nama_toko
ORDER BY total_penjualan DESC;

-- berapa rata-rata total penjualan toko? --> keluar 1 value --> sum total penjualan --> avg total penjualan semua toko
select avg(total_penjualan) as rata_rata_penjualan
from (
	select dt.nama_toko, sum(fp.total_neto) as total_penjualan
	from fact_penjualan fp
	join dim_toko dt
	on fp.toko_id = dt.toko_id
	where status_transaksi = 'Selesai'
	group by dt.nama_toko
) as ringkasan_toko;


-- toko mana saja yang penjualannya diatas angka rata-rata penjualan toko?
-- menggunakan CTE (Common Table Execution)
with penjualan_per_toko as(
select nama_toko, total_penjualan
from (
	select dt.nama_toko, sum(fp.total_neto) as total_penjualan
	from fact_penjualan fp
	join dim_toko dt
	on fp.toko_id = dt.toko_id
	where status_transaksi = 'Selesai'
	group by dt.nama_toko)
)
select nama_toko, total_penjualan
from penjualan_per_toko
where total_penjualan > (select avg(total_penjualan) from penjualan_per_toko)
order by total_penjualan desc;


-- dari kelima toko tersebut berapa besar persentase total penjualannya diatas rata-rata semua toko?
with total_per_toko as(
select nama_toko, total_penjualan
from (
	select dt.nama_toko, sum(fp.total_neto) as total_penjualan
	from fact_penjualan fp
	join dim_toko dt
	on fp.toko_id = dt.toko_id
	where status_transaksi = 'Selesai'
	group by dt.nama_toko)
), rata_rata_perusahaan as (select avg(total_penjualan) as avg_total from total_per_toko
	)
select 
	tpt.nama_toko,
	tpt.total_penjualan,
	rrp.avg_total,
	round(((tpt.total_penjualan - rrp.avg_total) / avg_total * 100) :: numeric,2) as persentase_diatas_rata_rata
from total_per_toko tpt, rata_rata_perusahaan rrp
where tpt.total_penjualan > rrp.avg_total
order by persentase_diatas_rata_rata desc;


-- Merek atau kategori produk apa yang paling nyumbang ke omzet?
SELECT 
    dp.kategori,
    dp.merek,
    SUM(fp.total_neto) AS total_omzet,
    COUNT(fp.penjualan_id) AS total_transaksi,
    ROUND((SUM(fp.total_neto) / (SELECT SUM(total_neto) FROM fact_penjualan WHERE status_transaksi = 'Selesai') * 100), 2) AS persentase_kontribusi
FROM 
    fact_penjualan fp
JOIN 
    dim_produk dp ON fp.produk_id = dp.produk_id
WHERE 
    fp.status_transaksi = 'Selesai'
GROUP BY 
    dp.kategori, 
    dp.merek
ORDER BY 
    total_omzet DESC;

-- Promosi beneran naikin penjualan, atau cuma ngurangin margin?
SELECT *
FROM dim_promosi;

SELECT 
    CASE 
        WHEN fp.promosi_id = 0 THEN 'Tanpa Promosi'
        ELSE 'Dengan Promosi'
    END AS status_promosi,
    COUNT(fp.penjualan_id) AS jumlah_transaksi,
    SUM(fp.total_neto) AS total_omzet,
    SUM(fp.gross_profit) AS total_profit,
    -- Menghitung Margin (%) = (Profit / Omzet) * 100
    ROUND((SUM(fp.gross_profit) / NULLIF(SUM(fp.total_neto), 0)) * 100, 2) AS margin_persen,
    -- Menghitung Rata-rata nilai belanja per transaksi (AOV)
    ROUND(AVG(fp.total_neto), 2) AS rata_rata_transaksi
FROM 
    fact_penjualan fp
WHERE 
    fp.status_transaksi = 'Selesai'
GROUP BY 
    CASE 
        WHEN fp.promosi_id = 0  THEN 'Tanpa Promosi'
        ELSE 'Dengan Promosi'
    END;


-- Metode pembayaran apa yang paling sering dipakai pelanggan?

SELECT 
    fp.metode_bayar,
    COUNT(fp.penjualan_id) AS jumlah_transaksi
FROM 
    fact_penjualan fp
GROUP BY 
    fp.metode_bayar
ORDER BY 
    jumlah_transaksi DESC;


-- Transaksi member beda nggak nilainya sama non-member?
SELECT * 
FROM dim_pelanggan;
SELECT *
FROM fact_penjualan;

SELECT 
	INITCAP(dp.segmen) AS segmen_bersih,
	count(fp.penjualan_id) AS jumlah_transaksi,
	SUM(fp.total_neto) AS total_omzet,
	ROUND(AVG(fp.total_neto), 2) AS rata_rata_transaksi
FROM 
	fact_penjualan fp
JOIN 
	dim_pelanggan dp
ON 
	fp.pelanggan_id = dp.pelanggan_id
WHERE 
	fp.status_transaksi = 'Selesai'
GROUP BY 
	INITCAP(dp.segmen)
ORDER BY jumlah_transaksi DESC;
