# BLM4522 — SQL Server Database Administration Projects

> **Database:** Microsoft SQL Server — WideWorldImporters sample database  
> **Tool:** SQL Server Management Studio (SSMS)

---

## 📁 Project Structure

```
BLM4522/
├── proje1/   → Database Administration & Performance
├── proje3/   → Security & Encryption
└── proje5/   → ETL & Data Quality
```

---

## 🗂️ Proje 1 — Veritabanı Yönetimi / Database Administration

Bu proje, WideWorldImporters veritabanının yönetimi ve performans optimizasyonu konularını kapsar.

_This project covers management and performance optimization of the WideWorldImporters database._

| File | TR | EN |
|---|---|---|
| `database_overview.sql` | Veritabanı şemalarını, tablo boyutlarını ve satır sayılarını listeler | Lists database schemas, table sizes, and row counts |
| `performance_monitoring.sql` | `STATISTICS IO/TIME` ile sorgu performansını ölçer; DMV kullanarak pahalı sorguları izler | Measures query performance with `STATISTICS IO/TIME`; monitors expensive queries via DMV |
| `index_management.sql` | Sorgu performansını `SET STATISTICS` ve DMV ile takip eder | Tracks query performance with `SET STATISTICS` and DMV |
| `query_optimization.sql` | `YEAR()` fonksiyonu yerine tarih aralığı kullanarak ve `SELECT *` yerine belirli sütunlar seçerek sorguları optimize eder | Optimizes queries by replacing `YEAR()` with date ranges and selecting only needed columns instead of `SELECT *` |
| `disk_space_management.sql` | Disk alanı kullanımını kontrol eder, index parçalanmasını tespit edip düzeltir | Checks disk space usage, detects and fixes index fragmentation |
| `roles_and_permissions.sql` | `ReadOnly`, `Monitoring` ve `SalesEditor` rolleri oluşturur, kullanıcı atamalarını ve izin testlerini yönetir | Creates `ReadOnly`, `Monitoring`, and `SalesEditor` roles; manages user assignments and permission tests |

---

## 🔐 Proje 3 — Güvenlik & Şifreleme / Security & Encryption

Bu proje, SQL Server'da erişim kontrolü, kimlik doğrulama, veri şifreleme, denetim günlükleri ve SQL injection konularını ele alır.

_This project covers access control, authentication, data encryption, audit logging, and SQL injection in SQL Server._

| File | TR | EN |
|---|---|---|
| `access_management.sql` | Kullanıcı ve roller oluşturur (`ReadOnly`, `Editor`, `Monitoring`); Sales, Purchasing ve Warehouse şemalarına izin verir | Creates users and roles; grants permissions on Sales, Purchasing, and Warehouse schemas |
| `authentication_methods.sql` | SQL Server Authentication ile Windows Authentication'ı karşılaştırır; SQL login oluşturur ve role atar | Compares SQL Server Authentication vs Windows Authentication; creates SQL login and assigns to role |
| `data_encryption.sql` | TDE (Transparent Data Encryption) ile AES-256 şifrelemeyi aktive eder; alternatif olarak sütun düzeyinde şifreleme (symmetric key + certificate) gösterir | Enables TDE with AES-256 encryption; alternatively demonstrates column-level encryption using symmetric key + certificate |
| `sql_injection_test.sql` | Güvensiz dinamik SQL ile `sp_executesql` kullanan güvenli parametreli sorguyu karşılaştırır | Compares unsafe dynamic SQL against a secure parameterized query using `sp_executesql` |
| `audit_logs.sql` | Server audit oluşturur, SELECT/INSERT/UPDATE/DELETE işlemlerini dosyaya kaydeder ve `sys.fn_get_audit_file` ile okur | Creates a server audit, logs SELECT/INSERT/UPDATE/DELETE actions to file, and reads them with `sys.fn_get_audit_file` |

> **Not / Note:** `audit_logs.sql` çalıştırmadan önce `C:\SQLAudit\` klasörünü oluşturun.  
> Create the folder `C:\SQLAudit\` before running `audit_logs.sql`.

---

## 🔄 Proje 5 — ETL & Veri Kalitesi / ETL & Data Quality

Bu proje, `Sales.Customers` tablosu üzerinde tam bir ETL (Extract, Transform, Load) akışı ve veri kalite raporlaması gerçekleştirir.

_This project performs a full ETL pipeline and data quality reporting on the `Sales.Customers` table._

| File | TR | EN |
|---|---|---|
| `task1_data_cleaning.sql` | Eksik değerleri ve mükerrer kayıtları tespit eder; `CleanedCustomers` tablosunu oluşturur | Detects missing values and duplicates; creates `CleanedCustomers` table with defaults |
| `task2_data_transformation.sql` | İsimleri büyük harfe çevirir, telefon numarasını standartlaştırır, URL'i küçük harfe dönüştürür; `TransformedCustomers` tablosuna kaydeder | Uppercases names, standardizes phone numbers, lowercases URLs; saves to `TransformedCustomers` |
| `task3_data_loading.sql` | Dönüştürülmüş veriyi `FinalCustomersETL` tablosuna yükler ve kayıt sayısını doğrular | Loads transformed data into `FinalCustomersETL` table and verifies record count |
| `task4_data_quality_reports.sql` | Toplam kayıt sayısı, temizleme sonrası eksik değerler ve mükerrer isimler hakkında rapor üretir | Generates reports on total records, missing values after cleaning, and duplicate names |

**ETL Akışı / ETL Flow:**
```
Sales.Customers → CleanedCustomers → TransformedCustomers → FinalCustomersETL → DataQualityReport
```

---

## ⚙️ Gereksinimler / Requirements

- Microsoft SQL Server (2016 veya üzeri / or later)
- SQL Server Management Studio (SSMS)
- WideWorldImporters örnek veritabanı / sample database ([indir/download](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0))
