IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_TblExamRoom_Allocation_GetRooms_ByExamType]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_TblExamRoom_Allocation_GetRooms_ByExamType](@Exam_Type_Id bigint)

AS
BEGIN
SELECT Tbl_Exam_Room_Allocation.Exam_Type_Id,
Tbl_Exam_Room_Allocation.Room_Id,
Tbl_Room.Room_Name,
Tbl_Exam_Room_Allocation.From_Date,
Tbl_Exam_Room_Allocation.To_Date FROM Tbl_Exam_Room_Allocation
INNER JOIN Tbl_Room on Tbl_Room.Room_Id=Tbl_Exam_Room_Allocation.Room_Id
WHERE Tbl_Exam_Room_Allocation.Exam_Type_Id=@Exam_Type_Id and Tbl_Exam_Room_Allocation.Exam_RoomAllocation_Status=0

END
    ')
END
