IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Modular_Candidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Insert_Modular_Candidate]                          
    @icpassport VARCHAR(50),
    @salutation VARCHAR(100),                        
    @candidatefname VARCHAR(100),
    @candidatelname VARCHAR(100),
    @email VARCHAR(100),
    @contact BIGINT,
    @type VARCHAR(100),
    @country VARCHAR(100),
    @countryCode  VARCHAR(100),
    @gender VARCHAR(MAX),
    @courseid BIGINT,
    @slotid BIGINT,
    @deletestatus INT = 0,
    @status VARCHAR(50) = ''1'',
    @candidateid BIGINT = 0, 
    @paymentmethod VARCHAR(50) = '''',
    @sponcerid VARCHAR(50) = ''0'',
    @flag INT 
AS 
BEGIN 
    SET NOCOUNT ON;

    IF @flag = 0
    BEGIN
        -- INSERT
        INSERT INTO dbo.Tbl_Modular_Candidate_Details (
            Ic_Passport,
            Salutation,
            Candidate_Fname,
            Candidate_Lname,
            Email,
            Contact,
            Type,
            Country,
            Gender,
            Modular_Course_Id,
            Modular_Slot_Id,
            Delete_Status,
            Country_Code,
            Status,
            Create_Date,
            Candidate_Id,
            Payment_Method,
            SponsorID,
            Application_Status
        )
        VALUES (
            @icpassport,
            @salutation,
            @candidatefname,
            @candidatelname,
            @email,
            @contact,
            @type,
            @country,
            @gender,
            @courseid,
            @slotid,
            @deletestatus,
            @countryCode,
            @status,
            GETDATE(),
            @candidateid,
            @paymentmethod,
            @sponcerid,
            ''Active''
        );

        SELECT SCOPE_IDENTITY() AS InsertedId;
    END
    ELSE IF @flag = 1
    BEGIN
        -- UPDATE
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
            Country_Code=@countryCode,
            Gender = @gender,
            Modular_Course_Id = @courseid,
            Modular_Slot_Id = @slotid,
            Delete_Status = @deletestatus,
            Status = @status,
            Payment_Method = @paymentmethod,
            SponsorID = @sponcerid,
            Create_Date = GETDATE()
        WHERE Modular_Candidate_Id = @candidateid;

        SELECT @candidateid AS UpdatedId;
    END
END;
    ')
END;
