IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_TblExamRoom_Allocation_GetRooms_ByExamTypeAndDate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_TblExamRoom_Allocation_GetRooms_ByExamTypeAndDate]    
(@Exam_Type_Id bigint,@ExamDate datetime)      
      
AS      
BEGIN      
SELECT     
Exam_Type_Id,    
E.Room_Id,    
From_Date,    
To_Date,    
Room_Name,    
Exam_SeatCapacity,  
Room_Name+'' (Seat Capacity: ''+Convert(varchar(10),Exam_SeatCapacity)+'')'' as RoomAndCapacity  
FROM Tbl_Exam_Room_Allocation  E    
INNER JOIN Tbl_Room R On E.Room_Id=R.Room_Id    
WHERE Exam_Type_Id=@Exam_Type_Id and Exam_RoomAllocation_Status=0      
and (@ExamDate between From_Date and To_Date)      
      
      
      
      
END
    ')
END;
