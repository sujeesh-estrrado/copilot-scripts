IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Course_Seat_Capacity_BY_Course_Seat_Capacity_IdNew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Course_Seat_Capacity_BY_Course_Seat_Capacity_IdNew] --1
(@Course_Seat_Capacity_Id bigint)      
      
AS      
      
BEGIN      
      
SELECT       
SC.totalCapacity_Id as ID,SC.Org_Id,   
SC.Batch_Id as BatchID,    
SC.Category_Id as CategoryID,    
SC.Department_Id as DeptID,    
SC.Total_Capacity as TotalCapacity,    
BD.Batch_Id,    
BD.Batch_Code as Batch,    
CC.Course_Category_Name as CategoryName,    
D.GraduationTypeId AS LevelID, 
CL.Course_Level_Name as LevelName,    
D.Department_Name as Department     
 
FROM Tbl_Course_Seat_TotalCapacity SC    
INNER JOIN Tbl_Course_Batch_Duration BD On SC.Batch_Id=BD.Batch_Id    
inner join Tbl_Program_Duration CD On BD.Duration_Id=CD.Duration_Id 
inner join dbo.Tbl_Course_Department Tbl_Course_Department on Tbl_Course_Department.Department_Id=CD.Program_Category_Id
inner join  dbo.Tbl_Department D on D.Department_Id=Tbl_Course_Department.Department_Id       
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=Tbl_Course_Department.Course_Category_Id 
 INNER JOIN Tbl_Course_Level CL on CL.Course_Level_Id=D.GraduationTypeId  
 Where totalCapacity_Id=@Course_Seat_Capacity_Id  
       
END
    ');
END;
