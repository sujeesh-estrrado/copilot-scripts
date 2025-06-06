IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Emp_Department_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Emp_Department_By_Id](@Dept_Id bigint)  
as  
begin  
select Dept_Id as ID,Dept_Name as Department,Dept_ShortName as [Short Name],Dept_Head as HOD,Dept_Signature as Signature  
,Parent_Dept from Tbl_Emp_Department  
where Dept_Status=0 and Dept_Id=@Dept_Id  
end
    ')
END
