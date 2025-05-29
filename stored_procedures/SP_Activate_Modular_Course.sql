IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Activate_Modular_Course]') 
    AND type = N'P'
)
BEGIN
    EXEC('


CREATE PROCEDURE [dbo].[SP_Activate_Modular_Course]
(
    @SlotId bigint,
    @Courseid bigint, 
    @ModularId bigint
)
AS
BEGIN 

    DECLARE @Ic_Passport varchar(50), @Salutation varchar(50), @Candidate_Fname varchar(100),
            @Candidate_Lname varchar(100), @Email varchar(50), @Contact bigint, @Type varchar(50),
            @Country bigint, @Gender varchar(50), @Create_Date date, @Delete_Status bigint,
            @Country_Code varchar(50), @Candidate_Id bigint, @Payment_Method varchar(50),
            @SponsorID varchar(50), @Status varchar(100), @Application_Status varchar(50)
    
    SELECT 
        @Ic_Passport = Ic_Passport,
        @Salutation = Salutation,
        @Candidate_Fname = Candidate_Fname,
        @Candidate_Lname = Candidate_Lname,
        @Email = Email,
        @Contact = Contact,
        @Type = Type,
        @Country = Country,
        @Gender = Gender,
        @Create_Date = Create_Date,
        @Delete_Status = Delete_Status,
        @Country_Code = Country_Code,
        @Candidate_Id = Candidate_Id,
        @Payment_Method = Payment_Method,
        @SponsorID = SponsorID,
        @Status = Status,
        @Application_Status = Application_Status
    FROM Tbl_Modular_Candidate_Details
    WHERE  Modular_Candidate_Id = @ModularId
      
       
       UPDATE Tbl_Modular_Candidate_Details
       SET ActivatedStatus=1
       ,Modular_Slot_Id=@SlotId
       WHERE Modular_Candidate_Id = @ModularId
      

  --  INSERT INTO Tbl_Modular_Candidate_Details (
  --      Ic_Passport,
  --      Salutation,
  --      Candidate_Fname,
  --      Candidate_Lname,
  --      Email,
  --      Contact,
  --      Type,
  --      Country,
  --      Gender,
  --      Modular_Course_Id,
  --      Modular_Slot_Id,
  --      Create_Date,
  --      Delete_Status,
  --      Country_Code,
  --      Candidate_Id,
  --      Payment_Method,
  --      SponsorID,
  --      Status,
  --      Application_Status,
        --ActivatedStatus
  --  ) VALUES (
  --      @Ic_Passport,
  --      @Salutation,
  --      @Candidate_Fname,
  --      @Candidate_Lname,
  --      @Email,
  --      @Contact,
  --      @Type,
  --      @Country,
  --      @Gender,
  --      @Courseid,
  --      @SlotId,
  --      @Create_Date,
  --      @Delete_Status,
  --      @Country_Code,
  --      @Candidate_Id,
  --      @Payment_Method,
  --      @SponsorID,
  --      ''1'',  
  --       ''Active'',
        -- ''1''
  --  )
     
END
    ')
END;
