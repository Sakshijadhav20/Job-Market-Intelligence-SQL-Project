USE job_intelligence;

-- PHASE 1 : BASIC QUERIES
-- QUERY 1: Display all job postings
select * from jobs;

-- QUERY 2 : Find all Data Analyst Jobs
select * from jobs where job_title="Data Analyst";

-- QUERY 3: Find companies offering salary more than 15 LPA
select * from jobs where salary_max_lpa>15;

-- QUERY 4: Find which companies are in IT Industry or FInance Industry
select * from companies 
	where Industry="Software Development" OR Industry="Information Technology";

-- QUERY 5: Find Jobs where Job Title is AI Engineer and Work Mode is Hybrid 
select * from jobs where job_title= "AI Engineer" AND Work_Mode="Hybrid";

-- QUERY 6: Find Distinct Skills
select distinct skill_name from skills;

-- QUERY 7: Arrange job title in Salary max descending
select * from jobs order by salary_max_lpa desc;     

-- QUERY 8: Find the Top 10 highest paying jobs
select Job_ID,Company_ID,Job_Title,Salary_Min_LPA,Salary_Max_LPA 
	from jobs order by salary_max_lpa desc limit 10;

-- QUERY 9: Find skills containing word like "Data"
select * from skills where skill_name Like "%Data%";
-- alternate query which uses Between , AND
select job_id,job_title,salary_min_lpa,salary_max_lpa
from jobs
where job_title like '%Data%'
  and salary_max_lpa between 8 and 20
order by salary_max_lpa desc;

-- QUERY 10: Find jobs having work mode in Hybrid and remote
select job_title, work_mode from jobs where work_mode in ("Remote","Hybrid");

-- Query10.1: Find jobs where job title is AI Engineer and work mode is Hybrid 
select * from jobs where job_title= "AI Engineer" AND Work_Mode="Hybrid";

-- QUERY 11: Find jobs within a salary range of 8 lpa and 20 lpa
select * from jobs where salary_max_lpa between 8 and 20;

-- QUERY 12: Find the total count of job posts and their average,minimum,maximum salaries
select count(*) as Total_Jobs, 
avg(salary_max_lpa)as average_max_salary, 
min(salary_max_lpa)as minimum_salary,
max(salary_max_lpa)as maximum_salary from jobs;
-- Query 12.1: Add a column for average salary
alter table jobs add column salary_avg_lpa int;
update jobs set salary_avg_lpa = salary_min_lpa+salary_max_lpa/2;

-- QUERY 13: Total jobs post for each job title
select count(*) as Total_Postings, job_title
from jobs
group by Job_Title order by total_postings desc;

-- QUERY 14: Find high demand job roles (more than 20)
select job_title, count(*) as Total_job_posts 
from jobs 
group by job_title 
having count(job_title)>20
order by Total_job_posts desc;

-- Query 15: Find companies with high hiring activity
select company_id, count(*) as Total_Job_postings 
from jobs 
where salary_max_lpa>10 
group by company_id 
having count(*) >20 order by total_job_postings;

-- Query 16: Find companies salaries across experience levels
select experience_level, company_id,
avg(salary_max_lpa) as AVGMAXSAl, 
max(salary_max_lpa) as maxsal
from jobs where salary_max_lpa is not null 
group by experience_level,company_id 
order by AVGMAXSAL;


-- PHASE 2-- Additional Aggregation and Funcions Queries
-- Query 17: Format job titles using string functions
select job_id, 
upper(job_title) as JOB_TITLE_UPPERCASE, 
lower(job_title) as job_title_lowercase, 
concat(job_title,' - ', experience_level)  as Job_Profiles 
from jobs;

-- Query 18: Extract the year and month of job postings
select job_id, job_title,posted_date, 
year(posted_date) as Posted_Year,
monthname(posted_date) as Posted_Month 
from jobs;

-- Query 19: Apply ROUND(), CEILING() and FLOOR() to salaries
select Job_title,round(avg(salary_max_lpa)) as roundmaxsal,
ceiling(avg(salary_max_lpa)) as Ceiling_Salary,
floor(avg(salary_max_lpa)) as Floor_salary from jobs group by job_title;

-- Query 20: Add an Average Salary Column
Alter table Jobs add column Salary_AVG_LPA decimal(10,2);

-- Query 21: Calculate the salary midpoint
update jobs set salary_avg_lpa= (salary_min_lpa+salary_max_lpa)/2;


-- PHASE 3 -- Delete 
-- Query 22: Delete one record from jobs
start transaction;
delete from skills where skill_id=500;
rollback;


