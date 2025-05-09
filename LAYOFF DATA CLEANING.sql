select*
from layoffs;

#TO CLEAN DATA
# backup or create a copy of database
#check for duplicate
# standardise the data/ data types
# look for nulls /empty cells
#remove uncessary columns

#Creating a copy of database

select*
FROM Layoffs;

create table layoffs_copy
like layoffs;

select* from layoffs_copy;

insert INTO layoffs_copy
select* 
from layoffs;

#check for duplicate and remove if any(using row number)

SELECT company, location, industry, total_laid_off, percentage_laid_off, date,
       ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date 
       ORDER BY (industry)) as row_num
FROM layoffs_copy;

WITH Layoffs_dupli AS (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, date,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date
           ORDER BY (industry)) as row_num
    FROM layoffs_copy
)
SELECT* 
FROM Layoffs_dupli
WHERE row_num > 1;

WITH CTE_duplicate AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location , industry, total_laid_off, date,
					stage, country, funds_raised ) row_num
from layoffs_copy
) 
select*
FROM CTE_duplicate
WHERE row_num >1;

select*
from layoffs_copy
where company='Oda';

drop table if exists layoffs_copy3;
CREATE TABLE `layoffs_copy3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select*
from layoffs_copy3;

insert into layoffs_copy3
select*,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date,stage, country, funds_raised
) as row_num
FROM layoffs_copy;


select*
from layoffs_copy3;

delete
from layoffs_copy3
where row_num>1;

select*
from layoffs_copy3
where row_num>1;

select `date`, trim(`date`)
from layoffs_copy3;

update layoffs_copy3
set country=trim(country);

select distinct country
from layoffs_copy3;

#Change the date-clean, transform and change the column format to date
select `date`
str_to_date ,(`date`, '%m/%d/%y')
from layoffs_copy3;

select `date`,
cast(`date` as datetime) Formatted_date
from layoffs_copy3
;

select `date`,
left(`date`, 10) Formatted_date
from layoffs_copy3;


select `date`,
  str_to_date(left(`date`, 10),'%Y-%m-%d') FORMATTED_DATE
from layoffs_copy3
;

update layoffs_copy3
set `date`= str_to_date(left(`date`, 10),'%Y-%m-%d');

Alter table layoffs_copy3
modify column `date` date;

select*
from layoffs_copy3;

#....Adjusting the location

select distinct location
from layoffs_copy3;

#removing(replacing) the [,', and . in the location

select location,
     REPLACE(REPLACE(REPLACE(location,"'",""), "[",""),"]","")
from layoffs_copy3
;

select location,
     REPLACE(REPLACE(REPLACE(location,"'",""), "[",""),"]","") Cleaned_Location
from layoffs_copy3
;

select location,
     trim(REPLACE(REPLACE(REPLACE(location,"'",""), "[",""),"]","")) Cleaned_Location
from layoffs_copy3
;

select location,
trim(REPLACE(REPLACE(REPLACE(location,"'",""), "[",""),"]","")) Cleaned_Location
from layoffs_copy3
;


rollback; 

select location
from layoffs_copy3;

select location,
	TRIM(TRAILING "." FROM (TRIM(TRAILING "]" 
    FROM REPLACE(REPLACE(location,"'",""), "[","")))) clean_Location 
from layoffs_copy3
;

update layoffs_copy3
set location= trim(REPLACE(REPLACE(REPLACE(location,"'",""), "[",""),"]",""));

#Split location column to indicate USA and Non-USA based

select location,
substring_index(location, ",", -1)
from layoffs_copy3;

select location,
trim(substring_index(location, ",", -1))
from layoffs_copy3;

select location,
nullif(trim(substring_index(location, ",", -1)),location) Non_US
from layoffs_copy3;

#added ifnull function to replace the Null in the location

select location,
ifnull(nullif(trim(substring_index(location, ",", -1)),location), "N/A") Non_US
from layoffs_copy3;

#rename

select location, substring_index(location, ",", 1) City,
ifnull(nullif(trim(substring_index(location, ",", -1)),location), "N/A") Not_US
from layoffs_copy3;

#to add the column, create by altering table, then update the table

alter table layoffs_copy3
add column Not_US varchar(150);



UPDATE layoffs_copy3
SET Not_US = 'Not_USA'
WHERE location LIKE '%Non-U.S.%';

UPDATE layoffs_copy3
SET location = SUBSTRING_INDEX(location, ',', 1);

UPDATE layoffs_copy3
SET Not_US = 'Not-USA'
WHERE country not LIKE 'United States';

Alter table layoffs_copy3
drop column Not_US;

Alter table layoffs_copy3
drop column row_num;

SELECT *
FROM layoffs_copy3
WHERE industry IS NULL OR industry = '';

UPDATE layoffs_copy3
SET industry = 'Data'
WHERE industry IS NULL OR industry = '';

select*
from layoffs_copy3;

ALTER TABLE layoffs_copy3
CHANGE COLUMN `Not_US` `Region` VARCHAR(150);


select*
from layoffs_copy3
where total_laid_off= ""
and percentage_laid_off= "";

select*
from layoffs_copy3
where industry = ""
or industry is null;

DELETE FROM layoffs_copy3
WHERE total_laid_off IS NULL 
   OR total_laid_off = ''
   OR percentage_laid_off IS NULL
   OR percentage_laid_off = '';
   
select distinct industry
from layoffs_copy3;

ALTER TABLE layoffs_copy3
CHANGE COLUMN `Not_US` `Region` VARCHAR(150);

select*
from layoffs_copy3;

#explorative data analysis

select max(total_laid_off), max(percentage_laid_off)
from layoffs_copy3;

ALTER TABLE layoffs_copy3
CHANGE COLUMN `funds_raised $million` funds_raised_million_$ VARCHAR(150);

select*
from layoffs_copy3
where percentage_laid_off=1;

select*
from layoffs_copy3
where percentage_laid_off=1
order by total_laid_off desc;

select*
from layoffs_copy3
where percentage_laid_off=1
order by funds_raised_million_$ desc;

select company, sum(total_laid_off)
from layoffs_copy3
group by company
order by 2 desc;

select company,`date`, sum(total_laid_off)
from layoffs_copy3
group by company, `date`
order by 2 desc;

select company, year(`date`), sum(total_laid_off)
from layoffs_copy3
group by company, year(`date`)
order by 2,3 desc;

select company, substring(`date`,6,2) Months, sum(total_laid_off)
from layoffs_copy3
group by company, substring(`date`,6,2)
order by 2,3 desc;

select substring(`date`,6,2) Months, sum(total_laid_off)
from layoffs_copy3
group by substring(`date`,6,2)
order by Months desc;

With company_year as
(select company, year (`date`), sum(total_laid_off)
from layoffs_copy3
group by company, year(`date`)
order by 1)
select* from company_year;

WITH Rolling_total AS (
SELECT 
    SUBSTRING(date, 1, 7) AS MONTH, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy3
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY MONTH
ORDER BY  1
)
SELECT MONTH, total_laid_off,
SUM(total_laid_off) OVER(ORDER BY MONTH) rolling_total 
FROM Rolling_total;

WITH Company_Year AS (
SELECT company, YEAR(date) as Years, SUM(total_laid_off) as Laid_offs
FROM layoffs_copy3
GROUP BY company, YEAR(date)
), Company_Year_RANKING AS(
SELECT *, DENSE_RANK() OVER( PARTITION BY years ORDER BY Laid_offs DESC) Ranking
FROM Company_Year
#WHERE total_laid_off <> 0 
)
SELECT *
FROM Company_Year_RANKING
WHERE Ranking <= 5
;

SELECT company, year(date), sum(total_laid_off) AS total_layoffs
FROM layoffs_copy3
WHERE year(date) between 2020 and 2026
GROUP BY company, year(date)
ORDER BY year(date), total_layoffs DESC
;

WITH YearlyLayoffs AS (
    -- Calculate the total layoffs per company for each year
    SELECT
        company,
        YEAR(date) AS layoff_year,
        SUM(CAST(total_laid_off AS UNSIGNED)) AS total_layoffs -- Cast text to number for summation
    FROM
        layoffs_copy3 
    WHERE
        YEAR(date) BETWEEN 2022 AND 2025 -- Filter for the specified years
    GROUP BY
        company,
        layoff_year
),
RankedLayoffs AS (
    -- Assign a rank to each company within each year based on total layoffs
    SELECT
        company,
        layoff_year,
        total_layoffs,
        ROW_NUMBER() OVER (PARTITION BY layoff_year ORDER BY total_layoffs DESC) as rn
        -- ROW_NUMBER assigns a unique rank for ties. Use RANK() if you want ties to have the same rank.
    FROM
        YearlyLayoffs
)
-- Select the top 5 companies for each year
SELECT
    company,
    layoff_year,
    total_layoffs
FROM
    RankedLayoffs
WHERE
    rn <= 5 -- Filter for the top 5 ranks in each partition (year)
ORDER BY
    layoff_year ASC,  -- Order results primarily by year
    total_layoffs DESC; -- Then by the number of layoffs (highest first) within each year
    
    select*
    from layoffs_copy3;layoffs_copy3