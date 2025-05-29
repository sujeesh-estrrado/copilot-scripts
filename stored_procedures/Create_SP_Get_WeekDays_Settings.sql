IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_WeekDays_Settings]')
    AND type = N'P'
)
BEGIN
    EXEC('
 
CREATE PROCEDURE [dbo].[SP_Get_WeekDays_Settings]
@Course_Department_Id BIGINT
AS
BEGIN 
    SELECT WDS.WeekDay_Settings_Id,
           WDS.WeekDay_Name,
           WDS.WeekDay_Code,
           ISNULL(DW.Checked_Status, 0) AS WeekDay_Status   
    FROM Tbl_WeekDay_Settings WDS
    LEFT JOIN Tbl_Day_Week DW
        ON WDS.WeekDay_Settings_Id = DW.WeekDay_Settings_Id
        AND DW.Status = 1
        AND DW.Dept_Id = @Course_Department_Id 
END

    ')
END
GO
