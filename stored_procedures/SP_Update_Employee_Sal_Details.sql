IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Employee_Sal_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Employee_Sal_Details]  
(@Salary_Details_Id bigint,@Salary_Head_Id bigint ,@Employee_Salary_Id bigint , @Grade_Sal_Value decimal(10,2) , @Mode_Calculation varchar(10), @Salary_Type varchar(100))  
  
AS  
  
BEGIN  
  
UPDATE Tbl_Employee_Salary_Details 
SET Salary_Head_Id=@Salary_Head_Id,
    Employee_Salary_Id=@Employee_Salary_Id,
    Grade_Sal_Value=@Grade_Sal_Value,
    Mode_Calculation=@Mode_Calculation,
    Salary_Type=@Salary_Type

WHERE Salary_Details_Id=@Salary_Details_Id  
  
END
    ')
END
