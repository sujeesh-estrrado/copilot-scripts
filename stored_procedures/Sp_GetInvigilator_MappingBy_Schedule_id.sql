IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetInvigilator_MappingBy_Schedule_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetInvigilator_MappingBy_Schedule_id]
(
    @schedule_id BIGINT = 0
)
AS
BEGIN
    SELECT 
        E.Employee_Id,
        CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS EmployeeName 
    FROM
        Tbl_Employee E 
    INNER JOIN Invigilator_Mapping I ON I.Employee_id = E.Employee_Id
    WHERE 
        I.Exam_Schedule_Details_Id = @schedule_id
END
');
END;