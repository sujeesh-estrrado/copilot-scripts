IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EnrolledStudent_ByIntake]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
 CREATE procedure [dbo].[Proc_EnrolledStudent_ByIntake]  
 @IntakeId bigint  
 as  
 begin  
 select distinct a.total,A.Batch_Id,A.Batch_Code  
  from (  
  
select distinct isnull(count(CPD.Candidate_Id),0) total,   
D.Course_Code,CBD.Batch_Code,cbd.Batch_Id        
  
        
FROM dbo.Tbl_Candidate_Personal_Det CPD        
INNER JOIN dbo.Tbl_Student_Registration SR  ON SR.Candidate_Id=CPD.Candidate_Id        
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=SR.Department_Id        
INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Candidate_Id=CPD.Candidate_Id        
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id        
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id        
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id        
--LEFT JOIN dbo.Tbl_Fee_Entry_Main FE ON FE.Candidate_Id=CPD.Candidate_Id        
        
WHERE  Student_Semester_Current_Status=1  and cbd.Batch_Id=@IntakeId  
and Candidate_DelStatus=0  
  
AND datepart(mm,CPD.RegDate)= datepart(m,getdate()) AND datepart(yyyy,CPD.RegDate)= datepart(yy,getdate())  
  
GROUP BY --CPD.RegDate,CPD.EnrollBy,
D.Course_Code,CBD.Batch_Code,cbd.Batch_Id         
)A  
group by a.total,A.Batch_Id,A.Batch_Code   
end   
    ')
END
