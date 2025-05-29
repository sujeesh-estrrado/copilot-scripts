IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Candidate_Individual_InternalMarks]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_RPT_Candidate_Individual_InternalMarks]
(
    @Duration_Mapping_Id BIGINT,
    @Candidate_Id BIGINT
)
AS
BEGIN
    DECLARE @Mapping_ID VARCHAR(10) = CAST(@Duration_Mapping_Id AS VARCHAR(10))
    DECLARE @CandidateID VARCHAR(10) = CAST(@Candidate_Id AS VARCHAR(10))
    DECLARE @query NVARCHAR(MAX)
    DECLARE @subjects NVARCHAR(MAX)

    -- Build dynamic column list for PIVOT
    SELECT @subjects = STUFF((
        SELECT DISTINCT '']],['' + Subject_Code
        FROM Tbl_Semester_Subjects SS
        INNER JOIN Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id
        INNER JOIN Tbl_Department_Subjects DS ON SS.Department_Subjects_Id = DS.Department_Subject_Id
        INNER JOIN Tbl_Subject S ON DS.Subject_Id = S.Subject_Id
        INNER JOIN Tbl_Student_Semester ST ON ST.Duration_Mapping_Id = SS.Duration_Mapping_Id
        WHERE SS.Semester_Subjects_Status = 0
          AND SS.Duration_Mapping_Id = @Duration_Mapping_Id
          AND ST.Candidate_Id = @Candidate_Id
          AND (SELECT COUNT(Subject_Id) FROM Tbl_Subject WHERE Parent_Subject_Id = S.Subject_Id) = 0
        ORDER BY '']],['' + Subject_Code
        FOR XML PATH('''')
    ), 1, 2, '''') + '']]''

    -- Build and execute dynamic PIVOT query
    SET @query = N''
    SELECT RollNumber, [Student Name], '' + @subjects + '' 
    FROM (
        SELECT 
            CR.RollNumber,
            C.Candidate_Fname + '''' '''' + C.Candidate_Mname + '''' '''' + C.Candidate_Lname AS [Student Name],
            S.Subject_Code,
            ISNULL(CAST(CIM.Internal_Marks AS VARCHAR(100)), ''''NA'''') AS Internal_Marks
        FROM Tbl_Semester_Subjects SS
        INNER JOIN Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id
        INNER JOIN Tbl_Department_Subjects DS ON SS.Department_Subjects_Id = DS.Department_Subject_Id
        INNER JOIN Tbl_Subject S ON DS.Subject_Id = S.Subject_Id
        INNER JOIN Tbl_Student_Semester ST ON ST.Duration_Mapping_Id = SS.Duration_Mapping_Id
        INNER JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = ST.Candidate_Id
        INNER JOIN Tbl_Candidate_RollNumber CR ON CR.Candidate_Id = C.Candidate_Id
        LEFT JOIN Tbl_Exam_Internal_Marks IM ON IM.Semester_Subject_Id = SS.Semester_Subject_Id
        LEFT JOIN Tbl_Exam_Candidate_Internal_Marks CIM ON CIM.Exam_InternalMarks_Id = IM.Exam_InternalMarks_Id 
            AND CIM.Candidate_Id = C.Candidate_Id
        WHERE SS.Semester_Subjects_Status = 0
          AND SS.Duration_Mapping_Id = '''''' + @Mapping_ID + ''''''
          AND C.Candidate_Id = '''''' + @CandidateID + ''''''
          AND (SELECT COUNT(Subject_Id) FROM Tbl_Subject WHERE Parent_Subject_Id = S.Subject_Id) = 0
    ) AS SourceTable
    PIVOT (
        MAX(Internal_Marks) 
        FOR Subject_Code IN ('' + @subjects + '')
    ) AS PivotTable''

    EXEC sp_executesql @query
END
');
END;