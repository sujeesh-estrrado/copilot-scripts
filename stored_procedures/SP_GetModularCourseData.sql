IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetModularCourseData]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetModularCourseData] 

    @Flag INT,
    @modularCourseId BIGINT
AS
BEGIN

IF(@Flag = 1)

BEGIN

WITH FeeWithRowNum AS (
    SELECT 
        MC.Id AS CourseId,
        MC.CourseName,
        MC.CourseCode,
        ISNULL(MCMP.MapFeeID, 0) AS MapFeeID,
        ROW_NUMBER() OVER (PARTITION BY MC.Id ORDER BY MCMP.MapFeeID DESC) AS RowNum
    FROM tbl_Modular_Courses MC
    LEFT JOIN Tbl_ModularCourseMapFee MCMP ON MC.Id = MCMP.ModularCourseID
    WHERE MC.Isdeleted = 0 
)
SELECT CourseId, CourseName, CourseCode, MapFeeID
FROM FeeWithRowNum
WHERE RowNum = 1


END

IF(@flag = 2)
BEGIN


    SELECT 
        MC.Id AS CourseId,
        ISNULL(MCMP.MapFeeID, 0) AS MapFeeID,
        MCMP.FeeHeading AS [FeeHeading],
        MCMP.ModularCourseFee AS [ModularCourseFee],
        MCMP.Ischecked AS [CheckBox]
    FROM tbl_Modular_Courses MC
    LEFT JOIN Tbl_ModularCourseMapFee MCMP ON MC.Id = MCMP.ModularCourseID
    WHERE MC.Isdeleted = 0 and ModularCourseID = @modularCourseId


END



END
    ')
END;
