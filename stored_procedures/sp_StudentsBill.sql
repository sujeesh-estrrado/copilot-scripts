IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentsBill]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_StudentsBill] 
--[dbo].[sp_StudentsBill] 1,1,1,1,'''',1
@FacultyId bigint = 0 ,
@ProgramId bigint = 0 ,
@Intakeid bigint = 0 ,
@Type varchar(50) ,
@Semesterno bigint = 0 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
            SELECT        distinct (CPD.Candidate_Id), CPD.IdentificationNo, CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname) 
                    AS StudentName, CPD.Candidate_Dob, CPD.Candidate_Img, CPD.Initial_Application_Id, CPD.New_Admission_Id, CPD.AdharNumber AS ICPassport, 
                    CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, CPD.Status, CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo, 
                    CPD.ApplicationStatus, CPD.FeeStatus, CPD.Mode_Of_Study, CPD.Edit_status, dbo.Tbl_Student_Semester.Candidate_Id AS Expr1, CDM.Duration_Mapping_Id, 
                    cd.Duration_Period_Id, cd.Batch_Id, cd.Semester_Id, CONVERT(varchar(50), cd.Duration_Period_From, 103) AS Duration_Period_From, CONVERT(varchar(50), 
                    cd.Duration_Period_To, 103) AS Duration_Period_To, cd.Duration_Period_Status, cs.Semester_Name, bd.Batch_Code, CONVERT(varchar(50), cd.Closing_Date, 103) 
                    AS Closing_Date, D.Department_Name AS Program, D.Course_Code AS ProgramCode, CL.Course_Level_Name,D.Department_Id

        FROM            dbo.Tbl_Candidate_Personal_Det AS CPD 
                    LEFT OUTER JOIN
                    dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN
                    dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN
                    dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN
                    dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id LEFT OUTER JOIN
                    dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cd.Semester_Id ON CDM.Duration_Period_Id = cd.Duration_Period_Id LEFT OUTER JOIN
                    dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = CDM.Course_Department_Id LEFT OUTER JOIN
                    dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN
                    dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId   
        WHERE        
                         (CPD.TypeOfStudent = @Type or @Type='''' ) and (cd.Semester_Id = @Semesterno or @Semesterno=0)and(cd.Batch_Id= @Intakeid or @Intakeid=0 )and(D.Department_Id = @ProgramId or @ProgramId=0 )and(CL.Course_Level_Id = @FacultyId or @FacultyId=0 )
                    
                    
                     
END
    ')
END
