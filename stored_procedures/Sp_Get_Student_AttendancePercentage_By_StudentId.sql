IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Student_AttendancePercentage_By_StudentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_Student_AttendancePercentage_By_StudentId] --93,''2017/10/25'',''2017/11/01''                   
@Candidate_Id bigint,                    
@FromDate Datetime,                              
@ToDate Datetime                    
As                    
BEGIN                        
Declare @TotalDays float                    
declare @Count bigint                
declare @Temp_Count bigint                
declare @Date datetime                
declare @DayCount float                
declare @AbsentDayCount float                
declare @Absentdays float                
set @Absentdays=0                
                
       Set @TotalDays=
    (SELECT Datediff(dd, @FromDate, @ToDate)
      + CASE WHEN Datepart(dw, @FromDate) = 7 THEN 0 ELSE 0 END
       - (Datediff(wk, @FromDate, @ToDate) * 1 )
       - CASE WHEN Datepart(dw, @FromDate) = 1 THEN 1 ELSE 0 END +
       


- CASE WHEN Datepart(dw, @ToDate) = 1 THEN 1 ELSE 0
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
--Set @TotalDays=(Select(DATEDIFF(DD,@FromDate,@ToDate)+1))   

                 
    create table #TempTbl(Id bigint PRIMARY KEY IDENTITY(1,1),Date datetime)                
insert #TempTbl(Date)                
select Absent_Date from Tbl_Student_Absence where Absent_Date between @FromDate and @ToDate and         
Candidate_Id=@Candidate_Id and (Absent_Type=''Both'' or Absent_Type=''absent'')                
group by Absent_Date                 
                
set @Count=1                      
set @Temp_Count=(select count(Id) from #TempTbl)                
while(@Count<=@Temp_Count)                      
Begin                   
set @Date=(select Date from #TempTbl where Id=@Count)                
set @DayCount=(select count(Absent_Id) from Tbl_Student_Absence where Candidate_Id=@Candidate_Id and                 
Absent_Date=@Date and (Absent_Type=''absent'' or Absent_Type=''Both''))                
if(@DayCount>=1)                
set @AbsentDayCount=1                
--else if(@DayCount=1)                
--set @AbsentDayCount=0.5                
else --if(@DayCount=0)                
set @AbsentDayCount=0          
                
set @Absentdays=@Absentdays+@AbsentDayCount                
                
set @Count=@Count+1                 
end                
--select * from #TempTbl                
--select @TotalDays-@PresentDayCount as NoofWrkingDays                
      --select @Absentdays       
      -- select @AbsentDayCount         
                
Select                     
Distinct SS.Candidate_Id,C.AdharNumber ,                   
Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname as Student_Name,                     
dbo.udf_Num_ToWords(floor(@TotalDays-@Absentdays),@TotalDays-@Absentdays) As WorkingDays,@TotalDays as TotalDays,TypeOfStudent,                   
 ROUND(((@TotalDays-@Absentdays)                   
/@TotalDays)*100,2) As AttendPerc                    
FROM Tbl_Student_Semester SS        
INNER JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=SS.Candidate_Id                  
LEFT JOIN Tbl_Student_Absence SA                      
ON SA.Candidate_Id=SS.Candidate_Id                      
Where SS.Candidate_Id=@Candidate_Id  and Student_Semester_Current_Status=1                  
                
                
END 
    ');
END;
