IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Student_AttendancePercentage_By_DurationMappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_Student_AttendancePercentage_By_DurationMappingId] --216,''2016/01/25'',''2017/01/18''     
                        
@Duration_Mapping_Id bigint,                              
@FromDate Datetime,                                        
@ToDate Datetime                              
As                              
BEGIN       
Declare @TotalDays decimal(18,2)                              
--Set @TotalDays=(Select(DATEDIFF(DD,@FromDate,@ToDate)+1))  
 Set @TotalDays=
    (SELECT Datediff(dd, @FromDate, @ToDate)
      + CASE WHEN Datepart(dw, @FromDate) = 7 THEN 0 ELSE 0 END
       - (Datediff(wk, @FromDate, @ToDate) * 1 )
       - CASE WHEN Datepart(dw, @FromDate) = 1 THEN 1 ELSE 0 END +
       - CASE




 WHEN Datepart(dw, @ToDate) = 1 THEN 1 ELSE 0
       END )
      - (select count(Student_Holiday_FromDate) from dbo.Tbl_Student_Holidays where
        Student_Holiday_FromDate>=@FromDate and Student_Holiday_FromDate<=@Todate)
    if((Datepart(dw, @FromDate) != 1 and  Datepart(dw, @ToDate) =1) or((Datepart(dw, @FromDate) = 1 and  Datepart(dw, @ToDate) =1)))
        begin
    set @TotalDays=@TotalDays+2
        end
else if((Datepart(dw, @FromDate) = 1 and  Datepart(dw, @ToDate) !=1) or (Datepart(dw, @FromDate) != 1 and  Datepart(dw, @ToDate) !=1))
begin
set @TotalDays=@TotalDays+1
end      
                            
 declare @Tot_Working_days decimal(18,2)                             
declare @Count bigint                  
declare @Temp_Count bigint                  
declare @Date datetime                  
declare @DayCount float              
declare @tableDateCount float           
declare @DateCount float         
declare @AbsentDayCount float                  
declare @Absentdays float                  
declare @Candidate_Id bigint                
            
