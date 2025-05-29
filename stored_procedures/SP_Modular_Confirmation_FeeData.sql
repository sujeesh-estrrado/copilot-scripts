IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Confirmation_FeeData]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Modular_Confirmation_FeeData]         
(         
    @CourseId BIGINT 
)        
AS        
BEGIN        
    SELECT 
        ROW_NUMBER() OVER (ORDER BY 
            CASE WHEN MCM.FeeHeading = ''CourseFee'' THEN 0 ELSE 1 END,
            MCM.MapFeeId
        ) AS SlNo,
        MCM.FeeHeading AS FeeType,
        MCM.ModularCourseFee AS Amount
    FROM Tbl_ModularCourseMapFee MCM
    LEFT JOIN Tbl_ModularMappingFee MMO ON MCM.ModularCourseID = MMO.ModularCourseID
    WHERE 
        MCM.DeleteStatus = 0 
        AND MCM.ModularCourseID = @CourseId
    ORDER BY 
        CASE WHEN MCM.FeeHeading = ''CourseFee'' THEN 0 ELSE 1 END,
        MCM.MapFeeId
END
    ')
END