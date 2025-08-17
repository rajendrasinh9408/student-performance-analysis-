
-- We must insure that our data is properly organized. Let's create a schema
-- specifically for importing/ copying data from our CSV files.
Create database students_performance;
use students_performance;

------------------------------------------------------------
--- EXPLORATORY DATA ANALYSIS
------------------------------------------------------------

select * from students;

# Firstly we will start with an understanding of data. so, we can perform queries

# Data Inspection
-- It provides a way to get glimpse of structure and content of your data without displaying the entire dataset, which can be especially useful for a large datasets.

-- Let's see overview of our dataset
select * from students
limit 5;

# Checking the size of datasets

-- Total Students: To get the count of total records
select count(*) from students;

-- Column count
select count(*)
from information_schema.columns
where table_name = "students";


# Checking the data type of columns

select column_name, data_type
from information_schema.columns
where table_name = "students";

-- Queries
-- calculate the average score of students in all subjects

select avg(math_score) as average_math,
	   avg(reading_score) as average_reading,
	   avg(writing_score) as average_writing
from students;


select count(*) from students
where math_score > 90 and reading_score > 90 and
writing_score > 90;

-- find each race with their average scores

select race, 
	avg(math_score) as avg_math_score,
	avg(reading_score) as avg_reading_score,
	avg(writing_score) as avg_writing_score
from students
group by race;

-- Write an SQL query to determine the number of students for each gender

select gender, count(*) as num_students
from students
group by gender;

-- find students who scored above the average math score

select * from students
where math_score > (select avg(math_score)
					from students);


-- find the top 10 students with the highest overall score (avg of math, reading, writing)
SELECT gender, race,
  Round((math_score + reading_score + writing_score) / 3, 2) AS overall_score
FROM students
ORDER BY overall_score DESC
limit 10;



-- find race groups where the average math score is greater than 70

select race, avg(math_score) as avg_math
from students
group by race
having avg_math > 70;

-- group students by gender and how many male and female there are in count and percentage 

select *, 
	Round(frequency/sum(frequency) over() * 100,2) as percentage
from(
select gender, count(*) as frequency
from students
group by gender
order by frequency desc) tab1;

-- find students with the highest reading score and students with the lowest reading_score

select min(math_score) as min_math_score,
       max(math_score) as max_math_score,
	   min(reading_score) as min_reading_score,  
       max(reading_score) as max_reading_score,
	   min(writing_score) as min_writing_score,
       max(writing_score) as max_writing_score
from students;


-- Write an SQL query to calculate the average score for students based on whether they 
-- completed a test preparation course

select *, 
	Round(frequency/sum(frequency) over() * 100,2) as percentage
from(
select test_preparation_course, 
	   count(*) as frequency
from students
group by test_preparation_course) per;


-- calcualte average math score by parental level education 
select parental_level_of_education,
		avg(math_score) as avg_math_score
from students
group by parental_level_of_education;

-- Students who completed the test preparation course generally have higher average scores 
-- compared to those who did not complete the course. 
-- it indicate the course likely helps improve their performance.

select test_preparation_course,
		avg(math_score) as avg_math_score,
		avg(reading_score) as avg_reading_score,
		avg(writing_score) as avg_writing_score
from students
group by test_preparation_course;


-- find number of students who completed test and those who did not

select test_preparation_course,
		count(*) as total_students
from students
group by test_preparation_course;

-- Create a view that displays the gender, test_preparation_course , and score of studentts

create view students_info as
select gender, 
	   test_preparation_course,
	   math_score,
       reading_score,
       writing_score
from students;

select * from students_info;

-- find frequency distribution for math scores

select 
	case
		 when math_score between 0 and 10 then '0-10'
		 when math_score between 11 and 20 then '11-20'
		 when math_score between 21 and 30 then '21-30'
		 when math_score between 31 and 40 then '31-40'
		 when math_score between 41 and 50 then '41-50'
		 when math_score between 51 and 60 then '51-60'
		 when math_score between 61 and 70 then '61-70'
		 when math_score between 71 and 80 then '71-80'
		 when math_score between 81 and 90 then '81-90'
		 when math_score between 91 and 100 then '91-100'
         end as score_range,
         count(*) as count
from students
group by score_range
order by score_range;