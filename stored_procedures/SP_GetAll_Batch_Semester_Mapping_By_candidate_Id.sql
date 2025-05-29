IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Batch_Semester_Mapping]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_Batch_Semester_Mapping] 
@Course_Category_Id bigint,
@Department_Id bigint
AS
BEGIN
SELECT 
Duration_Mapping_Id,
Batch_Code+''-''+Semester_Code AS BatchSemester,Batch_Code,Semester_Code
FROM Tbl_Course_Duration_Mapping cdm 
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id 
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id
WHERE cdm.Course_Department_Id IN (Select Course_Department_Id From Tbl_Course_Department WHERE Department_Id=@Department_Id and Course_Category_Id=@Course_Category_Id)
END

    ')
END
GO
