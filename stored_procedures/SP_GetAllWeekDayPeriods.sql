IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllWeekDayPeriods]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE PROCEDURE [dbo].[SP_GetAllWeekDayPeriods] -- 1,5,5,100    
@Class_Timings_Id bigint ,
--@Dept_Id BIGINT,
--@BatchID BIGINT,
@Location_Id BIGINT     =0   
AS          
BEGIN     
 
SELECT   
CCT.Customize_ClassTimingId  AS Class_Timings_Id, 
CCT.Is_BreakTime   
FROM       Tbl_Customize_ClassTiming        CCT 
INNER JOIN Tbl_Customize_ClassTimingMapping CCTM ON CCT.Customize_ClassTimingId=CCTM.Customize_ClassTimingId
WHERE 
CCT.ClassTiming_Status=0 
AND CCT.Customize_ClassTimingId=@Class_Timings_Id
--AND CCTM.Department_Id=@Dept_Id
--AND CCTM.Batch_Id=@BatchID


END ')
END;
