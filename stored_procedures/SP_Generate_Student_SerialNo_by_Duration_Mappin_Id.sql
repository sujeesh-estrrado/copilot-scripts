IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Generate_Student_SerialNo_by_Duration_Mappin_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Generate_Student_SerialNo_by_Duration_Mappin_Id]        
@Duration_Mapping_Id bigint          
AS          
BEGIN         
  Select       
  S.Candidate_Id,        
  S.Student_Semester_Id,          
  S.Candidate_Id,          
  S.Duration_Mapping_Id,          
  Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname As [CandidateName],      
  ISNULL(CASE WHEN (Student_Serial_No='''') THEN (''STUD''+CAST(S.Candidate_Id AS varchar(100))) ELSE Student_Serial_No END,(''STUD''+CAST(S.Candidate_Id AS varchar(100)))) AS Student_Serial_No      
  From Tbl_Student_Semester S          
  Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id=C.Candidate_Id          
  left Join Tbl_Student_Registration R On S.Candidate_Id=R.Candidate_Id          
  Where  S.Duration_Mapping_Id=@Duration_Mapping_Id and Student_Semester_Delete_Status=0 and Student_Semester_Current_Status=1 and Candidate_DelStatus=0       
  Order By CandidateName        
END
    ')
END
