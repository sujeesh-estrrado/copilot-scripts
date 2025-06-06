IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Course_Application_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Modular_Course_Application_List]        
AS        
BEGIN        
    SELECT 
        ROW_NUMBER() OVER (ORDER BY MCD.Modular_Candidate_Id DESC) AS SlNo, 
        MCD.Modular_Candidate_Id,
        MCD.Candidate_Id,
        CONCAT(MCD.Candidate_Fname, '' '', MCD.Candidate_Lname) AS Candidate_Name,
        MCD.Ic_Passport,
        MC.CourseName,
        MC.CourseCode,
        CASE 
            WHEN MCD.Candidate_Id != 0 THEN ''Existing''
            ELSE ''New''
        END AS StudentType,
        C.Nationality AS Country,
        BD.Batch_Code,
        D.Department_Name,
        CONCAT(MCD.Country_Code, ''-'', MCD.Contact) AS Phone ,
        MCD.Contact AS Raw_Phone,
        MCD.Status,
        MCD.Email,
        MCD.Application_Status,
        CASE 
            WHEN S.selectiontype = 1 THEN 
                CONCAT(
                    CONVERT(VARCHAR, S.TimeLine_FromDate, 103), 
                    '' - '', 
                    CONVERT(VARCHAR, S.TimeLine_EndDate, 103)
                )
            WHEN S.selectiontype = 0 THEN 
                CONCAT(
                    CONVERT(VARCHAR, MIN(SM.Date), 103), 
                    '' - '', 
                    CONVERT(VARCHAR, MAX(SM.Date), 103)
                )
            ELSE NULL
        END AS CourseDate

    FROM Tbl_Modular_Candidate_Details AS MCD
    LEFT JOIN tbl_Modular_Courses AS MC ON MCD.Modular_Course_Id = MC.Id 
    LEFT JOIN Tbl_Nationality AS C ON MCD.Country = C.Nationality_Id 
    LEFT JOIN tbl_Nationality_Code AS NC ON C.Nationality_Id = NC.Nationality_Id
    LEFT JOIN Tbl_Candidate_Personal_Det AS CP ON CP.Candidate_Id = MCD.Candidate_Id
    LEFT JOIN tbl_New_Admission AS A ON CP.New_Admission_Id = A.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration AS BD ON BD.Batch_Id = A.Batch_Id 
    LEFT JOIN Tbl_Department AS D ON D.Department_Id = A.Department_Id
    LEFT JOIN Tbl_Schedule_Planning AS S ON MCD.Modular_Slot_Id = S.Id
    LEFT JOIN Tbl_Schedule_DayWise_Selection AS SM ON S.Id = SM.ScheduleId AND MCD.Modular_Slot_Id = SM.ScheduleId

    WHERE 
        MCD.Delete_Status = 0
        AND MC.Isdeleted = 0 
        AND MCD.ActivatedStatus = 0

    GROUP BY 
        MCD.Modular_Candidate_Id,
        MCD.Candidate_Id,
        MCD.Candidate_Fname,
        MCD.Candidate_Lname,
        MCD.Ic_Passport,
        MC.CourseName,
        MC.CourseCode,
        MCD.Country_Code,
        MCD.Contact,
        NC.Mobile_Code,
        C.Nationality,
        BD.Batch_Code,
        D.Department_Name,
        MCD.Status,
        MCD.Email,
        MCD.Application_Status,
        S.selectiontype,
        S.TimeLine_FromDate,
        S.TimeLine_EndDate
END
   ')
END;
