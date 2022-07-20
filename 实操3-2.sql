
select a.customerID,a.date from mid_6m a JOIN sameid b on a.customerID=b.customerID;#找出中6个月的相同ID
 select DISTINCT t.customerID,t.nu,t.time,t.date from (select a2.*,b2.time,b2.nu from (select a.customerID,a.date from mid_6m a JOIN sameid b on a.customerID=b.customerID) a2 left join timedata_first b2 on a2.customerID=b2.customerID and a2.date=b2.date ) t  where customerID=9051 or customerID=19483 or customerID=12967 ORDER BY t.customerID asc,t.nu asc;
#选出两两时间的差和和对应的排序
drop table if EXISTS three_customer_mid;
CREATE table three_customer_mid (SELECT a3.CAI,b3.* from caidata_mid a3 join (select DISTINCT t.customerID,t.nu,t.time,t.date from (select a2.*,b2.time,b2.nu from (select a.customerID,a.date from mid_6m a JOIN sameid b on a.customerID=b.customerID) a2 left join timedata_first b2 on a2.customerID=b2.customerID and a2.date=b2.date ) t  where customerID=9051 or customerID=19483 or customerID=12967 ORDER BY t.customerID asc,t.nu asc) b3 on a3.customerID=b3.customerID);
#建表three_customer_mid