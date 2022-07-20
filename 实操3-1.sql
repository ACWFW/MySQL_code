create table f_cai select a.*,b.CAI from sameid a join caidata_first b on b.customerID=a.customerID order by CAI;
#建立有CAI和每个阶段F值的表