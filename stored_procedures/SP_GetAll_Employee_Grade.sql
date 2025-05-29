IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Employee_Grade]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Employee_Grade]  
  
AS  
  
BEGIN  
  
 SELECT  Emp_Grade_Id,Emp_Grade_Name  
  FROM [dbo].[Tbl_Employee_Grade] where Emp_Grade_Status=0
order by Emp_Grade_Name
END
');
END;