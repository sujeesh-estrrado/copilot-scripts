IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DropVsDefer]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Proc_DropVsDefer]   
@Duration_Mapping_Id bigint               
AS                
BEGIN   
  
    
  
SELECT      
''Drop'' As [User],      
 (select  COUNT(cpd.Candidate_Id)  FROM dbo.Tbl_Student_Semester SS       
INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id  
inner join Tbl_Student_Registration SR on SR.Candidate_Id=SS.Candidate_Id   
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id           
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id              
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id               
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id             
where  cdm.Duration_Mapping_Id=@Duration_Mapping_Id and Tc_Status=2  
and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1   ) as [Value]  
  
      
UNION      
SELECT       
''Defer'' As [User],      
 (select  COUNT(cpd.Candidate_Id)  FROM dbo.Tbl_Student_Semester SS       
INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id  
inner join Tbl_Student_Registration SR on SR.Candidate_Id=SS.Candidate_Id   
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id           
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id              
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id               
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id             
where  cdm.Duration_Mapping_Id=@Duration_Mapping_Id and Tc_Status=3  
and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1   ) as [Value]  
  
--UNION  
  
--SELECT       
--''Total'' As [User],      
-- (select  COUNT(cpd.Candidate_Id)  FROM dbo.Tbl_Student_Semester SS       
--INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id  
--inner join Tbl_Student_Registration SR on SR.Candidate_Id=SS.Candidate_Id   
--INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id           
--INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id              
--INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id               
--INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id             
--where  cdm.Duration_Mapping_Id=@Duration_Mapping_Id  
--and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1   ) --as [Value]  
  
--create table #temp (dropp bigint,defer bigint,total bigint)  
--insert into #temp (dropp,defer,total) values(@drop,@defer,@total)  
--select * from #temp  
      
END   
    ')
END
