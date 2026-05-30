/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on positions from Poland with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing how common those skills are,
    providing a more complete picture for skill development priorities
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.job_id) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_country = 'Poland'
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.job_id) > 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*
Key Insights:
- Two distinct salary clusters, not a gradient. Skills split into two clear bands: ~$147k (premium) and ~$133k (core).
  Mastering even one premium-tier tool can shift your expected salary bracket significantly.

- The premium cluster is mixed — interpret with caution. Snowflake, SQL Server, and Terraform belong there naturally.
  But TypeScript, React, PyTorch, and JavaScript signal full-stack or MLOps-flavored roles that happen to be tagged "Data Engineer"
  or simply higher-paying companies using those stacks. 
  Don't chase these for a DE salary bump; they represent a different job profile.

- The real DE sweet spot is the core cluster.
  SQL (n=4,626), Python (4,687), Spark (2,506), Airflow (1,601), Scala (1,503), BigQuery (892) — strong demand, $133k median.
  This is the stack worth owning.

- AWS underperforms vs. its demand volume. $127k median despite 2,433 postings.
  Likely skewed by junior or outsourcing-heavy AWS roles in the Polish market.

- R, Tableau, Jira sit at the bottom. These lean toward analyst and project management profiles.
  Featuring them without a strong DE foundation risks positioning you as an analyst, not an engineer.

Takeaway: For a junior DE role in Poland, the optimal target stack is
SQL + Python + Spark + Airflow — the intersection of high demand and solid compensation.
Snowflake and Terraform are worth queuing up as next steps once the core is solid.

Results:
┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ ssis       │      147500.0 │          337 │
│ sql server │      147500.0 │          431 │
│ pytorch    │      147500.0 │          118 │
│ typescript │      147500.0 │          120 │
│ snowflake  │      147500.0 │         1198 │
│ javascript │      147500.0 │          228 │
│ react      │      147500.0 │          183 │
│ flow       │      146750.0 │          354 │
│ gdpr       │      146500.0 │          114 │
│ terraform  │      146000.0 │          756 │
│ scala      │      133500.0 │         1503 │
│ sql        │      133500.0 │         4626 │
│ mysql      │      133500.0 │          395 │
│ bigquery   │      133500.0 │          892 │
│ postgresql │      133500.0 │          810 │
│ hadoop     │      133500.0 │         1111 │
│ pyspark    │      133250.0 │          826 │
│ github     │      133250.0 │          454 │
│ python     │      133000.0 │         4687 │
│ spark      │      133000.0 │         2506 │
│ airflow    │      127950.0 │         1601 │
│ aws        │      127950.0 │         2433 │
│ jira       │      124625.0 │          421 │
│ tableau    │      124625.0 │          435 │
│ r          │      122892.0 │          455 │
└────────────┴───────────────┴──────────────┘
*/