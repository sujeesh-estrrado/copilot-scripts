IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_ClassTimeTable_ByWeekSemAndSubject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_Delete_ClassTimeTable_ByWeekSemAndSubject]    
 (@WeekDay_Settings_Id bigint,    
  @Duration_Mapping_Id bigint,@Class_Timings_Id bigint    
)    
AS     
BEGIN    

 --DELETE FROM Tbl_Class_TimeTable WHERE     
 --            Class_Timings_Id=@WeekDay_Settings_Id     
 -- and Duration_Mapping_Id=@Duration_Mapping_Id    
 --       and Class_Timings_Id=@Class_Timings_Id 
        

        UPDATE  Tbl_Class_TimeTable SET
        Del_Status=1 WHERE 
         Duration_Mapping_Id=@Duration_Mapping_Id    
        and Class_Timings_Id=@Class_Timings_Id 
        AND Day_Id= @WeekDay_Settings_Id

           
END
    ')
END
