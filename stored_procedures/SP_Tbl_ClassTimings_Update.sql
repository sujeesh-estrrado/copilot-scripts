IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ClassTimings_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[SP_Tbl_ClassTimings_Update]  
(
    @Hour_Name VARCHAR(150),        
    @Start_Time DATETIME,        
    @End_Time DATETIME,        
    @Is_BreakTime BIT,  
    @Class_Timings_Id BIGINT,  
    @Department_Id BIGINT,    
    @Batch_Id BIGINT,    
    @Days VARCHAR(100),    
    @ClassTiming_GroupName VARCHAR(MAX),    
    @Day_Id VARCHAR(MAX) 
)   
AS  
BEGIN   

    UPDATE Tbl_Customize_ClassTiming    
    SET Hour_Name = @Hour_Name,  
        Start_Time = @Start_Time,  
        End_Time = @End_Time,  
        Is_BreakTime = @Is_BreakTime 
    WHERE Customize_ClassTimingId = @Class_Timings_Id 
      AND ClassTiming_Status = 0;   
   
    DELETE FROM Tbl_Customize_ClassTimingMapping 
    WHERE Customize_ClassTimingId = @Class_Timings_Id;   
     
    INSERT INTO Tbl_Customize_ClassTimingMapping (
        Customize_ClassTimingId,
        Days_Id,
        Department_Id,
        Batch_Id,
        Location_Id,
        Group_Name,
        Group_Id
    )
    SELECT 
        @Class_Timings_Id, 
        TRIM([Value]),  
        @Department_Id, 
        @Batch_Id, 
        0, 
        @ClassTiming_GroupName, 
        0
    FROM dbo.SplitStringFunction(@Day_Id, '','') 
    WHERE TRIM([Value]) <> '''' AND TRIM([Value]) IS NOT NULL; 
END  
    ')
END
