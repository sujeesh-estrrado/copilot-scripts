IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_approve_change_reguest]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_approve_change_reguest]
        (
            @Candidate_id bigint,
            @userid bigint,
            @faculty bigint,
            @pgmid bigint,
            @intakeid bigint
        )
        AS
        BEGIN
            IF EXISTS (
                SELECT New_Admission_Id 
                FROM tbl_New_Admission 
                WHERE Course_Level_Id = @faculty 
                  AND Department_Id = @pgmid 
                  AND Batch_Id = @intakeid
            )
            BEGIN
                UPDATE Tbl_Candidate_Personal_Det 
                SET 
                    ApplicationStatus = ''Approved'', 
                    New_Admission_Id = (SELECT New_Admission_Id FROM tbl_New_Admission WHERE Course_Level_Id = @faculty AND Department_Id = @pgmid AND Batch_Id = @intakeid),
                    status = 1 
                WHERE 
                    candidate_id = @Candidate_id;
                
                UPDATE Tbl_Student_Semester 
                SET Delete_Status = 1 
                WHERE Candidate_Id = @Candidate_id;
                
                UPDATE Tbl_Program_change_request 
                SET 
                    update_date = GETDATE(), 
                    Updated_by = @userid, 
                    delete_status = 1 
                WHERE 
                    Candidate_id = @Candidate_id;
            END
            ELSE
            BEGIN
                INSERT INTO tbl_New_Admission (Department_Id, Course_Level_Id, Batch_Id) 
                VALUES (@pgmid, @faculty, @intakeid);
                
                UPDATE Tbl_Candidate_Personal_Det 
                SET 
                    ApplicationStatus = ''Approved'', 
                    New_Admission_Id = (SELECT New_Admission_Id FROM tbl_New_Admission WHERE Course_Level_Id = @faculty AND Department_Id = @pgmid AND Batch_Id = @intakeid),
                    status = 1 
                WHERE 
                    candidate_id = @Candidate_id;
                
                UPDATE Tbl_Student_Semester 
                SET Delete_Status = 1 
                WHERE Candidate_Id = @Candidate_id;
                
                UPDATE Tbl_Program_change_request 
                SET 
                    update_date = GETDATE(), 
                    Updated_by = @userid, 
                    delete_status = 1 
                WHERE 
                    Candidate_id = @Candidate_id;
            END
        END
    ')
END
