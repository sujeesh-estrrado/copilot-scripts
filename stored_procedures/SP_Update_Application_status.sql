IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Application_status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Update_Application_status]  
        (@candidate_id BIGINT, @status VARCHAR(50), @Uid BIGINT, @flag BIGINT, @verifiedby VARCHAR(500) = '''')      
        AS      
        BEGIN      
            IF @flag = 1      
            BEGIN      
                UPDATE Tbl_Candidate_Personal_Det 
                SET ApplicationStatus = @status, Editable = 0 
                WHERE Candidate_Id = @candidate_id;     

                IF NOT EXISTS (SELECT * FROM tbl_approval_log WHERE candidate_id = @candidate_id AND delete_status = 0)  
                BEGIN  
                    INSERT INTO tbl_approval_log (candidate_id, Approved_by, Approved_date, Verified_date, Updated_date, delete_status)   
                    VALUES (@candidate_id, @Uid, GETDATE(), GETDATE(), GETDATE(), 0)      
                END  
                ELSE  
                BEGIN  
                    UPDATE tbl_approval_log 
                    SET Approved_by = @Uid, Approved_date = GETDATE(), Verified_date = GETDATE(), Updated_date = GETDATE()  
                    WHERE candidate_id = @candidate_id AND delete_status = 0  
                END  
            END      
            ELSE IF @flag = 2      
            BEGIN      
                UPDATE Tbl_Candidate_Personal_Det 
                SET ApplicationStatus = @status, Editable = 0, verifiedby = @verifiedby 
                WHERE Candidate_Id = @candidate_id;      

                UPDATE tbl_approval_log 
                SET Verified_by = @Uid, Verified_date = GETDATE(), Updated_date = GETDATE() 
                WHERE candidate_id = @candidate_id AND delete_status = 0    
            END      
            ELSE IF @flag = 3      
            BEGIN      
                UPDATE Tbl_Candidate_Personal_Det 
                SET ApplicationStatus = @status, Editable = 0 
                WHERE Candidate_Id = @candidate_id;      
            END      
            ELSE IF @flag = 4      
            BEGIN      
                UPDATE Tbl_Candidate_Personal_Det 
                SET ApplicationStatus = @status 
                WHERE Candidate_Id = @candidate_id;      
            END      
            ELSE IF @flag = 5    
            BEGIN      
                UPDATE Tbl_Candidate_Personal_Det 
                SET ApplicationStatus = @status, ApplicationStage = ''Initial Application'' 
                WHERE Candidate_Id = @candidate_id;      
            END      
        END
    ')
END
