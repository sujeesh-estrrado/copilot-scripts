IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Candidate_ExamRoomAllocation_Select_By_ExamAllocationId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Candidate_ExamRoomAllocation_Select_By_ExamAllocationId] 
@Exam_Allocation_Id bigint      
AS        
Begin        
Select      
Candidate_Exam_RoomAllocation_Id,      
Exam_Type_Id,      
Date,      
ExamTime,      
Exam_ScheduleDetails_Id,      
C.Candidate_Id,      
Room_Id ,    
RollNumber ,  
D.[Course_Department_Id],    
CC.Course_Category_Name+ '' - '' + DP.Department_Name  as Department_Name       
From       
Tbl_ExamRoom_Allocation E    
INNER JOIN Tbl_Candidate_ExamRoomAllocation C On E.Exam_Allocation_Id=C.Exam_Allocation_Id     
INNER JOIN Tbl_Candidate_RollNumber R On C.Candidate_Id=R.Candidate_Id    
INNER JOIN Tbl_Course_Duration_Mapping D ON R.Duration_Mapping_Id=D.Duration_Mapping_Id    
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON D.Duration_Period_Id=cdp.Duration_Period_Id     
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id    
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id     
INNER JOIN Tbl_Course_Department cd on cd.Course_Department_Id=D.Course_Department_Id    


left JOIN Tbl_Course_Category CC On CC.Course_Category_Id=cd.Course_Category_Id    
left JOIN Tbl_Department DP on DP.Department_Id=cd.Department_Id       
Where E.Exam_Allocation_Id=@Exam_Allocation_Id  and cd.Course_Department_Status=0    
End
    ')
END
