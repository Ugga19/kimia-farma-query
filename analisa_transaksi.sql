SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.price AS product_price,
  t.discount_percentage,

  -- Harga sebelum diskon
  t.price AS gross_sales,

  -- Diskon dalam rupiah
  t.price * (t.discount_percentage / 100) AS total_discount,

  -- Harga setelah diskon
  t.price * (1 - t.discount_percentage / 100) AS nett_sales,

  -- Persentase gross laba
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price <= 100000 THEN 0.15
    WHEN t.price <= 300000 THEN 0.20
    WHEN t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Nilai keuntungan (nett profit)
  (t.price * (1 - t.discount_percentage / 100)) *
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price <= 100000 THEN 0.15
    WHEN t.price <= 300000 THEN 0.20
    WHEN t.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  t.rating AS rating_transaksi

FROM 
  `rakamin-kf-analytics-463904.kimia_farma.kf_final_transaction` t
JOIN 
  `rakamin-kf-analytics-463904.kimia_farma.kf_product` p
ON 
  t.product_id = p.product_id
JOIN 
  `rakamin-kf-analytics-463904.kimia_farma.kf_kantor_cabang` c
ON 
  t.branch_id = c.branch_id;
