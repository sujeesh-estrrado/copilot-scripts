IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Official_Get_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Official_Get_By_Employee_Id]
            @Employee_Id bigint
        AS
        BEGIN
            SELECT * 
            FROM dbo.Tbl_Employee_Official 
            WHERE Employee_Id = @Employee_Id
        END
    ')
END
