IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Students_by_DateofAttendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_Students_by_DateofAttendance]      
@Duration_Mapping_Id bigint,          
@DateofAttendance varchar(30)          
AS          
BEGIN          
Declare @AttendanceCount int     
Declare @Status bit    
set  @Status=0            
       
Begin          
Set @AttendanceCount=(Select Count(Attendance_Id)          
From  Tbl_StudentAttendance         
Where Duration_Mapping_Id=@Duration_Mapping_Id and Attendance_Date=@DateofAttendance)          
 IF(@AttendanceCount>0)          
 Begin          
  Select           
  IsNull(R.RollNumber,ROW_NUMBER() OVER(ORDER BY S.Candidate_Id))  AS RollNo,          
  S.Student_Semester_Id,          
  S.Candidate_Id,          
  S.Duration_Mapping_Id,     
  SA.Is_Present  ,       
  Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname As [CandidateName]          
  From Tbl_Student_Semester S          
  Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id=C.Candidate_Id          
  left Join Tbl_Candidate_RollNumber R On S.Candidate_Id=R.Candidate_Id and S.Duration_Mapping_Id=R.Duration_Mapping_Id      
  left Join dbo.Tbl_StudentAttendance SA On SA.Candidate_Id=R.Candidate_Id and SA.Duration_Mapping_Id =R.Duration_Mapping_Id           
  Where  S.Duration_Mapping_Id=@Duration_Mapping_Id and Student_Semester_Delete_Status=0 and SA.Attendance_Date=@DateofAttendance       
 Order By  RollNo        
 End          
   Else          
   Begin          
    Select           
    ROW_NUMBER() OVER(ORDER BY Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname ASC) AS RollNo,          
 S.Student_Semester_Id,          
 S.Candidate_Id,          
 S.Duration_Mapping_Id,     
 @Status as Is_Present,    
 Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname As [CandidateName]          
 From Tbl_Student_Semester S          
 Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id=C.Candidate_Id          
 Where  S.Duration_Mapping_Id=@Duration_Mapping_Id and Student_Semester_Delete_Status=0          
 Order By CandidateName ASC          
  End          
     
END     
END
    ')
END
