-- Data Cleaning
SELECT * 
FROM world_layoffs.layoffs;

CREATE TABLE world_layoffs.layoffs_staging
LIKE world_layoffs.layoffs;

SELECT * 
FROM world_layoffs.layoffs_staging;

INSERT world_layoffs.layoffs_staging
SELECT *
FROM world_layoffs.layoffs;

SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised) 
AS row_num
FROM world_layoffs.layoffs_staging;

-- Check for duplicates 
WITH duplicate_cte AS 
( 
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised) 
AS row_num 
FROM world_layoffs.layoffs_staging
)
Select *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE world_layoffs.layoffs_staging2 (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM world_layoffs.layoffs_staging2;

INSERT INTO world_layoffs.layoffs_staging2 
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised) 
AS row_num 
FROM world_layoffs.layoffs_staging;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE row_num >1;

-- Delete duplicates
DELETE
FROM world_layoffs.layoffs_staging2
WHERE world_layoffs.layoffs_staging2.row_num > 1;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;


-- Standardizing Data
SELECT company, TRIM(company)
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
WHERE country LIKE 'United States%' ;

UPDATE world_layoffs.layoffs_staging2
SET country = TRIM( TRAILING '.' FROM country);

-- Update date formating
SELECT date,
STR_TO_DATE(date , '%m/%d/%Y')
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET date = STR_TO_DATE(date , '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN date DATE;

UPDATE world_layoffs.layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off NOT REGEXP '^-?[0-9]+$';

UPDATE world_layoffs.layoffs_staging2
SET funds_raised = NULL
WHERE funds_raised NOT REGEXP '^-?[0-9]+$';

UPDATE world_layoffs.layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off NOT REGEXP '^-?[0-9]+(\.[0-9]+)?$';

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY total_laid_off INTEGER,
MODIFY funds_raised INTEGER,
MODIFY percentage_laid_off DECIMAL(10,2);

-- Find Null Values
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry is NULL OR industry = ' ' ;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;


-- Remove necessary columns or rows
DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

SELECT *
FROM world_layoffs.layoffs_staging2;

ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;
