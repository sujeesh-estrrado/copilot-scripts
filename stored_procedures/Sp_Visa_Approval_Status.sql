IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Visa_Approval_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE PROCEDURE [dbo].[Sp_Visa_Approval_Status] 
    @Candidate_Id BIGINT,
    @VisaStatus   VARCHAR(500),
    @VisaType     VARCHAR(500),
    @VisaDuration VARCHAR(500),
    @VisaExpiryDate DATE,
    @Rejection_Remark VARCHAR(500),
    @PassportExpiryDate DATE,
    @Emp  bigint
AS
BEGIN
    SET NOCOUNT ON;
     
    IF @VisaStatus = ''Rejected''
    BEGIN

        UPDATE Tbl_Visa_ISSO
        SET 
            Visa_Status = @VisaStatus,
            Reject_Remark = @Rejection_Remark,
            Del_Status=1
        WHERE Candidate_Id = @Candidate_Id;
        
         
insert into Tbl_Visa_Log Values(@VisaStatus,@Candidate_Id,GETDATE(),'''','''',@Emp)
         
        
    END
    ELSE
    BEGIN

        UPDATE Tbl_Visa_ISSO
        SET
            Visa_Status = @VisaStatus,
            Visa_Type = @VisaType,
            Duration = @VisaDuration,
            Visa_Expiry = @VisaExpiryDate,
            Reject_Remark = @Rejection_Remark
            --Passport_visa_ExpiryDate = @PassportExpiryDate
        WHERE Candidate_Id = @Candidate_Id;


         
        insert into Tbl_Visa_Log Values(@VisaStatus,@Candidate_Id,GETDATE(),'''','''',@Emp)

    END



END
    ')
END
