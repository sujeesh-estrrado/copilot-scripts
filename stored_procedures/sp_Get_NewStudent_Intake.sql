IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_NewStudent_Intake]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[sp_Get_NewStudent_Intake] --30064
    (
        @Candidateid BIGINT
    )
    AS
    BEGIN
        SELECT 
            CDM.Duration_Mapping_Id,
            bd.Batch_From,
            bd.Batch_To,
            bd.Batch_Code + ''-'' + cs.Semester_Code AS Intake,
            cs.Semester_Code,
            bd.Batch_Code,
            cd.Duration_Period_Id
        FROM 
            dbo.Tbl_Course_Duration_PeriodDetails AS cd
            LEFT OUTER JOIN dbo.tbl_New_Admission AS Ad 
                ON Ad.Batch_Id = cd.Batch_Id
            LEFT OUTER JOIN dbo.Tbl_Student_NewApplication AS Pd 
                ON Pd.New_Admission_Id = Ad.New_Admission_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS bd 
                ON cd.Batch_Id = bd.Batch_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs 
                ON cs.Semester_Id = cd.Semester_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS CDM 
                ON CDM.Duration_Period_Id = cd.Duration_Period_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Department AS Cdep 
                ON Cdep.Department_Id = CDM.Course_Department_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Category AS CC 
                ON CC.Course_Category_Id = Cdep.Course_Category_Id
            LEFT OUTER JOIN dbo.Tbl_Department AS D 
                ON D.Department_Id = Cdep.Department_Id
        WHERE 
            Pd.Candidate_Id = @Candidateid
    END
    ')
END
GO
