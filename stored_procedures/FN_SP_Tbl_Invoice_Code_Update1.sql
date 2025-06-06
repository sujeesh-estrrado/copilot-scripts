IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Invoice_Code_Update1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[FN_SP_Tbl_Invoice_Code_Update1]  
        @Invoice_Code_Id BIGINT,  
        @Invoice_Code_Name VARCHAR(100),  
        @Invoice_Code_Prefix VARCHAR(5),  
        @Invoice_Code_StartNo BIGINT,  
        @Invoice_Code_Suffix VARCHAR(5),  
        @Invoice_Code_Current_Status BIT,  
        @Invoice_Code_From_Date DATETIME,  
        @Invoice_Code_To_Date DATETIME,  
        @Invoice_Code_Del_Status BIT  
        AS  
        BEGIN  
            UPDATE Tbl_Inventory_Invoice_Code  
            SET [Invoice_Code_Name] = @Invoice_Code_Name,  
                [Invoice_Code_Prefix] = @Invoice_Code_Prefix,  
                [Invoice_Code_StartNo] = @Invoice_Code_StartNo,  
                [Invoice_Code_Suffix] = @Invoice_Code_Suffix,  
                [Invoice_Code_Current_Status] = @Invoice_Code_Current_Status,  
                [Invoice_Code_From_Date] = @Invoice_Code_From_Date,  
                [Invoice_Code_To_Date] = @Invoice_Code_To_Date,  
                [Invoice_Code_Del_Status] = @Invoice_Code_Del_Status  
            WHERE Invoice_Code_Id = @Invoice_Code_Id  
        END
    ')
END
