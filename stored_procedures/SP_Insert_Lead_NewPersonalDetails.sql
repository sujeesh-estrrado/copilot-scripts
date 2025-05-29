IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Lead_NewPersonalDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Insert_Lead_NewPersonalDetails]                            
    (                            
        @Candidate_Fname VARCHAR(MAX),                            
        @Candidate_Lname VARCHAR(MAX),                            
        @Candidate_Nationality VARCHAR(MAX),                            
        @AdharNumber VARCHAR(MAX),                            
        @CounselorEmployee_id BIGINT,                            
        @candidate_country VARCHAR(100),                            
        @Status VARCHAR(50),                            
        @EnrollBy VARCHAR(500),                            
        @ApplicationStatus VARCHAR(50),                            
        @Enquiry_From VARCHAR(MAX),                            
        @SourceofInformation VARCHAR(MAX),                            
        @sourcename VARCHAR(500),                            
        @excelid BIGINT = 0,                            
        @Course VARCHAR(500),                            
        @TypeOfStudent VARCHAR(MAX) = '''',                            
        @eventid BIGINT = 0,                            
        @Page_Id BIGINT = 0,                            
        @CandidateReligion VARCHAR(100) = '''',                            
        @CandidateDob VARCHAR(100) = ''1900-01-01 00:00:00.000'',                            
        @Race VARCHAR(50) = ''0'',                            
        @CandidateGender VARCHAR(10) = '''',                            
        @Campus VARCHAR(500) = NULL,                            
        @ExtraRemarks VARCHAR(MAX) = '''',                            
        @Agent BIGINT = 0,                            
        @School_Institution VARCHAR(MAX) = '''',                            
        @Highest_Qul VARCHAR(MAX) = '''',                            
        @Field_study VARCHAR(MAX) = '''',                            
        @Level_Programme VARCHAR(MAX) = '''',                            
        @Year_Intake VARCHAR(MAX) = '''',                            
        @Month_Intake VARCHAR(MAX) = '''',                            
        @How VARCHAR(MAX) = '''',                            
        @Name_Event VARCHAR(MAX) = '''',                            
        @Date_Event VARCHAR(MAX) = '''',                            
        @Lead1 VARCHAR(MAX) = '''',                            
        @Lead2 VARCHAR(MAX) = '''',                            
        @Lead_Categories VARCHAR(MAX) = '''',                            
        @dob DATETIME = NULL,                            
        @gender VARCHAR(10),                            
        @religion VARCHAR(100),                            
        @State VARCHAR(100) = '''',                            
        @City VARCHAR(100) = '''',                            
        @FamilyIncome VARCHAR(10) = '''',                            
        @LeadStatusId BIGINT = 0                            
    )                            
    AS                            
    BEGIN                            
        -- Update Counsellor Page Mapping
        UPDATE Tbl_Counsellor_PageMapping                
        SET Counter = Counter + 1            
        WHERE Counsellor_Id = @CounselorEmployee_id;            

        -- Insert into Tbl_Lead_Personal_Det
        INSERT INTO Tbl_Lead_Personal_Det (
            Candidate_Fname, Candidate_Lname, Candidate_Nationality, AdharNumber, 
            CounselorEmployee_id, Residing_Country, Candidate_DelStatus, RegDate, 
            Status, EnrollBy, Active_Status, ApplicationStatus, Enquiry_From, 
            create_date, active, Display_Status, ApplicationStage, SourceofInformation, 
            source_name, Excel_id, Agent_ID, Scolorship_Remark, TypeOfStudent, 
            Event_Id, Page_Id, Candidate_Dob, Candidate_Gender, Race, Religion, 
            Candidate_State, candidate_city, Candidate_FamilyIncome, LeadStatus_Id
        )                            
        VALUES (
            @Candidate_Fname, @Candidate_Lname, @Candidate_Nationality, @AdharNumber, 
            @CounselorEmployee_id, @candidate_country, 0, GETDATE(), 
            @Status, @EnrollBy, ''ACTIVE'', @ApplicationStatus, @Enquiry_From, 
            GETDATE(), 9, ''Candidatefirst'', ''Initial Application'', @SourceofInformation, 
            @sourcename, @excelid, @Agent, @Course, @TypeOfStudent, 
            @eventid, @Page_Id, @dob, @gender, @Race, @religion,
            (SELECT TOP 1 CONVERT(VARCHAR(10), State_Id) FROM Tbl_State WHERE State_Name = @State), 
            (SELECT TOP 1 CONVERT(VARCHAR(10), City_Id) FROM Tbl_City WHERE City_Name = @City), 
            @FamilyIncome, @LeadStatusId
        );                            
        
        -- Return the inserted identity value
        SELECT SCOPE_IDENTITY();                
    END
    ');
END;
