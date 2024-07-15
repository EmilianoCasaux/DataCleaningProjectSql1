-- Data Cleaning Project

-- First visualization of our data

Select *
From layoffs;

-- Data cleaning process steps:
	-- 0. Create a new table in order to keep the original one as it is. 
	-- 1. Remove Duplicates OK.
	-- 2. Standardize data OK.
	-- 3. Null Values or blank values, Decide what to do with them. 
	-- 4. Remove Any Columns that are not necessary.
	-- 5. Correct errors.
	-- 6. Create variables that could be useful in a future analysis

-- Create new table

create table layoffs_staging
like layoffs;

Insert layoffs_staging
select *
from layoffs;

Select *
from layoffs_staging;

-- Identificate and eliminate duplicates 

CREATE TABLE `layoffs_staging1` (
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

Select *
from layoffs_staging1;

insert into layoffs_staging1
select *,
ROW_NUMBER() OVER(
partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions) as row_num
from layoffs_staging;

select *
from layoffs_staging1
where row_num>1;

select *
from layoffs_staging1
where company like "Cazoo%";

delete 
from layoffs_staging1
where row_num>1;

-- Standarize and correct the data

select *
from layoffs_staging1;

Select company, trim(company)
from layoffs_staging1
where company<>trim(company);

update layoffs_staging1
set company=trim(company);

Select distinct(industry)
from layoffs_staging1
order by 1;

update layoffs_staging1
set industry = 'Crypto'
where industry like 'crypto%';

Select *
from layoffs_staging1;

Select distinct(location)
from layoffs_staging1
order by 1;

update layoffs_staging1
set location =  REGEXP_REPLACE(location, '[^a-zA-Z ]', '')
;

update layoffs_staging1
set location = 'Dusseldorf'
where location like '%sseldorf';

update layoffs_staging1
set location = 'Florianopolis'
where location like '%npolis';

Select *
from layoffs_staging1
where location like 'Malm%';

update layoffs_staging1
set location = 'Malmo'
where location like 'Malm%';

Select distinct(country)
from layoffs_staging1
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging1
where country like 'United States%';

update layoffs_staging1
set country =  REGEXP_REPLACE(country, '[^a-zA-Z ]', '')
;

Select distinct(date)
from layoffs_staging1;

Select `date`,
str_to_date(`DATE`,'%m/%d/%Y')
from layoffs_staging1;

update layoffs_staging1
set `date` = str_to_date(`DATE`,'%m/%d/%Y');

Select *
from layoffs_staging1
order by 6;

alter table layoffs_staging1
modify column `date` Date;

-- Check and complete the Nulls if possible

Select *
from layoffs_staging1
where total_laid_off is null and percentage_laid_off is null;

select *
from layoffs_staging1
where industry is null or industry ='';

update layoffs_staging1
Set industry=null
where industry='';

select *
from layoffs_staging1
where company like'Bally%'
;

Select *
from layoffs_staging1 t1
join layoffs_staging1 t2
	on t1.company=t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

update layoffs_staging1 t1
join layoffs_staging1 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null;

delete 
from layoffs_staging1
where total_laid_off is null and percentage_laid_off is null;

Select *
from layoffs_staging1;

Alter table layoffs_staging2
drop row_num;


