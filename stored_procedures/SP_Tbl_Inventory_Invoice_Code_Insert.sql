IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Invoice_Code_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_Invoice_Code_Insert]
        @Invoice_Code_Name varchar(100),
        @Invoice_Code_Prefix varchar(5),
        @Invoice_Code_StartNo bigint,
        @Invoice_Code_Suffix varchar(5),
        @Invoice_Code_Current_Status bit,
        @Invoice_Code_From_Date datetime,
        @Invoice_Code_To_Date datetime,
        @Invoice_Code_Del_Status bit,
        @Prefix1 varchar(10),
        @Prefix2 varchar(10),
        @Prefix3 varchar(10),
        @prgmcode varchar(10)
        AS
        BEGIN
            IF EXISTS (
                SELECT Invoice_Code_Id 
                FROM Tbl_Inventory_Invoice_Code
                WHERE Invoice_Code_Name = @Invoice_Code_Name 
                  AND Invoice_Code_Current_Status = 1 
                  AND program_code = @prgmcode 
                  AND (
                    @Invoice_Code_From_Date BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date
                    OR @Invoice_Code_To_Date BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date
                  )
            )
            BEGIN
                SELECT -2
            END
            ELSE
            BEGIN
                INSERT INTO [Tbl_Inventory_Invoice_Code]
                    ([Invoice_Code_Name], [Invoice_Code_Prefix], [Invoice_Code_StartNo], 
                    [Invoice_Code_Suffix], [Invoice_Code_Current_Status], 
                    [Invoice_Code_From_Date], [Invoice_Code_To_Date], [Invoice_Code_Del_Status], 
                    [Prefix1], [Prefix2], [Prefix3], [program_code])
                VALUES 
                    (@Invoice_Code_Name, @Invoice_Code_Prefix, @Invoice_Code_StartNo, 
                    @Invoice_Code_Suffix, @Invoice_Code_Current_Status, 
                    @Invoice_Code_From_Date, @Invoice_Code_To_Date, @Invoice_Code_Del_Status, 
                    @Prefix1, @Prefix2, @Prefix3, @prgmcode)
                
                SELECT @@IDENTITY
                
                IF (@Invoice_Code_Current_Status = 1)
                BEGIN
                    UPDATE Tbl_Inventory_Invoice_Code 
                    SET Invoice_Code_Current_Status = 0 
                    WHERE Invoice_Code_Id <> @@IDENTITY 
                      AND Invoice_Code_Name = @Invoice_Code_Name
                END
            END
        END
    ')
END
