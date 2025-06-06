IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_WeekDay_Settings_Get_All_Active]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE PROCEDURE [dbo].[SP_Tbl_WeekDay_Settings_Get_All_Active]      
@Location_Id BIGINT  =0,
@Employee_Id BIGINT
AS      
BEGIN       

SELECT DISTINCT
W.WeekDay_Settings_Id AS Day_Id,
W.WeekDay_Name        AS [Days]
FROM Tbl_WeekDay_Settings W
INNER JOIN Tbl_Class_TimeTable CT ON W.WeekDay_Settings_Id=CT.Day_Id
WHERE W.WeekDay_Status=1 
AND CT.Employee_Id=@Employee_Id
AND CT.Del_Status=0     
END 
    ')
END
