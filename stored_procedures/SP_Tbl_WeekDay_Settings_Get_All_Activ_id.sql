IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_WeekDay_Settings_Get_All_Activ_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_WeekDay_Settings_Get_All_Activ_id]        
      
        
  @dep_id bigint,      
  @Duration_mapping_id bigint      
        
AS          
BEGIN          
--SELECT [WeekDay_Settings_Id]          
--      ,[WeekDay_Name]          
--      ,[WeekDay_Code]          
--      ,[WeekDay_Status]          
--  FROM [Tbl_WeekDay_Settings]          
--WHERE WeekDay_Status=1        
SELECT A.*,B.*          
  FROM   dbo.Tbl_WeekDay_Batch_Mapping  A     
  INNER JOIN dbo.Tbl_WeekDay_Settings B ON B.WeekDay_Settings_Id =A.WeekDay_Settings_Id    
WHERE A.WeekDay_Status=1 and A.Course_Department_Id=@dep_id and A.Duration_Mapping_Id=@Duration_mapping_id      
          
END
    ')
END;
