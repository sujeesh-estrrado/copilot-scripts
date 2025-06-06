IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_Invigilator_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_All_Invigilator_List]  
  
As  
Begin  
Select   
dbo.Tbl_Invigilator_ExamRoomAllocation_New.Invigilator_Exam_RoomAllocation_Id,  
Tbl_Invigilator_ExamRoomAllocation_New.Exam_Type,  
Tbl_Invigilator_ExamRoomAllocation_New.Exam_Date,  
--Tbl_Invigilator_ExamRoomAllocation_New.Time,  
case when Tbl_Invigilator_ExamRoomAllocation_New.Time=''False''  
then  
''FN''  
else   
''AN'' end as Time,  
  
Tbl_Invigilator_ExamRoomAllocation_New.Room_Id,  
Tbl_Invigilator_ExamRoomAllocation_New.Employee_Id,  
E.Employee_FName+'' ''+Employee_LName as Employeename,  
Tbl_Room.Room_Name,  
Tbl_Exam_Type.Exam_Type_Name  
  
From Tbl_Invigilator_ExamRoomAllocation_New Inner Join  
Tbl_Employee E on E.Employee_Id=Tbl_Invigilator_ExamRoomAllocation_New.Employee_Id inner join  
Tbl_Exam_Type on Tbl_Exam_Type.Exam_Type_Id=Tbl_Invigilator_ExamRoomAllocation_New.Exam_Type Inner Join  
Tbl_Room on Tbl_Room.Room_Id=Tbl_Invigilator_ExamRoomAllocation_New.Room_Id  
  
Where Tbl_Invigilator_ExamRoomAllocation_New.Invigilator_ExamRoomAllocation_Status=0  
End
    ')
END
ELSE
BEGIN
EXEC('--Created by krishna on 16/6/14---  
  
  
ALTER procedure [dbo].[Get_All_Invigilator_List]  
  
As  
Begin  
Select   
dbo.Tbl_Invigilator_ExamRoomAllocation_New.Invigilator_Exam_RoomAllocation_Id,  
Tbl_Invigilator_ExamRoomAllocation_New.Exam_Type,  
Tbl_Invigilator_ExamRoomAllocation_New.Exam_Date,  
--Tbl_Invigilator_ExamRoomAllocation_New.Time,  
case when Tbl_Invigilator_ExamRoomAllocation_New.Time=''False''  
then  
''FN''  
else   
''AN'' end as Time,  
  
Tbl_Invigilator_ExamRoomAllocation_New.Room_Id,  
Tbl_Invigilator_ExamRoomAllocation_New.Employee_Id,  
E.Employee_FName+'' ''+Employee_LName as Employeename,  
Tbl_Room.Room_Name,  
Tbl_Exam_Type.Exam_Type_Name  
  
From Tbl_Invigilator_ExamRoomAllocation_New Inner Join  
Tbl_Employee E on E.Employee_Id=Tbl_Invigilator_ExamRoomAllocation_New.Employee_Id inner join  
Tbl_Exam_Type on Tbl_Exam_Type.Exam_Type_Id=Tbl_Invigilator_ExamRoomAllocation_New.Exam_Type Inner Join  
Tbl_Room on Tbl_Room.Room_Id=Tbl_Invigilator_ExamRoomAllocation_New.Room_Id  
  
Where Tbl_Invigilator_ExamRoomAllocation_New.Invigilator_ExamRoomAllocation_Status=0  
End


')
END
