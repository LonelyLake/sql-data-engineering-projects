-- Data types, information schema
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;

DESCRIBE
SELECT
    job_title_short,
    salary_year_avg,
FROM
    job_postings_fact;

-- Casting
SELECT CAST('123' AS INTEGER);

SELECT
    job_id::VARCHAR || '-' || company_id::VARCHAR AS unique_id, -- "more" unique identifier
    job_work_from_home::INT AS job_work_from_home, -- from boolean to numeric value
    job_posted_date::DATE AS job_posted_date, -- from timestamp to date only
    salary_year_avg::DECIMAL(10, 0) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

SELECT (3 + 5.5)::FLOAT;
