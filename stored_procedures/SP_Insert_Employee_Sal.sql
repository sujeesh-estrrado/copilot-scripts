IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Employee_Sal]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_Employee_Sal]      
(@Grade_Id bigint ,@Emp_Id bigint , @Basic_Salary decimal(10,2) , @Date varchar(15) ,@Date_Time datetime , @Gross_Salary decimal(10,2) )      
      
AS      
   
IF EXISTS(SELECT @Grade_Id FROM Tbl_Employee_Salary Where Grade_Id = @Grade_Id and Emp_Id=@Emp_Id and Date=@Date )      
BEGIN      
RAISERROR (''Data Already Exists.'', -- Message text.      
               16, -- Severity.      
               1 -- State.      
               );      
END      
ELSE  
   
BEGIN      
      
  INSERT INTO Tbl_Employee_Salary (Grade_Id,Emp_Id,Basic_Salary,Date,Date_Time,Gross_Salary)      
   VALUES(@Grade_Id,@Emp_Id,@Basic_Salary,@Date,@Date_Time,@Gross_Salary)       
    
select SCOPE_IDENTITY()     
    
END');
END;