-- PHASE 4 -- Joins and Union
-- Query 23: Display job postings with company names
select j.job_id,j.job_title,j.company_id,j.company_id 
from jobs as j join companies as c on j.company_id=c.company_id;

-- Query 24: Display all companies and their job postings
select c.company_id,c.company_name,c.industry, 
	j.job_id,j.job_title,j.experience_level,j.employment_type,j.work_mode, j.salary_min_lpa,j.salary_max_lpa,j.posted_date
    from companies as c 
    left join jobs as j 
    on c.company_id=j.company_id;
    
-- Query 25: Display all locations and their job postings
select l.Location_ID, City, Country, 
	Job_ID, Company_ID, Job_Title, Experience_Level, Employment_Type, Work_Mode, Salary_Min_LPA, Salary_Max_LPA, Posted_Date, Salary_AVG_LPA 
	from locations as l right join jobs as j on l.location_id=j.location_id;
    
-- Query 26: Create a complete job Market report
select Job_ID, j.Company_ID, j.Location_ID, Job_Title, Experience_Level, Employment_Type, Work_Mode, Salary_Min_LPA, Salary_Max_LPA, Posted_Date, Salary_AVG_LPA, 
	City, Country, Company_Name, Industry from jobs as j 
    inner join locations as l on j.location_id=l.location_id 
    inner join companies as c on j.company_id=c.company_id 
    order by j.salary_max_lpa desc;
    
-- Query 27: Find the skills required for each job
select js.skill_id,s.skill_name,js.job_id, j.job_title 
	from job_skills as js 
	left join skills as s on js.skill_id=s.skill_id 
    inner join jobs as j on js.job_id=j.job_id 
    order by salary_max_lpa desc;
    
 -- Query 28: Display all locations and their job postings
 select l.Location_ID, City, Country, 
	Job_ID, Company_ID, Job_Title, Experience_Level, Employment_Type, Work_Mode, Salary_Min_LPA, Salary_Max_LPA, Posted_Date, Salary_AVG_LPA 
    from locations as l right join jobs as j on l.location_id=j.location_id;
    
-- Query 29: Combine jobs from two selected role groups
select Job_ID, Company_ID, Job_Title, Experience_Level, Salary_Max_LPA
from jobs where job_title="Data Analyst"
Union
select Job_ID, Company_ID, Job_Title, Experience_Level, Salary_Max_LPA
from jobs where job_title="Data Scientist"
order by Salary_max_lpa desc;


-- PHASE 5 -- Single-row Subqueries
-- Query 30: Find jobs offering above-average maximum salaries
select job_title, salary_max_lpa from jobs where salary_max_lpa > (select avg(salary_max_lpa) from jobs);

-- Query 31: Find the job with the highest maximum salary
select job_title, salary_max_lpa from jobs where salary_max_lpa=(select max(salary_max_lpa) from jobs);

-- Query 32: Find jobs with above average minimum salaries
select job_title,salary_min_lpa from jobs where salary_min_lpa>(select avg(salary_min_lpa) from jobs) order by salary_min_lpa desc;

-- Query 33: Find companies with more job postings than the average company 
select company_id, count(*) as Total_postings from jobs group by company_id having count(*)>
	(select avg(job_count) from 
	(select count(*) as job_count from jobs group by company_id) as company_postings) 
    order by total_postings desc;
    
-- Query 34: Find jobs posted by a specific company 
select job_id,job_title,j.company_id,company_name,Salary_min_lpa, salary_max_lpa 
	from jobs as j left join companies as c on J.company_id=c.company_id
    where j.company_id=(select company_id from companies where company_name="TechNova Solutions");

-- Query 35: Find jobs offering the highest minimum salary
select  job_id,job_title,salary_min_lpa,salary_max_lpa 
	from jobs 
    where salary_min_lpa=(select max(salary_min_lpa) from jobs);
    
-- PHASE 6 -- Multi-row Subquery
-- Query 36: Find jobs offered by companies in the IT or Software Development industry
select job_id,job_title,Industry,Salary_max_lpa,salary_min_lpa 
	from jobs left join companies on jobs.company_id=companies.company_id
    where jobs.company_id in 
    (select companies.company_id from companies 
    where industry in ("Information Technology","Software Development")) 
    order by salary_max_lpa desc;

-- Query 37: Find jobs that require skills listed in the skills table
select job_id,job_title,Salary_max_lpa 
	from jobs 
    where job_id in 
    (select job_id from job_skills where skill_id in
    (select skill_id from skills where skill_name like "%data%")) 
    order by salary_max_lpa desc;
    
