IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SeatCapacity_GetAllBy_BatchId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_SeatCapacity_GetAllBy_BatchId]
	(@batchid BIGINT)
	
AS
BEGIN	
	SELECT a.Duration_Period_Id, a.Batch_Id, a.Semester_Id, b.Duration_Mapping_Id, b.Duration_Period_Id,
	b.Course_Department_Id AS CourseDepartment, c.Department_Id AS DepartmentId, d.Department_Name AS DepartmentName
	FROM dbo.Tbl_Course_Duration_PeriodDetails a 
	LEFT JOIN dbo.Tbl_Course_Duration_Mapping b ON a.Duration_Period_Id = b.Duration_Period_Id 
	LEFT JOIN dbo.Tbl_Course_Department c ON b.Course_Department_Id = c.Course_Department_Id
	LEFT JOIN dbo.Tbl_Department d ON c.Department_Id = d.Department_Id
	WHERE a.Batch_Id = @batchid
END
');
END;