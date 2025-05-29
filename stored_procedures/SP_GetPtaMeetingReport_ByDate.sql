IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetPtaMeetingReport_ByDate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetPtaMeetingReport_ByDate]    
@From_Date datetime,      
@To_Date datetime                   
AS                  
BEGIN                  
SELECT                  
Date,                  
Time,                  
ChairedBy,                  
SpecialGuest           
                  
                  
FROM   dbo.Tbl_Pta_Meeting_Entry               
         
WHERE Date between @From_Date and @To_Date               
END
');
END;