IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insertinto_DepartmentSales]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insertinto_DepartmentSales](       
 @Department_Id bigint      
,@CustomerName varchar(100)    
,@Op_Number varchar(max)     
,@Remarks varchar(max)      
,@Invoice_Date DateTime      
,@Invoice_Number bigint      
,@GrandTotal decimal(18,2)      
)      
AS      
Begin      
Insert into Tbl_DepartmentSales    
(       
Dept_Id,      
Customer_Name,    
Op_Number,    
Remarks,      
Invoice_Date,      
Invoice_Number,      
Grand_Total      
)      
values      
(        
@Department_Id,      
@CustomerName,   
@Op_Number,     
@Remarks,      
@Invoice_Date,      
@Invoice_Number,      
@GrandTotal      
)      
select Scope_Identity();    
End')
END
