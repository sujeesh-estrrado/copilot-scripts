IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Invoice_Code_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_Invoice_Code_SelectAll]
        AS
        BEGIN
            SELECT [Invoice_Code_Id],
                   [Invoice_Code_Name],
                   CASE 
                       WHEN Invoice_Code_Name = ''Admission Number'' 
                       THEN Prefix1 + ''_'' + Prefix2 + ''_'' + Prefix3 
                       ELSE Invoice_Code_Prefix 
                   END AS [Invoice_Code_Prefix],
                   [Invoice_Code_StartNo],
                   [Invoice_Code_Suffix],
                   [Invoice_Code_Current_Status],
                   [Invoice_Code_From_Date],
                   [Invoice_Code_To_Date],
                   [Invoice_Code_Del_Status],
                   [program_code]
            FROM [Tbl_Inventory_Invoice_Code]
            WHERE Invoice_Code_Del_Status = 0
        END
    ')
END
