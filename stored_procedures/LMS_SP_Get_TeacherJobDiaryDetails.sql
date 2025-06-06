IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_TeacherJobDiaryDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_TeacherJobDiaryDetails]  --45,''2017/02/21''          
@Date datetime           
AS              
BEGIN       
Declare @Count bigint    
Declare @Temp_Count bigint    
    
    
    
truncate table LMS_TempReview_Tbl    
create table #Temp_Tbl(Id bigint PRIMARY KEY IDENTITY(1,1),Emp_Id bigint,EmpName varchar(250),Est_Time varchar(10),Act_Time varchar(10))           
insert into #Temp_Tbl(Emp_Id,EmpName,Est_Time,Act_Time)    
    
    
select  E.Employee_Id,E.Employee_FName+'' ''+E.Employee_LName as Employee_Name,'''' as Est_Time,'''' as  Act_Time from Tbl_Employee E        
where E.Employee_Status=0     
    
set @Count=1    
set @Temp_Count=(select count(Id) from #Temp_Tbl)      
while(@Count<=@Temp_Count)     
begin    
if exists(select User_Id from LMS_Tbl_JobDiary where Date=@Date and User_Id=(select Emp_Id from #Temp_Tbl where Id=@Count))    
update #Temp_Tbl set Est_Time=''9'',Act_Time=''5'' where Id=@Count    
else    
update #Temp_Tbl set Est_Time=''Not Filled'',Act_Time=''Not Filled'' where Id=@Count    
    
insert into LMS_TempReview_Tbl(Candidate_Id,CandidateName,Est_Time,Act_Time)    
select Emp_Id,EmpName,Est_Time,Act_Time from #Temp_Tbl where Id=@Count    
set @Count=@Count+1     
end    
    
select * from LMS_TempReview_Tbl    
END
    ')
END
