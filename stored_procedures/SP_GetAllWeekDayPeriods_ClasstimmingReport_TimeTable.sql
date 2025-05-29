IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllWeekDayPeriods_ClasstimmingReport_TimeTable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE PROCEDURE [dbo].[SP_GetAllWeekDayPeriods_ClasstimmingReport_TimeTable]   
@Class_Timings_Id bigint ,
@Dept_Id BIGINT,
@BatchID BIGINT,
@Location_Id BIGINT     =0   
AS          
BEGIN     
         
--SELECT 
--CT.Class_Timings_Id    AS Class_Timings_Id,
--CCT.Is_BreakTime   
--FROM 
--Tbl_Class_TimeTable CT 
--INNER JOIN  Tbl_Customize_ClassTiming CCT ON CT.Class_Timings_Id=CCT.Customize_ClassTimingId
--WHERE 
--CT.Class_Timings_Id=@Class_Timings_Id
--AND CT.Department_Id=@Dept_Id
--AND CT.Duration_Mapping_Id=@BatchID
      


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
