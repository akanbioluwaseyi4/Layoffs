SELECT * FROM layoff.layoffs_copy3;
select country, sum(funds_raised_million_$) from layoffs_copy3 group by funds_raised_million_$, country;

select*,
sum(funds_raised_million_$) over(partition by industry order by region ) Sum_of_Indstry_funds
FROM layoffs_copy3;

select industry, country, location,
dense_rank() over(order by funds_raised_million_$ desc)
from layoffs_copy3;

select industry, country, location,
lag(funds_raised_million_$) over(order by country desc)
from layoffs_copy3;

select industry, country, location,
lead(funds_raised_million_$) over(order by country desc)
from layoffs_copy3;

select*
from layoffs_copy3;

With CTE as(
select company, region,
row_number()  over(order by funds_raised_million_$ desc) Hrsd from layoffs_copy3)
select* from CTE where Hrsd=3;

select*
from layoffs_copy3;

select company, stage
from layoffs_copy3 where Region in ('USA');

select company, stage
from layoffs_copy3 where Region not in ('USA');
