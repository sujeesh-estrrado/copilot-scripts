IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_ActiveStudent_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_ActiveStudent_List] 
        @flag BIGINT = 0,
        @search_Keyword VARCHAR(MAX) = '''',
        @PageSize BIGINT = 10,
        @CurrentPage BIGINT = 1,
        @status BIGINT = 0
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                SELECT DISTINCT 
                    CPD.Candidate_Id,
                    AdharNumber,
                    CONCAT(Candidate_Fname, '' '' , candidate_Lname) AS CandidateName,
                    IDMatrixNo,
                    IM.intake_no,
                    CONCAT(D.Course_Code, ''-'' , D.Department_Name) AS Department_Name,
                    CS.Semester_Name,
                    SSS.name
                FROM 
                    Tbl_Candidate_Personal_Det CPD
                LEFT JOIN 
                    Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
                LEFT JOIN 
                    Tbl_Department D ON D.Department_Id = NA.Department_Id
                LEFT JOIN 
                    Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
                LEFT JOIN 
                    Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterId
                LEFT JOIN 
                    Tbl_Student_semester SS ON SS.Candidate_Id = CPD.Candidate_Id
                LEFT JOIN 
                    Tbl_Course_Semester CS ON CS.Semester_Id = SS.SEMESTER_NO
                LEFT JOIN 
                    Tbl_Student_Status SSS ON SSS.id = CPD.active
                WHERE 
                    (CPD.active = @status)
                    AND (
                        AdharNumber LIKE CONCAT(''%'', @search_Keyword, ''%'')
                        OR CONCAT(Candidate_Fname, '' '' , candidate_Lname) LIKE CONCAT(''%'', @search_Keyword, ''%'')
                        OR IDMatrixNo LIKE CONCAT(''%'', @search_Keyword, ''%'')
                        OR IM.intake_no LIKE CONCAT(''%'', @search_Keyword, ''%'')
                        OR CONCAT(D.Course_Code, ''-'' , D.Department_Name) LIKE CONCAT(''%'', @search_Keyword, ''%'')
                        OR CS.Semester_Name LIKE CONCAT(''%'', @search_Keyword, ''%'')
                    )
                ORDER BY 
                    CONCAT(Candidate_Fname, '' '' , candidate_Lname)
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
            END

            IF (@flag = 2)
            BEGIN
                SELECT * INTO #temp FROM (
                    SELECT DISTINCT 
                        CPD.Candidate_Id,
                        AdharNumber,
                        CONCAT(Candidate_Fname, '' '' , candidate_Lname) AS CandidateName,
                        IDMatrixNo,
                        IM.intake_no,
                        CONCAT(D.Course_Code, ''-'' , D.Department_Name) AS Department_Name,
                        CS.Semester_Name,
                        SSS.name
                    FROM 
                        Tbl_Candidate_Personal_Det CPD
                    LEFT JOIN 
                        Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
                    LEFT JOIN 
                        Tbl_Department D ON D.Department_Id = NA.Department_Id
                    LEFT JOIN 
                        Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
                    LEFT JOIN 
                        Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterId
                    LEFT JOIN 
                        Tbl_Student_semester SS ON SS.Candidate_Id = CPD.Candidate_Id
                    LEFT JOIN 
                        Tbl_Course_Semester CS ON CS.Semester_Id = SS.SEMESTER_NO
                    LEFT JOIN 
                        Tbl_Student_Status SSS ON SSS.id = CPD.active
                    WHERE 
                        (CPD.active = @status)
                        AND (
                            AdharNumber LIKE CONCAT(''%'', @search_Keyword, ''%'')
                            OR CONCAT(Candidate_Fname, '' '' , candidate_Lname) LIKE CONCAT(''%'', @search_Keyword, ''%'')
                            OR IDMatrixNo LIKE CONCAT(''%'', @search_Keyword, ''%'')
                            OR IM.intake_no LIKE CONCAT(''%'', @search_Keyword, ''%'')
                            OR CONCAT(D.Course_Code, ''-'' , D.Department_Name) LIKE CONCAT(''%'', @search_Keyword, ''%'')
                            OR CS.Semester_Name LIKE CONCAT(''%'', @search_Keyword, ''%'')
                        )
                ) AS base
                SELECT COUNT(*) AS totcount FROM #temp;
            END
        END
    ');
END
