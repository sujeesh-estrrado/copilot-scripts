IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_StudentsPerCourseList]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_StudentsPerCourseList]
    @Flag INT,
    @modularCourseId BIGINT,
    @country NVARCHAR(100) = NULL,
    @batchCode NVARCHAR(100) = NULL,
    @department NVARCHAR(100) = NULL,
    @status NVARCHAR(50) = NULL,
    @searchkeyword NVARCHAR(200) = NULL,
    @studtype NVARCHAR(200) = NULL
AS
BEGIN
    IF (@Flag = 1)
    BEGIN
        SELECT 
            ROW_NUMBER() OVER (ORDER BY md.Modular_Candidate_Id DESC) AS SINO,
            md.Modular_Candidate_Id,
            CONCAT(md.Candidate_Fname, '' '', md.Candidate_Lname) AS Name,
            md.Ic_Passport AS Passport,
            CASE 
                WHEN md.Candidate_Id != 0 THEN ''Existing''
                ELSE ''New''
            END AS StudentType,
            TC.Nationality AS Nationality,
            D.Department_Name AS Programme,
             IM.Batch_Code AS Intakeno,      
            CONCAT(NC.Mobile_Code, ''-'', md.Contact) AS MobileNo,
            md.Email,
            md.Status AS StudStatus,
            SP.Id AS ScheduleId
        FROM Tbl_Modular_Candidate_Details AS md
        LEFT JOIN tbl_Modular_Courses AS mc ON mc.id = md.Modular_Course_Id
        LEFT JOIN Tbl_Candidate_Personal_Det AS cp ON cp.Candidate_Id = md.Candidate_Id
        LEFT JOIN tbl_New_Admission AS a ON cp.New_Admission_Id = a.New_Admission_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = a.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
        LEFT JOIN Tbl_Department AS D ON D.Department_Id = a.Department_Id
        LEFT JOIN Tbl_Nationality AS TC ON TC.Nationality_Id = md.Country
        LEFT JOIN tbl_Nationality_Code AS NC    ON md.Country = NC.Nationality_Id
        LEFT JOIN Tbl_Schedule_Planning SP ON MC.Id = SP.CourseId
        WHERE 
            SP.Id = @modularCourseId
           
    END

     IF (@Flag = 2)
    BEGIN
        SELECT 
            ROW_NUMBER() OVER (ORDER BY md.Modular_Candidate_Id DESC) AS SINO,
            md.Modular_Candidate_Id,
            CONCAT(md.Candidate_Fname, '' '', md.Candidate_Lname) AS Name,
            md.Ic_Passport AS Passport,
            CASE 
                WHEN md.Candidate_Id != 0 THEN ''Existing''
                ELSE ''New''
            END AS StudentType,
            TC.Nationality AS Nationality,
            D.Department_Name AS Programme,
            IM.Batch_Code AS Intakeno,      
            CONCAT(NC.Mobile_Code, ''-'', md.Contact) AS MobileNo,
            md.Email,
            md.Status AS StudStatus,
            SP.Id AS ScheduleId
        FROM Tbl_Modular_Candidate_Details AS md
        LEFT JOIN tbl_Modular_Courses AS mc ON mc.id = md.Modular_Course_Id
        LEFT JOIN Tbl_Candidate_Personal_Det AS cp ON cp.Candidate_Id = md.Candidate_Id
        LEFT JOIN tbl_New_Admission AS a ON cp.New_Admission_Id = a.New_Admission_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = a.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
        LEFT JOIN Tbl_Department AS D ON D.Department_Id = a.Department_Id
        LEFT JOIN Tbl_Nationality AS TC ON TC.Nationality_Id = cp.Candidate_Nationality
        LEFT JOIN tbl_Nationality_Code AS NC    ON md.Country = NC.Nationality_Id
        LEFT JOIN Tbl_Schedule_Planning SP ON MC.Id = SP.CourseId
      WHERE 
        SP.Id = @modularCourseId
            AND
            (
                @searchkeyword IS NULL OR @searchkeyword = '''' OR
                (   
                    D.Department_Name LIKE ''%'' + @searchkeyword + ''%'' OR
                    TC.Nationality LIKE ''%'' + @searchkeyword + ''%'' OR
                    BD.Batch_Code LIKE ''%'' + @searchkeyword + ''%'' 
                )
            )
           AND (@Country IS NULL OR @country ='''' OR TC.Nationality = @country)
            AND (@batchCode IS NULL OR @batchCode ='''' OR IM.Batch_Code = @batchCode)
            AND (@department IS NULL OR @department ='''' OR D.Department_Id = @department)
            AND (@status IS NULL OR @status= '''' OR  md.Status = @status)
            --AND (@studtype IS NULL OR @studtype =''0'' OR md.StudentType = @studtype)
            AND (@studtype IS NULL OR @studtype = ''0'' OR 
    (CASE WHEN md.Candidate_Id != 0 THEN ''Existing'' ELSE ''New'' END) = @studtype)

    END
END
    ')
END;
