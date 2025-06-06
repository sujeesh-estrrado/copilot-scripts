IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Education_Delete_By_Employee_Education_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Education_Delete_By_Employee_Education_Id]
        @Employee_Education_Id BIGINT
        AS
        BEGIN
            UPDATE dbo.Tbl_Employee_Education
            SET Employee_Education_Status = 1
            WHERE Employee_Education_Id = @Employee_Education_Id
        END
    ')
END
