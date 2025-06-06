IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_ClassTimeTable_ByWeekSemAndSubjectAndEmp]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_ClassTimeTable_ByWeekSemAndSubjectAndEmp]      
 (  
  @WeekDay_Settings_Id bigint,      
  @Duration_Mapping_Id bigint,  
  @Class_Timings_Id bigint,  
  @EmployeeID bigint      
)      
AS       
BEGIN      
 --DELETE FROM Tbl_Class_TimeTable WHERE       
 --            --WeekDay_Settings_Id=@WeekDay_Settings_Id       
 --            Duration_Mapping_Id=@Duration_Mapping_Id      
 --            and Class_Timings_Id=@Class_Timings_Id   
 --   and  Employee_Id=@EmployeeID  

 
        UPDATE  Tbl_Class_TimeTable SET
        Del_Status=1 WHERE 
         Day_Id=@WeekDay_Settings_Id 
         AND  Class_Timings_Id=@Class_Timings_Id
        AND Duration_Mapping_Id=@Duration_Mapping_Id
        and Employee_Id=@EmployeeID 



      
END
    ')
END
