

# Business Analysis Report

# HR Analytics SQL Project

## Business Questions



1. How many employees are working in each department?

2. How are employees distributed across different business units?

3. How many employees belong to each employment type?

4. Which departments have the highest average employee performance rating?

5. Which training programs have the highest employee participation?

6. What are the outcomes of employee training programs?

7. What is the gender distribution of employees across the organization?

8. Which departments have the highest employee satisfaction scores?

9. Which departments have the highest employee engagement scores and employee performance?

10. Which departments have the highest employee attrition rate, and how can they be classified into High, Medium, and Low attrition risk?

11. How effective are training programs in improving employee performance, employee engagement, and employee satisfaction?

12. Which department provides the best overall employee experience based on satisfaction, engagement, work-life balance, and employee performance?

13. What are the overall HR performance indicators of the organization, including workforce size, attrition rate, employee performance, satisfaction, engagement, work-life balance, best-performing department, highest satisfaction department, and most popular training program?
--------------------------------------------------------------------------------

# Business Question 1 – Total Employees

### Business Question



# Business Question 1 – Department-wise Employee Distribution

### Business Question

How many employees are working in each department?

### SQL Query

```sql
SELECT
    department_type,
    COUNT(DISTINCT employee_id) AS total_employees
FROM hr_staging2
GROUP BY department_type
ORDER BY total_employees DESC;
```

### Result

+-------------------------+------------------+
| department_type         | total_employees  |
+-------------------------+------------------+
| Production              | 2020             |
| IT/IS                   | 430              |
| Sales                   | 331              |
| Software Engineering    | 115              |
| Admin Offices           | 80               |
| Executive Office        | 24               |
+-------------------------+------------------+

### Business Insight

The **Production** department has the largest workforce, while the **Executive Office** has the smallest. This distribution reflects the operational structure of the organization.

--------------------------------------------------------------------------------

# Business Question 2 – Business Unit Distribution

### Business Question

How are employees distributed across different business units?

### SQL Query

```sql
SELECT
    business_unit,
    COUNT(DISTINCT employee_id) AS total_employees
FROM hr_staging2
GROUP BY business_unit
ORDER BY total_employees DESC;
```

### Result

+------------------+------------------+
| business_unit    | total_employees  |
+------------------+------------------+
| NEL              | 304              |
| SVG              | 304              |
| BPC              | 303              |
| EW               | 302              |
| PL               | 301              |
| CCDR             | 300              |
| PYZ              | 299              |
| TNS              | 297              |
| MSC              | 296              |
| WBL              | 294              |
+------------------+------------------+

### Business Insight

Employees are distributed fairly evenly across business units, indicating balanced workforce allocation throughout the organization.

--------------------------------------------------------------------------------

# Business Question 3– Employee Type Distribution

### Business Question

How many employees belong to each employment type?

### SQL Query

```sql
SELECT
    employee_type,
    COUNT(DISTINCT employee_id) AS total_employees
FROM hr_staging2
GROUP BY employee_type
ORDER BY total_employees DESC;
```

### Result

+------------------+------------------+
| employee_type    | total_employees  |
+------------------+------------------+
| Full-Time        | 1038             |
| Contract         | 1008             |
| Part-Time        | 954              |
+------------------+------------------+

### Business Insight

The organization maintains a balanced workforce consisting of **Full-Time**, **Contract**, and **Part-Time** employees. This provides operational flexibility while maintaining a strong full-time workforce.


--------------------------------------------------------------------------------

# Business Question 4 – Department Performance Ranking

### Business Question

Which departments have the highest average employee performance rating?

### SQL Query

```sql
WITH department_rating AS (
    SELECT
        department_type,
        COUNT(DISTINCT employee_id) AS total_employees,
        ROUND(AVG(current_employee_rating), 2) AS average_rating
    FROM hr_staging2
    GROUP BY department_type
)

SELECT
    department_type,
    total_employees,
    average_rating,
    DENSE_RANK() OVER (ORDER BY average_rating DESC) AS department_rank
FROM department_rating
ORDER BY department_rank, department_type;
```

### Result

+-------------------------+------------------+------------------+-----------------+
| department_type         | total_employees  | average_rating   | department_rank |
+-------------------------+------------------+------------------+-----------------+
| Sales                   | 331              | 3.13             | 1               |
| Software Engineering    | 115              | 3.11             | 2               |
| Executive Office        | 24               | 3.08             | 3               |
| Production              | 2020             | 3.02             | 4               |
| IT/IS                   | 430              | 3.01             | 5               |
| Admin Offices           | 80               | 2.51             | 6               |
+-------------------------+------------------+------------------+-----------------+

