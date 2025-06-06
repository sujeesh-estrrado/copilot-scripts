IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Department_Fine_Payment_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Department_Fine_Payment_Insert]  
            @Dept_Fine_Id BIGINT,  
            @Date DATETIME
        AS
        BEGIN
            INSERT INTO [dbo].[Tbl_Department_Fine_Payment]  
                ([Dept_Fine_Id],  
                [Date])  
            VALUES  
                (@Dept_Fine_Id,  
                @Date)
        END
    ')
END
