-- Check if the stored procedure [dbo].[Proc_Insert_New_Admission_New] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_New_Admission_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_New_Admission_New]
        (
            @Department_Id BIGINT = 0,
            @Batch_Id BIGINT = 0,
            @CandidateId BIGINT = 0,
            @Choice BIGINT = 0
        )
        AS
        BEGIN
            DECLARE @NewAdmissionId BIGINT;
            
            -- Get the maximum New_Admission_Id for the given Department_Id and Batch_Id
            SET @NewAdmissionId = (
                SELECT ISNULL(MAX(New_Admission_Id), 0) AS Admission_Id
                FROM tbl_New_Admission
                WHERE Department_Id = @Department_Id AND Batch_Id = @Batch_Id
            );

            -- If no New_Admission_Id found, insert a new record
            IF (@NewAdmissionId = 0)
            BEGIN
                INSERT INTO dbo.tbl_New_Admission
                (
                    Department_Id,
                    Batch_Id,
                    FromDate,
                    ToDate,
                    EndDate,
                    Admission_Status,
                    Course_Category_Id,
                    Course_Level_Id
                )
                VALUES
                (
                    @Department_Id,
                    @Batch_Id,
                    GETDATE(),
                    GETDATE(),
                    GETDATE(),
                    1,
                    (SELECT Program_Type_Id FROM Tbl_Department WHERE Department_Id = @Department_Id),
                    (SELECT GraduationTypeId FROM Tbl_Department WHERE Department_Id = @Department_Id)
                );

                -- Get the newly inserted New_Admission_Id
                SET @NewAdmissionId = (SELECT SCOPE_IDENTITY());
            END

            -- Update Tbl_Candidate_Personal_Det based on the choice provided
            IF (@Choice = 1)
            BEGIN
                UPDATE Tbl_Candidate_Personal_Det
                SET New_Admission_Id = @NewAdmissionId
                WHERE Candidate_Id = @CandidateId;
            END

            IF (@Choice = 2)
            BEGIN
                UPDATE Tbl_Candidate_Personal_Det
                SET Option2 = @NewAdmissionId
                WHERE Candidate_Id = @CandidateId;
            END

            IF (@Choice = 3)
            BEGIN
                UPDATE Tbl_Candidate_Personal_Det
                SET Option3 = @NewAdmissionId
                WHERE Candidate_Id = @CandidateId;
            END
        END
    ')
END
