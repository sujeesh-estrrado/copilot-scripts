IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_AllocateRoom_Select_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_AllocateRoom_Select_By_Id]
            @Allocation_Id BIGINT
        AS
        BEGIN
            SELECT 
                Tbl_Campus.Campus_Id, 
                Tbl_Room.Room_Id, 
                Tbl_Course_Duration_Mapping.Duration_Mapping_Id,
                Tbl_Course_Duration_Mapping.Course_Department_Id
            FROM 
                Tbl_Class_Allocation
            INNER JOIN 
                Tbl_Room 
                ON Tbl_Class_Allocation.Room_Id = Tbl_Room.Room_Id
            INNER JOIN 
                Tbl_Course_Duration_Mapping 
                ON Tbl_Class_Allocation.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id
            INNER JOIN 
                Tbl_Campus 
                ON Tbl_Room.Campus_Id = Tbl_Campus.Campus_Id
            WHERE 
                Tbl_Class_Allocation.Allocation_Id = @Allocation_Id;
        END
    ');
END