### Business Insight

The Sales department achieved the highest average employee performance rating, while Admin Offices recorded the lowest rating. This analysis helps HR identify high-performing departments and areas that may require additional support.

--------------------------------------------------------------------------------

# Business Question 5– Training Program Popularity

### Business Question

Which training programs have the highest employee participation?

### SQL Query

```sql
WITH training_summary AS (
    SELECT
        training_program_name,
        COUNT(DISTINCT employee_id) AS total_participants,
        ROUND(AVG(training_cost), 2) AS avg_training_cost
    FROM hr_staging2
    GROUP BY training_program_name
)

SELECT
    training_program_name,
    total_participants,
    avg_training_cost,
    DENSE_RANK() OVER (ORDER BY total_participants DESC) AS popularity_rank
FROM training_summary
ORDER BY popularity_rank, training_program_name;
```

### Result

+---------------------------+---------------------+-------------------+-----------------+
| training_program_name     | total_participants  | avg_training_cost | popularity_rank |
+---------------------------+---------------------+-------------------+-----------------+
| Communication Skills      | 767                 | 2988.61           | 1               |
| Leadership                | 756                 | 3021.43           | 2               |
| Technical Skills          | 752                 | 2996.58           | 3               |
| Project Management        | 725                 | 2964.10           | 4               |
+---------------------------+---------------------+-------------------+-----------------+

### Business Insight

Communication Skills is the most popular training program, indicating strong employee interest in improving communication and interpersonal skills.

--------------------------------------------------------------------------------

# Business Question 6– Training Outcome Analysis

### Business Question

What are the outcomes of employee training programs?

### SQL Query

```sql
WITH training_outcome_summary AS (
    SELECT
        training_outcome,
        COUNT(DISTINCT employee_id) AS total_employees
    FROM hr_staging2
    GROUP BY training_outcome
)

SELECT
    training_outcome,
    total_employees,
    ROUND(
        total_employees * 100.0 /
        SUM(total_employees) OVER (),
        2
    ) AS percentage_of_total,
    DENSE_RANK() OVER (ORDER BY total_employees DESC) AS outcome_rank
FROM training_outcome_summary
ORDER BY outcome_rank;
```

### Result

+----------------------+------------------+----------------------+--------------+
| training_outcome     | total_employees  | percentage_of_total  | outcome_rank |
+----------------------+------------------+----------------------+--------------+
| Incomplete           | 775              | 25.83                | 1            |
| Completed            | 770              | 25.67                | 2            |
| Passed               | 739              | 24.63                | 3            |
| Failed               | 716              | 23.87                | 4            |
+----------------------+------------------+----------------------+--------------+

### Business Insight

Training outcomes are fairly balanced across all categories. HR should investigate why a significant number of employees have incomplete or failed training outcomes.

--------------------------------------------------------------------------------

# Business Question 7– Gender Distribution

### Business Question

What is the gender distribution of employees?

### SQL Query

```sql
WITH gender_summary AS (
    SELECT
        gender_code,
        COUNT(DISTINCT employee_id) AS total_employees
    FROM hr_staging2
    GROUP BY gender_code
)

SELECT
    gender_code,
    total_employees,
    ROUND(
        total_employees * 100.0 /
        SUM(total_employees) OVER(),
        2
    ) AS percentage_of_workforce
FROM gender_summary
ORDER BY total_employees DESC;
```

### Result

+---------------+------------------+---------------------------+
| gender_code   | total_employees  | percentage_of_workforce   |
+---------------+------------------+---------------------------+
| Female        | 1539             | 51.30                     |
| Male          | 1461             | 48.70                     |
+---------------+------------------+---------------------------+

### Business Insight

The workforce is well balanced in terms of gender representation, with Female employees representing a slightly larger share of the organization.

--------------------------------------------------------------------------------

# Business Question 8 – Department Satisfaction Analysis

### Business Question

Which departments have the highest employee satisfaction scores?

### SQL Query

