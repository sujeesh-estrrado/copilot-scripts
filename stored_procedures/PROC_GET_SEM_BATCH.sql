IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GET_SEM_BATCH]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[PROC_GET_SEM_BATCH]
        @Candidate_Id BIGINT, 
        @ExamCode VARCHAR(200)
        AS
        BEGIN
            DECLARE @intake VARCHAR(100);
            
            SET @intake = (
                SELECT [Intake_Number] 
                FROM [dbo].[Tbl_Exam_Mark_Entry_Child] 
                WHERE [Candidate_Id] = @Candidate_Id
                AND [ExamCode] = @ExamCode
            );

            -- If there is no intake value, fetch distinct batch and semester details
            IF (@intake IS NULL OR @intake = '''')
            BEGIN
                SELECT DISTINCT 
                    CBD.Batch_Code AS Intake_Number, 
                    CS.Semester_Code AS Sem_Number
                FROM [dbo].[Tbl_Student_Semester] SEM
                INNER JOIN [dbo].[Tbl_Candidate_Personal_Det] CPD 
                    ON CPD.Candidate_Id = SEM.Candidate_Id
                INNER JOIN [dbo].[Tbl_Course_Duration_Mapping] CDM 
                    ON CDM.Duration_Mapping_Id = SEM.Duration_Mapping_Id
                INNER JOIN [dbo].[Tbl_Course_Duration_PeriodDetails] PD 
                    ON PD.Duration_Period_Id = CDM.Duration_Period_Id
                INNER JOIN [dbo].[Tbl_Course_Semester] CS 
                    ON CS.Semester_Id = PD.Semester_Id
                INNER JOIN [dbo].[Tbl_Course_Batch_Duration] CBD 
                    ON CBD.Batch_Id = PD.Batch_Id
                WHERE SEM.Candidate_Id = @Candidate_Id 
                AND SEM.Student_Semester_Current_Status = 1;
            END
            ELSE
            BEGIN
                SELECT [Intake_Number], [Sem_Number] 
                FROM [dbo].[Tbl_Exam_Mark_Entry_Child] 
                WHERE [Candidate_Id] = @Candidate_Id
                AND [ExamCode] = @ExamCode;
            END
        END
    ');
END;
