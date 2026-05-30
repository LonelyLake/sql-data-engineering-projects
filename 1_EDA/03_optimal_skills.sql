-- Poland market
/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on Data Engineer positions from Poland with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward.
      It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and
      widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
    - The / 1_000_000 divisor is purely cosmetic — it scales the score to a human-readable range (0.0–1.5)
      without affecting skill rankings.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.job_id) AS demand_count,
    ROUND(LN(COUNT(jpf.job_id)), 1) AS ln_demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.job_id)) / 1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_country = 'Poland'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.job_id) > 3
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
Key Insights (Poland, salary-reported postings only — 35–37 per top skill):
- SQL, Spark, and Python are virtually tied at the top (score 0.47–0.48),
  confirming they are the non-negotiable foundation for DE in Poland

- Cloud platforms rank mid-table: AWS (0.40) > GCP (0.35) > Azure (0.34)
  — note: Azure leads in raw demand but trails in salary-weighted score

- Snowflake scores 0.32 despite only 9 postings — high salary ($147k)
  compensates for lower demand; worth learning but not a priority

- Java and Kafka rank low (0.22 and 0.17) due to below-average salaries
  ($86k and $85k), despite decent demand counts

- Kotlin, Docker, and Windows appearing in top 25 are likely small-sample
  artifacts (4–6 postings each) — treat with caution

Takeaway:
  Core path confirmed: Python/SQL/Spark → Airflow → cloud (AWS/GCP/Azure)
  Small sample size (salary_year_avg rarely filled in Polish postings)
  limits statistical confidence — global market analysis recommended
  for stronger conclusions.

Result:
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ spark      │      133000.0 │           37 │             3.6 │          0.48 │
│ sql        │      133500.0 │           37 │             3.6 │          0.48 │
│ python     │      133000.0 │           35 │             3.6 │          0.47 │
│ aws        │      127950.0 │           22 │             3.1 │           0.4 │
│ bigquery   │      133500.0 │           17 │             2.8 │          0.38 │
│ gcp        │      122700.0 │           18 │             2.9 │          0.35 │
│ azure      │      119500.0 │           17 │             2.8 │          0.34 │
│ hadoop     │      133500.0 │           13 │             2.6 │          0.34 │
│ pyspark    │      133250.0 │           12 │             2.5 │          0.33 │
│ scala      │      133500.0 │           11 │             2.4 │          0.32 │
│ airflow    │      127950.0 │           12 │             2.5 │          0.32 │
│ snowflake  │      147500.0 │            9 │             2.2 │          0.32 │
│ github     │      133250.0 │            8 │             2.1 │          0.28 │
│ mysql      │      133500.0 │            7 │             1.9 │          0.26 │
│ sql server │      147500.0 │            5 │             1.6 │          0.24 │
│ git        │      120000.0 │            7 │             1.9 │          0.23 │
│ go         │      122892.0 │            6 │             1.8 │          0.22 │
│ java       │       86400.0 │           13 │             2.6 │          0.22 │
│ postgresql │      133500.0 │            5 │             1.6 │          0.21 │
│ kotlin     │      104903.0 │            6 │             1.8 │          0.19 │
│ kafka      │       85000.0 │            7 │             1.9 │          0.17 │
│ docker     │       90887.0 │            6 │             1.8 │          0.16 │
│ databricks │      108137.0 │            4 │             1.4 │          0.15 │
│ nosql      │       80850.0 │            5 │             1.6 │          0.13 │
│ windows    │       83750.0 │            4 │             1.4 │          0.12 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
*/



