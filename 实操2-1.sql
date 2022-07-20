
select a.customerID,a.date from first_12m a JOIN sameid b on a.customerID=b.customerID;#找出前12月的相同ID
select DISTINCT t.customerID,t.nu,t.time,t.date from (select a2.*,b2.time,b2.nu from (select a.customerID,a.date from first_12m a JOIN sameid b on a.customerID=b.customerID) a2 left join timedata_first b2 on a2.customerID=b2.customerID and a2.date=b2.date ) t ORDER BY t.customerID asc,t.nu asc;
#选出两两时间的差和和对应的排序
SELECT CAI,customerID from caidata_first ORDER BY rand() limit 3;
#随机选三个customerID且有CAI
drop table if EXISTS Three_customer;
CREATE table Three_customer (select b3.*,a3.time,a3.nu,a3.date from (select DISTINCT t.customerID,t.nu,t.time,t.date from (select a2.*,b2.time,b2.nu from (select a.customerID,a.date from first_12m a JOIN sameid b on a.customerID=b.customerID) a2 left join timedata_first b2 on a2.customerID=b2.customerID and a2.date=b2.date ) t ORDER BY t.customerID asc,t.nu asc) a3 join (SELECT CAI,customerID from caidata_first ORDER BY rand() limit 3) b3 on a3.customerID=b3.customerID);
#随机选三个顾客并给出每次的间隔时间并建表Three_customer