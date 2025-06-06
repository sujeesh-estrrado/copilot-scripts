IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Employee_Grade_BY_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Employee_Grade_BY_Employee_Id](@Employee_Id bigint)  
  
AS  
  
BEGIN  
  
 select EG.Emp_Grade_Id,
   EG.Emp_Grade_Name  
 from dbo.Tbl_Grade_Mapping GM 
Inner join Tbl_Employee_Grade EG on EG.Emp_Grade_Id=GM.Emp_Grade_Id
 where EG.Emp_Grade_Status=0 and GM.Employee_Id=@Employee_Id  
END
    ')
END
