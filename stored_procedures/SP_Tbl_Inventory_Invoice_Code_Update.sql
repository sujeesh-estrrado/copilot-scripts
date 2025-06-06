IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Invoice_Code_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_Invoice_Code_Update]
            @Invoice_Code_Id bigint,
            @Invoice_Code_Name varchar(100),
            @Invoice_Code_Prefix varchar(5),
            @Invoice_Code_StartNo bigint,
            @Invoice_Code_Suffix varchar(5),
            @Invoice_Code_Current_Status bit,
            @Invoice_Code_From_Date datetime,
            @Invoice_Code_To_Date datetime,
            @Invoice_Code_Del_Status bit
        AS
        BEGIN
            UPDATE [Tbl_Inventory_Invoice_Code]
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
