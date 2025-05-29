IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_isso_dashboard_det]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_isso_dashboard_det] 
@flag INT
AS
BEGIN
    IF @flag = 0
    BEGIN
        SELECT COUNT(DISTINCT CD.Candidate_Id)
        FROM Tbl_Candidate_Personal_Det CD
        LEFT JOIN Tbl_Nationality N ON CD.Candidate_Nationality = CAST(N.Nationality_Id AS VARCHAR)
        LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CD.Candidate_Id = CCD.Candidate_Id
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CD.New_Admission_Id
        LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id 
        LEFT JOIN Tbl_Course_Batch_Duration BD ON NA.Batch_Id = BD.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid
        LEFT JOIN Tbl_Candidate_Englishtest CE ON CD.Candidate_Id = CE.Cand_Id AND CE.Delete_Status=0
        LEFT JOIN tbl_approval_log VL ON CD.Candidate_Id = VL.Candidate_Id
        LEFT JOIN TBL_Gender G ON CD.Candidate_Gender = G.Gender_Name
        LEFT JOIN Tbl_Candidate_NopassportList CNP ON CD.Candidate_Id = CNP.Candidate_id
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) V ON CD.Candidate_Id = V.Candidate_Id
        WHERE CD.TypeOfStudent = ''INTERNATIONAL''
        AND CD.ApplicationStatus IN(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
        AND CD.Status=''ACTIVE''
        AND CD.Active_Status = ''ACTIVE''
        AND NOT EXISTS (
            SELECT 1
            FROM Tbl_Candidate_Personal_Det CD2
            WHERE CD2.Candidate_Id = CD.Candidate_Id
            AND CD2.Active = 3
            AND CD2.ApplicationStatus IN (
                ''rejected'', ''Conditional_Admission'',''Completed''
            )
        );
    END
   
    IF @flag = 1
    BEGIN
        WITH RankedCandidates AS (
            SELECT 
                d.Candidate_Id, 
                d.Candidate_Fname,
                d.typeofstudent,
                d.ApplicationStatus,
                d.Active,
                v.Visa_Status,
                v.Visa_Type,
                ROW_NUMBER() OVER (PARTITION BY d.Candidate_Id ORDER BY v.Visa_Status DESC) AS rn
            FROM Tbl_Candidate_Personal_Det d
            INNER JOIN Tbl_Visa_ISSO v ON d.Candidate_Id = v.Candidate_Id
            WHERE d.typeofstudent = ''INTERNATIONAL'' 
            AND v.visa_Status = ''Applied'' 
            AND d.ApplicationStatus IN(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
            AND d.Status=''ACTIVE''
            AND d.Active_Status = ''ACTIVE''
            AND NOT EXISTS (
                SELECT 1
                FROM Tbl_Candidate_Personal_Det CD2
                LEFT JOIN Tbl_Visa_ISSO V2 ON CD2.Candidate_Id = V2.Candidate_Id
                WHERE CD2.Candidate_Id = d.Candidate_Id
                AND CD2.Active = 3
                AND CD2.ApplicationStatus = ''Completed''
                AND V2.Visa_Status = ''Approved''
                AND CD2.ApplicationStatus IN (
                    ''rejected'', ''Conditional_Admission'',''Completed''
                )
            )
        )
        SELECT COUNT(*) AS TotalCandidates FROM RankedCandidates WHERE rn = 1;
    END
    
    IF @flag = 2
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON cpd.Candidate_Id = tvi.Candidate_Id
        WHERE EXISTS (
            SELECT 1 FROM Tbl_Visa_ISSO V3
            WHERE V3.Candidate_Id = CPD.Candidate_Id
            AND V3.Visa_Status = ''Approved''
            AND V3.Expiry_Status = 0 
            AND V3.Del_Status = 0
        ) 
        AND CPD.Candidate_Nationality!=63 
        AND cpd.ApplicationStatus=''Completed'' 
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Status=''Approved'' 
        AND tvi.Visa_Expiry>=GETDATE() 
        AND cpd.active=3;
    END

    IF @flag = 3
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON CPD.Candidate_Id = tvi.Candidate_Id
        WHERE EXISTS (
            SELECT 1 FROM Tbl_Visa_ISSO V3
            WHERE V3.Candidate_Id = CPD.Candidate_Id
            AND V3.Visa_Status = ''Approved''
            AND V3.Expiry_Status = 0 
            AND V3.Del_Status = 0
        ) 
        AND cpd.typeofstudent= ''INTERNATIONAL'' 
        AND cpd.ApplicationStatus=''Completed'' 
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Type = ''Special Pass'' 
        AND tvi.Visa_Status=''Approved'' 
        AND cpd.active=3;
    END
    
    IF @flag = 4
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN Tbl_Visa_ISSO tvi ON tvi.Candidate_Id=cpd.Candidate_Id
        WHERE cpd.typeofstudent= ''INTERNATIONAL'' 
        AND cpd.ApplicationStatus=''Completed''  
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Status=''Approved'' 
        AND cpd.active=3 
        AND cpd.PassportDate IS NOT NULL 
        AND cpd.PassportDate <> ''''
        AND cpd.PassportDate <= DATEADD(MONTH, 3, GETDATE());
    END
    
    IF @flag = 5
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN Tbl_Visa_ISSO tvi ON tvi.Candidate_Id=cpd.Candidate_Id
        WHERE cpd.typeofstudent= ''INTERNATIONAL'' 
        AND cpd.ApplicationStatus=''Completed'' 
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Status=''Approved'' 
        AND cpd.active=3 
        AND cpd.PassportDate IS NOT NULL 
        AND cpd.PassportDate <> ''''
        AND cpd.PassportDate <= DATEADD(MONTH, 6, GETDATE()) 
        AND (cpd.PassportDate > DATEADD(MONTH, 3, GETDATE()));
    END

    IF @flag = 6
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN Tbl_Visa_ISSO tvi ON tvi.Candidate_Id=cpd.Candidate_Id
        WHERE cpd.typeofstudent= ''INTERNATIONAL'' 
        AND cpd.ApplicationStatus=''Completed''  
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Status=''Approved'' 
        AND cpd.active=3 
        AND cpd.PassportDate IS NOT NULL 
        AND cpd.PassportDate <> ''''
        AND cpd.PassportDate <= DATEADD(MONTH, 9, GETDATE()) 
        AND (cpd.PassportDate > DATEADD(MONTH,6, GETDATE()));
    END
    
    IF @flag = 7
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON CPD.Candidate_Id = tvi.Candidate_Id
        WHERE cpd.typeofstudent= ''INTERNATIONAL'' 
        AND cpd.ApplicationStatus=''Completed''  
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Status=''Approved'' 
        AND cpd.active=3 
        AND tvi.Visa_Expiry IS NOT NULL 
        AND tvi.Visa_Expiry <> ''''
        AND tvi.Visa_Expiry <= DATEADD(MONTH, 3, GETDATE());
    END
    
    IF @flag = 8
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON tvi.Candidate_Id=cpd.Candidate_Id
        WHERE cpd.typeofstudent= ''INTERNATIONAL'' 
        AND cpd.ApplicationStatus=''Completed''  
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Status=''Approved'' 
        AND cpd.active=3 
        AND tvi.Visa_Expiry IS NOT NULL 
        AND tvi.Visa_Expiry <> ''''
        AND tvi.Visa_Expiry <= DATEADD(MONTH, 6, GETDATE()) 
        AND tvi.Visa_Expiry > DATEADD(MONTH, 3, GETDATE());
    END
    
    IF @flag = 9
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON tvi.Candidate_Id=cpd.Candidate_Id
        WHERE cpd.typeofstudent= ''INTERNATIONAL'' 
        AND cpd.ApplicationStatus=''Completed''  
        AND tvi.Expiry_Status=0 
        AND tvi.DEL_STATUS=0 
        AND tvi.Visa_Status=''Approved'' 
        AND cpd.active=3 
        AND tvi.Visa_Expiry IS NOT NULL 
        AND tvi.Visa_Expiry <> ''''
        AND tvi.Visa_Expiry <= DATEADD(MONTH, 9, GETDATE()) 
        AND (tvi.Visa_Expiry > DATEADD(MONTH, 6, GETDATE()));
    END

    IF @flag = 10
    BEGIN
        WITH Months AS (
            SELECT 1 AS MonthID, ''Jan'' AS MonthName UNION ALL
            SELECT 2, ''Feb'' UNION ALL
            SELECT 3, ''Mar'' UNION ALL
            SELECT 4, ''Apr'' UNION ALL
            SELECT 5, ''May'' UNION ALL
            SELECT 6, ''Jun'' UNION ALL
            SELECT 7, ''Jul'' UNION ALL
            SELECT 8, ''Aug'' UNION ALL
            SELECT 9, ''Sep'' UNION ALL
            SELECT 10, ''Oct'' UNION ALL
            SELECT 11, ''Nov'' UNION ALL
            SELECT 12, ''Dec''
        ),
        LatestVisa AS (
            SELECT * FROM (
                SELECT 
                    tvi.*, 
                    ROW_NUMBER() OVER (PARTITION BY tvi.Candidate_Id ORDER BY tvi.Visa_Id DESC) AS rn
                FROM Tbl_Visa_ISSO tvi 
                LEFT JOIN Tbl_Candidate_Personal_Det cpd
                    ON cpd.Candidate_Id = tvi.Candidate_Id
                WHERE tvi.Expiry_Status = 0
                    AND tvi.DEL_STATUS = 0 
                    AND tvi.Visa_Status = ''Approved''
                    AND cpd.ApplicationStatus = ''Completed''
            ) tvi_latest
            WHERE rn = 1
        )
        SELECT 
            m.MonthName, 
            m.MonthID,
            COALESCE(t1.ExpiryCount, 0) + COALESCE(t2.ExpiryCount, 0) AS TotalExpiryCount
        FROM Months m
        LEFT JOIN (
            SELECT 
                MONTH(tvi.Visa_Expiry) AS MonthID, 
                COUNT(tvi.Visa_Expiry) AS ExpiryCount
            FROM Tbl_Candidate_Personal_Det cpd
            LEFT JOIN LatestVisa tvi 
                ON tvi.Candidate_Id = cpd.Candidate_Id 
            WHERE cpd.typeofstudent = ''INTERNATIONAL'' 
                AND cpd.ApplicationStatus = ''Completed''  
                AND cpd.active = 3 
                AND tvi.Visa_Expiry IS NOT NULL
                AND YEAR(tvi.Visa_Expiry) = YEAR(GETDATE())
            GROUP BY MONTH(tvi.Visa_Expiry)
        ) t1 ON m.MonthID = t1.MonthID
        LEFT JOIN (
            SELECT 
                MONTH(cpd.PassportDate) AS MonthID, 
                COUNT(cpd.PassportDate) AS ExpiryCount
            FROM Tbl_Candidate_Personal_Det cpd
            LEFT JOIN LatestVisa tvi 
                ON tvi.Candidate_Id = cpd.Candidate_Id 
            WHERE cpd.typeofstudent = ''INTERNATIONAL'' 
                AND cpd.ApplicationStatus = ''Completed''  
                AND cpd.active = 3 
                AND cpd.PassportDate IS NOT NULL
                AND YEAR(cpd.PassportDate) = YEAR(GETDATE())
            GROUP BY MONTH(cpd.PassportDate)
        ) t2 ON m.MonthID = t2.MonthID
        ORDER BY m.MonthID;
    END
    
    IF @flag = 11
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON cpd.Candidate_Id = tvi.Candidate_Id
        WHERE CPD.Candidate_Nationality!=63 
        AND cpd.ApplicationStatus=''Completed'' 
        AND cpd.active=15;
    END
    
    IF @flag = 12
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON cpd.Candidate_Id = tvi.Candidate_Id
        WHERE CPD.Candidate_Nationality!=63 
        AND cpd.ApplicationStatus=''Completed''  
        AND cpd.active=7;
    END
    
    IF @flag = 13
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON cpd.Candidate_Id = tvi.Candidate_Id
        WHERE CPD.Candidate_Nationality!=63 
        AND cpd.ApplicationStatus=''Completed''  
        AND cpd.active=6;
    END
    
    IF @flag = 14
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Candidate_Personal_Det cpd
        LEFT JOIN (
            SELECT V1.*
            FROM Tbl_Visa_ISSO V1
            WHERE V1.Visa_Id = (
                SELECT MAX(V2.Visa_Id)
                FROM Tbl_Visa_ISSO V2
                WHERE V2.Candidate_Id = V1.Candidate_Id
            )
        ) tvi ON cpd.Candidate_Id = tvi.Candidate_Id
        WHERE CPD.Candidate_Nationality!=63 
        AND cpd.ApplicationStatus=''Completed'' 
        AND cpd.active=5;
    END
END
');
END;