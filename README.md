# 🧹 Layoff Data Cleaning with SQL

![Layoff Table 1](https://github.com/user-attachments/assets/d989bdf5-74a5-4221-bbd6-c94e54cbccbf)

<p align="center"><i>Layoff Table 1 – Before Cleaning</i></p>

## 📄 Project Overview

This project showcases my data cleaning and preparation skills using SQL. The dataset contains information on employee layoffs across various companies, industries, and countries.

🧪 Goal: Transform a raw, duplicate-ridden dataset into a clean, analysis-ready table using structured SQL queries.

---

## 🛠️ Tools Used

- SQL (MySQL)
- SQL Server (Workbench or SSMS)
- Notepad++ (for script review)

---

## 🧼 Data Cleaning Summary

The original data had issues including:
- Duplicate rows
- Inconsistent formatting
- Missing or NULL values
- Non-standard data types

🔧 Cleaning Steps Performed:

1. Created a backup table (layoffs_copy)
2. Used ROW_NUMBER() to detect and remove duplicates
3. Trimmed whitespace from fields like date and company
4. Converted data types (e.g., text to double/int where applicable)
5. Removed unnecessary columns
6. Ensured null values were properly handled

---

![Layoff Final Table](https://github.com/user-attachments/assets/75f019b2-b627-401a-8b20-ccb458839ba1)

<p align="center"><i>Layoff Final – After Cleaning</i></p>

---

## 📁 Files Included

- LAYOFF DATA CLEANING.sql – SQL Full Script
- More Querying Layoffs.sql – additional queries for data exploration
- Screenshot – before and after images

---

## 🚀 How to Use

1. Load your raw layoff data into a SQL-compatible environment
2. Run the LAYOFF DATA CLEANING.sql script
3. Use cleaned data for analysis or dashboards

---

## 📌 Author

Samuel O.A  
Pharmacist & Certified Data Analyst  
[LinkedIn](www.linkedin.com/in/samuel-o-akanbi-msc-639345168) • [Email](samueloluwaseyi100@gmail.com)

---
🧠 “Transforming messy data into clear insights.”
