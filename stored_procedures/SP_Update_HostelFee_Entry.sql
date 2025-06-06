IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_HostelFee_Entry]') 
    AND type = N'P'
)
BEGIN
    EXEC(' 
        CREATE PROCEDURE [dbo].[SP_Update_HostelFee_Entry]                                       
        (                   
            @Hostel_Fee_Payment_Id BIGINT,                                  
            @StudenOrEmployee_Status BIT,        
            @StudentOrEmployee_Id BIGINT,      
            @Department_Id BIGINT,      
            @Total_Amount DECIMAL(18, 2),        
            @Date DATETIME,      
            @Payment_Mode INT,                    
            @Payment_Due_Date DATETIME,                    
            @Payee_Name VARCHAR(200),                    
            @Payment_No  VARCHAR(200),                    
            @Payment_Date  DATETIME,                    
            @Payment_AccountNo VARCHAR(150),                    
            @Bank_Name VARCHAR(100),                    
            @Bank_Address VARCHAR(300),                    
            @Payment_Amount DECIMAL(18,2),                    
            @Grand_Total DECIMAL(18,2),        
            @ddwhichaccount VARCHAR(50)                    
        )                                       
        AS                                       
        BEGIN TRANSACTION                    
        
        DECLARE @intErrorCode INT                                    
        DECLARE @id BIGINT                                     
        DECLARE @FeeCode VARCHAR(100),                                  
                @InvoiceCodeStartNo VARCHAR(100),                                  
                @code VARCHAR(100),                                  
                @Invoice_Code_Id BIGINT,                                  
                @Invoice_Code_Prefix VARCHAR(100),                                  
                @Invoice_Code_Suffix VARCHAR(100),                                  
                @Invoice_Code_Old VARCHAR(100)                                 
        
        SET @FeeCode = (SELECT TOP 1 Invoice_Code FROM Tbl_Hostel_Fee_Payment ORDER BY Hostel_Fee_Payment_Id DESC)                                    
        SET @InvoiceCodeStartNo = (SELECT Invoice_Code_StartNo FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''HOSTEL'' AND Invoice_Code_Current_Status=1)                                     
        SET @code = ISNULL(@FeeCode+1, @InvoiceCodeStartNo)                                    
        SET @Invoice_Code_Id = (SELECT Invoice_Code_Id FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''HOSTEL'' AND Invoice_Code_Current_Status=1)                                     
        SET @Invoice_Code_Old = (SELECT Invoice_Code FROM Tbl_Hostel_Fee_Payment WHERE Hostel_Fee_Payment_Id=@Hostel_Fee_Payment_Id)                                   
        
        UPDATE Tbl_Hostel_Fee_Payment 
        SET Delete_Status=1 
        WHERE Hostel_Fee_Payment_Id=@Hostel_Fee_Payment_Id               
        
        SELECT @intErrorCode = @@ERROR                                    
        IF (@intErrorCode <> 0) GOTO PROBLEM                  
        
        INSERT INTO [Tbl_Hostel_Fee_Payment]        
            ([StudenOrEmployee_Status], [StudentOrEmployee_Id], [Department_Id], [Invoice_Code_id], [Invoice_Code], [Total_Amount], [Date])        
        VALUES        
            (@StudenOrEmployee_Status, @StudentOrEmployee_Id, @Department_Id, @Invoice_Code_Id, @code, @Total_Amount, @Date)                        
        
        SET @id = (SELECT @@IDENTITY)                  
        
        SELECT @intErrorCode = @@ERROR                                    
        IF (@intErrorCode <> 0) GOTO PROBLEM              
        
        INSERT INTO Tbl_Adjustment (Adjustment_Particular, Adjustment_Particular_Id, Adjustment_Invoice_Code_Id, Adjustment_Invoice_Code_Old, Adjustment_Invoice_Code_New, Adjustment_Date)               
        VALUES (''HOSTEL'', @id, @Invoice_Code_Id, @Invoice_Code_Old, @code, GETDATE())                 
        
        SELECT @intErrorCode = @@ERROR                                    
        IF (@intErrorCode <> 0) GOTO PROBLEM                  
        
        UPDATE Tbl_Hostel_Fee_Payment_Detail 
        SET Delete_Status=1 
        WHERE Hostel_Fee_Payment_Id=@Hostel_Fee_Payment_Id               
        
        SELECT @intErrorCode = @@ERROR                                    
        IF (@intErrorCode <> 0) GOTO PROBLEM                               
        
        EXEC SP_Cancel_Payment_Details ''HOSTEL'', @Hostel_Fee_Payment_Id            
        
        SELECT @intErrorCode = @@ERROR                                    
        IF (@intErrorCode <> 0) GOTO PROBLEM                              
        
        DECLARE @ApprovalId BIGINT                      
        
        INSERT INTO [Tbl_Payment_Approval_List]                      
            ([Approval_Date], [Approval_Due_Date], [Approval_Total_Amount], [Approval_Balance_Amount], [Approval_Status], [Approval_Del_Status])                      
        VALUES                      
            (GETDATE(), @Payment_Due_Date, @Grand_Total, @Grand_Total-@Payment_Amount, 0, 0)                      
        
        SET @ApprovalId = (SELECT @@IDENTITY)                
        
        SELECT @intErrorCode = @@ERROR                                    
        IF (@intErrorCode <> 0) GOTO PROBLEM                    
        
        EXEC SP_Tbl_Payment_Details_Insert @ApprovalId, @Payment_Mode, ''HOSTEL'', @id, 1, @Payment_Amount, @Payee_Name, @Payment_Date, @Payment_No, @Payment_AccountNo, @Bank_Name, @Bank_Address, ''HOSTEL'', '''', '''', '''', '''', @ddwhichaccount                        
        
        SELECT @id               
        
        SELECT @intErrorCode = @@ERROR                                    
        IF (@intErrorCode <> 0) GOTO PROBLEM                       
        
        COMMIT TRANSACTION                                    
        RETURN
        
        PROBLEM:                                    
        IF (@intErrorCode <> 0) BEGIN                                    
            PRINT ''Unexpected error occurred!''                                    
            ROLLBACK TRANSACTION                                    
        END
    ')
END
