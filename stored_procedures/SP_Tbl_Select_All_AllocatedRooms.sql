IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Select_All_AllocatedRooms]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Select_All_AllocatedRooms]            
        AS            
        BEGIN            

            SELECT 
                Tbl_Course_Category.Course_Category_Name + ''-'' + Tbl_Department.Department_Name AS DepartmentName, 
                Tbl_Room.Room_Name,  
                Tbl_Campus.Campus_Name, 
                B.Batch_Code + ''-'' + Tbl_Course_Semester.Semester_Code AS BatchName,
                Tbl_Room.Room_Id,     
                Tbl_Class_Allocation.Allocation_Id    
            FROM Tbl_Class_Allocation 
            INNER JOIN Tbl_Room ON Tbl_Class_Allocation.Room_Id = Tbl_Room.Room_Id 
            INNER JOIN Tbl_Campus ON Tbl_Room.Campus_Id = Tbl_Campus.Campus_Id 
            INNER JOIN Tbl_Course_Duration_Mapping ON Tbl_Class_Allocation.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id 
            INNER JOIN Tbl_Course_Department ON Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Department_Id 
            INNER JOIN Tbl_Course_Category ON Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id  
            INNER JOIN Tbl_Department ON Tbl_Course_Department.Department_Id = Tbl_Department.Department_Id      
            INNER JOIN Tbl_Course_Duration_PeriodDetails CP ON Tbl_Course_Duration_Mapping.Duration_Period_Id = CP.Duration_Period_Id       
            INNER JOIN Tbl_Course_Batch_Duration B ON CP.Batch_Id = B.Batch_Id       
            INNER JOIN Tbl_Course_Semester ON CP.Semester_Id = Tbl_Course_Semester.Semester_Id      

        END
    ')
END;
