IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Timetable_By_DurationMappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Timetable_By_DurationMappingId]       
@Duration_Mapping_Id bigint      
As      
Begin    
Delete From Tbl_Class_TimeTable Where 
Duration_Mapping_Id=@Duration_Mapping_Id
End
    ')
END
