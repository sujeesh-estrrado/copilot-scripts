IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Store_Mapping_By_EMployee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employee_Store_Mapping_By_EMployee_Id] 
(  
@Employee_Id bigint  
)  
  
as  
  
begin  
  
select ES.*,E.Employee_FName+'' ''+E.Employee_LName as Employee_Name from dbo.Tbl_Employee_Store_Mapping ES 
left join Tbl_Employee E on ES.Employee_Id=E.Employee_Id where ES.Employee_Id=@Employee_Id  
  
end

	');
END;
