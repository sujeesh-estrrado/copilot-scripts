IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Income_Head_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Income_Head_Insert]                
            (@Acc_Cat_Id bigint,                
            @Income_Title varchar(100),                
            @Income_Description varchar(300),                
            @Income_Amount decimal(18,2),                
            @Income_Date datetime,                
            @Payment_No varchar(200),                  
            @Payment_Date datetime,                  
            @Payment_AccountNo varchar(150),                  
            @Bank_Name varchar(100),                  
            @Bank_Address varchar(300),                  
            @Payment_Amount decimal(18,2),                  
            @Payment_Mode int,                  
            @Payment_Due_Date datetime,                  
            @Payee_Name varchar(200),                 
            @Grand_Total decimal(18,2),      
            @Bank_Transfer_To_Which_Account varchar(50),      
            @Bank_Transfer_From_Which_Acount varchar(50),      
            @Bank_Transfer_Payment_Mode varchar(50),      
            @Bank_Transfer_Date datetime,      
            @Bank_Transfer_Remarks varchar(50), 
            @ddwhichaccount varchar(50))                
        AS
        BEGIN
            DECLARE @intErrorCode INT;
            DECLARE @ApprovalId bigint;
            DECLARE @id bigint;
            DECLARE @InventoryIncomeCode varchar(100),
                    @InvoiceCodeStartNo varchar(100),
                    @code varchar(100),
                    @Invoice_Code_Id bigint,
                    @Invoice_Code_Prefix varchar(100),
                    @Invoice_Code_Suffix varchar(100),
                    @Acc_Cat_Name varchar(150);
                
            SET @InventoryIncomeCode = (SELECT TOP 1 Inventory_Invoice_code 
                                         FROM Tbl_Income_Head 
                                         ORDER BY Income_Id DESC);
            SET @InvoiceCodeStartNo = (SELECT TOP 1 Invoice_Code_StartNo 
                                       FROM Tbl_Inventory_Invoice_Code 
                                       WHERE Invoice_Code_Name = ''Income'' 
                                         AND Invoice_Code_Current_Status = 1 
                                       ORDER BY Invoice_Code_Id DESC);
            SET @code = ISNULL(@InventoryIncomeCode + 1, @InvoiceCodeStartNo);
            SET @Invoice_Code_Id = (SELECT TOP 1 Invoice_Code_Id 
                                    FROM Tbl_Inventory_Invoice_Code 
                                    WHERE Invoice_Code_Name = ''Income'' 
                                      AND Invoice_Code_Current_Status = 1 
                                    ORDER BY Invoice_Code_Id DESC);
            SET @Invoice_Code_Prefix = (SELECT TOP 1 Invoice_Code_Prefix 
                                       FROM Tbl_Inventory_Invoice_Code 
                                       WHERE Invoice_Code_Name = ''Income'' 
                                         AND Invoice_Code_Current_Status = 1 
                                       ORDER BY Invoice_Code_Id DESC);
            SET @Invoice_Code_Suffix = (SELECT TOP 1 Invoice_Code_Suffix 
                                       FROM Tbl_Inventory_Invoice_Code 
                                       WHERE Invoice_Code_Name = ''Income'' 
                                         AND Invoice_Code_Current_Status = 1 
                                       ORDER BY Invoice_Code_Id DESC);
                
            BEGIN TRANSACTION;
                
            INSERT INTO dbo.Tbl_Income_Head 
                (Inventory_Invoice_code, Invoice_Code_Id, Acc_Cat_Id, Income_Title, 
                 Income_Description, Income_Amount, Income_Date)
            VALUES 
                (@code, @Invoice_Code_Id, @Acc_Cat_Id, @Income_Title, @Income_Description, 
                 @Income_Amount, @Income_Date);
                
            SET @id = (SELECT @@IDENTITY);
                
            SELECT @intErrorCode = @@ERROR;
                
            IF (@intErrorCode <> 0) GOTO PROBLEM;
                
            INSERT INTO [Tbl_Payment_Approval_List] 
                ([Approval_Date], [Approval_Due_Date], [Approval_Total_Amount], 
                 [Approval_Balance_Amount], [Approval_Status], [Approval_Del_Status])
            VALUES 
                (GETDATE(), @Payment_Due_Date, @Grand_Total, @Grand_Total - @Payment_Amount, 0, 0);
                
            SET @ApprovalId = (SELECT @@IDENTITY);
                
            SET @Acc_Cat_Name = (SELECT Acc_Cat_Name 
                                 FROM dbo.Tbl_Income_Expense_Category 
                                 WHERE Acc_Cat_Id = @Acc_Cat_Id);
                
            EXEC SP_Tbl_Payment_Details_Insert 
                @ApprovalId, @Payment_Mode, ''INCOME'', @id, 1, @Payment_Amount, 
                @Payee_Name, @Payment_Date, @Payment_No, @Payment_AccountNo, 
                @Bank_Name, @Bank_Address, @Acc_Cat_Name, @Bank_Transfer_To_Which_Account, 
                @Bank_Transfer_From_Which_Acount, @Bank_Transfer_Payment_Mode, 
                @Bank_Transfer_Date, @Bank_Transfer_Remarks, @ddwhichaccount;
                
            -- EXEC SP_Tbl_Payment_Details_Insert 
            --    @ApprovalId, @Payment_Mode, ''INCOME'', @id, 1, @Payment_Amount, 
            --    @Payee_Name, @Payment_Date, @Payment_No, @Payment_AccountNo, 
            --    @Bank_Name, @Bank_Address;
                
            SELECT @intErrorCode = @@ERROR;
                
            IF (@intErrorCode <> 0) GOTO PROBLEM;
                
            COMMIT TRANSACTION;
                
        PROBLEM:
            IF (@intErrorCode <> 0) 
            BEGIN
                PRINT ''Unexpected error occurred!'';
                ROLLBACK TRANSACTION;
            END
        END
    ')
END
