IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ApplicationPrint]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_ApplicationPrint]
        (
            @Candidate_Id bigint
        )
        AS
        BEGIN
            SELECT DISTINCT 
                D.Candidate_Id,
                Candidate_Fname + '' '' + Candidate_Lname AS Candidatename,
                Candidate_Gender,
                AdharNumber,
                TypeOfStudent,
                Race,
                Religion,
                Candidate_Dob AS DOB,
                Candidate_Marital_Status,
                Candidate_Email,
                Candidate_Mob1,
                Candidate_Telephone,
                Nationality,
                E.Employee_FName + '' '' + E.Employee_LName AS Counselor,
                Candidate_PermAddress + '' '' + Candidate_PermAddress_Line2 + '' '' + Co.Country + '' '' + Cs.State_Name + '' '' + Ci.City_Name + '' '' + Candidate_PermAddress_postCode AS CommAddress,
                Candidate_ContAddress + '' '' + Candidate_ContAddress_Line2 + '' '' + Cc.Country + '' '' + Ms.State_Name + '' '' + Mi.City_Name + '' '' + Candidate_ContAddress_postCode AS mailaddress,
                CASE WHEN Disability_Chkbox_Status = 1 THEN ''Yes'' WHEN Disability_Chkbox_Status = 0 THEN ''No'' ELSE ''No'' END AS DisabilityStatus,
                Disability_Type,
                CASE WHEN BR1M_Status = 1 THEN ''Yes'' WHEN BR1M_Status = 0 THEN ''No'' ELSE ''No'' END AS BR1MStatus,
                -- Program Details
                O.Organization_Name,
                Mode_Of_Study,
                Ca.Course_Category_Name,
                CL.Course_Level_Name,
                TD.Department_Name AS program1,
                T2.Department_Name AS program2,
                T3.Department_Name AS program3,
                Scolorship_Name,
                Scolorship_Remark,
                DateName(Month, DateAdd(Month, Month(Batch_From), -1)) + '' '' + CAST(YEAR(Batch_From) AS varchar(10)) AS Intake
            FROM 
                Tbl_Candidate_Personal_Det D 
            LEFT JOIN Tbl_Candidate_ContactDetails C ON D.Candidate_Id = C.Candidate_Id
            LEFT JOIN Tbl_Country Co ON Co.Country_Id = C.Candidate_PermAddress_Country
            LEFT JOIN Tbl_Country Cc ON Cc.Country_Id = C.Candidate_ContAddress_Country
            LEFT JOIN Tbl_State Cs ON Cs.State_Id = C.Candidate_PermAddress_State
            LEFT JOIN Tbl_State Ms ON Ms.State_Id = C.Candidate_ContAddress_State
            LEFT JOIN Tbl_City Ci ON Ci.City_Id = C.Candidate_PermAddress_City
            LEFT JOIN Tbl_City Mi ON Mi.City_Id = C.Candidate_ContAddress_City 
            LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = D.Candidate_Nationality
            LEFT JOIN Tbl_Employee E ON D.CounselorEmployee_id = E.Employee_Id
            LEFT JOIN [Tbl_Organzations] O ON D.Campus = O.Organization_Id
            LEFT JOIN tbl_New_Admission NA ON D.New_Admission_Id = NA.New_Admission_Id
            LEFT JOIN Tbl_Course_Category Ca ON NA.Course_Category_Id = Ca.Course_Category_Id
            LEFT JOIN Tbl_Course_Level CL ON NA.Course_Level_Id = CL.Course_Level_Id
            LEFT JOIN Tbl_Department TD ON NA.Department_Id = TD.Department_Id
            LEFT JOIN tbl_New_Admission N2 ON D.Option2 = N2.New_Admission_Id
            LEFT JOIN Tbl_Department T2 ON N2.Department_Id = T2.Department_Id
            LEFT JOIN tbl_New_Admission N3 ON D.Option3 = N3.New_Admission_Id
            LEFT JOIN Tbl_Department T3 ON N3.Department_Id = T3.Department_Id
            LEFT JOIN view_programL_bind VMY ON D.New_Admission_Id = VMY.Department_Id AND NA.Batch_Id = VMY.Batch_Id
            WHERE D.Candidate_Id = @Candidate_Id;
        END
    ')
END
