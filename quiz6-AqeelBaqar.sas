*Quiz 6 Aqeel Baqar
7863564*;

libname ex '/folders/myshortcuts/MYFOLDERS/Large database/epi5143 work folder/data';
libname classdat '/folders/myshortcuts/MYFOLDERS/Large database/class data';*needed to set two libraries. One for ex and then one for where the classdat was*;

*Q1*;
data ex.nencounter;
set classdat.nencounter;
if year(datepart(EncStartDtm)) in:(2003); *encounters that happened starting in 2003*;
keep EncStartDtm EncWID EncPatWID EncVisitTypeCd;
run;

*now we sort the data by patient enc id*;
proc sort data= ex.nencounter;
by EncPatWID;
run;

*now we need to flat-file by inpatient encounter*;
data ex.nencounter1;
set ex.nencounter;
by EncPatWID;
if first.EncPatWID=1 then do;
inpatient=0;*if we have inpatient encounter, the value takes 0*;
emerg=1; *if there is emerg encounter, it takes value of 1*;
enc=0;*if there is inpatient or emerg visit, it takes value of 1*;
count=0; *this gives us the number of encounters*;
end;
if first.EncPatWID=1 then do;
emerg=0;
count=0;
end;
if EncVisitTypeCd= 'INPT' then do;
inpatient=1; *gives 1 if there is an in patient encounter*;
end;
if EncVisitTypeCd= 'EMERG' then do;
emerg=1;
end;
if EncVisitTypeCd in: ('INPT' 'EMERG') then do; *if they had either inpt or emerg enc*;
enc=1;
count=count+1;
end;
if last.EncPatWID then output;
retain inpatient emerg enc count;
run;

proc freq data=ex.nencounter1;
table inpatient emerg enc count;
options formchar="|----|+|---+=|-/\<>*"; *printing nice frequency tables*;
run;

*1a) the number of patients that had at least 1 in patient encounter that started in 2003 was 
1074*;
*inpatient	Frequency	Percent	Cumulative
Frequency	Cumulative
Percent
0	1817	62.85	1817	62.85
1	1074	37.15	2891	100.00
*;

*1b) the number of patients that had at least 1 EMERG encounter that started in 2003 was 
1978
*;

*emerg	Frequency	Percent	Cumulative
Frequency	Cumulative
Percent
0	913	31.58	913	31.58
1	1978	68.42	2891	100.00
*;

*1c) the number of patients that had either INPT or EMERG encounter that started in 2003 was 
2891*;

*enc	Frequency	Percent	Cumulative
Frequency	Cumulative
Percent
1	2891	100.00	2891	100.00
*;

1d) In patients from c) who had at least 1 visit of either type, create a variable that counts the total number encounters (of either type)-for example, a patient with one inpatient encounter and one emergency room encounter would have a total encounter count of 

/*
count	Frequency	Percent	Cumulative
Frequency	Cumulative
Percent
1	2556	88.41	2556	88.41
2	270	9.34	2826	97.75
3	45	1.56	2871	99.31
4	14	0.48	2885	99.79
5	3	0.10	2888	99.90
6	1	0.03	2889	99.93
7	1	0.03	2890	99.97
12	1	0.03	2891	100.00
*;
