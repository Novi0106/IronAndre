# bad customers, no of trans, amount moved, by month and year

select status, date_format(convert(t.date,date),'%M-%Y') as monthandyear,
count(distinct t.account_id) as noofaccounts,
count(distinct t.trans_id) as nooftrans,
ceiling(sum(t.amount)) as movedamount 
from trans t
join disp d using (account_id) 
join loan l using (account_id) 
where d.type = 'OWNER'
group by status, date_format(convert(t.date,date),'%M-%Y');

-- export to tableau for visualisation

# month on month comparison, unique accounts making trans 
# view - for each trans, account, date 
create or replace view user_activity as 
select account_id,
date_format(convert(date,date), '%m') as activitymonth, 
date_format(convert(date,date), '%Y') as activityyear, 
date_format(convert(date,date), '%m-%Y') as activitymonthyear 
from trans;

# view - year month unique account_id 

create or replace view monthly_active_users
 as 
 Select activitymonth, activityyear, activitymonthyear , count(distinct account_id) as active_users
 from user_activity 
 group by activitymonth, activityyear, activitymonthyear 
 order by activityyear, activitymonth;
 
 
 # apply the lag function for MOM comparison
 # active_users table and create a new column with the prev month 
 
 create or replace view monthonmont_users as 
 select *, lag(active_users,1) over() as prev_month
 from monthly_active_users;
 
 # %difference 
 select *, round((active_users-prev_month)/active_users *100,2) as perchange 
 FROM monthonmont_users
 where prev_month is not null ;
 
 -- export to tableau for visualisation
 
 
 # approach 3 - month on month sticky accounts
 
 create or replace view retained_customers_view as
with distinct_users as (
  select distinct account_id , activitymonthyear, activityyear 
  from user_activity
)
select d1.activitymonthyear, d1.activityyear,
count(distinct d1.account_id) as Retained_customers
from distinct_users d1
left join distinct_users d2 on d1.account_id = d2.account_id
and d1.activitymonthyear = d2.activitymonthyear + 1
group by d1.activitymonthyear, d1.activityyear
order by d1.activityyear, d1.activitymonthyear;

# building upon the above view, to find the month on month comparison, using LAG:
select*, 
lag(Retained_customers, 1) over(order by activityyear,activitymonthyear) as Last_month_retained_customers,
(Retained_customers-lag(Retained_customers, 1) over(order by activityyear,activitymonthyear)) as Diff
from bank.retained_customers_view;

-- export to tableau for visualisation




 

