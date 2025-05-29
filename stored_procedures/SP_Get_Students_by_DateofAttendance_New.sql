IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Students_by_DateofAttendance_New]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Get_Students_by_DateofAttendance_New]                
@Duration_Mapping_Id bigint,                    
@DateofAttendance varchar(30)                    
AS                    
BEGIN            
  Select                     
  IsNull(R.RollNumber,ROW_NUMBER() OVER(ORDER BY S.Candidate_Id))  AS RollNo,                    
  S.Student_Semester_Id,                    
  S.Candidate_Id,                    
  S.Duration_Mapping_Id,               
  Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname As [CandidateName],          
 ISNULL(
    (Select 
        IsAbsent = case Absent_Type 
                    when ''Both'' then 1 
                    when ''FN'' then 2 
                    when ''AN'' then 3 
                    else 0 
                END 
    From Tbl_Student_Absence 
    Where Duration_Mapping_Id = @Duration_Mapping_Id
    and Absent_Date = @DateofAttendance 
    and Candidate_Id = S.Candidate_Id), 0) AS IsAbsent,      
    
  ISNULL(
    (Select 1 
    From Tbl_Student_Absence 
    Where Duration_Mapping_Id = @Duration_Mapping_Id        
    and Absent_Date = @DateofAttendance 
    and Candidate_Id = S.Candidate_Id 
    and Absent_Type = ''Both''), 0) AS Absent,  
    
  ISNULL(
    (Select 1 
    From Tbl_Student_Absence 
    Where Duration_Mapping_Id = @Duration_Mapping_Id        
    and Absent_Date = @DateofAttendance 
    and Candidate_Id = S.Candidate_Id 
    and Absent_Type = ''FN''), 0) AS FN,     
  
  ISNULL(
    (Select 1 
    From Tbl_Student_Absence 
    Where Duration_Mapping_Id = @Duration_Mapping_Id        
    and Absent_Date = @DateofAttendance 
    and Candidate_Id = S.Candidate_Id 
    and Absent_Type = ''AN''), 0) AS AN            
  
  From Tbl_Student_Semester S                    
  Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id = C.Candidate_Id                    
  left Join Tbl_Candidate_RollNumber R On S.Candidate_Id = R.Candidate_Id 
    and S.Duration_Mapping_Id = R.Duration_Mapping_Id                
                     
  Where  S.Duration_Mapping_Id = @Duration_Mapping_Id 
    and Student_Semester_Delete_Status = 0          
    and Student_Semester_Current_Status = 1           
  Order By RollNo                  
END
    ')
END;
