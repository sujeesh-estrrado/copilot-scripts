IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Exam_Attendance_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Exam_Attendance_List]
  @Exam_Master_id int 
as
begin
  
  SELECT 
    MS.Exam_Name, 
    MS.Exam_Master_id, 
    ES.Exam_Date,
    ESD.venue as Room_Name,
    (MS.Exam_end_date) AS Examtime,
    ES.Course_id,
    MS.Duration_Period_id,
    D.Department_Name,
    CBD.intake_no,L.Course_Level_Name as CourseName,S.Semester_Name   
FROM Tbl_Exam_Master MS
INNER JOIN Tbl_Exam_Schedule ES 
    ON MS.Exam_Master_id = ES.Exam_Master_id
    inner join Tbl_Exam_Schedule_Details ESD on ES.Exam_Master_id = ESD.Exam_Schedule_Id
INNER JOIN Tbl_Course_Duration_PeriodDetails CPD 
    ON CPD.Duration_Period_Id = MS.Duration_Period_Id
    inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                                                        
    CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                                        
    inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                          
    inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                                      
    inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0  
    WHERE MS.Exam_Master_id=@Exam_Master_id
    AND MS.Publish_status=2

end
    ')
END
