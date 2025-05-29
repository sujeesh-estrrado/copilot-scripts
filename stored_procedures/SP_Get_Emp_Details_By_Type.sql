IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Emp_Details_By_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Emp_Details_By_Type]

as  
begin 

select Employee_Id,Employee_FName+''''+Employee_LName as [Name] , Employee_Type from Tbl_Employee 
where Employee_Type=''Teaching''

end
');
END;
