IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_CopyTopersonal_FromLead]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_CopyTopersonal_FromLead] 
        (
            @Candidate_Id bigint = 0
        )
        AS
        BEGIN
            DECLARE @id bigint = 0;

            IF NOT EXISTS (
                SELECT * 
                FROM Tbl_Candidate_Personal_Det 
                WHERE AdharNumber = (
                    SELECT AdharNumber 
                    FROM Tbl_Lead_Personal_Det 
                    WHERE Candidate_Id = @Candidate_Id
                )
            )
            BEGIN
                INSERT INTO Tbl_Candidate_Personal_Det (
                    IdentificationNo, Candidate_Fname, Candidate_Mname, Candidate_Lname, Candidate_Gender, 
                    Candidate_Dob, Candidate_PlaceOfBirth, Candidate_Nationality, Candidate_State, 
                    candidate_city, Religion, Caste, Diocese, Parish, ApplicationCategory, Candidate_Category, 
                    Candidate_FamilyIncome, Candidate_Img, Candidate_DelStatus, Initial_Application_Id, 
                    New_Admission_Id, AdharNumber, Online_OfflineStatus, AdmissionType, RegDate, OldICPassport, 
                    Salutation, Campus, TypeOfStudent, Status, CounselorCampus, CounselorEmployee_id, AgentName, 
                    SalesStudentICNo, SalesStudentName, SalesOrganizationName, SalesHRName, EnrollBy, CounselorName, 
                    SalesLeadName, Active_Status, Race, IDMatrixNo, Sponsorship, Visa, VisaFrom, VisaTo, Passport, 
                    PassportFrom, PassportDate, Insurance_detail, Agent_ID, Residing_Country, Hostel_Required, 
                    Room_Type, Scolorship_Name, Scolorship_Remark, Bh1M_Doc_Name, Disability_Doc_name, ApplicationStatus, 
                    Option2, Option3, FeeStatus, Candidate_Marital_Status, Address_Chkbox_Status, Disability_Chkbox_Status, 
                    Disability_Type, BR1M_Status, Mode_Of_Study, Edit_status, Edit_request, Display_Status, Enquiry_From, 
                    Candidate_Hereaboutus, bankid1, bankaccountno1, bankid2, bankaccountno2, billoutstanding, sponsor, 
                    Editable, Invoice_Status, Payment_Request_Status, surname, create_date, active, LastUpdate, 
                    SourceofInformation, ApplicationStage, Edit_request_remark, CouncelloAttendedLastDate, recruitedby_other, 
                    sourceplace, barracuda_state, barracuda_city, documentcomplete
                )
                SELECT 
                    IdentificationNo, Candidate_Fname, Candidate_Mname, Candidate_Lname, Candidate_Gender, 
                    Candidate_Dob, Candidate_PlaceOfBirth, Candidate_Nationality, Candidate_State, candidate_city, 
                    Religion, Caste, Diocese, Source_name, ApplicationCategory, Candidate_Category, Candidate_FamilyIncome, 
                    Candidate_Img, Candidate_DelStatus, Initial_Application_Id, New_Admission_Id, AdharNumber, 
                    Online_OfflineStatus, AdmissionType, RegDate, OldICPassport, Salutation, Campus, TypeOfStudent, 
                    Status, CounselorCampus, CounselorEmployee_id, AgentName, SalesStudentICNo, SalesStudentName, 
                    SalesOrganizationName, SalesHRName, EnrollBy, CounselorName, SalesLeadName, Active_Status, Race, 
                    IDMatrixNo, Sponsorship, Visa, VisaFrom, VisaTo, Passport, PassportFrom, PassportDate, Insurance_detail, 
                    Agent_ID, Residing_Country, Hostel_Required, Room_Type, Scolorship_Name, Scolorship_Remark, Bh1M_Doc_Name, 
                    Disability_Doc_name, ''Pending'', Option2, Option3, FeeStatus, Candidate_Marital_Status, Address_Chkbox_Status, 
                    Disability_Chkbox_Status, Disability_Type, BR1M_Status, Mode_Of_Study, Edit_status, Edit_request, 
                    Display_Status, Enquiry_From, Candidate_Hereaboutus, bankid1, bankaccountno1, bankid2, bankaccountno2, 
                    billoutstanding, sponsor, Editable, Invoice_Status, Payment_Request_Status, surname, create_date, 1, 
                    GETDATE(), SourceofInformation, ApplicationStage, Edit_request_remark, CouncelloAttendedLastDate, 
                    recruitedby_other, sourceplace, barracuda_state, barracuda_city, documentcomplete
                FROM Tbl_Lead_Personal_Det
                WHERE Candidate_Id = @Candidate_Id AND Candidate_DelStatus = 0;

                SET @id = SCOPE_IDENTITY();

                INSERT INTO Tbl_Candidate_ContactDetails (
                    Candidate_Id, Candidate_Email, Candidate_Mob1, Candidate_PermAddress, Candidate_PermAddress_Line2, 
                    Candidate_PermAddress_Country, Candidate_PermAddress_State, Candidate_PermAddress_City, 
                    Candidate_PermAddress_postCode
                )
                SELECT 
                    @id, Candidate_Email, Candidate_Mob1, Candidate_PermAddress, Candidate_PermAddress_Line2, 
                    Candidate_PermAddress_Country, Candidate_PermAddress_State, Candidate_PermAddress_City, 
                    Candidate_PermAddress_postCode
                FROM Tbl_Lead_ContactDetails 
                WHERE Candidate_Id = @Candidate_Id;

                UPDATE Tbl_Lead_Personal_Det 
                SET ApplicationStatus = ''Pending'', Moved_id = @id 
                WHERE Candidate_Id = @Candidate_Id;

                SELECT @id;
            END;

            SELECT * INTO #ControlTable 
            FROM dbo.[Tbl_FollowUpLead_Detail] 
            WHERE Candidate_Id = @Candidate_Id;

            DECLARE @TableID INT;

            WHILE EXISTS (SELECT * FROM #ControlTable)
            BEGIN
                SET @TableID = (SELECT TOP 1 Follow_Up_Detail_Id FROM #ControlTable);

                INSERT INTO [dbo].[Tbl_FollowUp_Detail] (
                    [Counselor_Employee], [Candidate_Id], [Followup_Date], [Followup_time], [Remarks], [Respond_Type], 
                    [Action_to_Be_Taken], [Action_Taken], [Next_Date], [Medium], [Delete_Status]
                )
                SELECT TOP 1
                    [Counselor_Employee], @id, [Followup_Date], [Followup_time], [Remarks], [Respond_Type], 
                    [Action_to_Be_Taken], [Action_Taken], [Next_Date], [Medium], [Delete_Status]
                FROM #ControlTable;

                DELETE FROM #ControlTable 
                WHERE Follow_Up_Detail_Id = @TableID;
            END;

            DROP TABLE #ControlTable;
        END
    ')
END;
