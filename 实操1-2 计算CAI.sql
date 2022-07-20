#代码中需要改变的名词chapter4(原始数据表） group_sorting_new(分组排序表） timedata(两两之差表）CAIdata_new（最终结果表） RMF_new(RMF_new表）
drop table if EXISTS group_sorting_new;
drop table if EXISTS timedata_new;
drop table if EXISTS CAIdata_new;
drop table if EXISTS RMF_new;
create table RMF_new (select customerID customerID,timestampdiff(DAY,MF.date,'2012-12-01') R,mf.M,mf.F from ( select customerID,max(date) date,avg(amount) M,count(customerID) F from group_sorting_new group by customerID) MF);
#算出RMF_new并建立RMF_new表
create table group_sorting_new (select @i:=if(@type=a.customerID,@i+1,1) nu,@type:=a.customerID customerID,a.date,a.amount from group_sorting_new a,(select @i:=0,@type:=null) b order by a.customerID,a.date);
#分组排序并建表group_sorting_new
#select a.nu/b.sumnu weight,a.customerID,a.date,a.amount from group_sorting a left join (select sum(nu) sumnu,customerID from group_sorting group by customerID) b on a.customerID=b.customerID;
#算权重
create
  table timedata_new(select 
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
  (select a.nu/b.sumnu weight,a.nu,a.customerID,a.date,a.amount from group_sorting_new a left join (select sum(nu) sumnu,customerID from group_sorting_new group by customerID) b on a.customerID=b.customerID) t1
left join
  (select a.nu/b.sumnu weight,a.nu,a.customerID,a.date,a.amount from group_sorting_new a left join (select sum(nu) sumnu,customerID from group_sorting_new group by customerID) b on a.customerID=b.customerID) t2
on
  t1.customerID=t2.customerID and t1.nu+1=t2.nu 
left join
  (select max(nu) maxnu ,customerID from group_sorting_new group by customerID) t3
on
  t1.customerID=t3.customerID and t1.nu=t3.maxnu) t4) t5);
#找出所有的两两之差 权重weight和最大值并建立表time
 CREATE TABLE CAIdata_new (select (t.mle-t.wmle)/t.mle CAI,t.*from(select a.*,b.WMLE,b.MLE_maxnu/a.F MLE from RMF_new a join (select
           customerID,
            sum(weight*time) WMLE,
            round(max((unix_timestamp('2012-12-01')-unix_timestamp(date))/86400),0) MLE_maxnu
          from
             timedata_new
          group by
            customerID) b
          on a.customerID=b.customerID) t);
#算出CAI,WMLE,MLE,R,M,F并建立表CAI
