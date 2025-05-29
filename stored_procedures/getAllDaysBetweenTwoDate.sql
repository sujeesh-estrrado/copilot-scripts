IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[getAllDaysBetweenTwoDate]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[getAllDaysBetweenTwoDate]    
(    
@FromDate DATETIME,        
@ToDate DATETIME    
)    
AS    
BEGIN    
        
    DECLARE @TOTALCount INT    
    SET @FromDate = DATEADD(DAY,-1,@FromDate)    
    Select  @TOTALCount= DATEDIFF(DD,@FromDate,@ToDate);    
    
    WITH d AS     
            (    
              SELECT top (@TOTALCount) AllDays = DATEADD(DAY, ROW_NUMBER()     
                OVER (ORDER BY object_id), REPLACE(@FromDate,''-'',''''))    
              FROM sys.all_objects    
            )    
        SELECT AllDays From d    
            
    RETURN     
END
    ')
END;
