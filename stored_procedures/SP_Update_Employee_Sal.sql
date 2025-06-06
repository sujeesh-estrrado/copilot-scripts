IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Employee_Sal]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Employee_Sal]    
(@Employee_Salary_Id bigint, @Grade_Id bigint ,@Emp_Id bigint , @Basic_Salary decimal(10,2) , @Date varchar(15) ,@Date_Time datetime , @Gross_Salary decimal(10,2)  )    
    
AS    
    
BEGIN    
    
UPDATE Tbl_Employee_Salary  
SET Grade_Id=@Grade_Id,  
 Basic_Salary=@Basic_Salary,  
 Date=@Date,  
 Date_Time=@Date_Time,   
 Gross_Salary=@Gross_Salary   
  
WHERE  Emp_Id= @Emp_Id AND Employee_Salary_Id=@Employee_Salary_Id
  
END
    ')
END
