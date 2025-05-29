IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ClassTimeTable_Automatic]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_ClassTimeTable_Automatic]            
(            
@Semster_Subject_Id bigint,            
@Duration_Mapping_Id bigint,            
@WeekDay_Settings_Id bigint,            
@Class_Timings_Id bigint,            
@Employee_Id bigint            
)            
AS            
BEGIN      
Declare @SubjMaxHr int    
Declare @EmpMaxHr int    
    
SET @SubjMaxHr=(Select Top 1 Subject_MaxHours From Tbl_Subject_Hours_PerWeek Where Semester_Subject_Id=@Semster_Subject_Id)    
SET @EmpMaxHr=(Select Top 1 Hours_per_week From Tbl_Employee_Working_Hours Where Employee_Id=@Employee_Id)    
    
IF (@EmpMaxHr<>(Select Count(Class_TimeTable_Id) From Tbl_Class_TimeTable Where Employee_Id=@Employee_Id))    
 BEGIN    
IF (@SubjMaxHr<>(Select Count(Class_TimeTable_Id) From Tbl_Class_TimeTable Where Semster_Subject_Id=@Semster_Subject_Id))    
 BEGIN    
   IF not exists(select * from Tbl_Class_TimeTable where Employee_Id=@Employee_Id        
    and WeekDay_Settings_Id=@WeekDay_Settings_Id and Class_Timings_Id=@Class_Timings_Id)        
   BEGIN        
    IF NOT EXISTS(Select * from Tbl_Class_TimeTable WHERE Duration_Mapping_Id=@Duration_Mapping_Id and            
       WeekDay_Settings_Id=@WeekDay_Settings_Id and Class_Timings_Id=@Class_Timings_Id and Class_TimeTable_Status=0)            
     BEGIN            
       INSERT INTO Tbl_Class_TimeTable(Semster_Subject_Id,Duration_Mapping_Id,WeekDay_Settings_Id,Class_Timings_Id,Employee_Id)            
       VALUES(@Semster_Subject_Id,@Duration_Mapping_Id,@WeekDay_Settings_Id,@Class_Timings_Id,@Employee_Id)        
    SELECT @@identity           
     END         
    ELSE        
      SELECT -1  --Class alloted for that period    
   END        
  ELSE        
   SELECT -2    --Class alloted for Employee     
END        
    ELSE        
   SELECT -3    --Subject Max Hours Exceeded    
END      
ELSE        
   SELECT -4    --Employee Max Hours Exceeded    
END');
END;
