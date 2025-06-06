IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Invoice_Code_SelectAll1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[FN_SP_Tbl_Invoice_Code_SelectAll1]      
        AS      
        BEGIN      
            SELECT 
                [Invoice_Code_Id],      
                [Invoice_Code_Name],      
                [Invoice_Code_Prefix],      
                [Invoice_Code_StartNo],      
                [Invoice_Code_Suffix],    
                [Invoice_Code_Current_Status],    
                [Invoice_Code_From_Date],    
                [Invoice_Code_To_Date],    
                [Invoice_Code_Del_Status]      
            FROM Tbl_Inventory_Invoice_Code      
            WHERE Invoice_Code_Del_Status = 0      
        END
    ')
END
