IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Cash_In_Hand_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Cash_In_Hand_Insert]    
            @Cash_Title VARCHAR(100),
            @Cash_Description VARCHAR(300),
            @Cash_Amount DECIMAL(18,2),
            @Cash_Date DATETIME,
            @Payment_No VARCHAR(200),
            @Payment_Date DATETIME,
            @Payment_AccountNo VARCHAR(150),
            @Bank_Name VARCHAR(100),
            @Bank_Address VARCHAR(300),
            @Payment_Amount DECIMAL(18,2),
            @Payment_Mode INT,
            @Payment_Due_Date DATETIME,
            @Payee_Name VARCHAR(200),
            @Grand_Total DECIMAL(18,2),
            @Bank_Transfer_To_Which_Account VARCHAR(50),
            @Bank_Transfer_From_Which_Acount VARCHAR(50),
            @Bank_Transfer_Payment_Mode VARCHAR(50),
            @Bank_Transfer_Date DATETIME,
            @Bank_Transfer_Remarks VARCHAR(50),
            @ddwhichaccount VARCHAR(50)
        AS
        BEGIN
            DECLARE 
                @intErrorCode INT,
                @ApprovalId BIGINT,
                @id BIGINT,
                @InventoryCashCode VARCHAR(100),
                @InvoiceCodeStartNo VARCHAR(100),
                @code VARCHAR(100),
                @Invoice_Code_Id BIGINT,
                @Invoice_Code_Prefix VARCHAR(100),
                @Invoice_Code_Suffix VARCHAR(100);

            -- Get cash invoice code and related details
            SET @InventoryCashCode = (SELECT TOP 1 Cash_Invoice_Code FROM Tbl_Cash_In_Hand ORDER BY Cash_Id DESC);
            SET @InvoiceCodeStartNo = (SELECT Invoice_Code_StartNo FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name = ''Cash In Hand'' AND Invoice_Code_Current_Status = 1);
            SET @code = ISNULL(@InventoryCashCode + 1, @InvoiceCodeStartNo);
            SET @Invoice_Code_Id = (SELECT Invoice_Code_Id FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name = ''Cash In Hand'' AND Invoice_Code_Current_Status = 1);
            SET @Invoice_Code_Prefix = (SELECT Invoice_Code_Prefix FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name = ''Cash In Hand'' AND Invoice_Code_Current_Status = 1);
            SET @Invoice_Code_Suffix = (SELECT Invoice_Code_Suffix FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name = ''Cash In Hand'' AND Invoice_Code_Current_Status = 1);

            BEGIN TRAN;

            -- Insert into Tbl_Cash_In_Hand
            INSERT INTO dbo.Tbl_Cash_In_Hand (Cash_Invoice_Code, Cash_Invoice_Code_Id, Cash_Title, Cash_Description, Cash_Amount, Cash_Date)
            VALUES (@code, @Invoice_Code_Id, @Cash_Title, @Cash_Description, @Cash_Amount, @Cash_Date);

            SET @id = (SELECT @@IDENTITY);
            SELECT @intErrorCode = @@ERROR;
            IF (@intErrorCode <> 0) GOTO PROBLEM;

            -- Insert into Tbl_Payment_Approval_List
            INSERT INTO [Tbl_Payment_Approval_List] 
                ([Approval_Date], [Approval_Due_Date], [Approval_Total_Amount], [Approval_Balance_Amount], [Approval_Status], [Approval_Del_Status])
            VALUES 
                (GETDATE(), @Payment_Due_Date, @Grand_Total, @Grand_Total - @Payment_Amount, 0, 0);

            SET @ApprovalId = (SELECT @@IDENTITY);
            DECLARE @Payment_Details_Particulars VARCHAR(500);
            SET @Payment_Details_Particulars = ''Cash Withdrawal From A/C '' + @Bank_Transfer_From_Which_Acount;

            EXEC SP_Tbl_Payment_Details_Insert 
                @ApprovalId, ''6'', ''Cash In Hand'', @id, 0, @Payment_Amount, @Payee_Name, @Payment_Date, 
                @Payment_No, @Payment_AccountNo, @Bank_Name, @Bank_Address, @Payment_Details_Particulars, 
                @Bank_Transfer_To_Which_Account, @Bank_Transfer_From_Which_Acount, @Bank_Transfer_Payment_Mode, 
                @Bank_Transfer_Date, @Bank_Transfer_Remarks, @ddwhichaccount;

            -- Insert into Tbl_Payment_Approval_List
            INSERT INTO [Tbl_Payment_Approval_List] 
                ([Approval_Date], [Approval_Due_Date], [Approval_Total_Amount], [Approval_Balance_Amount], [Approval_Status], [Approval_Del_Status])
            VALUES 
                (GETDATE(), @Payment_Due_Date, @Grand_Total, @Grand_Total - @Payment_Amount, 0, 0);

            SET @ApprovalId = (SELECT @@IDENTITY);

            SET @Payment_Details_Particulars = ''Cash Received From A/C '' + @Bank_Transfer_From_Which_Acount;

            EXEC SP_Tbl_Payment_Details_Insert 
                @ApprovalId, ''1'', ''Cash In Hand'', @id, 1, @Payment_Amount, @Payee_Name, @Payment_Date, 
                @Payment_No, @Payment_AccountNo, @Bank_Name, @Bank_Address, @Payment_Details_Particulars, 
                @Bank_Transfer_To_Which_Account, @Bank_Transfer_From_Which_Acount, @Bank_Transfer_Payment_Mode, 
                @Bank_Transfer_Date, @Bank_Transfer_Remarks, @ddwhichaccount;

            SELECT @intErrorCode = @@ERROR;
            IF (@intErrorCode <> 0) GOTO PROBLEM;

            COMMIT TRAN;

            PROBLEM:
                IF (@intErrorCode <> 0) 
                BEGIN
                    PRINT ''Unexpected error occurred!'';
                    ROLLBACK TRAN;
                END
        END
    ')
END
