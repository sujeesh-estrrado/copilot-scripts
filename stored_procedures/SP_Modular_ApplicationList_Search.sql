IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_ApplicationList_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Modular_ApplicationList_Search]         
    @CourseIds VARCHAR(MAX) = NULL,
    @StudentType INT = NULL,
    @Nationality INT = NULL,
    @ProgramId INT = NULL,
    @IntakeId INT = NULL,
    @ApplicationStatus VARCHAR(50) = NULL
AS        
BEGIN        
    SELECT 
        ROW_NUMBER() OVER (ORDER BY MCD.Candidate_Fname) AS SlNo, 
        MCD.Modular_Candidate_Id,
        MCD.Candidate_Id,       
        MCD.Candidate_Fname AS Candidate_Name,
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
        CONCAT(MCD.Country_Code, ''-'', MCD.Contact) AS Phone,
        MCD.Status,
        MCD.Email,
        MCD.Application_Status
    FROM
        Tbl_Modular_Candidate_Details AS MCD
        INNER JOIN tbl_Modular_Courses AS MC ON MCD.Modular_Course_Id = MC.Id 
        INNER JOIN Tbl_Nationality AS C ON MCD.Country = C.Nationality_Id
        LEFT JOIN Tbl_Candidate_Personal_Det AS CP ON CP.Candidate_Id = MCD.Candidate_Id
        LEFT JOIN tbl_New_Admission AS A ON CP.New_Admission_Id = A.New_Admission_Id
        LEFT JOIN Tbl_Course_Batch_Duration AS BD ON BD.Batch_Id = A.Batch_Id 
        LEFT JOIN Tbl_Department AS D ON D.Department_Id = A.Department_Id
    WHERE
        MCD.Delete_Status=0
        AND (@CourseIds IS NULL OR MCD.Modular_Course_Id IN (SELECT value FROM dbo.SplitStringFunction(@CourseIds, '','')))
        AND (@StudentType IS NULL OR 
            (@StudentType = 1 AND MCD.Candidate_Id = 0) OR 
            (@StudentType = 2 AND MCD.Candidate_Id != 0))
        AND (@Nationality IS NULL OR MCD.Country = @Nationality)
        AND (@ProgramId IS NULL OR A.Department_Id = @ProgramId)
        AND (@IntakeId IS NULL OR A.Batch_Id = @IntakeId)
        AND (@ApplicationStatus IS NULL OR MCD.Application_Status = @ApplicationStatus)
END
    ')
END;