--drop table #Tbl    
                
              
create table #Tbl(Id bigint PRIMARY KEY IDENTITY(1,1),Candidate_Id bigint,Student_Name varchar(500),TotalDays float,WorkingDays varchar(1000),AttendPerc float,TypeOfStudent varchar(50),AdharNumber varchar(50) )                    
insert #Tbl(Candidate_Id,Student_Name,TotalDays,WorkingDays,AttendPerc,TypeOfStudent,AdharNumber)                
Select                               
Distinct SS.Candidate_Id,                              
Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname as Student_Name,  @TotalDays as TotalDays,                             
'''' as WorkingDays,                             
0 as AttendPerc,TypeOfStudent,AdharNumber                             
From                           
Tbl_Student_Semester SS  INNER JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=SS.Candidate_Id                          
LEFT JOIN Tbl_Student_Absence SA                              
ON SA.Candidate_Id=SS.Candidate_Id                              
Where SS.Duration_Mapping_Id=@Duration_Mapping_Id  and Student_Semester_Current_Status=1 and SA.Absent_Date >=@FromDate                
and SA.Absent_Date <=@ToDate                
                
                
                 
    create table #TempTbl(Id bigint PRIMARY KEY IDENTITY(1,1),Candidate_Id bigint)                  
insert #TempTbl(Candidate_Id)                  
select Candidate_Id from Tbl_Student_Absence where Absent_Date between @FromDate and @ToDate and Duration_Mapping_Id=@Duration_Mapping_Id                 
and (Absent_Type=''Both'' or Absent_Type=''absent'' )                  
group by Candidate_Id         
        
    create table #DateTbl(Id bigint PRIMARY KEY IDENTITY(1,1),Date datetime)                
insert #DateTbl(Date)                
select Absent_Date from Tbl_Student_Absence where Absent_Date between @FromDate and @ToDate and Duration_Mapping_Id=@Duration_Mapping_Id               
and (Absent_Type=''Both'' or Absent_Type=''absent'' )                
group by Absent_Date          
                  
                  
set @Count=1                        
set @Temp_Count=(select count(Id) from #TempTbl)  
while(@Count<=@Temp_Count)                        
Begin        
set @Absentdays=0                  
                 
set @Candidate_Id=(select Candidate_Id from #TempTbl where Id=@Count)                
        
set @DateCount=1        
set @tableDateCount=(select count(Id) from #DateTbl)        
while(@DateCount<=@tableDateCount)                        
Begin         
 set @Date=(select Date from #DateTbl where Id=@DateCount)                 
          
set @DayCount=(select count(Absent_Id) from Tbl_Student_Absence where Candidate_Id=@Candidate_Id and  Duration_Mapping_Id=@Duration_Mapping_Id                
and Absent_Date=@Date and (Absent_Type=''absent'' or Absent_Type=''Both''))                
                
--print @Candidate_Id                
--print @DayCount                
--print @TotalDays                
if(@DayCount>=1)                  
set @AbsentDayCount=1                  
--else if(@DayCount=1)                  
--set @AbsentDayCount=0.5                  
else --if(@DayCount=0)                  
set @AbsentDayCount=0         
--set @Tot_Working_days= @TotalDays-@AbsentDayCount                
--print @Tot_Working_days                
set @Absentdays=@Absentdays+@AbsentDayCount                  
--  update #Tbl set WorkingDays=@TotalDays-@PresentDayCount,AttendPerc=Round(((@TotalDays-@PresentDayCount)/@TotalDays)*100,2)                
--where Candidate_Id=@Candidate_Id --and Id=@Count                
    set @DateCount=@DateCount+1                   
        
                
end         
        
      update #Tbl set WorkingDays=dbo.udf_Num_ToWords(floor(@TotalDays-@Absentdays),@TotalDays-@Absentdays),AttendPerc=Round(((@TotalDays-@Absentdays)/@TotalDays)*100,2)                
where Candidate_Id=@Candidate_Id          
--select * from #Tbl  where Candidate_Id=361                
                
set @Count=@Count+1                   
                
                
end                  
 select * from #Tbl                 
               
--select Candidate_Id,Student_Name,(dbo.udf_Num_ToWords(floor(TotalDays),TotalDays)) as TotalDays,WorkingDays,AttendPerc from #Tbl                 
                
                
                
--Select                               
--Distinct SS.Candidate_Id,                              
--Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname as Student_Name,  @TotalDays as TotalDays,                             
--@TotalDays-(                              
--(Select Count(Absent_Id) From Tbl_Student_Absence Where Absent_Date between @FromDate and @ToDate and Candidate_Id=SA.Candidate_Id and Absent_Type=''Both'' )+                              
--(SELECT Cast((Select Count(Absent_Id) From Tbl_Student_Absence Where Absent_Date between @FromDate and @ToDate and Candidate_Id=SA.Candidate_Id and Absent_Type<>''Both'')As Float)/ CAST(2 AS float)))                            
--As WorkingDays,                             
-- ROUND(((@TotalDays-(                              
--(Select Count(Absent_Id) From Tbl_Student_Absence Where Absent_Date between @FromDate and @ToDate and Candidate_Id=SA.Candidate_Id and Absent_Type=''Both'' )+                              
--(SELECT Cast((Select Count(Absent_Id) From Tbl_Student_Absence Where Absent_Date between @FromDate and @ToDate and Candidate_Id=SA.Candidate_Id and Absent_Type<>''Both'')As Float)/ CAST(2 AS float))))/@TotalDays)*100,2) As AttendPerc                     










   
    
      
        
--From                           
--Tbl_Student_Semester SS  INNER JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=SS.Candidate_Id                          
--LEFT JOIN Tbl_Student_Absence SA                              
--ON SA.Candidate_Id=SS.Candidate_Id                              
--Where SS.Duration_Mapping_Id=@Duration_Mapping_Id  and Student_Semester_Current_Status=1                         
END 
    ');
END;
