IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Promoted_Student_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          
CREATE procedure [dbo].[Get_Promoted_Student_Details]           
--[dbo].[Get_Promoted_Student_Details] 47          
@Candidate_Id bigint          
as          
begin     

   
SELECT        SS.Student_Semester_Id, SS.Candidate_Id, SS.Duration_Mapping_Id, SS.Student_Semester_Current_Status, SS.Student_Semester_Delete_Status, CPD.CounselorEmployee_id, SS.IC_PASSPORT, SS.COURSE_CODE,           
                         SS.INTAKE_NUMBER, SS.STUDY_MODE, SS.SEMESTER_NO AS Semester_Name, SS.BatchId, SS.SemesterId, SS.FromDate, SS.ToDate, SS.Duration_Period_Id, SS.PromoteFrom_Date, SS.PromoteTo_Date,           
                         SS.Old_SemesterName, SS.Created_Date, SS.Updated_Date, SS.Delete_Status,CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname)  AS StudentName, cbd.Batch_Code AS Intake, CONCAT(cbd.Batch_Code, ''-'',           
                         cs.Semester_Code)  AS BatchSemester, CPD.IDMatrixNo, CPD.Active_Status, CPD.AdharNumber, CPD.ApplicationStatus, cs.Semester_Name AS Expr1, CD.Department_Name, CD.Course_Code AS ProgramCode,           
                         CL.Course_Level_Name, CPD.Candidate_Img, cbd.Batch_Id AS IntakeID, CPD.TypeOfStudent, CD.Department_Id AS DepartmentID, CONCAT(cc.Candidate_PermAddress, '' '', cc.Candidate_PermAddress_Line2, '' '',           
       con.country,'' '',ste.State_Name,'' '',cty.City_Name, '' '', cc.Candidate_PermAddress_postCode)  AS StudentAddress, cdp.Semester_Id, S.name AS StudentStatus          
FROM            dbo.Tbl_Course_Level AS CL INNER JOIN          
                         dbo.Tbl_Department AS CD ON CL.Course_Level_Id = CD.GraduationTypeId RIGHT OUTER JOIN          
                         dbo.Tbl_Candidate_Personal_Det AS CPD LEFT OUTER JOIN          
                         dbo.Tbl_Candidate_ContactDetails AS cc ON cc.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN          
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Category AS cA ON NA.Course_Category_Id = cA.Course_Category_Id ON CD.Department_Id = NA.Department_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Semester AS SS ON CPD.Candidate_Id = SS.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_status AS S ON S.id = CPD.active LEFT OUTER JOIN           
       dbo.Tbl_Country AS con ON cc.Candidate_PermAddress_Country=con.Country_Id LEFT OUTER JOIN           
        dbo.Tbl_State AS ste ON cc.Candidate_PermAddress_State=ste.State_Id LEFT OUTER JOIN           
         dbo.Tbl_City AS cty ON cc.Candidate_PermAddress_City=cty.City_id          
WHERE        (CPD.Candidate_Id = @Candidate_Id)          
        
 
end   
    ')
END
