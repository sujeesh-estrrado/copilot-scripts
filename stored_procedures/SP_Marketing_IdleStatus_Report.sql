IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_IdleStatus_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Marketing_IdleStatus_Report]
        @flag INT,
        @Employee_Id BIGINT = 0,
        @Department_Id BIGINT = 0,
        @Agent_ID BIGINT = 0,
        @days BIGINT = 0,
        @CurrentPage BIGINT = 0,
        @PageSize BIGINT = 0
    AS      
    BEGIN 
        IF (@flag = 1)
        BEGIN
            DECLARE @UpperBand INT;
            DECLARE @LowerBand INT;

            SET @LowerBand = (@CurrentPage - 1) * @PageSize;
            SET @UpperBand = (@CurrentPage * @PageSize) + 1;
   
            SELECT * INTO #TEMP1 FROM
            (
                SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id DESC) AS slno, BK.*  
                FROM (        
                    SELECT DISTINCT 
                        D.Candidate_Id,
                        Candidate_Fname + '' '' + Candidate_Lname AS Candidatename,
                        AdharNumber,
                        P.Course_Code + '' - '' + Department_Name AS Course,
                        Candidate_Mob1,
                        Department_Name,
                        P.Course_Code,
                        E.Employee_FName + '' '' + Employee_LName AS CounselorName,
                        CONVERT(VARCHAR, d.LastUpdate, 101) AS LastUpdate,
                        A.Agent_Name,
                        D.IDMatrixNo, 
                        COALESCE(DATEDIFF(DAY, d.LastUpdate, GETUTCDATE()), '''') AS LastUpdate2
                    FROM Tbl_Candidate_Personal_Det D
                    INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
                    LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
                    LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
                    LEFT JOIN Tbl_Agent A ON A.Agent_ID = D.Agent_ID 
                    LEFT JOIN Tbl_Employee E ON E.Employee_Id = D.CounselorEmployee_id
                    LEFT JOIN Tbl_Candidate_Additionalqualification AQ ON AQ.Candidate_Id = D.Candidate_Id
                    WHERE (ApplicationStatus IN (''Pending'', ''Conditional_Admission'', ''Verified'', 
                        ''approved'', ''submited'', ''Preactivated''))
                    AND (ISNULL(@Employee_Id, 0) = 0 OR E.Employee_Id = @Employee_Id)
                    AND (ISNULL(@Department_Id, 0) = 0 OR N.Department_Id = @Department_Id)
                    AND (ISNULL(@Agent_ID, 0) = 0 OR D.Agent_ID = @Agent_ID)
                    AND DATEDIFF(DAY, LastUpdate, GETUTCDATE()) >= @days
                ) BK  
            ) B;

            SELECT *, ''Staff: '' + CounselorName AS CounselorNames, 
                      ''Agent: '' + Agent_Name AS Agent_Names 
            FROM #TEMP1 
            WHERE slno > CONVERT(VARCHAR, @LowerBand)  
            AND slno < CONVERT(VARCHAR, @UpperBand);

            DROP TABLE #TEMP1;
        END

        ELSE IF (@flag = 2)
        BEGIN
            SELECT * INTO #TEMP2 FROM
            (
                SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id DESC) AS slno, BK.*  
                FROM (        
                    SELECT DISTINCT 
                        D.Candidate_Id,
                        Candidate_Fname + '' '' + Candidate_Lname AS Candidatename,
                        AdharNumber,
                        P.Course_Code + '' - '' + Department_Name AS Course,
                        Candidate_Mob1,
                        Department_Name,
                        P.Course_Code,
                        E.Employee_FName + '' '' + Employee_LName AS CounselorName,
                        A.Agent_Name,
                        D.IDMatrixNo,
                        COALESCE(DATEDIFF(DAY, d.LastUpdate, GETUTCDATE()), '''') AS LastUpdate
                    FROM Tbl_Candidate_Personal_Det D
                    INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
                    LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
                    LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
                    LEFT JOIN Tbl_Agent A ON A.Agent_ID = D.Agent_ID 
                    LEFT JOIN Tbl_Employee E ON E.Employee_Id = D.CounselorEmployee_id
                    LEFT JOIN Tbl_Candidate_Additionalqualification AQ ON AQ.Candidate_Id = D.Candidate_Id
                    WHERE (ApplicationStatus IN (''Pending'', ''Conditional_Admission'', ''Verified'', 
                        ''approved'', ''submited'', ''Preactivated''))
                    AND (ISNULL(@Employee_Id, 0) = 0 OR E.Employee_Id = @Employee_Id)
                    AND (ISNULL(@Department_Id, 0) = 0 OR N.Department_Id = @Department_Id)
                    AND (ISNULL(@Agent_ID, 0) = 0 OR D.Agent_ID = @Agent_ID)
                    AND COALESCE(DATEDIFF(DAY, LastUpdate, GETUTCDATE()), '''') <= @days
                ) BK  
            ) B;

            SELECT COUNT(Candidate_Id) AS totcount FROM #TEMP2;
            
            DROP TABLE #TEMP2;
        END
    END;')
END;
