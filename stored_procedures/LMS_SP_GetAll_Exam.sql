IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Exam]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Exam]  
            @Exams_Id BIGINT  
        AS  
        BEGIN  
            SET NOCOUNT ON;
            
            SELECT 
                LMS_Tbl_Exams.Exams_Id,
                LMS_Tbl_Exams.Exam_Name,
                LMS_Tbl_Exams.Exam_Date,
                LMS_Tbl_Exams.Exam_Time,
                Tbl_Employee.Employee_FName AS EmployeeName,
                LMS_Tbl_Exams.Status
            FROM LMS_Tbl_Exams
            INNER JOIN Tbl_Employee ON LMS_Tbl_Exams.Emp_Id = Tbl_Employee.Employee_Id
            WHERE LMS_Tbl_Exams.Exams_Id = @Exams_Id;
        END
    ')
END
