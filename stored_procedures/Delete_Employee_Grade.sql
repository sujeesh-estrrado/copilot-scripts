IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Delete_Employee_Grade]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Delete_Employee_Grade](@Emp_Grade_Id BIGINT)
        AS
        BEGIN
            

            UPDATE [dbo].[Tbl_Employee_Grade]
            SET Emp_Grade_Status = 1
            WHERE Emp_Grade_Id = @Emp_Grade_Id;
        END
    ')
END
