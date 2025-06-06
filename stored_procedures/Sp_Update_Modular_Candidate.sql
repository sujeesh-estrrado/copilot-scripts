IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Modular_Candidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_Update_Modular_Candidate]
    @icpassport VARCHAR(50),
    @salutation VARCHAR(100),                        
    @candidatefname VARCHAR(100),
    @candidatelname VARCHAR(100),
    @email VARCHAR(100),
    @contact BIGINT,
    @type VARCHAR(100),
    @country VARCHAR(100),
    @gender VARCHAR(MAX),
    @courseid BIGINT,
    @slotid BIGINT,
    @countrycode VARCHAR(50),
    @candidateid BIGINT = NULL, 
    @paymentmethod VARCHAR(50) = '''',
    @sponcerid VARCHAR(50) = ''0'',
    @flag INT -- 0 for insert, 1 for update
AS 
BEGIN 
    SET NOCOUNT ON;
    
                UPDATE dbo.Tbl_Modular_Candidate_Details
                SET 
                    Ic_Passport = @icpassport,
                    Salutation = @salutation,
                    Candidate_Fname = @candidatefname,
                    Candidate_Lname = @candidatelname,
                    Email = @email,
                    Contact = @contact,
                    Type = @type,
                    Country = @country,
                    Gender = @gender,
                    Modular_Course_Id = @courseid,
                    Modular_Slot_Id = @slotid,
                    Country_Code = @countrycode,
                    Payment_Method = @paymentmethod,
                    SponsorID = CASE WHEN @paymentmethod = ''Sponsor'' THEN @sponcerid ELSE ''0'' END  
                WHERE Modular_Candidate_Id = @candidateid;
 
END
   ')
END;
