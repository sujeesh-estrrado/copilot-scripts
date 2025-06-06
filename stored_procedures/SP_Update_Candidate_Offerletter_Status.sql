IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_Offerletter_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Update_Candidate_Offerletter_Status]  
        (
            @flag BIGINT,
            @Candidate_Id BIGINT
        )          
        AS            
        BEGIN 
           

            IF (@flag = 1) -- Accept
            BEGIN     
                UPDATE tbl_approval_log 
                SET Offerletter_status = 1, offer_letter_accept_date = GETDATE()   
                WHERE candidate_id = @Candidate_Id AND delete_status = 0;

                UPDATE Tbl_offerletter_log
                SET offeracceptstatus = 1, acceptdate = GETDATE()
                WHERE temppath = (
                    SELECT DISTINCT Offerletter_Path 
                    FROM Tbl_Offerlettre 
                    WHERE candidate_id = @Candidate_Id AND Offerletter_Path IS NOT NULL
                );
            END

            IF (@flag = 2) -- Reject
            BEGIN
                UPDATE tbl_approval_log 
                SET Offerletter_status = 0 
                WHERE candidate_id = @Candidate_Id AND delete_status = 0;
            END

            IF (@flag = 3) -- Select
            BEGIN
                SELECT * FROM tbl_approval_log 
                WHERE candidate_id = @Candidate_Id AND delete_status = 0;
            END

            IF (@flag = 4) -- Skip (Offerletter_status = 2)
            BEGIN
                UPDATE tbl_approval_log 
                SET Offer_letter_Skip_Status = 2, Skipped_date = GETDATE() 
                WHERE candidate_id = @Candidate_Id AND delete_status = 0;

                UPDATE Tbl_offerletter_log
                SET offeracceptstatus = 2, Offer_letter_Skipped_Date = GETDATE()
                WHERE temppath = (
                    SELECT DISTINCT Offerletter_Path 
                    FROM Tbl_Offerlettre 
                    WHERE candidate_id = @Candidate_Id AND Offerletter_Path IS NOT NULL
                );
            END
        END
    ')
END
