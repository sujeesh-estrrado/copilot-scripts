IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Payment_Dtls]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[Get_Payment_Dtls]
    @Candidate_Id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT distinct
        CC.Candidate_Id,
        Concat(Candidate_Fname , '' '' , CPD.Candidate_Lname) AS CandidateName,
        CC.Candidate_Email,
        FORMAT(CPD.RegDate, ''dd/MM/yyyy'') AS regdate,
        FORMAT(CAST(DATEADD(DAY, 7, CAST(CPD.RegDate AS DATE)) AS DATE), ''dd/MM/yyyy'') AS paymentdate,
        CPD.New_Admission_Id,
        D.Department_Name,
         FG.totallocal as Localamount, FG.totalintl as Internationalamount,
        (CASE 
            WHEN CPD.TypeOfStudent = ''LOCAL'' THEN ''Local''
            WHEN CPD.TypeOfStudent = ''INTERNATIONAL'' THEN ''International''
            ELSE ''-NA-'' 
        END) AS TypeOfStudent
    FROM 
        Tbl_Candidate_ContactDetails CC 
    LEFT JOIN 
        Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = CC.Candidate_Id 
    LEFT JOIN 
        tbl_new_admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id 
    LEFT JOIN 
        Tbl_Department D ON D.Department_Id = NA.Department_Id 
          LEFT JOIN 
        tbl_course_batch_duration CBD  on CBD.Duration_Id=NA.Department_Id 
          LEFT JOIN 
        fee_group FG  on FG.programIntakeID=NA.Batch_Id  
          LEFT JOIN 
        Tbl_IntakeMaster IM  on IM.id=CBD.IntakeMasterID
    WHERE 
        CC.Candidate_Id = @Candidate_Id;
END;
    ')
END
