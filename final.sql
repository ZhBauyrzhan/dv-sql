create database final_dv;

use final_dv;


select * from transactions;


SELECT 
    c.Id_client,
    AVG(t.Sum_payment) AS average_receipt,
    SUM(t.Sum_payment) / 12 AS average_monthly_purchase,
    COUNT(t.Id_check) AS total_transactions
FROM 
    customers c
JOIN 
    transactions t ON c.Id_client = t.ID_client
WHERE 
    STR_TO_DATE(t.date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY 
    c.Id_client
HAVING 
        COUNT(DISTINCT DATE_FORMAT(STR_TO_DATE(t.date_new, '%d/%m/%Y'), '%Y-%m')) = 12;


-- Задание 2: Информация в разрезе месяцев
-- a) Средняя сумма чека в месяц
SELECT
    DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y-%m') AS month,
    AVG(Sum_payment) AS avg_check
FROM
    transactions
GROUP BY
    month
ORDER BY
    month;

-- b) Среднее количество операций в месяц
SELECT
    DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y-%m') AS month,
    COUNT(Id_check) / COUNT(DISTINCT DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y-%m')) AS avg_operations
FROM
    transactions
GROUP BY
    month
ORDER BY
    month;

-- c) Среднее количество клиентов, которые совершали операции
SELECT
    DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y-%m') AS month,
    COUNT(DISTINCT ID_client) AS avg_clients
FROM
    transactions
GROUP BY
    month
ORDER BY
    month;

-- d) Доля от общего количества операций за год
-- 1. Доля от общего количества операций
SELECT
    DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y-%m') AS month,
    COUNT(Id_check) AS total_operations,
    (COUNT(Id_check) / (SELECT COUNT(*) FROM transactions WHERE DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y') = '2015')) * 100 AS percentage_of_year
FROM
    transactions
WHERE
    STR_TO_DATE(date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY
    month
ORDER BY
    month;

-- 2. Доля в месяц от общей суммы операций
SELECT
    DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y-%m') AS month,
    SUM(Sum_payment) AS total_sum,
    (SUM(Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions WHERE DATE_FORMAT(STR_TO_DATE(date_new, '%d/%m/%Y'), '%Y') = '2015')) * 100 AS percentage_of_month
FROM
    transactions
WHERE
    STR_TO_DATE(date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY
    month
ORDER BY
    month;

-- e) Вывести % соотношение M/F/NA в каждом месяце с их долей затрат
SELECT
    DATE_FORMAT(STR_TO_DATE(t.date_new, '%d/%m/%Y'), '%Y-%m') AS month,
    SUM(CASE WHEN c.Gender = 'M' THEN t.Sum_payment ELSE 0 END) AS male_spending,
    SUM(CASE WHEN c.Gender = 'F' THEN t.Sum_payment ELSE 0 END) AS female_spending,
    SUM(CASE WHEN c.Gender IS NULL THEN t.Sum_payment ELSE 0 END) AS na_spending,
    (SUM(CASE WHEN c.Gender = 'M' THEN t.Sum_payment ELSE 0 END) / SUM(t.Sum_payment)) * 100 AS male_percentage,
    (SUM(CASE WHEN c.Gender = 'F' THEN t.Sum_payment ELSE 0 END) / SUM(t.Sum_payment)) * 100 AS female_percentage,
    (SUM(CASE WHEN c.Gender IS NULL THEN t.Sum_payment ELSE 0 END) / SUM(t.Sum_payment)) * 100 AS na_percentage
FROM
    transactions t
JOIN
    customers c ON t.ID_client = c.Id_client
WHERE
    STR_TO_DATE(t.date_new, '%d/%m/%Y') BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY
    month
ORDER BY
    month;

-- Задание 3: Возрастные группы клиентов
-- Возрастные группы клиентов
SELECT
    CASE
        WHEN Age < 10 THEN '0-9'
        WHEN Age < 20 THEN '10-19'
        WHEN Age < 30 THEN '20-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        WHEN Age < 60 THEN '50-59'
        WHEN Age < 70 THEN '60-69'
        ELSE '70+'
    END AS age_group,
    SUM(t.Sum_payment) AS total_spending,
    COUNT(t.Id_check) AS total_transactions
FROM
    customers c
JOIN
    transactions t ON c.Id_client = t.ID_client
GROUP BY
    age_group
ORDER BY
    age_group;

-- Клиенты без информации о возрасте
SELECT
    'No Age Info' AS age_group,
    SUM(t.Sum_payment) AS total_spending,
    COUNT(t.Id_check) AS total_transactions
FROM
    customers c
JOIN
    transactions t ON c.Id_client = t.ID_client
WHERE
    c.Age IS NULL;

-- Поквартальная статистика
SELECT
    CONCAT(YEAR(t.date_new), '-Q', QUARTER(t.date_new)) AS quarter,
    AVG(t.Sum_payment) AS avg_transaction_value,
    COUNT(t.Id_check) AS total_transactions,
    COUNT(DISTINCT t.ID_client) AS total_clients
FROM
    transactions t
JOIN
    customers c ON t.ID_client = c.Id_client
GROUP BY
    quarter
ORDER BY
    quarter;


