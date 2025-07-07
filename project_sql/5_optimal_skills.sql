/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/
WITH top_demanded_skills AS (
    SELECT
        skills_dim.skill_id, 
        skills as skill_name, 
        COUNT(skills) AS skill_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON
        job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON
        skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), top_paying_skills AS (
    SELECT 
        skills_dim.skill_id,
        skills as skill_name,
        ROUND(AVG(salary_year_avg)) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON
        job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON
        skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
)

SELECT 
    top_demanded_skills.skill_id,
    top_demanded_skills.skill_name,
    skill_count,
    average_salary
FROM top_demanded_skills
INNER JOIN top_paying_skills 
ON top_demanded_skills.skill_id = top_paying_skills.skill_id
ORDER BY skill_count DESC
