SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    first_12m;#去掉重复的数据

CREATE table
  fisrt_distinct (SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    first_12m);
		
	show tables;
	
 
		
SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    mid_6m;
	
SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    end_6m;

		
	SELECT 
	  customerID,count(customerID) F1
	from first_distinct
	group by
	  customerID;#找出去重后的F1
		
	SELECT 
	  t2.customerID,count(t2.customerID) F2
	from (SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    mid_6m) t2
	group by
	  t2.customerID;#F2
	
	SELECT 
	  t3.customerID,count(t3.customerID) F3
	from (SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    end_6m) t3
	group by
	  t3.customerID;#F3
		
select a.customerID,a.f1,b.f2,c.f3
from (SELECT 
	  customerID,count(customerID) F1
	from first_distinct
	group by
	  customerID) a
join
  (SELECT 
	  t2.customerID,count(t2.customerID) F2
	from (SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    mid_6m) t2
	group by
	  t2.customerID) b
on
  a.customerID=b.customerID
join 
  (SELECT 
	  t3.customerID,count(t3.customerID) F3
	from (SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    end_6m) t3
	group by
	  t3.customerID) c
on
  a.customerID=c.customerID
where
  a.F1>=5 and b.F2>=5 and c.F3>=5;#共同ID

create table 
  sameID(select a.customerID,a.f1,b.f2,c.f3
from (SELECT 
	  customerID,count(customerID) F1
	from first_distinct
	group by
	  customerID) a
join
  (SELECT 
	  t2.customerID,count(t2.customerID) F2
	from (SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    mid_6m) t2
	group by
	  t2.customerID) b
on
  a.customerID=b.customerID
join 
  (SELECT 
	  t3.customerID,count(t3.customerID) F3
	from (SELECT DISTINCT
    date,
		customerID,
		sumsame
	from	
    end_6m) t3
	group by
	  t3.customerID) c
on
  a.customerID=c.customerID
where
  a.F1>=5 and b.F2>=5 and c.F3>=5);
	


 
 desc first_distinct;
 select * from first_distinct limit 100;
	
	show variables like '%sql_mode';
		
	
	
    
