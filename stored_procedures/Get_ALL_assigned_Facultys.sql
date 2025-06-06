IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_ALL_assigned_Facultys]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_ALL_assigned_Facultys]
            @employeeid BIGINT = 0,
            @facultyid BIGINT = 0
        AS
        BEGIN
            
            
            SELECT Course_Level_Name 
            FROM Tbl_Course_Level 
            WHERE Faculty_dean_id <> @employeeid 
                AND Course_Level_Id = @facultyid;
        END
    ')
END
