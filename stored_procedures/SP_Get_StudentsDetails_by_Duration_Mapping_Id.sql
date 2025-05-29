IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_StudentsDetails_by_Duration_Mapping_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE PROCEDURE [dbo].[SP_Get_StudentsDetails_by_Duration_Mapping_Id] -- 7       
@Duration_Mapping_Id BIGINT            
            
AS            
BEGIN       
           
  SELECT DISTINCT (S.Candidate_Id), S.Student_Semester_Id, S.Candidate_Id, S.Duration_Mapping_Id,
  CONCAT(C.Candidate_Fname, '' '', C.Candidate_Lname) AS CandidateName, 
  C.Candidate_Fname
  FROM dbo.Tbl_Student_Semester AS S 
  INNER JOIN dbo.Tbl_Candidate_Personal_Det AS C 
      ON S.Candidate_Id = C.Candidate_Id
  WHERE S.Duration_Mapping_Id = @Duration_Mapping_Id 
    AND Student_Semester_Current_Status = 1  
    AND Student_Semester_Delete_Status = 0   
    AND Candidate_DelStatus = 0           
END
    ')
END;
