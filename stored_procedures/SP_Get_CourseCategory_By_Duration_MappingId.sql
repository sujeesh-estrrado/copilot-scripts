IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CourseCategory_By_Duration_MappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CourseCategory_By_Duration_MappingId]       
@Duration_Mapping_Id bigint      
As      
Begin      
 Select 
 CDM.Course_Department_Id 
 From  Tbl_Course_Duration_Mapping CDM 
  Where Duration_Mapping_Id=@Duration_Mapping_Id     
    
End
    ');
END;
