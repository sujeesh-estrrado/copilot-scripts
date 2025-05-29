IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_RegNo_by_Duration_Mappin_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
 create procedure [dbo].[SP_Get_Student_RegNo_by_Duration_Mappin_Id]    
@Duration_Mapping_Id bigint      
AS      
BEGIN     
  Select        
  R.University_RegnoId,    
  S.Candidate_Id,    
  R.University_Regno,    
  S.Student_Semester_Id,      
  S.Candidate_Id,      
  S.Duration_Mapping_Id,      
  Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname As [CandidateName]      
  From Tbl_Student_Semester S      
  Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id=C.Candidate_Id      
  left Join Tbl_Candidate_University_Regno R On S.Candidate_Id=R.Candidate_Id      
  Where  S.Duration_Mapping_Id=@Duration_Mapping_Id and Student_Semester_Delete_Status=0  and Student_Semester_Current_Status  =1 and Candidate_DelStatus=0  
  Order By CandidateName    
END
    ')
END;
