IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Education_Get_By_Education_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Education_Get_By_Education_Id]
        @Employee_Education_Id BIGINT
        AS
        BEGIN
            SELECT * 
            FROM dbo.Tbl_Employee_Education 
            WHERE Employee_Education_Id = @Employee_Education_Id 
              AND Employee_Education_Status = 0
        END
    ')
END
