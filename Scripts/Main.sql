USE [DB39];

-- 1. Select all from Evaluation
SELECT *
FROM Evaluation;

-- 2. Select female evaluators over 30
SELECT FirstName, LastName
FROM Evaluator
WHERE Gender = 'Female' AND Age > 30;

-- 3. Join Evaluation, Evaluator, Property, and Address for detailed view
SELECT 
    e.FirstName, 
    e.LastName, 
    a.Street, 
    a.Number, 
    a.City, 
    ev.Price
FROM Evaluation ev
JOIN Evaluator e ON ev.EvaluatorCode = e.Code
JOIN Property p ON ev.PropertyCode = p.Code
JOIN Address a ON p.AddressCode = a.Code;

-- 4. Update all evaluation prices by 10%
UPDATE Evaluation
SET Price = Price * 1.1;

-- 5. Select properties in areas with average income > 40000, evaluated late December 2020
SELECT DISTINCT 
    p.Code, 
    a.Street, 
    a.Number, 
    a.City
FROM Property p
JOIN Address a ON p.AddressCode = a.Code
JOIN Area ar ON p.AreaCode = ar.Code
JOIN Evaluation ev ON p.Code = ev.PropertyCode
WHERE ar.Income > 35000 
AND ev.EvaluationDate >= '2020-01-01' AND ev.EvaluationDate < '2021-01-01';

-- 6. Count evaluations per evaluator for year 2020
SELECT DISTINCT 
    e.Code AS EvaluatorCode,
    e.Gender,
    e.Age,
    (SELECT COUNT(*)
     FROM Evaluation ev
     WHERE ev.EvaluatorCode = e.Code
       AND YEAR(ev.EvaluationDate) = 2020) AS EvaluationCount
FROM Evaluator e;

-- 7. Find properties evaluated more than twice in 2020
SELECT PropertyCode
FROM Evaluation
WHERE YEAR(EvaluationDate) = 2020
GROUP BY PropertyCode
HAVING COUNT(PropertyCode) > 1;

-- 8.Find evaluation eodes for properties in areas with average income above 38,000
SELECT ev.Code
FROM Evaluation ev
WHERE PropertyCode IN (
    SELECT p.Code
    FROM Property p
    JOIN Area a ON p.AreaCode = a.Code
    WHERE a.Income > 38000
);

-- 9. Count evaluations per property in areas with population > 100000
SELECT 
    p.Code,
    (SELECT COUNT(*)
     FROM Evaluation ev
     WHERE ev.PropertyCode = p.Code
     AND YEAR(ev.EvaluationDate) = 2020) AS EvaluationCount
FROM Property p
WHERE p.AreaCode IN (
    SELECT Code
    FROM Area
    WHERE Population > 100000
);

-- 10. Count evaluations by area and evaluator gender
SELECT 
    a.Code AS AreaCode,
    e.Gender AS EvaluatorGender,
    COUNT(*) AS EvaluationCount
FROM Evaluation ev
JOIN Property p ON ev.PropertyCode = p.Code
JOIN Area a ON p.AreaCode = a.Code
JOIN Evaluator e ON ev.EvaluatorCode = e.Code
GROUP BY a.Code, e.Gender;

-- 11. Average price per square meter by area
SELECT 
    a.Code AS AreaCode,
    AVG(CAST(ev.Price AS FLOAT) / p.Size) AS AveragePricePerSqMeter
FROM Property p
JOIN Evaluation ev ON p.Code = ev.PropertyCode
JOIN Area a ON p.AreaCode = a.Code
GROUP BY a.Code
ORDER BY AveragePricePerSqMeter ASC;

-- 12. Count residence and office evaluations per evaluator for 2020
SELECT 
    e.Code AS EvaluatorCode,
    COUNT(CASE WHEN r.Code IS NOT NULL THEN 1 END) AS ResidenceEvaluationCount,
    COUNT(CASE WHEN o.Code IS NOT NULL THEN 1 END) AS OfficeEvaluationCount
FROM Evaluation ev
JOIN Evaluator e ON ev.EvaluatorCode = e.Code
LEFT JOIN Residence r ON ev.PropertyCode = r.Code
LEFT JOIN Office o ON ev.PropertyCode = o.Code
WHERE YEAR(ev.EvaluationDate) = 2020
GROUP BY e.Code;

-- 13. Change in average price per square meter between 2019 and 2020 by area
SELECT 
    a.Code AS AreaCode,
    ROUND(
        (AVG(CASE WHEN YEAR(ev.EvaluationDate) = 2022 THEN ev.Price / p.Size ELSE NULL END) 
         - AVG(CASE WHEN YEAR(ev.EvaluationDate) = 2021 THEN ev.Price / p.Size ELSE NULL END)), 2
    ) AS PriceChangePerSqMeter
FROM Area a
JOIN Property p ON a.Code = p.AreaCode
JOIN Evaluation ev ON p.Code = ev.PropertyCode
WHERE YEAR(ev.EvaluationDate) IN (2022, 2021)
GROUP BY a.Code
HAVING ROUND(
    (AVG(CASE WHEN YEAR(ev.EvaluationDate) = 2022 THEN ev.Price / p.Size ELSE NULL END) 
     - AVG(CASE WHEN YEAR(ev.EvaluationDate) = 2021 THEN ev.Price / p.Size ELSE NULL END)), 2
) IS NOT NULL;

-- 14. Count unique evaluators per area
SELECT 
    p.AreaCode,
    COUNT(DISTINCT ev.EvaluatorCode) AS EvaluatorCount
FROM Property p
JOIN Evaluation ev ON p.Code = ev.PropertyCode
GROUP BY p.AreaCode;

-- 15. Average price per square meter by construction year range per area
SELECT 
    p.AreaCode AS AreaCode,
    AVG(CASE WHEN p.YearBuilt < 1960 THEN ev.Price / p.Size ELSE NULL END) AS AvgPricePerSqMeter_Pre1960,
    AVG(CASE WHEN p.YearBuilt >= 1960 AND p.YearBuilt < 1980 THEN ev.Price / p.Size ELSE NULL END) AS AvgPricePerSqMeter_1960_1980,
    AVG(CASE WHEN p.YearBuilt >= 1980 AND p.YearBuilt < 2000 THEN ev.Price / p.Size ELSE NULL END) AS AvgPricePerSqMeter_1980_2000,
    AVG(CASE WHEN p.YearBuilt >= 2000 AND p.YearBuilt <= 2021 THEN ev.Price / p.Size ELSE NULL END) AS AvgPricePerSqMeter_2000_2021
FROM Property p
JOIN Evaluation ev ON p.Code = ev.PropertyCode
GROUP BY p.AreaCode;

-- 16. Percentage of evaluations and population by area for 2020
SELECT 
    a.Code AS AreaCode,
    (COUNT(ev.PropertyCode) * 100.0 / (SELECT COUNT(*) FROM Evaluation WHERE YEAR(EvaluationDate) = 2020)) AS PercentOfEvaluations,
    (a.Population * 100.0 / (SELECT SUM(Population) FROM Area)) AS PercentOfPopulation
FROM Area a
JOIN Property p ON a.Code = p.AreaCode
JOIN Evaluation ev ON p.Code = ev.PropertyCode
WHERE YEAR(ev.EvaluationDate) = 2020
GROUP BY a.Code, a.Population;