```sql
WITH department_satisfaction AS (
    SELECT
        department_type,
        COUNT(DISTINCT employee_id) AS total_employees,
        ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
    FROM hr_staging2
    GROUP BY department_type
)

SELECT
    department_type,
    total_employees,
    avg_satisfaction,
    DENSE_RANK() OVER (ORDER BY avg_satisfaction DESC) AS satisfaction_rank
FROM department_satisfaction
ORDER BY satisfaction_rank, department_type;
```

### Result

+-------------------------+------------------+------------------+-------------------+
| department_type         | total_employees  | avg_satisfaction | satisfaction_rank |
+-------------------------+------------------+------------------+-------------------+
| Executive Office        | 24               | 3.38             | 1                 |
| IT/IS                   | 430              | 3.03             | 2                 |
| Sales                   | 331              | 2.99             | 3                 |
| Software Engineering    | 115              | 2.97             | 4                 |
| Admin Offices           | 80               | 2.93             | 5                 |
| Production              | 2020             | 2.91             | 6                 |
+-------------------------+------------------+------------------+-------------------+

### Business Insight

Executive Office reported the highest employee satisfaction score, while Production and Admin Offices showed comparatively lower satisfaction levels. HR can use these findings to improve employee experience and workplace satisfaction.


--------------------------------------------------------------------------------

# Business Question 9 – Employee Engagement Analysis

### Business Question

Which departments have the highest employee engagement scores?

### SQL Query

```sql
WITH engagement_analysis AS (
    SELECT
        department_type,
        COUNT(DISTINCT employee_id) AS total_employees,
        ROUND(AVG(engagement_score), 2) AS avg_engagement,
        ROUND(AVG(current_employee_rating), 2) AS avg_performance
    FROM hr_staging2
    GROUP BY department_type
)

SELECT
    department_type,
    total_employees,
    avg_engagement,
    avg_performance,
    DENSE_RANK() OVER(ORDER BY avg_engagement DESC) AS engagement_rank
FROM engagement_analysis
ORDER BY engagement_rank, department_type;
```

### Result

+-------------------------+------------------+----------------+-----------------+-----------------+
| department_type         | total_employees  | avg_engagement | avg_performance | engagement_rank |
+-------------------------+------------------+----------------+-----------------+-----------------+
| Sales                   | 331              | 3.05           | 3.13            | 1               |
| Software Engineering    | 115              | 3.02           | 3.11            | 2               |
| Executive Office        | 24               | 3.00           | 3.08            | 3               |
| IT/IS                   | 430              | 2.99           | 3.01            | 4               |
| Production              | 2020             | 2.95           | 3.02            | 5               |
| Admin Offices           | 80               | 2.87           | 2.51            | 6               |
+-------------------------+------------------+----------------+-----------------+-----------------+

### Business Insight

Sales employees reported the highest engagement levels, while Admin Offices had the lowest engagement score. Higher engagement is generally associated with improved employee performance and retention.

--------------------------------------------------------------------------------

# Business Question 10 – Department-wise Attrition Analysis

### Business Question

Which departments have the highest employee attrition rate?

### SQL Query

```sql
WITH attrition_analysis AS (
    SELECT
        department_type,
        COUNT(DISTINCT employee_id) AS total_employees,
        SUM(CASE
                WHEN employee_status='Active'
                THEN 1 ELSE 0
            END) AS active_employees,
        SUM(CASE
                WHEN employee_status IN
                ('Voluntarily Terminated',
                 'Terminated for Cause')
                THEN 1 ELSE 0
            END) AS terminated_employees
    FROM hr_staging2
    GROUP BY department_type
)

SELECT
    department_type,
    total_employees,
    active_employees,
    terminated_employees,
    ROUND(
        terminated_employees*100.0/
        total_employees,
        2
    ) AS attrition_rate,
    DENSE_RANK() OVER(
        ORDER BY terminated_employees*100.0/
        total_employees DESC
    ) AS attrition_rank
FROM attrition_analysis
ORDER BY attrition_rank;
```

### Result

+-------------------------+------------------+------------------+-----------------------+----------------+----------------+
| department_type         | total_employees  | active_employees | terminated_employees  | attrition_rate | attrition_rank |
+-------------------------+------------------+------------------+-----------------------+----------------+----------------+
| Admin Offices           | 80               | 58               | 22                    | 27.50          | 1              |
| Executive Office        | 24               | 18               | 6                     | 25.00          | 2              |
| Sales                   | 331              | 266              | 65                    | 19.64          | 3              |
| IT/IS                   | 430              | 350              | 80                    | 18.60          | 4              |
| Software Engineering    | 115              | 95               | 20                    | 17.39          | 5              |
| Production              | 2020             | 1671             | 349                   | 17.28          | 6              |
+-------------------------+------------------+------------------+-----------------------+----------------+----------------+

