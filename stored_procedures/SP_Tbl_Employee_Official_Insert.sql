IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Official_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Official_Insert]  
            @Employee_DOJ datetime,  
            @Employee_Probation_Period varchar(50),  
            @Employee_Confirmation_Date varchar(50),  
            @Employee_Pan_No varchar(50),  
            @Employee_Esi_No varchar(50),  
            @Employee_Payment_mode varchar(50),  
            @Employee_Bank_Account_No varchar(50),  
            @Employee_Bank_Name varchar(200),  
            @Employee_Mode_Job varchar(200),  
            @Employee_Reporting_Staff varchar(200),  
            @Employee_Id bigint,  
            @Department_Id bigint,        
            @PFNO varchar(50),      
            @SocsoNo varchar(50),      
            @KwspNo varchar(50),      
            @BasicSalary decimal,    
            @Insurance_detail varchar(max),    
            @Designation_Id bigint,  
            @ResignedDate datetime,         
            @ExtendResignedDate datetime,         
            @OfficialLastDate datetime  
        AS  
        BEGIN  

            INSERT INTO Tbl_Employee_Official  
            (Employee_DOJ,Employee_Probation_Period,Employee_Confirmation_Date,Employee_Pan_No,  
            Employee_Esi_No,Employee_Payment_mode,Employee_Bank_Account_No,Employee_Bank_Name,Employee_Mode_Job,Employee_Reporting_Staff,  
            Employee_Official_Status,Employee_Id,Department_Id,PFNO,BasicSalary,  
            SocsoNo,  
            KwspNo,Insurance_detail,Designation_Id,Created_Date,Updated_Date,Delete_Status,  
            ResignedDate,ExtendResignedDate,OfficialLastDate)  
            VALUES  
            (@Employee_DOJ,@Employee_Probation_Period,@Employee_Confirmation_Date,@Employee_Pan_No,  
            @Employee_Esi_No,@Employee_Payment_mode,@Employee_Bank_Account_No,@Employee_Bank_Name,@Employee_Mode_Job,@Employee_Reporting_Staff,  
            0,@Employee_Id,@Department_Id,@PFNO,@BasicSalary,  
            @SocsoNo,  
            @KwspNo,@Insurance_detail,@Designation_Id,GETDATE(),GETDATE(),0,@ResignedDate,@ExtendResignedDate,@OfficialLastDate)  
        END
    ')
END