-- Global market — same methodology, worldwide scope
/*
Question: How does the optimal skill ranking look on the global market?
- Same salary * LN(demand) scoring as the Poland query above.
- Focus on Data Engineer positions worldwide with specified annual salaries.
- Why?
    - Poland's sample is small (~35 postings per top skill) due to low
      salary-reporting rates. The global dataset provides a statistically
      stronger baseline to validate or challenge the Poland findings.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.job_id) AS demand_count,
    ROUND(LN(COUNT(jpf.job_id)), 1) AS ln_demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.job_id)) / 1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.job_id) > 50
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
Key Insights (Global vs Poland comparison):

- Python and SQL hold the #1–2 spots in both markets, confirming their
  universal importance — but globally SQL median salary ($126k) is notably
  lower than Poland ($133k), likely due to US market dilution

- Kafka jumps from low-ranked in Poland (0.17) to #4 globally (1.12, $147k)
  — in Poland it was dragged down by low local salaries, not low demand

- Java reverses completely: bottom tier in Poland ($86k) vs solid mid-table
  globally ($137k, score 1.07) — Polish Java postings appear to be
  lower-paid legacy/backend roles, not DE-specific

- Mongo at #6 globally ($201k) is a small-sample outlier (n=243) —
  high salary inflates the score despite limited demand; treat with caution

- Kubernetes, Terraform, Docker, Cassandra appear globally but are absent
  from Poland top 25 — either rare in Polish postings or salary-unreported

- Azure scores lower than AWS globally (1.04 vs 1.13), consistent with
  Poland results — AWS commands a salary premium across both markets

- Snowflake is stronger globally (1.05, n=2473) than in Poland (0.32, n=9)
  — Polish sample too small to draw conclusions about Snowflake locally

Takeaway:
  Global data validates the core Poland path: Python/SQL/Spark/Airflow.
  Cloud platform: AWS leads globally by salary score (1.13 vs Azure 1.04),
  but Azure has higher raw demand in Poland (2,900 vs 2,433 postings) —
  either cloud platform is a valid next step depending on target employer.
  Key divergences worth noting: Kafka and Java are undervalued in Polish
  postings relative to global benchmarks — possibly a reporting artifact.
  Kubernetes and Terraform score well globally; worth adding to long-term
  roadmap even if not yet prominent in Polish market.

Result:
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ python     │      133000.0 │         7004 │             8.9 │          1.18 │
│ spark      │      140000.0 │         3521 │             8.2 │          1.14 │
│ aws        │      135000.0 │         4406 │             8.4 │          1.13 │
│ kafka      │      147500.0 │         1991 │             7.6 │          1.12 │
│ sql        │      126010.0 │         7155 │             8.9 │          1.12 │
│ mongo      │      201000.0 │          243 │             5.5 │           1.1 │
│ airflow    │      145000.0 │         1618 │             7.4 │          1.07 │
│ java       │      137500.0 │         2469 │             7.8 │          1.07 │
│ hadoop     │      140000.0 │         1951 │             7.6 │          1.06 │
│ scala      │      140000.0 │         1966 │             7.6 │          1.06 │
│ snowflake  │      135000.0 │         2473 │             7.8 │          1.05 │
│ azure      │      126500.0 │         3613 │             8.2 │          1.04 │
│ redshift   │      137500.0 │         1723 │             7.5 │          1.02 │
│ nosql      │      135000.0 │         1641 │             7.4 │           1.0 │
│ kubernetes │      145500.0 │          929 │             6.8 │          0.99 │
│ databricks │      130000.0 │         1783 │             7.5 │          0.97 │
│ gcp        │      135000.0 │         1180 │             7.1 │          0.95 │
│ docker     │      139000.0 │          921 │             6.8 │          0.95 │
│ terraform  │      145000.0 │          688 │             6.5 │          0.95 │
│ cassandra  │      147500.0 │          531 │             6.3 │          0.93 │
│ mysql      │      136500.0 │          873 │             6.8 │          0.92 │
│ pyspark    │      135000.0 │          917 │             6.8 │          0.92 │
│ flow       │      130000.0 │          945 │             6.9 │          0.89 │
│ tableau    │      122500.0 │         1384 │             7.2 │          0.89 │
│ bigquery   │      135000.0 │          721 │             6.6 │          0.89 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
*/