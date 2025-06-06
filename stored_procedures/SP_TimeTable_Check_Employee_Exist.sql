IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_TimeTable_Check_Employee_Exist]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        Create procedure [dbo].[SP_TimeTable_Check_Employee_Exist]      
 (        
  @Duration_Mapping_Id bigint,  
  @Day_Id bigint,  
  @EmployeeID bigint      
)      
AS       
BEGIN      

SELECT COUNT(1) FROM Tbl_Class_TimeTable WHERE Duration_Mapping_Id = @Duration_Mapping_Id AND Day_Id = @Day_Id
      
END

    ')
END
