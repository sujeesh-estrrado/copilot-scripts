IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Income_Head_UpdateNew1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[FN_SP_Tbl_Income_Head_UpdateNew1]
        @Income_Id bigint,
        @Acc_Cat_Id bigint,
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
        @Grand_Total decimal(18,2)
        AS

        DECLARE @intErrorCode INT
        DECLARE @ApprovalId bigint
        DECLARE @id bigint
        DECLARE @InventoryIncomeCode varchar(100),
                @InvoiceCodeStartNo varchar(100),
                @code varchar(100),
                @Invoice_Code_Id bigint,
                @Invoice_Code_Prefix varchar(100),
                @Invoice_Code_Suffix varchar(100),
                @Acc_Cat_Name varchar(150)

        SET @InventoryIncomeCode = (
            SELECT TOP 1 Inventory_Invoice_code 
            FROM FN_Tbl_Income_Head1 
            ORDER BY Income_Id DESC
        )
        
        SET @InvoiceCodeStartNo = (
            SELECT Invoice_Code_StartNo 
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Name = ''Income'' 
              AND Invoice_Code_Current_Status = 1
        )
        
        SET @code = (
            SELECT Inventory_Invoice_Code 
            FROM FN_Tbl_Income_Head1 
            WHERE Income_Id = @Income_Id
        )
        
        SET @Invoice_Code_Id = (
            SELECT Invoice_Code_Id 
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Name = ''Income'' 
              AND Invoice_Code_Current_Status = 1
        )
        
        SET @Invoice_Code_Prefix = (
            SELECT Invoice_Code_Prefix 
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Name = ''Income'' 
              AND Invoice_Code_Current_Status = 1
        )
        
        SET @Invoice_Code_Suffix = (
            SELECT Invoice_Code_Suffix 
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Name = ''Income'' 
              AND Invoice_Code_Current_Status = 1
        )

        BEGIN TRAN

        -- Update the income head status
        UPDATE dbo.FN_Tbl_Income_Head1 
        SET Income_Status = 1  
        WHERE Income_Id = @Income_Id

        -- Insert the new income head record
        INSERT INTO dbo.FN_Tbl_Income_Head1
            (Inventory_Invoice_code, Invoice_Code_Id, Acc_Cat_Id, Income_Title, 
            Income_Description, Income_Amount, Income_Date)
        VALUES
            (@code, @Invoice_Code_Id, @Acc_Cat_Id, @Income_Title, 
            @Income_Description, @Income_Amount, @Income_Date)

        SET @id = (SELECT @@IDENTITY)

        -- Call the cancel payment procedure
        EXEC FN_SP_Cancel_Payment_Details1 ''INCOME'', @Income_Id
        SELECT @intErrorCode = @@ERROR
        IF (@intErrorCode <> 0) GOTO PROBLEM

        -- Insert into the payment approval list
        INSERT INTO [FN_Tbl_Payment_Approval_List1]
            ([Approval_Date], [Approval_Due_Date], [Approval_Total_Amount], 
            [Approval_Balance_Amount], [Approval_Status], [Approval_Del_Status])
        VALUES
            (GETDATE(), @Payment_Due_Date, @Grand_Total, 
            @Grand_Total - @Payment_Amount, 0, 0)

        SET @ApprovalId = (SELECT @@IDENTITY)

        -- Retrieve account category name
        SET @Acc_Cat_Name = (
            SELECT Acc_Cat_Name 
            FROM dbo.FN_Tbl_Head1 
            WHERE Acc_Cat_Id = @Acc_Cat_Id
        )

        -- Insert into payment details
        EXEC FN_SP_Tbl_Payment_Details_Insert1 
            @ApprovalId, @Payment_Mode, ''INCOME'', @id, 1, 
            @Payment_Amount, @Payee_Name, @Payment_Date, 
            @Payment_No, @Payment_AccountNo, 
            @Bank_Name, @Bank_Address, @Acc_Cat_Name

        -- Check for any errors
        SELECT @intErrorCode = @@ERROR
        IF (@intErrorCode <> 0) GOTO PROBLEM

        COMMIT TRAN

        PROBLEM:
        IF (@intErrorCode <> 0)
        BEGIN
            PRINT ''Unexpected error occurred!''
            ROLLBACK TRAN
        END
    ')
END
