IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Duration_Mapping_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Duration_Mapping_By_Id]  
(  
@Duration_Mapping_Id bigint  
)  
as  
begin  
  
  
SELECT [Duration_Mapping_Id]  
      ,[Duration_Period_Id]  
      ,[Course_Department_Id]  
      ,[Course_Department_Status]  
  FROM [Tbl_Course_Duration_Mapping] where [Duration_Mapping_Id]=@Duration_Mapping_Id  
  
end
');
END;