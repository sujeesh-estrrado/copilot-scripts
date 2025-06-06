IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Poll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Poll]
        @Poll_id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;
            
            SELECT 
                P.Poll_id,
                P.Poll_Question,
                E.Employee_FName AS EmployeeName,
                P.Status
            FROM LMS_Tbl_Poll P
            INNER JOIN Tbl_Employee E ON P.Emp_Id = E.Employee_Id
            WHERE P.Poll_id = @Poll_id;
        END
    ')
END
