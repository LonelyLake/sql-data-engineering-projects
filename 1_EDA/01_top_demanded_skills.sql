-- Query: Poland market
/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on job postings from Poland
- Why? Retrieves the top 10 skills with the highest demand in the Poland's job market,
    providing insights into the most valuable skills for data engineers seeking work in Poland
*/

SELECT
    sd.skills,
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
ORDER BY
    demand_count DESC
LIMIT 10;

/*
Key Takeaways Poland:
- Python/SQL (#1–2, nearly tied) are the core foundation
- Azure dominates over AWS — typical for European market
- Airflow and Spark are the most in-demand pipeline tools
- Scala/Java reflect Poland's large corporate sector (banking, telecom)
- Snowflake and Kafka less prominent vs global market
- Priority learning path: Python/SQL (done) → Azure → Airflow → Spark

Results Poland:
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ python     │         4687 │
│ sql        │         4626 │
│ azure      │         2900 │
│ spark      │         2506 │
│ aws        │         2433 │
│ gcp        │         1610 │
│ airflow    │         1601 │
│ scala      │         1503 │
│ java       │         1501 │
│ databricks │         1399 │
└────────────┴──────────────┘
*/


-- Query: Global market  
/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on global job market (no country filter)
- Why? Provides a baseline to compare Poland's market against global trends
*/

SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 10;

/*
Key Takeaways Global:
- SQL (#1) leads globally, Python close second — reversed vs Poland
- AWS edges Azure at global level — opposite of Polish market
- Snowflake and Kafka appear in top 10 — absent in Poland
- GCP less prominent globally despite being #6 in Poland
- Priority learning path unchanged: Python/SQL → Azure → Airflow → Spark

Results Global:
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │       233132 │
│ python     │       224102 │
│ aws        │       130205 │
│ azure      │       128822 │
│ spark      │       106904 │
│ java       │        69657 │
│ databricks │        63012 │
│ snowflake  │        60379 │
│ scala      │        57079 │
│ kafka      │        56410 │
└────────────┴──────────────┘
*/
