IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_InterNational_StudentList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_InterNational_StudentList]         
(        
    @Flag INT = 0,        
    @SearchTerm VARCHAR(MAX) = '''',        
    @CurrentPage BIGINT = 0,        
    @PageSize BIGINT = 0,        
    @Gender BIGINT = 0,         
    @Intake_Id BIGINT = 0,        
    @Department_Id BIGINT = 0,        
    @Status BIGINT = 0,
    @Nationality BIGINT = 0
)        
AS        
BEGIN        
    IF @Flag IN (1, 2, 3, 4, 5, 6, 7)        
    BEGIN        
        DECLARE @UpperBand INT, @LowerBand INT;        
        SET @LowerBand = (@CurrentPage - 1) * @PageSize;        
        SET @UpperBand = (@CurrentPage * @PageSize);    
		 
		DECLARE @StatusText VARCHAR(50);
		IF @Status <> 0
		BEGIN
		    SELECT @StatusText = Status_Name 
		    FROM tbl_Visa_Status 
		    WHERE Visa_Status_Id = @Status;
		END

        DECLARE @TotalRecords INT;
        SELECT @TotalRecords = COUNT(DISTINCT CD.Candidate_Id)
        FROM Tbl_Candidate_Personal_Det CD
        LEFT JOIN Tbl_Nationality N ON CD.Candidate_Nationality = CAST(N.Nationality_Id AS VARCHAR)
        LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CD.Candidate_Id = CCD.Candidate_Id
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CD.New_Admission_Id
        LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id 
        LEFT JOIN Tbl_Course_Batch_Duration BD ON NA.Batch_Id = BD.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid
        LEFT JOIN Tbl_Candidate_Englishtest CE ON CD.Candidate_Id = CE.Cand_Id and CE.Delete_Status=0
        LEFT JOIN tbl_approval_log VL ON CD.Candidate_Id = VL.Candidate_Id
		LEFT JOIN TBL_Gender G ON CD.Candidate_Gender = G.Gender_Name
		LEFT JOIN Tbl_Candidate_NopassportList CNP ON CD.Candidate_Id = CNP.Candidate_id and CNP.Delete_status=0
		LEFT JOIN 
		(
		    SELECT Candidate_Id, Visa_Status,Visa_Type
		    FROM (
		        SELECT 
		            Candidate_Id, 
		            Visa_Status,
					Visa_Type,
		            ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Visa_Id DESC) AS rn
		        FROM Tbl_Visa_ISSO 
				WHERE EXPIRY_STATUS = 0
		    ) AS LatestVisa
		    WHERE rn = 1
		) V ON CD.Candidate_Id = V.Candidate_Id
        WHERE 
            CD.TypeOfStudent = ''INTERNATIONAL''
			AND CD.ApplicationStatus in(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
			AND CD.Status=''ACTIVE''
			AND CD.Active_Status = ''ACTIVE''
			AND (@Gender = 0 OR G.Gender_Id = @Gender)
            AND (@Nationality = 0 OR CD.Candidate_Nationality = CAST(@Nationality AS VARCHAR))
			AND (@Department_Id = 0 OR NA.Department_Id = @Department_Id)
			AND (@Intake_Id = 0 OR NA.Batch_Id = @Intake_Id)
		    AND (@Status = 0 OR ISNULL(V.Visa_Status, ''Pending'') = @StatusText)
            AND (
                CD.Candidate_Fname LIKE ''%'' + @SearchTerm + ''%''
                OR CD.Candidate_Lname LIKE ''%'' + @SearchTerm + ''%''
                OR N.Nationality LIKE ''%'' + @SearchTerm + ''%''
                OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
				OR CD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
				OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                OR IM.Batch_Code LIKE ''%'' + @SearchTerm + ''%''
				OR NA.Batch_Id LIKE ''%'' + @SearchTerm + ''%''
				OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
                OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                OR CCD.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
                OR v.Visa_Type LIKE ''%'' + @SearchTerm + ''%''
                OR CONCAT(LTRIM(RTRIM(CD.Candidate_Fname)), '' '', LTRIM(RTRIM(CD.Candidate_Lname))) LIKE ''%'' + @SearchTerm + ''%''
           )
		   AND NOT EXISTS (
				SELECT 1
				FROM Tbl_Candidate_Personal_Det CD2
				WHERE CD2.Candidate_Id = CD.Candidate_Id
				  AND CD2.Active = 3
				  AND CD2.ApplicationStatus IN (
					  ''rejected'', ''Conditional_Admission'',''Completed''
				  )
			);

        WITH RankedStudents AS (
            SELECT DISTINCT
                CD.Candidate_Id,
                CONCAT(CD.Candidate_Fname, '' '', CD.Candidate_Mname, '' '', CD.Candidate_Lname) AS StudentName,
                CD.Candidate_Gender,
                N.Nationality,
                CD.AdharNumber AS ICPassport,
                D.Department_Name AS Program,
                IM.Batch_Code AS masterintake,
                CCD.Candidate_Mob1 AS MobileNumber,                                          
                CCD.Candidate_Email AS EmailID,
                CASE WHEN CE.Cand_Id IS NOT NULL THEN ''Yes'' ELSE ''No'' END AS EnglishQualification,
                CASE WHEN VL.offer_letter_accept_date IS NOT NULL THEN ''YES'' ELSE ''NO'' END AS OfferLetterAccepted,
				CASE WHEN CNP.Candidate_id IS NOT NULL THEN ''Yes'' ELSE ''No'' END AS Temp,
				CASE WHEN V.Visa_Status IS NOT NULL THEN V.Visa_Status ELSE ''Pending'' END AS VisaStatus,
				CASE WHEN V.Visa_Type IS NULL OR V.Visa_Type = '''' THEN ''-'' ELSE V.Visa_Type END AS Visa_Type,
                ROW_NUMBER() OVER (
                  ORDER BY 
                    CASE WHEN VL.offer_letter_accept_date IS NOT NULL THEN 1 ELSE 0 END DESC, 
                    CD.Candidate_Id
                ) AS RowNum
            FROM Tbl_Candidate_Personal_Det CD
            LEFT JOIN Tbl_Nationality N ON CD.Candidate_Nationality = CAST(N.Nationality_Id AS VARCHAR)
            LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CD.Candidate_Id = CCD.Candidate_Id
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CD.New_Admission_Id
            LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id 
            LEFT JOIN Tbl_Course_Batch_Duration BD ON NA.Batch_Id = BD.Batch_Id 
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid
            LEFT JOIN Tbl_Candidate_Englishtest CE ON CD.Candidate_Id = CE.Cand_Id and CE.Delete_Status=0
            LEFT JOIN tbl_approval_log VL ON CD.Candidate_Id = VL.Candidate_Id
			LEFT JOIN TBL_Gender G ON CD.Candidate_Gender = G.Gender_Name
			LEFT JOIN Tbl_Candidate_NopassportList CNP ON CD.Candidate_Id = CNP.Candidate_id and CNP.Delete_status=0
			LEFT JOIN 
			(
			    SELECT Candidate_Id, Visa_Status,Visa_Type
			    FROM (
			        SELECT 
			            Candidate_Id, 
			            Visa_Status,
						Visa_Type,
			            ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Visa_Id DESC) AS rn
			        FROM Tbl_Visa_ISSO
                   WHERE EXPIRY_STATUS = 0
			    ) AS LatestVisa
			    WHERE rn = 1
			) V ON CD.Candidate_Id = V.Candidate_Id
            WHERE 
                CD.TypeOfStudent = ''INTERNATIONAL''
				AND CD.ApplicationStatus in(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
				AND CD.Status=''ACTIVE''
				AND CD.Active_Status = ''ACTIVE''
				AND (@Gender = 0 OR G.Gender_Id = @Gender)
				AND (@Nationality = 0 OR CD.Candidate_Nationality = CAST(@Nationality AS VARCHAR))
				AND (@Department_Id = 0 OR NA.Department_Id = @Department_Id)
				AND (@Intake_Id = 0 OR NA.Batch_Id = @Intake_Id)
				AND (@Status = 0 OR ISNULL(V.Visa_Status, ''Pending'') = @StatusText)
                AND (
                    CD.Candidate_Fname LIKE ''%'' + @SearchTerm + ''%''
                    OR CD.Candidate_Lname LIKE ''%'' + @SearchTerm + ''%''
                    OR N.Nationality LIKE ''%'' + @SearchTerm + ''%''
					OR CD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
					OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                    OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
					OR NA.Batch_Id LIKE ''%'' + @SearchTerm + ''%''
				    OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
                    OR IM.Batch_Code LIKE ''%'' + @SearchTerm + ''%''
                    OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                    OR CCD.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
                    OR v.Visa_Type LIKE ''%'' + @SearchTerm + ''%''
                    OR CONCAT(LTRIM(RTRIM(CD.Candidate_Fname)), '' '', LTRIM(RTRIM(CD.Candidate_Lname))) LIKE ''%'' + @SearchTerm + ''%''
                )
        )
        SELECT 
			Temp,
            OfferLetterAccepted,
			VisaStatus,
            Candidate_Id,
            StudentName,
            Candidate_Gender,
            Nationality,
            ICPassport,
            Program,
            masterintake,
            MobileNumber,
            EmailID,
			Visa_Type,
            EnglishQualification,		
            RowNum,
            @TotalRecords AS TotalRecords
        FROM RankedStudents
        WHERE RowNum BETWEEN @LowerBand + 1 AND @UpperBand
		ORDER BY OfferLetterAccepted DESC
        OPTION (RECOMPILE);
    END

    IF @Flag = 100
	BEGIN
	    SET @LowerBand = (@CurrentPage - 1) * @PageSize;        
        SET @UpperBand = (@CurrentPage * @PageSize);    
		
        SELECT @TotalRecords = COUNT(DISTINCT CD.Candidate_Id)
        FROM Tbl_Candidate_Personal_Det CD
        LEFT JOIN Tbl_Nationality N ON CD.Candidate_Nationality = CAST(N.Nationality_Id AS VARCHAR)
        LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CD.Candidate_Id = CCD.Candidate_Id
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CD.New_Admission_Id
        LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id 
        LEFT JOIN Tbl_Course_Batch_Duration BD ON NA.Batch_Id = BD.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid
        LEFT JOIN Tbl_Candidate_Englishtest CE ON CD.Candidate_Id = CE.Cand_Id and CE.Delete_Status=0
        LEFT JOIN tbl_approval_log VL ON CD.Candidate_Id = VL.Candidate_Id
        LEFT JOIN TBL_Gender G ON CD.Candidate_Gender = G.Gender_Name
        LEFT JOIN Tbl_Candidate_NopassportList CNP ON CD.Candidate_Id = CNP.Candidate_id and CNP.Delete_Status=0
        LEFT JOIN 
        (
            SELECT Candidate_Id, Visa_Status, Visa_Expiry, Visa_Type
            FROM (
                SELECT 
                    Candidate_Id, 
                    Visa_Status,
                    Visa_Expiry,
                    Visa_Type,
                    ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Visa_Id DESC) AS rn
                FROM Tbl_Visa_ISSO
            ) AS LatestVisa
            WHERE rn = 1
        ) V ON CD.Candidate_Id = V.Candidate_Id
        WHERE 
            CD.TypeOfStudent = ''INTERNATIONAL'' 
            AND (V.Visa_Status = ''Applied'') 
			AND CD.ApplicationStatus in(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
			AND CD.Status=''ACTIVE''
			AND CD.Active_Status = ''ACTIVE''
			AND (@Gender = 0 OR G.Gender_Id = @Gender)
            AND (@Nationality = 0 OR CD.Candidate_Nationality = CAST(@Nationality AS VARCHAR))
			AND (@Department_Id = 0 OR NA.Department_Id = @Department_Id)
			AND (@Intake_Id = 0 OR NA.Batch_Id = @Intake_Id)
		    AND (@Status = 0 OR ISNULL(V.Visa_Status, ''Pending'') = @StatusText)
            AND (
                CD.Candidate_Fname LIKE ''%'' + @SearchTerm + ''%''
                OR CD.Candidate_Lname LIKE ''%'' + @SearchTerm + ''%''
                OR N.Nationality LIKE ''%'' + @SearchTerm + ''%''
                OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
				OR CD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
				OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                OR IM.Batch_Code LIKE ''%'' + @SearchTerm + ''%''
				OR NA.Batch_Id LIKE ''%'' + @SearchTerm + ''%''
				OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
                OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                OR CCD.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
                OR v.Visa_Type LIKE ''%'' + @SearchTerm + ''%''
                OR CONCAT(LTRIM(RTRIM(CD.Candidate_Fname)), '' '', LTRIM(RTRIM(CD.Candidate_Lname))) LIKE ''%'' + @SearchTerm + ''%'')
            AND NOT EXISTS (
                SELECT 1
                FROM Tbl_Candidate_Personal_Det CD2
                LEFT JOIN Tbl_Visa_ISSO V2 ON CD2.Candidate_Id = V2.Candidate_Id
                WHERE CD2.Candidate_Id = CD.Candidate_Id
                AND CD2.Active = 3
                AND CD2.ApplicationStatus IN (
					  ''rejected'', ''Conditional_Admission'',''Completed''
				  )
                AND V2.Visa_Status = ''Approved''
            );

        WITH RankedStudents AS (
            SELECT 
                CD.Candidate_Id,
                CONCAT(CD.Candidate_Fname, '' '', CD.Candidate_Mname, '' '', CD.Candidate_Lname) AS StudentName,
                CD.Candidate_Gender,
                N.Nationality,
                CD.AdharNumber AS ICPassport,
                D.Department_Name AS Program,
                IM.Batch_Code AS masterintake,
                CCD.Candidate_Mob1 AS MobileNumber,                                          
                CCD.Candidate_Email AS EmailID,
                CASE WHEN CE.Cand_Id IS NOT NULL THEN ''YES'' ELSE ''NO'' END AS EnglishQualification,
                CASE WHEN VL.offer_letter_accept_date IS NOT NULL THEN ''YES'' ELSE ''NO'' END AS OfferLetterAccepted,
                CASE WHEN CNP.Candidate_id IS NOT NULL THEN ''YES'' ELSE ''NO'' END AS Temp,
                CASE WHEN V.Visa_Status IS NOT NULL THEN V.Visa_Status ELSE ''Pending'' END AS VisaStatus,
                V.Visa_Expiry,
				CASE WHEN V.Visa_Type IS NULL OR V.Visa_Type = '''' THEN ''-'' ELSE V.Visa_Type END AS Visa_Type,
                CD.PassportDate,
                ROW_NUMBER() OVER (
                    PARTITION BY CD.Candidate_Id 
                    ORDER BY VL.offer_letter_accept_date DESC, V.Visa_Expiry DESC, CD.Candidate_Id ASC
                ) AS RowNum
            FROM Tbl_Candidate_Personal_Det CD
            LEFT JOIN Tbl_Nationality N ON CD.Candidate_Nationality = CAST(N.Nationality_Id AS VARCHAR)
            LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CD.Candidate_Id = CCD.Candidate_Id
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CD.New_Admission_Id
            LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id 
            LEFT JOIN Tbl_Course_Batch_Duration BD ON NA.Batch_Id = BD.Batch_Id 
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid
            LEFT JOIN Tbl_Candidate_Englishtest CE ON CD.Candidate_Id = CE.Cand_Id and CE.Delete_Status=0
            LEFT JOIN tbl_approval_log VL ON CD.Candidate_Id = VL.Candidate_Id
            LEFT JOIN TBL_Gender G ON CD.Candidate_Gender = G.Gender_Name
            LEFT JOIN Tbl_Candidate_NopassportList CNP ON CD.Candidate_Id = CNP.Candidate_id and CNP.Delete_status=0
            LEFT JOIN 
            (
                SELECT Candidate_Id, Visa_Status, Visa_Expiry, Visa_Type
                FROM (
                    SELECT 
                        Candidate_Id, 
                        Visa_Status,
                        Visa_Expiry,
                        Visa_Type,
                        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Visa_Id DESC) AS rn
                    FROM Tbl_Visa_ISSO
                ) AS LatestVisa
                WHERE rn = 1
            ) V ON CD.Candidate_Id = V.Candidate_Id
            WHERE 
                CD.TypeOfStudent = ''INTERNATIONAL''  
                AND (V.Visa_Status = ''Applied'')
				AND CD.ApplicationStatus in(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
				AND CD.Status=''ACTIVE''
				AND CD.Active_Status = ''ACTIVE''
				AND (@Gender = 0 OR G.Gender_Id = @Gender)
                AND (@Nationality = 0 OR CD.Candidate_Nationality = CAST(@Nationality AS VARCHAR))
				AND (@Department_Id = 0 OR NA.Department_Id = @Department_Id)
				AND (@Intake_Id = 0 OR NA.Batch_Id = @Intake_Id)
				AND (@Status = 0 OR ISNULL(V.Visa_Status, ''Pending'') = @StatusText)
                AND (
                    CD.Candidate_Fname LIKE ''%'' + @SearchTerm + ''%''
                    OR CD.Candidate_Lname LIKE ''%'' + @SearchTerm + ''%''
                    OR N.Nationality LIKE ''%'' + @SearchTerm + ''%''
                    OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
					OR CD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
					OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                    OR IM.Batch_Code LIKE ''%'' + @SearchTerm + ''%''
					OR NA.Batch_Id LIKE ''%'' + @SearchTerm + ''%''
				    OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
                    OR CCD.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
                    OR CCD.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
                    OR v.Visa_Type LIKE ''%'' + @SearchTerm + ''%''
                    OR CONCAT(LTRIM(RTRIM(CD.Candidate_Fname)), '' '', LTRIM(RTRIM(CD.Candidate_Lname))) LIKE ''%'' + @SearchTerm + ''%''
                )
				AND NOT EXISTS (
                SELECT 1
                FROM Tbl_Candidate_Personal_Det CD2
                LEFT JOIN Tbl_Visa_ISSO V2 ON CD2.Candidate_Id = V2.Candidate_Id
                WHERE CD2.Candidate_Id = CD.Candidate_Id
                AND CD2.Active = 3
                AND CD2.ApplicationStatus IN (
					  ''rejected'', ''Conditional_Admission'',''Completed''
				  )
                AND V2.Visa_Status = ''Approved''
            )
        )
        SELECT 
            Temp,
            OfferLetterAccepted,
            VisaStatus,
            Candidate_Id,
            StudentName,
            Candidate_Gender,
            Nationality,
            ICPassport,
            Program,
            masterintake,
            MobileNumber,
            Visa_Expiry,
            EmailID,
            EnglishQualification,        
            Visa_Type,
            @TotalRecords AS TotalRecords,
            PassportDate
        FROM RankedStudents
        WHERE RowNum BETWEEN @LowerBand + 1 AND @UpperBand
        ORDER BY OfferLetterAccepted DESC
        OPTION (RECOMPILE);
	END  

    IF @Flag = 102
	BEGIN
        SET @LowerBand = (@CurrentPage - 1) * @PageSize;        
        SET @UpperBand = (@CurrentPage * @PageSize);    
		
        SELECT @TotalRecords = COUNT(DISTINCT CD.Candidate_Id)
        FROM Tbl_Candidate_Personal_Det CD
        LEFT JOIN Tbl_Nationality N ON CD.Candidate_Nationality = CAST(N.Nationality_Id AS VARCHAR)
        LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CD.Candidate_Id = CCD.Candidate_Id
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CD.New_Admission_Id
        LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id 
        LEFT JOIN Tbl_Course_Batch_Duration BD ON NA.Batch_Id = BD.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid
        LEFT JOIN Tbl_Candidate_Englishtest CE ON CD.Candidate_Id = CE.Cand_Id and CE.Delete_Status=0
        LEFT JOIN tbl_approval_log VL ON CD.Candidate_Id = VL.Candidate_Id
        LEFT JOIN TBL_Gender G ON CD.Candidate_Gender = G.Gender_Name
        LEFT JOIN Tbl_Candidate_NopassportList CNP ON CD.Candidate_Id = CNP.Candidate_id and CNP.Delete_status=0
        LEFT JOIN 
        (
            SELECT Candidate_Id, Visa_Status,EXPIRY_STATUS
            FROM (
                SELECT 
                    Candidate_Id, 
                    Visa_Status,
					EXPIRY_STATUS,
                    ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Visa_Id DESC) AS rn
                FROM Tbl_Visa_ISSO
                WHERE DEL_STATUS=0 
                AND EXPIRY_STATUS = 0
            ) AS LatestVisa
            WHERE rn = 1
        ) V ON CD.Candidate_Id = V.Candidate_Id
        WHERE 
           CD.TypeOfStudent = ''INTERNATIONAL''
			AND CD.ApplicationStatus in(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
			AND CD.Status=''ACTIVE''
			AND CD.Active_Status = ''ACTIVE'';

        WITH RankedStudents AS (
            SELECT DISTINCT
                CD.Candidate_Id,
                CONCAT(CD.Candidate_Fname, '' '', CD.Candidate_Mname, '' '', CD.Candidate_Lname) AS StudentName,
                CD.Candidate_Gender,
                N.Nationality,
                CD.AdharNumber AS ICPassport,
                D.Department_Name AS Program,
                IM.Batch_Code AS masterintake,
                CCD.Candidate_Mob1 AS MobileNumber,                                          
                CCD.Candidate_Email AS EmailID,
                CASE WHEN CE.Cand_Id IS NOT NULL THEN ''Yes'' ELSE ''No'' END AS EnglishQualification,
                CASE WHEN VL.offer_letter_accept_date IS NOT NULL THEN ''YES'' ELSE ''NO'' END AS OfferLetterAccepted,
                CASE WHEN CNP.Candidate_id IS NOT NULL THEN ''Yes'' ELSE ''No'' END AS Temp,
                CASE WHEN V.Visa_Status IS NOT NULL THEN V.Visa_Status ELSE ''Pending'' END AS VisaStatus,
				CASE WHEN V.Visa_Type IS NULL OR V.Visa_Type = '''' THEN ''-'' ELSE V.Visa_Type END AS Visa_Type,
		        v.Expiry_Status,
                ROW_NUMBER() OVER (
                  ORDER BY 
                    CASE WHEN VL.offer_letter_accept_date IS NOT NULL THEN 1 ELSE 0 END DESC, 
                    CD.Candidate_Id
                ) AS RowNum
            FROM Tbl_Candidate_Personal_Det CD
            LEFT JOIN Tbl_Nationality N ON CD.Candidate_Nationality = CAST(N.Nationality_Id AS VARCHAR)
            LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CD.Candidate_Id = CCD.Candidate_Id
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CD.New_Admission_Id
            LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id 
            LEFT JOIN Tbl_Course_Batch_Duration BD ON NA.Batch_Id = BD.Batch_Id 
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid
            LEFT JOIN Tbl_Candidate_Englishtest CE ON CD.Candidate_Id = CE.Cand_Id and CE.Delete_Status=0
            LEFT JOIN tbl_approval_log VL ON CD.Candidate_Id = VL.Candidate_Id
            LEFT JOIN TBL_Gender G ON CD.Candidate_Gender = G.Gender_Name
            LEFT JOIN Tbl_Candidate_NopassportList CNP ON CD.Candidate_Id = CNP.Candidate_id and CNP.Delete_status=0
            LEFT JOIN 
            (
                SELECT Candidate_Id, Visa_Status,Expiry_Status,Visa_Type
                FROM (
                    SELECT 
                        Candidate_Id, 
                        Visa_Status,
						Visa_Type,
						Expiry_Status,
                        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Visa_Id DESC) AS rn
                    FROM Tbl_Visa_ISSO
                    WHERE DEL_STATUS=0 
                    AND EXPIRY_STATUS = 0
                ) AS LatestVisa
                WHERE rn = 1
            ) V ON CD.Candidate_Id = V.Candidate_Id
            WHERE 
                CD.TypeOfStudent = ''INTERNATIONAL''
				AND CD.ApplicationStatus in(''pending'',''Pending'',''submited'',''Submited'',''approved'',''Verified'',''Preactivated'')
				AND CD.Status=''ACTIVE''
				AND CD.Active_Status = ''ACTIVE''
        )
        SELECT 
            Temp,
            OfferLetterAccepted,
            VisaStatus,
            Candidate_Id,
            StudentName,
            Candidate_Gender,
            Nationality,
            ICPassport,
            Program,
            masterintake,
            MobileNumber,
            EmailID,
            EnglishQualification,  
	        Expiry_Status,
            RowNum,
	        @TotalRecords AS TotalRecords
        FROM RankedStudents
        WHERE Expiry_Status=0 and RowNum BETWEEN @LowerBand + 1 AND @UpperBand
        ORDER BY OfferLetterAccepted DESC
        OPTION (RECOMPILE);
	END 
END
');
END;