IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_TimeTable_Check_Time_Match]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_TimeTable_Check_Time_Match]      
(        
    @Duration_Mapping_Id BIGINT,  
    @Day_Id BIGINT,  
    @EmployeeID BIGINT      
)      
AS       
BEGIN      
    SELECT 
        Start_Time, 
        End_Time 
    FROM 
        Tbl_Customize_ClassTiming 
    WHERE 
        Customize_ClassTimingId = (
            SELECT 
                Class_Timings_Id 
            FROM 
                Tbl_Class_TimeTable 
            WHERE 
                Duration_Mapping_Id = @Duration_Mapping_Id 
                AND Day_Id = @Day_Id
                and Employee_Id=@EmployeeID
        );
END
    ')
END
