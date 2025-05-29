IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllWeekDayPeriods_TimeTable_ClassTiming_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetAllWeekDayPeriods_TimeTable_ClassTiming_Report] -- 1,5,5,100    
@Class_Timings_Id bigint ,
@Dept_Id BIGINT,
@BatchID BIGINT,
@Location_Id BIGINT     =0   
AS          
BEGIN     


SELECT 
CT.Customize_ClassTimingId    AS Class_Timings_Id,
CT.Is_BreakTime   
FROM 
Tbl_Customize_ClassTiming CT 
INNER JOIN  Tbl_Customize_ClassTimingMapping CCT ON CT.Customize_ClassTimingId=CCT.Customize_ClassTimingId 
WHERE 
CT.Customize_ClassTimingId=@Class_Timings_Id
AND CCT.Department_Id=@Dept_Id
AND CCT.Batch_Id=@BatchID

 

END      ')
END;
