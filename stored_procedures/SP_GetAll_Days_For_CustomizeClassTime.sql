IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Days_For_CustomizeClassTime]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetAll_Days_For_CustomizeClassTime]   
@Dept_Id bigint,            
@Location_Id bigint =0
AS  
BEGIN   

  SELECT WDS.WeekDay_Settings_Id AS Day_Id,
           WDS.WeekDay_Name AS Days,
           WDS.WeekDay_Code,
           ISNULL(DW.Checked_Status, 0) AS WeekDay_Status   
    FROM Tbl_WeekDay_Settings WDS
    INNER JOIN Tbl_Day_Week DW
        ON WDS.WeekDay_Settings_Id = DW.WeekDay_Settings_Id
        AND DW.Status = 1
        AND DW.Dept_Id = @Dept_Id
END  
');
END;