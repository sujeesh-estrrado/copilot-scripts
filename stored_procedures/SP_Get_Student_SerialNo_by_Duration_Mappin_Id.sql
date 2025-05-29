IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_SerialNo_by_Duration_Mappin_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
 create procedure [dbo].[SP_Get_Student_SerialNo_by_Duration_Mappin_Id]         
@Duration_Mapping_Id bigint          
AS          
BEGIN         
  SELECT       
      S.Candidate_Id,        
      S.Student_Semester_Id,          
      S.Candidate_Id,          
      S.Duration_Mapping_Id,          
      Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname AS [CandidateName],      
      Student_Serial_No        
  FROM Tbl_Student_Semester S          
  INNER JOIN Tbl_Candidate_Personal_Det C ON S.Candidate_Id = C.Candidate_Id          
  LEFT JOIN Tbl_Student_Registration R ON S.Candidate_Id = R.Candidate_Id          
  WHERE S.Duration_Mapping_Id = @Duration_Mapping_Id 
    AND Student_Semester_Delete_Status = 0 
    AND Student_Semester_Current_Status = 1 
    AND Candidate_DelStatus = 0      
  ORDER BY CandidateName        
END
    ')
END;
