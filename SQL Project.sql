use walmart_sales;

select * from sales;

select distinct time from sales;

-- Adding the time of day column

select time, case 
				when time between "00:00:00" AND "12:00:00" then "Morning"
                when time between "12:01:00" and "16:00:00" then "Afternoon"
                else "Evening"
			end AS time_of_day
from sales;

alter table sales add column time_of_day varchar(30);

update sales
set time_of_day =(
case 
	when time between "00:00:00" AND "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
end
);

-- adding day_name
select date, dayname(date) from sales;
alter table sales add column day_name varchar(15);

update sales
set day_name =dayname(date);

-- Adding month_name
select date, monthname(date) from sales;
alter table sales add column month_name varchar (15);
update sales
set month_name = monthname(date);

-- Unique city
select distinct city from sales;

select distinct city ,branch from sales;

-- Unique product
select distinct `product line` from sales;

-- Common payment method
select distinct payment from sales;

select distinct payment,count(*) from sales
group by Payment;

-- Most selling product
select distinct `Product line`,count(*) from sales
group by `product line`;

-- Total Revenue by month
select distinct month_name from sales;

select month_name as Month, sum(total)as total_revenue
from sales
group by month_name
order by total_revenue;

-- largest COGS
select month_name as month, sum(cogs) as COGS
from sales
group by month_name
order by COGS desc;

-- Product largest revenue

select `product line`, sum(total) as total_revenue
from sales
group by `product line`
order by total_revenue desc;

-- City with largest revenue

select city,sum(total) as  total_revenue
from sales
group by city
order by total_revenue desc;

-- product line with largest VAT

select `product line`,sum(`tax 5%`) as VAT
from sales
group by `product line`
order by VAT;

-- adding case to product line
select
	avg(quantity) as avg_qnty
from sales;
select `product line`, 
case
	when avg(quantity) > 4 then "Good"
	else "Bad"
end as remark
from sales 
group by `product line`;

select avg(total) as avg_product
from sales;

select branch,avg(total)
from sales
group by branch
having avg(total)> 322;

select gender,`product line`,count(*) as count
from sales
group by gender,`product line`
order by gender;

select `product line`,avg(rating) as average_rating
from sales
group by `product line`
order by average_rating desc;

-- what is the most common customer type?
select `customer type`, count(*) as count
from sales
group by `customer type`
order by count desc;

-- which customer type buys the most?
select `customer type`, count(*) as count
from sales
group by `customer type`;

-- what is the gender of most customer?
select gender,count(*) as gender_count
from sales
group by gender
order by gender_count desc;

-- gender distribution per branch
select gender,count(*) as gender_count
from sales
where branch ="A"
group by gender
order by gender_count;

select branch,gender,count(*) as gender_count
from(
	select branch,gender
    from sales
    where branch in ("A","B","C")
)as subquery
group by branch,gender
order by branch,gender_count;

-- which time of the day do customer give most rating?
select time_of_day,round(avg(rating),2) AS AVG_rating
from sales
group by time_of_day
order by avg_rating desc;

-- what time of the day do customer give most rating per branch?
select time_of_day,branch, round(avg(rating),2) as avg_rating
from (
	select branch,time_of_day,rating
    from sales
    where branch in ("A","B","C")
) as subquery
group by branch,time_of_day
order by branch,avg_rating desc;

-- which day of the week has the best average rating'
select day_name,round(avg(rating),2) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- which day of the week has the best average rating per branch?
select day_name,branch,round(avg(rating),2) as avg_rating
from(
	select day_name,branch,Rating
    from sales
    where Branch in ("A","B","C")
) as subquery
group by branch,day_name
order by branch,avg_rating desc;

-- number of sales made in each time of the day per weekday?

select day_name,time_of_day, count(*) as total_sales
from(
	SELECT day_name,time_of_day
    from sales
    where day_name in ("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
)as subquery
group by day_name,time_of_day
order by day_name, Total_sales desc;

select day_name, count(*) as total_sales
from(
	SELECT day_name
    from sales
    where day_name in ("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
)as subquery
group by day_name
order by day_name, Total_sales desc;


-- which customer type brings the most revenue?
select `customer type`,round(sum(total),2) as TotalRevenue
from sales
group by `customer type`
order by TotalRevenue desc;

-- which city has the largest tax percentage/VAT( Value Added Tax)?
select city, round(avg(`tax 5%`),2) as avg_tax_pct
from sales
group by city
order by avg_tax_pct desc;

-- which customer pay the most in VAT?
SELECT 
    `customer type`, ROUND(AVG(`Tax 5%`), 2) AS total_tax
FROM
    sales
GROUP BY `Customer type`
ORDER BY total_tax DESC;