-- 1.	Write a SQL query to remove the details of an employee whose first name ends in ‘even’
delete from employees where first_name like '%even';

-- 2.	Write a query in SQL to show the three minimum values of the salary from the table.
select salary from employees order by salary limit 3;

-- 3.	Write a SQL query to remove the employees table from the database
-- drop table employees;

-- 4.	Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table
create table Employee as select * from employees;
-- delete from employees;

-- 5.	Write a SQL query to remove the column Age from the table
-- alter table Employee drop column age;

-- 6.	Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
select concat_ws(' ', first_name, last_name) as full_name, email, year(hire_date) as hire_year from employees where hire_year < 2000;

-- 7.	Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
select employee_id, job_id from employee where year(hire_date) between 1990 and 1999;


-- 8.	Find the first occurrence of the letter 'A' in each employees Email ID
-- Return the employee_id, email id and the letter position
select employee_id, email, charindex('A', email) as letter_position from employee;
-- charindex() returns zero if char not found.


-- 9.	Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
select employee_id, concat_ws(' ', first_name, last_name) as full_name, email as hire_year from employees where length(full_name) < 12;

-- 10.	Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID 
-- Return the employee_id, and their corresponding UNQ_ID;
select employee_id, concat_ws('-', first_name, last_name, email) as UNQ_ID from employees;

-- 11.	Write a SQL query to update the size of email column to 30
alter table employee modify email varchar(30);

-- 12.	Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  
-- Info : this mean you need to separate phone into 2 parts 
-- eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
select first_name, email,
substring(phone_number, 0, length(phone_number) - charindex('.', reverse(phone_number))) as phone,
split_part(phone_number, '.', -1) as extension
from employee;

-- 13.	Write a SQL query to find the employee with second and third maximum salary.
select * from employee where salary in (select distinct salary from employee order by salary desc offset 1 fetch next 2);

-- 14.	  Fetch all details of top 3 highly paid employees who are in department Shipping and IT
select top 3 * from employee where department_id in (select department_id from departments where department_name in ('Shipping'))
union
select top 3 * from employee where department_id in (select department_id from departments where department_name in ('IT'));

-- top three among all
--select * from employee where department_id in (select department_id from departments where department_name in ('IT','Shipping')) limit 3;

-- 15.	  Display employee id and the positions(jobs) held by that employee (including the current position)
select employee_id, job_title from employee, jobs where employee.job_id = jobs.job_id
union
select employee_id, job_title from job_history, jobs where job_history.job_id = jobs.job_id;

-- 16.	Display Employee first name and date joined as WeekDay, Month Day, Year
-- Eg : 
-- Emp ID      Date Joined
-- 1	Monday, June 21st, 1999
select employee_id, concat_ws(', ', dayname(hire_date), concat_ws(' ', monthname(hire_date), concat(day(hire_date),
case
    when day(hire_date) between 11 and 13 then 'th'
    when endswith(day(hire_date),'1') then 'st'
    when endswith(day(hire_date),'2') then 'nd'
    when endswith(day(hire_date),'3') then 'rd'
    else 'th'
end)),year(hire_date)) as Date_Joined  from employee;

-- 17.	The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
-- The job position might be removed based on market trends (so, save the changes) . 
alter session set autocommit = false;

insert into jobs values (
    'DT_ENGG',
    'Data Engineer',
    12000,
    30000 );

commit;

-- - Later, update the maximum salary to 40,000 . 
-- - Save the entries as well.
update jobs set max_salary = 40000 where job_id = 'DT_ENGG';
-- select * from jobs;

-- -  Now, revert back the changes to the initial state, where the salary was 30,000
rollback;

alter session set autocommit = true;

-- select * from jobs;

-- 18.	Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
select round(avg(salary),3) as average_salary from employee where hire_date > Date('1996-1-8') and hire_date < Date('2000-1-1');

-- 19.	 Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
select region_name from regions union all select 'Australia' union all select 'Asia' union all select 'Antartica' union all select 'Europe';

-- B. Display all the unique regions
select region_name from regions union select 'Australia' union select 'Asia' union select 'Antartica' union select 'Europe';