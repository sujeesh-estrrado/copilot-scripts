-- Create Get_Student_Details procedure if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Student_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Get_Student_Details] --446
@Candidate_Id bigint
as
begin
   
SELECT        SS.Student_Semester_Id, SS.Candidate_Id, SS.Duration_Mapping_Id, SS.Student_Semester_Current_Status, SS.Student_Semester_Delete_Status, 
                         SS.IC_PASSPORT, SS.COURSE_CODE, SS.INTAKE_NUMBER, SS.STUDY_MODE, SS.SEMESTER_NO, SS.BatchId, SS.SemesterId, SS.FromDate, SS.ToDate, 
                         SS.Duration_Period_Id, SS.PromoteFrom_Date, SS.PromoteTo_Date, SS.Old_SemesterName, SS.Created_Date, SS.Updated_Date, SS.Delete_Status, 
                         CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS StudentName, cbd.Batch_Code + ''-'' + cs.Semester_Code AS BatchSemester, 
                         CPD.IDMatrixNo, CPD.Active_Status, CPD.AdharNumber, CPD.ApplicationStatus, CPD.TypeOfStudent,CPD.New_admission_id,na.batch_id as intake,na.department_id as pgmid
FROM            dbo.Tbl_Student_Semester AS SS INNER JOIN
                         dbo.Tbl_Candidate_Personal_Det AS CPD ON CPD.Candidate_Id = SS.Candidate_Id INNER JOIN
                         dbo.Tbl_Candidate_ContactDetails AS cc ON cc.Candidate_Id = CPD.Candidate_Id left JOIN
                         tbl_new_admission na on na.new_admission_id=CPD.new_admission_id left join
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id left JOIN
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id left JOIN
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id left JOIN
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id   
where SS.Candidate_Id=@Candidate_Id and SS.Student_Semester_Delete_Status=0    
end
    ')
END;
GO
