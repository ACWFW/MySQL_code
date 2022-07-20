#换表new_table 换入参的值
drop PROCEDURE if exists new_chapter4;
delimiter $
CREATE PROCEDURE new_chapter4(in a int,in cid int)
begin
	DECLARE id int DEFAULT(1);
	REPEAT
	insert into new_table(nu,customerID,Date,amount,id) SELECT t.nu,t.customerID,t.Date,t.amount,id from (SELECT customerID,Date,amount,ROW_NUMBER()over(PARTITION by customerID ORDER BY Date) nu from chapter4 where customerID=cid) t where t.nu <=id;
		set id=id+1;
UNTIL id>a END REPEAT; 
end $#用存储和窗口函数实现循环插入想要的值
call new_chapter4(85,89)$
delimiter;
select *from new_table;#输入到新的表中





#代码中需要改变的名词group_sorting_new1314(原始数据表） group_sorting_new1314(分组排序表） timedata_new1314(两两之差表）CAIdata_new1314（最终结果表） RMF_new1314(RMF_new1314表）
drop table if EXISTS timedata_new1314;
drop table if EXISTS CAIdata_new1314;
drop table if EXISTS RMF_new1314;
create table RMF_new1314 (select customerID customerID,timestampdiff(DAY,MF.date,'2012-12-01') R,mf.M,mf.F from ( select customerID,max(date) date,avg(amount) M,count(customerID) F from group_sorting_new1314 group by customerID) MF);
#算出RMF_new1314并建立RMF_new1314表
create
  table timedata_new1314(select 
  t5.weight,t5.nu,t5.customerID,t5.date,t5.amount,t5.maxnu,
  round(if(maxnu=0,time,(unix_timestamp('2012-12-01')-unix_timestamp(date))/86400),0) time
from 
  (select 
  if(t4.maxnu=0,t4.time,timestampdiff(DAY,t4.date,2012-12-01)) time,
  t4.weight,t4.nu,t4.customerID,t4.date,t4.amount,t4.maxnu
from
  (select
  t1.*,
  ifnull(timestampdiff(DAY,t1.date,t2.date),0) time,
  ifnull(t3.maxnu,0) maxnu
from
  (select a.nu/b.sumnu weight,a.nu,a.customerID,a.date,a.amount from group_sorting_new1314 a left join (select sum(nu) sumnu,customerID from group_sorting_new1314 group by customerID) b on a.customerID=b.customerID) t1
left join
  (select a.nu/b.sumnu weight,a.nu,a.customerID,a.date,a.amount from group_sorting_new1314 a left join (select sum(nu) sumnu,customerID from group_sorting_new1314 group by customerID) b on a.customerID=b.customerID) t2
on
  t1.customerID=t2.customerID and t1.nu+1=t2.nu 
left join
  (select max(nu) maxnu ,customerID from group_sorting_new1314 group by customerID) t3
on
  t1.customerID=t3.customerID and t1.nu=t3.maxnu) t4) t5);
#找出所有的两两之差 权重weight和最大值并建立表time
 CREATE TABLE CAIdata_new1314 (select (t.mle-t.wmle)/t.mle CAI,t.*from(select a.*,b.WMLE,b.MLE_maxnu/a.F MLE from RMF_new1314 a join (select
           customerID,
            sum(weight*time) WMLE,
            round(max((unix_timestamp('2012-12-01')-unix_timestamp(date))/86400),0) MLE_maxnu
          from
             timedata_new1314
          group by
            customerID) b
          on a.customerID=b.customerID) t);
#算出CAI,WMLE,MLE,R,M,F并建立表CAI