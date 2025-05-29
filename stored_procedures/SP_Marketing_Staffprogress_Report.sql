IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_Staffprogress_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Marketing_Staffprogress_Report]  
(	
	@flag bigint = 0,
	@staff bigint = 0,
	@faculty bigint = 0,
	--@program bigint = 0,
	@Fromdate varchar(MAX) = '''',
	@todate varchar(MAX) = ''''
)
AS      
BEGIN 
    IF (@flag = 1)
    BEGIN
        SELECT DISTINCT L.Course_Level_Id, L.Course_Level_Name
        FROM Tbl_Course_Level L 
        LEFT JOIN Tbl_Department D ON L.Course_Level_Id = D.GraduationTypeId
        LEFT JOIN tbl_New_Admission N ON N.Department_Id = D.Department_Id
        LEFT JOIN Tbl_Candidate_Personal_Det P ON P.New_Admission_Id = N.New_Admission_Id 
        WHERE Course_Level_Status = 0
    END
    
    IF (@flag = 2)
    BEGIN
        CREATE TABLE #tempdept(Department_Id bigint, Department_Name varchar(MAX))
        
        INSERT INTO #tempdept (Department_Id, Department_Name)
        SELECT DISTINCT D.Department_Id, D.Course_Code + '' - '' + D.Department_Name + '' ( '' + L.Course_Level_Name + '' ) '' AS Department_Name
        FROM Tbl_Department D 
        LEFT JOIN Tbl_Course_Level L ON D.GraduationTypeId = L.Course_Level_Id
        LEFT JOIN tbl_New_Admission N ON N.Department_Id = D.Department_Id
        LEFT JOIN Tbl_Candidate_Personal_Det P ON P.New_Admission_Id = N.New_Admission_Id
        WHERE (L.Course_Level_Id = @faculty OR @faculty = 0) 
          AND Department_status = 0 
          AND D.Delete_status = 0
        
        CREATE TABLE #tempunpaid(TotalOutstanding bigint, studentid bigint)
        
        INSERT INTO #tempunpaid (TotalOutstanding, studentid)
        SELECT SUM(outstandingbalance) AS TotalOutstanding, studentid 
        FROM student_bill 
        GROUP BY studentid
        
        CREATE TABLE #tempunpaids(unpaid bigint, Department_Id bigint)
        
        INSERT INTO #tempunpaids (unpaid, Department_Id)
        SELECT COUNT(DISTINCT D.Candidate_Id) AS unpaid, N.Department_Id
        FROM Tbl_Candidate_Personal_Det D
        LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
        LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
        LEFT JOIN Tbl_Offerlettre O ON O.candidate_id = D.Candidate_Id 
        WHERE D.Candidate_Id IN (SELECT studentid FROM #tempunpaid WHERE TotalOutstanding > 0)
          AND (ApplicationStatus IN (''Pending'', ''Conditional_Admission'', ''Verified'', ''approved'', ''submited'', ''Preactivated''))
          AND ((RegDate BETWEEN @Fromdate AND @todate) 
               OR (@Fromdate = '''' AND @todate = '''') 
               OR (RegDate BETWEEN @Fromdate AND GETDATE()) 
               OR (RegDate BETWEEN @todate AND GETDATE()))
          AND (@staff = 0 OR D.CounselorEmployee_id = @staff)
        GROUP BY N.Department_Id
        
        CREATE TABLE #temppaid(TotalOutstanding bigint, studentid bigint)
        
        INSERT INTO #temppaid (TotalOutstanding, studentid)
        SELECT SUM(outstandingbalance) AS TotalOutstanding, studentid 
        FROM student_bill 
        GROUP BY studentid
        
        CREATE TABLE #temppaids(paid bigint, Department_Id bigint)
        
        INSERT INTO #temppaids (paid, Department_Id)
        SELECT COUNT(DISTINCT D.Candidate_Id) AS paid, N.Department_Id
        FROM Tbl_Candidate_Personal_Det D
        LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
        LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
        LEFT JOIN Tbl_Offerlettre O ON O.candidate_id = D.Candidate_Id 
        WHERE D.Candidate_Id IN (SELECT studentid FROM #temppaid WHERE TotalOutstanding <= 0)
          AND (ApplicationStatus IN (''Pending'', ''Conditional_Admission'', ''Verified'', ''approved'', ''submited'', ''Preactivated''))
          AND ((RegDate BETWEEN @Fromdate AND @todate) 
               OR (@Fromdate = '''' AND @todate = '''') 
               OR (RegDate BETWEEN @Fromdate AND GETDATE()) 
               OR (RegDate BETWEEN @todate AND GETDATE()))
          AND (@staff = 0 OR D.CounselorEmployee_id = @staff)
        GROUP BY N.Department_Id
        
        CREATE TABLE #tempoffers(TotalOutstanding bigint, Department_Id bigint)
        
        INSERT INTO #tempoffers (TotalOutstanding, Department_Id)
        SELECT COUNT(DISTINCT Offerletter_Path) AS Offerletter_Path, N.Department_Id 
        FROM Tbl_Candidate_Personal_Det D
        LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
        LEFT JOIN Tbl_Offerlettre O ON O.candidate_id = D.Candidate_Id
        WHERE Offerletter_Path IS NOT NULL 
          AND (ApplicationStatus IN (''Pending'', ''Conditional_Admission'', ''Verified'', ''approved'', ''submited'', ''Preactivated''))
          AND ((RegDate BETWEEN @Fromdate AND @todate) 
               OR (@Fromdate = '''' AND @todate = '''') 
               OR (RegDate BETWEEN @Fromdate AND GETDATE()) 
               OR (RegDate BETWEEN @todate AND GETDATE()))
          AND (@staff = 0 OR D.CounselorEmployee_id = @staff)
        GROUP BY N.Department_Id
        
        CREATE TABLE #temprejected(countreject bigint, Department_Id bigint)
        
        INSERT INTO #temprejected (countreject, Department_Id)
        SELECT COUNT(D.Candidate_Id) AS countreject, N.Department_Id 
        FROM Tbl_Candidate_Personal_Det D
        LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
        WHERE ApplicationStatus = ''rejected''
          AND ((RegDate BETWEEN @Fromdate AND @todate) 
               OR (@Fromdate = '''' AND @todate = '''') 
               OR (RegDate BETWEEN @Fromdate AND GETDATE()) 
               OR (RegDate BETWEEN @todate AND GETDATE()))
          AND (@staff = 0 OR D.CounselorEmployee_id = @staff)
        GROUP BY N.Department_Id
        
        SELECT d.Department_Id, 
               Department_Name,
               ISNULL(unpaid, 0) AS unpaid,
               ISNULL(paid, 0) AS paid,
               COALESCE(TotalOutstanding, 0) AS Offerlettercount,
               COALESCE(countreject, 0) AS countreject 
        FROM #tempdept d 
        LEFT JOIN #tempunpaids u ON d.Department_Id = u.Department_Id
        LEFT JOIN #temppaids p ON d.Department_Id = p.Department_Id
        LEFT JOIN #tempoffers o ON d.Department_Id = o.Department_Id
        LEFT JOIN #temprejected r ON d.Department_Id = r.Department_Id
    END
END
');
END