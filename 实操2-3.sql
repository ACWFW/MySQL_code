#50个ID和CAI并排序
CREATE TABLE activeness_analysis(select a.customerID,b.CAI,@nu:=@nu+1 nu from sameid a join cai b on a.customerID=b.customer,(select @nu:=0) t ORDER BY b.CAI);
 