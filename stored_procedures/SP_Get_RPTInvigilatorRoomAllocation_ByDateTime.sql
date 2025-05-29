IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_RPTInvigilatorRoomAllocation_ByDateTime]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_RPTInvigilatorRoomAllocation_ByDateTime]   
@Exam_Date datetime,    
@Exam_Type bigint,    
@Time Bit    
AS    
BEGIN    
SELECT      
    
R.Room_Name,    
RA.Employee_Id,    
E.Employee_FName+'' ''+E.Employee_LName as EmployeeName,    
RA.Exam_Date,    
RA.Exam_Type,    
ET.Exam_Type_Name,    
ET.Exam_Type_Code,    
Case RA.Time when 0 then ''FN'' else ''AN'' END as Exam_Time,    
    
RA.Invigilator_Exam_RoomAllocation_Id,    
RA.Exam_Type,    
RA.Room_Id    
    
FROM Tbl_Invigilator_ExamRoomAllocation_New RA    
INNER JOIN Tbl_Room R on RA.Room_Id=R.Room_Id    
INNER JOIN Tbl_Exam_Type ET On ET.Exam_Type_Id=RA.Exam_Type    
INNER JOIN Tbl_Employee E On E.Employee_Id=RA.Employee_Id    
    
WHERE RA.Exam_Date=@Exam_Date AND RA.[Time]=@Time     
and RA.Exam_Type=@Exam_Type    
END


						 ');
END;
