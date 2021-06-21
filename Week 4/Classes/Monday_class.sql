-- Prepare bank data to prcess in Python

select l.status, date_format(convert(t.date, date),'%M-%Y') as m_y,
count(distinct t.account_id) as nrofaccounts,
count(distinct t.trans_id) as nroftrans,
ceiling(sum(t.amount)) as movedamount
from trans t
join disp d using(account_id)
join loan l using(account_id)
where d.type = 'OWNER'
group by status, m_y;