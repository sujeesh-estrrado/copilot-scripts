IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Emp_Details_By_Emp_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Emp_Details_By_Emp_Id]
@Emp_Id bigint
as  
begin 
SELECT    E.Employee_Id,E.Employee_FName +'' ''+E.Employee_LName as [Name], EE.Employee_Desigination,E.Employee_Type
FROM         Tbl_Employee E INNER JOIN
                      Tbl_Employee_Experience EE ON E.Employee_Id = EE.Employee_Id
where EE.Employee_Id = @Emp_Id
END
');
END;
