# Exploratory Data Analysis w/ SQL: Job Market Analytics
 
![Project 1 Overview](../Images/1_1_Project1_EDA.png)

A SQL project analyzing the data engineer job market using real world job posting data. It demonstrates my ability to **write production-quality analytical SQL, design efficient queries, and turn business questions into data-driven insights**.


## Executive Summary

- ✅ **Project scope**: Built **5 analytical queries across 3 SQL files** that answer key questions about the data engineer job market, with Poland-specific and global market comparisons
- ✅ **Data modeling**: Used **multi-table joins** across fact and dimension tables to extract insights
- ✅ **Analytics**: Applied **aggregations, filtering, and sorting** to find top skills by demand, salary, and overall value
- ✅ **Outcomes**: Delivered **actionable insights** on SQL/Python dominance, cloud platform trade-offs, and Poland vs global market divergences

If you only have a minute, review these:
1. [01_top_demanded_skills.sql](./01_top_demanded_skills.sql) – demand analysis with multi-table joins
2. [02_top_paying_skills.sql](./02_top_paying_skills.sql) – salary analysis with aggregations
3. [03_optimal_skills.sql](./03_optimal_skills.sql) – combined demand/salary optimization queries

## Problem & Context

Job market analysts need to answer questions like:

- 🎯 Most in-demand: Which skills are most in-demand for data engineers?
- 💰 Highest paid: Which skills command the highest salaries?
- ⚖️ Best trade-off: What is the optimal skill set balancing demand and compensation?

This project analyzes a data warehouse built using a star schema design. The warehouse structure consists of:

![Data Warehouse](../Images/1_2_Data_Warehouse.png)

- **Fact Table**: `job_postings_fact` - Central table containing job posting details (job titles, locations, salaries, dates, etc.)
- **Dimension Tables**:
    - `company_dim` - Company information linked to job postings
    - `skills_dim` - Skills catalog with skill names and types
- **Bridge Table**: `skills_job_dim` - Resolves the many-to-many relationship between job postings and skills

By querying across these interconnected tables, I extracted insights about skill demand, salary patterns, and optimal skill combinations for data engineering roles.

## Tech Stack

- 🐤 **Query Engine**: DuckDB for fast OLAP-style analytical queries
- 🧮 **Language**: SQL (ANSI-style with analytical functions)
- 📊 **Data Model**: Star schema with fact + dimension + bridge tables
- 🛠️ **Development**: VS Code for SQL editing + Terminal for DuckDB CLI
- 📦 **Version Control**: Git/GitHub for versioned SQL scripts

## Analysis Overview

### Query Structure

1. **[Top Demanded Skills](../1_EDA/01_top_demanded_skills.sql)** – Poland vs global demand comparison (10 most in-demand skills)
2. **[Top Paying Skills](../1_EDA/02_top_paying_skills.sql)** – Analyzes the 25 highest-paying skills with salary and demand metrics for Polish market
3. **[Optimal Skills](../1_EDA/03_optimal_skills.sql)** – Poland vs global optimal score using natural log of demand combined with median salary to identify the most valuable skills to learn

### Key Insights

- 🧠 Core languages: SQL and Python dominate in both markets — #1 and #2 globally (233k and 224k postings) and in Poland (4,626 and 4,687)
- ☁️ Cloud platforms: AWS and Azure are critical for modern data engineering roles
- 🧱 Infra & tooling: Kubernetes, Docker, and Terraform are associated with premium salaries
- 🔥 Big data tools: Apache Spark shows strong demand with competitive compensation
- 🌍 Poland vs global: Azure leads in Polish raw demand but trails AWS in salary-weighted score — skills like Kafka and Java are significantly undervalued locally vs global benchmarks


## SQL Skills Demonstrated

### Query Design & Optimization

- **Complex Joins**: Multi-table `INNER JOIN` operations across job_postings_fact, skills_job_dim, and skills_dim
- **Aggregations**: `COUNT()`, `MEDIAN()`, `ROUND()` for statistical analysis
- **Filtering**: Boolean logic with `WHERE` clauses and multiple conditions (`job_title_short`, `job_country`, `salary_year_avg IS NOT NULL`)
- **Sorting & Limiting**: `ORDER BY` with `DESC` and `LIMIT` for top-N analysis

### Data Analysis Techniques

- **Grouping**: `GROUP BY` for categorical analysis by skill
- **Mathematical Functions**: `LN()` for natural logarithm transformation to normalize demand metrics
- **Calculated Metrics**: Derived optimal score combining log-transformed demand with median salary
- **HAVING Clause**: Filtering aggregated results with query-specific thresholds (> 3 for small Polish sample, > 50 globally, > 100 for salary analysis)
- **NULL Handling**: Proper filtering of incomplete records (`salary_year_avg IS NOT NULL`)
