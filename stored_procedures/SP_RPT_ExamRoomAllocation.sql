IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_ExamRoomAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_RPT_ExamRoomAllocation]      
@Date datetime,      
@Time varchar(10)      
AS    
Begin      
Select    
Exam_Type_Id,    
E.Date,    
ExamTime,    
C.Room_Id ,  
Room_Name,  
CS.Semester_Code+'' - ''+D.Department_Name As Semester,    
cast (Min(RollNumber) as varchar(10))+''-''+cast(Max(RollNumber) as varchar(10)) As RollNumber,  
R.Duration_Mapping_Id  
From     
Tbl_ExamRoom_Allocation E     
INNER JOIN Tbl_Candidate_ExamRoomAllocation C On E.Exam_Allocation_Id=C.Exam_Allocation_Id   
INNER JOIN Tbl_Candidate_RollNumber R On C.Candidate_Id=R.Candidate_Id     
INNER JOIN Tbl_Room RM On C.Room_Id=RM.Room_Id  
Inner Join Tbl_Course_Duration_Mapping CDM On CDM.Duration_Mapping_Id=R.Duration_Mapping_Id      
Inner Join Tbl_Course_Duration_PeriodDetails CDP On CDP.Duration_Period_Id=CDM.Duration_Period_Id      
Inner Join Tbl_Course_Semester CS On CS.Semester_Id=CDP.Semester_Id      
Inner Join Tbl_Course_Department CD On CD.Course_Department_Id=CDM.Course_Department_Id      
Inner Join Tbl_Department D On D.Department_Id=CD.Department_Id     
Where E.Exam_Allocation_Status=0   
and E.Date=@Date       
and E.ExamTime=@Time  
Group By  
Exam_Type_Id,    
E.Date,    
ExamTime,    
C.Room_Id ,  
Room_Name,  
R.Duration_Mapping_Id,  
CS.Semester_Code+'' - ''+D.Department_Name  
End
');
END;