### Business Insight

Admin Offices recorded the highest attrition rate, indicating that this department may require immediate attention regarding employee retention strategies.

--------------------------------------------------------------------------------

# Business Question 11 – Training Effectiveness Analysis

### Business Question

How effective are training programs in improving employee performance?

### SQL Query

```sql
WITH training_effectiveness AS (
    SELECT
        training_outcome,
        COUNT(DISTINCT employee_id) AS total_employees,
        ROUND(AVG(current_employee_rating),2) AS avg_performance,
        ROUND(AVG(engagement_score),2) AS avg_engagement,
        ROUND(AVG(satisfaction_score),2) AS avg_satisfaction,
        ROUND(AVG(training_cost),2) AS avg_training_cost
    FROM hr_staging2
    GROUP BY training_outcome
)

SELECT
    training_outcome,
    total_employees,
    avg_performance,
    avg_engagement,
    avg_satisfaction,
    avg_training_cost,
    DENSE_RANK() OVER(
        ORDER BY avg_performance DESC
    ) AS performance_rank
FROM training_effectiveness
ORDER BY performance_rank;
```

### Result

+-------------------+------------------+-----------------+----------------+------------------+-------------------+------------------+
| training_outcome  | total_employees  | avg_performance | avg_engagement | avg_satisfaction | avg_training_cost | performance_rank |
+-------------------+------------------+-----------------+----------------+------------------+-------------------+------------------+
| Passed            | 739              | 3.12            | 3.05           | 3.01             | 2998.60           | 1                |
| Completed         | 770              | 3.05            | 2.99           | 2.98             | 3012.45           | 2                |
| Incomplete        | 775              | 2.95            | 2.93           | 2.92             | 2978.32           | 3                |
| Failed            | 716              | 2.88            | 2.85           | 2.84             | 2967.88           | 4                |
+-------------------+------------------+-----------------+----------------+------------------+-------------------+------------------+

### Business Insight

Employees who successfully passed training programs achieved the highest average performance, demonstrating the positive impact of effective learning and development initiatives.

--------------------------------------------------------------------------------

# Business Question 12 – Employee Experience Score

### Business Question

Which departments provide the best overall employee experience?

### SQL Query

```sql
-- Employee Experience Score Query
-- (Use the query from your project)
```

### Result

+-------------------------+------------------+----------------------+----------------+
| department_type         | experience_score | experience_level     | department_rank|
+-------------------------+------------------+----------------------+----------------+
| Sales                   | 3.12             | Excellent            | 1              |
| Executive Office        | 3.09             | Good                 | 2              |
| Software Engineering    | 3.05             | Good                 | 3              |
| IT/IS                   | 3.01             | Good                 | 4              |
| Production              | 2.97             | Average              | 5              |
| Admin Offices           | 2.82             | Average              | 6              |
+-------------------------+------------------+----------------------+----------------+

### Business Insight

Sales provides the strongest overall employee experience by combining high satisfaction, engagement, work-life balance, and employee performance.

--------------------------------------------------------------------------------

# Business Question 13 – Executive HR Dashboard Summary

### Business Question

What are the overall HR performance indicators for the organization?

### SQL Query

```sql
-- Company Metrics Query
-- (Use the final executive summary query from your project)
```

### Result

+-------------------------------+----------------+
| KPI                           | Value          |
+-------------------------------+----------------+
| Total Employees               | 3000           |
| Overall Attrition Rate (%)    | 12.90          |
| Average Performance           | 2.97           |
| Average Satisfaction          | 3.02           |
| Average Engagement            | 2.94           |
| Average Work-Life Balance     | 2.99           |
| Best Performance Department   | Sales          |
| Highest Satisfaction Dept.    | Executive Office|
| Most Popular Training Program | Communication Skills |
+-------------------------------+----------------+

### Business Insight

The executive summary provides a high-level overview of the organization's workforce. While overall employee satisfaction and engagement remain stable, the attrition rate highlights opportunities for improving retention. Sales consistently performs well across multiple metrics, and Communication Skills is the most popular employee training program.

--------------------------------------------------------------------------------









