# USA Master Email Pipeline

A complete, production-ready automation pipeline for processing, cleaning,
deduplicating, and managing USA Master Email data using SQL Server and
PowerShell.

This repository is designed for **data operations teams**, **automation engineers**,
and **ETL workflows** that require accuracy, performance, and repeatability.

---

## 📌 Key Features

- Bulk CSV ingestion using PowerShell
- Staging-to-master email processing
- SQL-based email cleaning and normalization
- Advanced deduplication logic
- Indexed master tables for high performance
- Fully documented SOP and process flow

---

## 📂 Repository Structure


---

## ⚙️ Technologies Used

- Microsoft SQL Server
- PowerShell
- Bulk Insert / BCP
- Stored Procedures
- Index optimization techniques

---

## 🔄 High-Level Process Flow

1. Source CSV files are received
2. PowerShell script loads data into staging tables
3. SQL stored procedures:
   - Clean and standardize emails
   - Remove duplicates
   - Apply business rules
4. Final data is inserted into the master table
5. Indexes are created/maintained for performance

---

## ▶️ How to Run the Pipeline

### 1️⃣ Load Data (PowerShell)
```powershell
.\import_all_csv.ps1

2️⃣ Execute SQL Processing
EXEC dbo.usp_Process_USA_Master_Emails;


