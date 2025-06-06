IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Total_StudentBy_Batch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      
  
  CREATE procedure [dbo].[Total_StudentBy_Batch] --1     
  @Duration_Mapping_Id bigint    
  as    
  begin    
      
  --declare @total bigint    
  --declare @active bigint  
  --set @total=  
  (select  isnull(COUNT(cpd.Candidate_Id),0) as total  FROM dbo.Tbl_Student_Semester SS         
INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id    
inner join Tbl_Student_Registration SR on SR.Candidate_Id=SS.Candidate_Id     
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id             
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                 
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id               
where  cdm.Duration_Mapping_Id=@Duration_Mapping_Id and  Candidate_DelStatus=0   
and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1)   
  
--   set @active=(select  isnull(COUNT(cpd.Candidate_Id),0) as total  FROM dbo.Tbl_Student_Semester SS         
--INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id    
--inner join Tbl_Student_Registration SR on SR.Candidate_Id=SS.Candidate_Id     
--INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id             
--INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                
--INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                 
--INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id               
--where  cdm.Duration_Mapping_Id=1  and Candidate_DelStatus=0  
--and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1)   
    
end 
    ')
END;
GO
