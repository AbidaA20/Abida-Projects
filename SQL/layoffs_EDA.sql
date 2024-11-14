-- Exploratory Data Analysis

SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = '1'
ORDER BY funds_raised DESC;

-- % laid off and how many were laid off
SELECT company, AVG(percentage_laid_off) AS Percent_laid_off, SUM(total_laid_off) AS laid_off
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY 2 DESC,3 DESC;

-- Total laid off by company
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(date), MAX(date)
FROM world_layoffs.layoffs_staging2;

-- Total laid off by industry
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2 
GROUP BY industry
ORDER BY 2 DESC;

-- Total laid off yearly
SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 2 DESC;

-- Total laid off by country
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTRING(date,1,7) AS Month, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY Month
ORDER BY 1 ASC;

-- Rolling total of total laid off
WITH Rolling_Total AS
(SELECT SUBSTRING(date,1,7) AS Month, SUM(total_laid_off) AS sum_laid_off
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY Month
ORDER BY 1 ASC 
)
SELECT Month, sum_laid_off, SUM(sum_laid_off) OVER (ORDER BY Month) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(date) as Year, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company, Year
ORDER BY 3 DESC;

-- Yearly Top 5 company layoffs 
WITH Company_Year (company, Year, total_laid_off) AS
( SELECT company, YEAR(date) as Year, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company, Year
), Company_Year_Rank AS
( SELECT *, DENSE_RANK() OVER (PARTITION BY Year ORDER BY SUM(total_laid_off) DESC) AS Ranking
FROM Company_Year
GROUP BY company, Year
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;