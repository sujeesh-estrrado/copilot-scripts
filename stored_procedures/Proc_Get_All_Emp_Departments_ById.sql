IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_All_Emp_Departments_ById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Get_All_Emp_Departments_ById]    
  @Dept_Id bigint=0
as      
begin      
      
select Dept_Id,Dept_Id as ID ,Dept_Name,Dept_Name as Department, Dept_ShortName as [Short Name],Dept_Head as HOD,Parent_Dept as PId    
from Tbl_Emp_Department      
where Dept_Status=0 and Delete_Status=0 and Dept_Id!=@Dept_Id   
order by Dept_Name    
      
      
end
    ')
END
