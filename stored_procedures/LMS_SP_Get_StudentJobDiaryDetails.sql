IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_StudentJobDiaryDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_StudentJobDiaryDetails] -- 43,''2017/03/01''        
@Duration_Mapping_Id bigint  ,  
@Date datetime         
AS            
BEGIN     
Declare @Count bigint  
Declare @Temp_Count bigint  
  
  
  
truncate table LMS_TempReview_Tbl  
create table #Temp_Tbl(Id bigint PRIMARY KEY IDENTITY(1,1),Candidate_Id bigint,CandidateName varchar(250),Est_Time varchar(10),Act_Time varchar(10))         
insert into #Temp_Tbl(Candidate_Id,CandidateName,Est_Time,Act_Time)  
  
  
select  cpd.Candidate_Id,                                                       
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,'''' as Est_Time,'''' as  Act_Time from    
Tbl_Candidate_Personal_Det cpd      
inner join  Tbl_Student_Semester S on cpd.Candidate_Id=S.Candidate_Id    
where S.Student_Semester_Current_Status=1 and  S.Duration_Mapping_Id=@Duration_Mapping_Id   and cpd.Candidate_DelStatus=0  
  
set @Count=1  
set @Temp_Count=(select count(Id) from #Temp_Tbl)    
while(@Count<=@Temp_Count)   
begin  
if exists(select User_Id from LMS_Tbl_JobDiary where Date=@Date and User_Id=(select Candidate_Id from #Temp_Tbl where Id=@Count))  
update #Temp_Tbl set Est_Time=''9'',Act_Time=''5'' where Id=@Count  
else  
update #Temp_Tbl set Est_Time='''',Act_Time='''' where Id=@Count  
  
insert into LMS_TempReview_Tbl(Candidate_Id,CandidateName,Est_Time,Act_Time)  
select Candidate_Id,CandidateName,Est_Time,Act_Time from #Temp_Tbl where Id=@Count  
set @Count=@Count+1   
end  
  
select * from LMS_TempReview_Tbl  
END
    ')
END
