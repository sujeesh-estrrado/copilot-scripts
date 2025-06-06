IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Emp_RosterGroup_Mapping_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Emp_RosterGroup_Mapping_SelectAll]
        AS
        BEGIN
            SELECT 
                m.[Emp_RosterGroup_Map_Id],
                m.[RosterGroup_Id],
                m.[Employee_Id],
                m.[Emp_RosterGroup_Status],
                r.RosterGroup_Name,
                e.Employee_FName + '' '' + e.Employee_LName AS Employee_FullName
            FROM Tbl_Emp_RosterGroup_Mapping m
            INNER JOIN Tbl_RosterGroup r ON m.RosterGroup_Id = r.RosterGroup_Id
            INNER JOIN Tbl_Employee e ON m.Employee_Id = e.Employee_Id
            WHERE m.Emp_RosterGroup_Status = 0
        END
    ')
END