-- Query 38:Find companies that have posted jobs in locations where the country is India
select company_id,company_name,Industry 
	from companies 
	where company_id in
	(select company_id from jobs where location_id in
	(select location_id from locations where country ="india"));
    
-- Query 39: Find jobs offering a maximum salary greater than the maximum salary of any Data Analyst job
select job_id,job_title,salary_max_lpa 
	from jobs where salary_max_lpa > ANY
    (select salary_max_lpa from jobs where job_title="Data Analyst") 
    order by salary_max_lpa desc;
    
-- Query 40: Find jobs offering a maximum salary greater than the maximum salary of all Data Analyst jobs
select job_id,job_title,salary_max_lpa 
	from jobs where salary_max_lpa > All
    (select salary_max_lpa from jobs where job_title="Data Analyst") 
    order by salary_max_lpa desc;
    
-- QUery 41: Find jobs whose maximum salary is equal to the maximum salary offered by companies in the Software Development industry
select job_id,job_title,salary_max_lpa from jobs where salary_max_lpa=
	(select max(j.salary_max_lpa) from jobs as j 
    join companies as c on j.company_id=c.company_id where c.industry="software development");
 
 
 -- PHASE 7 -- WINDOW FUNCTIONS
-- Query 42: Ranks jobs by maximum salary
select job_id,job_title,salary_max_lpa,
	rank() over (order by salary_max_lpa desc) as salary_rank
    from jobs
    where salary_max_lpa is not null;
    
-- Query 43: Rank jobs within each experience level by maximum salary
select job_id,job_title,salary_max_lpa, 
	dense_rank() over(partition by experience_level order by salary_max_lpa desc) as salary_rank
	from jobs order by experience_level, salary_rank;
    
-- Query 44: Assign a unique row number to each job based on maximum salary
select job_id,job_title,Salary_max_lpa, 
	row_number() over (order by salary_max_lpa desc) as salary_row_number
	from jobs; 
    
-- Query 45: Compare each job's maximum salary with the average salary for its experience level
select job_id,job_title,salary_max_lpa,experience_level, 
	avg(salary_max_lpa) over( partition by experience_level) as Experience_Level_Avg_Salary
	from jobs
	order by experience_level,salary_max_lpa desc;
 
-- Query 46: Find the highest-paying job within each experience level
select job_id,job_title,salary_max_lpa,experience_level,
	first_value(job_title) over(partition by experience_level order by salary_max_lpa desc,job_id asc) as highest_paying_job,
	first_value(salary_max_lpa) over(partition by experience_level order by salary_max_lpa desc,job_id asc) as highest_salary_in_level
from jobs
where salary_max_lpa is not null
order by experience_level,salary_max_lpa desc;


-- PHASE 8 -- VIEWS
-- Query 47: Create a VIEW for job market analysis
create view job_market_view as
	select j.job_id,j.job_title,c.company_name,c.industry,l.city,l.country,j.experience_level,j.work_mode,j.salary_min_lpa,j.salary_max_lpa
		from jobs as j
        inner join companies as c on j.company_id=c.company_id
        inner join locations as l on j.location_id=l.location_id;

select * from job_market_view;

-- Query 48: Create a VIEW to analyze high-paying jobs
create view high_paying_jobs_view as
	select j.job_id,j.job_title,c.company_name,c.industry,j.experience_level,j.salary_max_lpa
		from jobs j
		inner join companies c on j.company_id=c.company_id
		where j.salary_max_lpa>=20;
        
select * from high_paying_jobs_view;



-- PHASE 9 -- CTE (COMMON TABLE EXPRESSION)
-- Query 49: Use a CTE to find jobs offering above-average maximum salaries
with avg_salary as 
	(select avg(salary_max_lpa) as average_salary from jobs)
    select job_id,job_title,experience_level,salary_max_lpa from jobs 
    where salary_max_lpa>(select average_salary from avg_salary)
    order by salary_max_lpa desc;
    
-- Query 50: Use a CTE to find the highest-paying job in each experience level
with experience_salary as
	(select experience_level, max(salary_max_lpa) as highest_salary
		from jobs
			where salary_max_lpa is not null
				group by experience_level)
	select j.job_id,j.job_title,j.experience_level,j.salary_max_lpa from jobs as j
    inner join experience_salary as e 
    on j.experience_level = e.experience_level
    and j.salary_max_lpa=e.highest_salary
    order by j.experience_level;