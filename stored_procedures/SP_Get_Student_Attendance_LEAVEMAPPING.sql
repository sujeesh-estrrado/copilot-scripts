IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Attendance_LEAVEMAPPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_Student_Attendance_LEAVEMAPPING]          
@Duration_Mapping_Id bigint,          
@DateofAttendance varchar(30),          
@Candidate_Id bigint,      
--@Subject_Id bigint,           
@Class_Timings_Id bigint          
AS          
BEGIN          
  Select          
  IsNull(R.RollNumber,ROW_NUMBER() OVER(ORDER BY S.Candidate_Id))  AS RollNo,          
  S.Student_Semester_Id,          
  S.Candidate_Id,          
  S.Duration_Mapping_Id,          
  Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname As [CandidateName],          
 ISNULL((Select IsAbsent=case Absent_Type when ''absent'' then ''A'' when ''FN'' then ''FN'' when ''AN'' then ''AN''  when ''DL'' then ''DL'' else  ''P'' END From Tbl_Student_Absence Where Duration_Mapping_Id=@Duration_Mapping_Id          
  and Absent_Date=@DateofAttendance and Candidate_Id=S.Candidate_Id  and Class_Timings_Id=@Class_Timings_Id),''P'') AS IsAbsent ,  --and Subject_Id=@Subject_Id    
      
ISNULL((Select Subject_Id From Tbl_Student_Absence Where Duration_Mapping_Id=@Duration_Mapping_Id                
  and Absent_Date=@DateofAttendance and Candidate_Id=S.Candidate_Id  and Class_Timings_Id=@Class_Timings_Id),0)--,@Subject_Id) --and Subject_Id=@Subject_Id     
      
 AS Subject_Id ,      
ISNULL((Select Class_Timings_Id From Tbl_Student_Absence Where Duration_Mapping_Id=@Duration_Mapping_Id                    
  and Absent_Date=@DateofAttendance and Candidate_Id=S.Candidate_Id  and Class_Timings_Id=@Class_Timings_Id),@Class_Timings_Id)  AS Class_Timings_Id,       --and Subject_Id=@Subject_Id   
          
ISNUll((SELECT CASE WHEN COUNT(Stud_LeaveApply_Id) > 0 THEN ''LEAVE APPLIED'' ELSE ''---'' END AS [Value]          
          
FROM Tbl_Stud_Leave_Apply where Candidate_Id=@Candidate_Id           
and @DateofAttendance  between Stud_LeaveFromDate and Stud_LeaveToDate),''---'') as LEAVESTATUS          
  From Tbl_Student_Semester S          
  Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id=C.Candidate_Id          
  left Join Tbl_Candidate_RollNumber R On S.Candidate_Id=R.Candidate_Id          
  and S.Duration_Mapping_Id=R.Duration_Mapping_Id          
          
  Where  S.Duration_Mapping_Id=@Duration_Mapping_Id and Student_Semester_Delete_Status=0  and S.Candidate_Id=@Candidate_Id          
   and Student_Semester_Current_Status=1        
 Order By  RollNo          
END
    ');
END;
