IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Candidate_Program_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_Candidate_Program_Details]
(@StudentID bigint
)
as 
begin
	SELECT        SS.Student_Semester_Id, SS.Candidate_Id, SS.Student_Semester_Current_Status, SS.Student_Semester_Delete_Status, SS.PromoteFrom_Date, 
							 CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS StudentName, cbd.Batch_Code + ''-'' + cs.Semester_Code AS BatchSemester, 
							 dbo.Tbl_Department.Department_Name AS Program, dbo.Tbl_Department.Course_Code AS ProgramCode, cbd.Batch_Code
	FROM            dbo.Tbl_Student_Semester AS SS INNER JOIN
							 dbo.Tbl_Candidate_Personal_Det AS CPD ON CPD.Candidate_Id = SS.Candidate_Id left outer JOIN
							 dbo.Tbl_Candidate_ContactDetails AS cc ON cc.Candidate_Id = CPD.Candidate_Id left outer  JOIN
							 dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id left outer  JOIN
							 dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id left outer  JOIN
							 dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id left outer  JOIN
							 dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id left outer  JOIN
							 dbo.Tbl_Department ON cdm.Course_Department_Id = dbo.Tbl_Department.Department_Id
	WHERE        (SS.Student_Semester_Delete_Status = 0) AND (CPD.Candidate_Id = @StudentID)
end
');
END;