IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_allow_edit_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_allow_edit_request] 
        (
            @Candidate_Id bigint, 
            @flag bigint = 0
        )
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN    
                UPDATE Tbl_Candidate_Personal_Det 
                SET Edit_status = 1, Edit_request = 0, Editable = 1
                WHERE Candidate_Id = @Candidate_Id;
            END

            IF (@flag = 1)
            BEGIN    
                UPDATE Tbl_Student_NewApplication 
                SET Edit_status = 1, Edit_request = 0, Editable = 1
                WHERE Candidate_Id = @Candidate_Id;
            END
        END
    ')
END
