IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Employee_Grade]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Proc_Update_Employee_Grade]  
(@Emp_Grade_Id bigint,@Emp_Grade_Name varchar(50))  
       
  
AS  
IF  EXISTS (SELECT Emp_Grade_Name FROM [Tbl_Employee_grade] WHERE      
Emp_Grade_Name=@Emp_Grade_Name and Emp_Grade_Status=0 and Emp_Grade_Id<>@Emp_Grade_Id)       
BEGIN        
RAISERROR(''Department already exists.'',16,1);        
END     
else  
BEGIN  
UPDATE [dbo].[Tbl_Employee_grade]  
SET      
Emp_Grade_Name= @Emp_Grade_Name   
         
WHERE   Emp_Grade_Id= @Emp_Grade_Id  
  
END
    ')
END
