IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Assign_Class_Duplicate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Assign_Class_Duplicate]
        (
            @Campus_Id bigint,
            @Room_Id bigint
        )
        AS
        BEGIN
            SELECT  
                CA.Allocation_Id, 
                CA.Room_Id, 
                CA.Duration_Mapping_Id, 
                R.Room_Name, 
                C.Campus_Id, 
                C.Campus_Name
            FROM        
                Tbl_Class_Allocation CA
            INNER JOIN 
                Tbl_Room R ON CA.Room_Id = R.Room_Id
            INNER JOIN 
                Tbl_Campus C ON R.Campus_Id = C.Campus_Id
            WHERE 
                C.Campus_Id = @Campus_Id 
                AND R.Room_Id = @Room_Id
        END
    ')
END
