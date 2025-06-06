IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Check_Ic_And_Email_Existance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Check_Ic_And_Email_Existance]
            @name VARCHAR(MAX),
            @flag BIGINT
        AS
        BEGIN
            IF (@flag = 1)  -- IC/Passport in EnquiryList
            BEGIN
                SELECT CONCAT(Tbl_Student_status.name, '' - '', 
                    CASE 
                        WHEN ApplicationStatus = ''pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''submited'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''approved'' THEN ''Candidate List(Admissions)'' 
                        WHEN ApplicationStatus = ''Verified'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Conditional_Admission'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Preactivated'' THEN ''Preactivated List(Admissions)'' 
                        WHEN ApplicationStatus = ''Completed'' THEN ''Student List(Admissions)'' 
                        WHEN ApplicationStatus = ''Lead'' THEN ''Enquiry List'' 
                        ELSE ''Student List(Admissions)'' 
                    END
                ) AS Status, * 
                FROM Tbl_Candidate_Personal_Det
                LEFT JOIN Tbl_Student_status ON Tbl_Student_status.id = Tbl_Candidate_Personal_Det.active
                WHERE AdharNumber = @name AND ApplicationStatus != ''rejected''
            END
            ELSE IF (@flag = 2)  -- Email in EnquiryList
            BEGIN
                SELECT CONCAT(Tbl_Student_status.name, '' - '', 
                    CASE 
                        WHEN ApplicationStatus = ''pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''submited'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''approved'' THEN ''Candidate List(Admissions)'' 
                        WHEN ApplicationStatus = ''Verified'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Conditional_Admission'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Preactivated'' THEN ''Preactivated List(Admissions)'' 
                        WHEN ApplicationStatus = ''Completed'' THEN ''Student List(Admissions)'' 
                        WHEN ApplicationStatus = ''Lead'' THEN ''Enquiry List'' 
                        ELSE ''Student List(Admissions)'' 
                    END
                ) AS Status, * 
                FROM Tbl_Candidate_ContactDetails
                LEFT JOIN Tbl_Candidate_Personal_Det ON Tbl_Candidate_ContactDetails.Candidate_Id = Tbl_Candidate_Personal_Det.Candidate_Id
                LEFT JOIN Tbl_Student_status ON Tbl_Student_status.id = Tbl_Candidate_Personal_Det.active
                WHERE Candidate_Email = @name AND ApplicationStatus != ''rejected''
            END
            ELSE IF (@flag = 3)  -- IC/Passport in LeadList
            BEGIN
                SELECT CONCAT(Tbl_Student_status.name, '' - '', 
                    CASE 
                        WHEN ApplicationStatus = ''pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''submited'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''approved'' THEN ''Candidate List(Admissions)'' 
                        WHEN ApplicationStatus = ''Verified'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Conditional_Admission'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Preactivated'' THEN ''Preactivated List(Admissions)'' 
                        WHEN ApplicationStatus = ''Completed'' THEN ''Student List(Admissions)'' 
                        WHEN ApplicationStatus = ''Lead'' THEN ''Enquiry List'' 
                        ELSE ''Student List(Admissions)'' 
                    END
                ) AS Status, * 
                FROM Tbl_Lead_Personal_Det
                LEFT JOIN Tbl_Student_status ON Tbl_Student_status.id = Tbl_Lead_Personal_Det.active
                WHERE AdharNumber = @name AND ApplicationStatus != ''rejected''
            END
            ELSE IF (@flag = 4)  -- Email in LeadList
            BEGIN
                SELECT CONCAT(Tbl_Student_status.name, '' - '', 
                    CASE 
                        WHEN ApplicationStatus = ''pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''submited'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''approved'' THEN ''Candidate List(Admissions)'' 
                        WHEN ApplicationStatus = ''Verified'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Conditional_Admission'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Preactivated'' THEN ''Preactivated List(Admissions)'' 
                        WHEN ApplicationStatus = ''Completed'' THEN ''Student List(Admissions)'' 
                        WHEN ApplicationStatus = ''Lead'' THEN ''Enquiry List'' 
                        ELSE ''Student List(Admissions)'' 
                    END
                ) AS Status, * 
                FROM Tbl_Lead_ContactDetails
                LEFT JOIN Tbl_Lead_Personal_Det ON Tbl_Lead_ContactDetails.Candidate_Id = Tbl_Lead_Personal_Det.Candidate_Id
                LEFT JOIN Tbl_Student_status ON Tbl_Student_status.id = Tbl_Lead_Personal_Det.active
                WHERE Candidate_Email = @name AND ApplicationStatus != ''rejected''
            END
            ELSE IF (@flag = 5)  -- Phone in EnquiryList
            BEGIN
                SELECT CONCAT(Tbl_Student_status.name, '' - '', 
                    CASE 
                        WHEN ApplicationStatus = ''pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''submited'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''approved'' THEN ''Candidate List(Admissions)'' 
                        WHEN ApplicationStatus = ''Verified'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Conditional_Admission'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Preactivated'' THEN ''Preactivated List(Admissions)'' 
                        WHEN ApplicationStatus = ''Completed'' THEN ''Student List(Admissions)'' 
                        WHEN ApplicationStatus = ''Lead'' THEN ''Enquiry List'' 
                        ELSE ''Student List(Admissions)'' 
                    END
                ) AS Status, * 
                FROM Tbl_Candidate_ContactDetails
                LEFT JOIN Tbl_Candidate_Personal_Det ON Tbl_Candidate_ContactDetails.Candidate_Id = Tbl_Candidate_Personal_Det.Candidate_Id
                LEFT JOIN Tbl_Student_status ON Tbl_Student_status.id = Tbl_Candidate_Personal_Det.active
                WHERE Candidate_Mob1 = @name AND ApplicationStatus != ''rejected''
            END
            ELSE IF (@flag = 6)  -- Phone in LeadList
            BEGIN
                SELECT CONCAT(Tbl_Student_status.name, '' - '', 
                    CASE 
                        WHEN ApplicationStatus = ''pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''submited'' THEN ''Enquiry List'' 
                        WHEN ApplicationStatus = ''approved'' THEN ''Candidate List(Admissions)'' 
                        WHEN ApplicationStatus = ''Verified'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Conditional_Admission'' THEN ''Verified List(Admissions)'' 
                        WHEN ApplicationStatus = ''Preactivated'' THEN ''Preactivated List(Admissions)'' 
                        WHEN ApplicationStatus = ''Completed'' THEN ''Student List(Admissions)'' 
                        WHEN ApplicationStatus = ''Lead'' THEN ''Enquiry List'' 
                        ELSE ''Student List(Admissions)'' 
                    END
                ) AS Status, * 
                FROM Tbl_Lead_ContactDetails
                LEFT JOIN Tbl_Lead_Personal_Det ON Tbl_Lead_ContactDetails.Candidate_Id = Tbl_Lead_Personal_Det.Candidate_Id
                LEFT JOIN Tbl_Student_status ON Tbl_Student_status.id = Tbl_Lead_Personal_Det.active
                WHERE Candidate_Mob1 = @name AND ApplicationStatus != ''rejected''
            END
        END
    ')
END
