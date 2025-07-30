

-- Data Cleaning  World Layoff 
-- data comes from layoffs.csv (original source: https://www.kaggle.com/datasets/swaptr/layoffs-2022)

-- Steps I will be following to clean the data


--  Remove Duplicates
		-- there is no unique identifier for this file, therefore I have to create one to find the dups and get rid of them. 
--  Remove any columns and rows with minimal data available
--  Standardize the data. 
--  Null values or blank values



-- Remove Duplicates. 


-- To preserve the original table I always create a copy. 

SELECT *
FROM layoffs;
CREATE TABLE layoffs_stagging
LIKE layoffs;


SELECT *
FROM layoffs_stagging;


INSERT layoffs_stagging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_stagging
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM layoffs_stagging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1
;

SELECT *
FROM layoffs_stagging
WHERE company = 'Casper'
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM layoffs_stagging
)
DELETE
FROM duplicate_cte
WHERE row_num >1
;


CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Created a new table 'row_num' to find out if there were any duplicates (anything >1)

SELECT *
FROM layoffs_stagging2;

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM layoffs_stagging;

SELECT *
FROM layoffs_stagging2
WHERE row_num >1 ;


DELETE
FROM layoffs_stagging2
WHERE row_num > 1 ;


-- Standardize Data

-- I noticed some of the cells have extra spaces so I removed them:
SELECT *
FROM layoffs_stagging2;

SELECT distinct company, (TRIM(company))
FROM layoffs_stagging;


UPDATE layoffs_stagging2
SET company = (TRIM(company));


SELECT distinct industry
FROM layoffs_stagging2
ORDER BY 1;

-- Crypto industry is listed different ways so I updated the industry column and standartized "Crypto" industry:

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';



UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_stagging2;

SELECT *
FROM layoffs_stagging2;

SELECT distinct location
FROM layoffs_stagging2
Order by 1;


-- In "country" column there is an extra character after "United States" so I removed that character:
SELECT *
FROM layoffs_stagging2
WHERE country LIKE 'United States%'
ORDER By 1;

SELECT distinct country, TRIM(TRAILING '.' FROM country)
FROM layoffs_stagging2
ORDER By 1;

UPDATE layoffs_stagging2
SET country = trim(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_stagging2
;

-- On the table the date is showing as a txt file. Changed the data type to `date`:


SELECT `date`, 
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_stagging2;

SELECT * 
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');


SELECT `Date`
FROM layoffs_stagging2;


ALTER TABLE layoffs_stagging2
modify column `date` date;



SELECT *
FROM layoffs_stagging2;

-- Null values or blank values:


SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Some of the companies listed were missing industry name. If a company had multiple layoffs it was listed multiple times. 
-- Sometimes I was able to fill in the industry name based on other layoffs for that company.
-- Example: Airbnb was listed two times. I was able to determine the industry as "travel". Data updated. 
-- Bally's only had one entry so I was not able to update the missing industry data. 

SELECT distinct industry
FROM layoffs_stagging2
;

SELECT *
FROM layoffs_stagging2
WHERE industry IS NULL
OR industry = '';


SELECT *
From layoffs_stagging2
WHERE company = 'airbnb';

SELECT *
From layoffs_stagging2
WHERE company LIKE 'Bally%';

SELECT t1.industry, t2.industry
FROM layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
;


UPDATE layoffs_stagging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_stagging2;

-- Now that all the duplicates were determined and removed there is no need to have 'row_num' column. No need to occupy space. 
-- Newly created column was removed:

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;

-- Dataset was fully processed and it is ready for consumption. 
