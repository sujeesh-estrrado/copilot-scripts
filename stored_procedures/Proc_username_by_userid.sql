IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_username_by_userid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_username_by_userid]
        (
            @User_Id BIGINT
        )
        AS
        BEGIN
            -- Select the User_Id, Employee_Id, and the concatenated Employee name
            SELECT 
                User_Id,
                E.Employee_Id,
                E.Employee_FName + '' '' + E.Employee_LName AS Name
            FROM 
                Tbl_Employee E
            INNER JOIN 
                dbo.Tbl_Employee_User EU ON EU.Employee_Id = E.Employee_Id
            WHERE 
                Employee_Status = 0 
                AND User_Id = @User_Id;
        END
    ')
END
