IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Store_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employee_Store_Mapping]  
  
    
as    
    
begin    
 Select * from   
(select ROW_NUMBER() OVER(PARTITION BY ES.Employee_Id ORDER BY ES.Employee_Id) As RNO,
 ES.Employee_Store_Mapping_Id, ES.Employee_Id,E.Employee_FName+'' ''+E.Employee_LName as Employee_Name from dbo.Tbl_Employee_Store_Mapping ES   
 inner join Tbl_Employee E on ES.Employee_Id=E.Employee_Id 
) As tbl where RNO=1 order by Employee_Store_Mapping_Id desc
end

	');
END;
