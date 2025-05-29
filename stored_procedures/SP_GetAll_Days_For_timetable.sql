IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Days_For_timetable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetAll_Days_For_timetable]   
@Dept_Id     BIGINT,  
@BatchID     BIGINT,
@Location_Id BIGINT =0
AS  
BEGIN   
 
  --SELECT DISTINCT
  --         WDS.WeekDay_Settings_Id AS ID,
  --         WDS.WeekDay_Name AS Name,
  --         WDS.WeekDay_Code,
  --         ISNULL(DW.Day_Week_Status, 0) AS Day_Week_Status   
  --  FROM       
	 --      Tbl_WeekDay_Settings WDS
  --         INNER JOIN Tbl_Day_Week DW
		--   ON WDS.WeekDay_Settings_Id = DW.WeekDay_Settings_Id
  --         AND DW.Status = 1
		--   AND DW.Checked_Status=1
  --         AND DW.Dept_Id = @Dept_Id

   SELECT DISTINCT
           WDS.WeekDay_Settings_Id AS ID,
           WDS.WeekDay_Name AS Name,
           WDS.WeekDay_Code,
           ISNULL(DW.Day_Week_Status, 0) AS Day_Week_Status   
    FROM       
	       Tbl_Customize_ClassTimingMapping  CCTM
           INNER JOIN Tbl_WeekDay_Settings   WDS ON CCTM.Days_Id=WDS.WeekDay_Settings_Id
		   INNER JOIN Tbl_Day_Week			 DW  ON WDS.WeekDay_Settings_Id = DW.WeekDay_Settings_Id
		  INNER JOIN Tbl_Course_Duration_PeriodDetails CCP ON CCTM.Batch_Id=CCP.Duration_Period_Id

		   AND DW.Status = 1
		   AND DW.Checked_Status=1
           AND CCTM.Department_Id = @Dept_Id
		   AND CCTM.Batch_Id=@BatchID
  
		   
		   END
');
END;