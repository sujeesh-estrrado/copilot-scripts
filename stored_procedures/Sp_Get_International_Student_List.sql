IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_International_Student_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      
CREATE procedure [dbo].[Sp_Get_International_Student_List]
(
@CurrentPage int=null ,                                                                     
@PageSize int=null   ,                                                                  
@SearchTerm varchar(100)=''''  ,
@Gender varchar(100)='''' ,
@Nationality bigint=0,
@Department bigint=0,
@visatype varchar(100)='''',
@visafrom varchar(100)='''',
@visato varchar(100)='''',
@passportfrom varchar(100)='''',
@passportto varchar(100)='''',
@flag bigint=0
)
as
BEGIN    
if(@flag=0)
begin
    Declare @UpperBand int                                                                            
    Declare @LowerBand int                                      
                                                                         
    SET @LowerBand  = (@CurrentPage -                                                        
     1) * @PageSize                                                                            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1 

SELECT
    CPD.Candidate_Id AS ID,
    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
    CPD.AdharNumber,
    CPD.IDMatrixNo,
   Case when CPD.PassportDate is null then ''-''
   when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
    CASE 
        WHEN VI.Visa_Status IS NULL THEN ''Pending''  
        ELSE VI.Visa_Status 
    END AS Visa_Status,
    CPD.Candidate_Gender,
    N.Nationality,
    D.Department_Name,
    CBD.Batch_Code,
    CCD.Candidate_Mob1,
    CCD.Candidate_Email,
    CPD.TypeOfStudent,
   COUNT(*) OVER () AS TotalCount
FROM Tbl_Candidate_Personal_Det CPD
LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id
LEFT JOIN Tbl_Candidate_NopassportList CNO ON CNO.Candidate_id = CPD.Candidate_Id and CNO.Delete_status=0
LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CCD.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = CPD.Candidate_Nationality
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id
LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
WHERE 
--EXISTS (
    -- Ensure at least one approved visa exists
--    SELECT 1 FROM Tbl_Visa_ISSO V3
--    WHERE V3.Candidate_Id = CPD.Candidate_Id
--    AND V3.Visa_Status = ''Approved''
--    AND V3.Expiry_Status = 0 
--    AND V3.Del_Status = 0
--)
--AND
(
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
AND CPD.ApplicationStatus = ''Completed''
AND CPD.active = 3
AND CPD.Candidate_Nationality != 63



--and VI.Visa_Status=''Approved'' and VI.Expiry_Status=0 and VI.Del_Status=0

 ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

                            
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end
  if(@flag=109)
begin
                                       
                                                                         
    SET @LowerBand  = (@CurrentPage -                                                        
     1) * @PageSize                                                                            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1 

SELECT
    CPD.Candidate_Id AS ID,
    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
    CPD.AdharNumber,
    CPD.IDMatrixNo,
   Case when CPD.PassportDate is null then ''-''
   when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
    CASE 
        WHEN VI.Visa_Status IS NULL THEN ''Pending''  
        ELSE VI.Visa_Status 
    END AS Visa_Status,
    CPD.Candidate_Gender,
    N.Nationality,
    D.Department_Name,
    CBD.Batch_Code,
    CCD.Candidate_Mob1,
    CCD.Candidate_Email,
    CPD.TypeOfStudent,
   COUNT(*) OVER () AS TotalCount
FROM Tbl_Candidate_Personal_Det CPD
LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id
LEFT JOIN Tbl_Candidate_NopassportList CNO ON CNO.Candidate_id = CPD.Candidate_Id and CNO.Delete_status=0
LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CCD.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = CPD.Candidate_Nationality
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id
LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
WHERE
--EXISTS (
--    -- Ensure at least one approved visa exists
--    SELECT 1 FROM Tbl_Visa_ISSO V3
--    WHERE V3.Candidate_Id = CPD.Candidate_Id
--    AND V3.Visa_Status = ''Approved''
--    AND V3.Expiry_Status = 0 
--    AND V3.Del_Status = 0
--)
--AND 
(
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
AND CPD.ApplicationStatus = ''Completed''
AND CPD.active = 3
AND CPD.Candidate_Nationality != 63


and VI.Visa_Status=''Approved'' and VI.Expiry_Status=0 and VI.Del_Status=0

ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

                            
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end

  IF (@flag = 101)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

   WITH VisaDetails AS (
    SELECT 
        Candidate_Id, 
        Visa_Expiry, 
        Visa_Type, 
        Visa_Status, 
        Expiry_Status, 
        Del_Status, 
        Duration,
        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Applied_Date DESC) AS rn
    FROM Tbl_Visa_ISSO 
    WHERE Expiry_Status = 0 
        AND Del_Status = 0 
        AND Visa_Status = ''Approved''
),
FinalCandidates AS (
    SELECT 
        CPD.Candidate_Id AS ID,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        CPD.AdharNumber,
        CPD.IDMatrixNo,
        Case when CPD.PassportDate is null then ''-''
    when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
        COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
        CPD.Candidate_Gender,
        N.Nationality,
        D.Department_Name,
        CBD.Batch_Code,
        CCD.Candidate_Mob1,
        CCD.Candidate_Email,
        CPD.TypeOfStudent,
        ROW_NUMBER() OVER (
            PARTITION BY CPD.Candidate_Id 
            ORDER BY 
                CASE 
                    WHEN CPD.PassportDate IS NULL AND VI.Visa_Expiry IS NULL THEN 1  
                    ELSE 0  
                END ASC,
                CASE 
                    WHEN CPD.PassportDate IS NOT NULL AND VI.Visa_Expiry IS NOT NULL 
                    THEN CASE 
                             WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                             ELSE VI.Visa_Expiry 
                         END
                    ELSE COALESCE(CPD.PassportDate, VI.Visa_Expiry) 
                END ASC
        ) AS rn
    FROM Tbl_Candidate_Personal_Det CPD
    LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id  -- Ensures only the latest visa entry
    LEFT JOIN Tbl_Candidate_NopassportList CNO 
        ON CNO.Candidate_id = CPD.Candidate_Id
    LEFT JOIN Tbl_Candidate_ContactDetails CCD 
        ON CCD.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Nationality N 
        ON N.Nationality_Id = CPD.Candidate_Nationality
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration CBD 
        ON CBD.Batch_Id = NA.Batch_Id
    LEFT JOIN Tbl_Department D 
        ON D.Department_Id = NA.Department_Id
    WHERE 
  --EXISTS (
 --       -- Ensures only candidates with an approved visa appear
 --       SELECT 1 FROM Tbl_Visa_ISSO V3
 --       WHERE V3.Candidate_Id = CPD.Candidate_Id
 --           AND V3.Visa_Status = ''Approved''
 --           AND V3.Expiry_Status = 0 
 --           AND V3.Del_Status = 0
 --   ) 
  --AND 
  (
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
    AND CPD.ApplicationStatus = ''Completed''
    AND CPD.active = 3
  AND CPD.Candidate_Nationality!=63
    --AND CPD.TypeOfStudent = ''INTERNATIONAL''
    AND VI.Visa_Status = ''Approved'' 
    --AND VI.Expiry_Status = 0 
    --AND VI.Del_Status = 0 
    AND VI.Visa_Type = ''Special Pass''
),
FinalCount AS (
    SELECT *, COUNT(*) OVER () AS TotalCount
    FROM FinalCandidates
    WHERE rn = 1 -- Ensures only unique candidates
)
SELECT * FROM FinalCount
ORDER BY ID

    OFFSET @LowerBand ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;
  if(@flag=1)
  begin
  SELECT COUNT(*) AS Total_Count
FROM (

  SELECT DISTINCT CPD.Candidate_Id



FROM
Tbl_Candidate_Personal_Det CPD
LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id
LEFT JOIN Tbl_Candidate_NopassportList CNO ON CNO.Candidate_id = CPD.Candidate_Id and CNO.Delete_status=0
LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CCD.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = CPD.Candidate_Nationality
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id
LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
WHERE
--EXISTS (
--    -- Ensure at least one approved visa exists
--    SELECT 1 FROM Tbl_Visa_ISSO V3
--    WHERE V3.Candidate_Id = CPD.Candidate_Id
--    AND V3.Visa_Status = ''Approved''
--    AND V3.Expiry_Status = 0 
--    AND V3.Del_Status = 0
--)
--AND
(
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
AND CPD.ApplicationStatus = ''Completed''
AND CPD.active = 3
AND CPD.Candidate_Nationality != 63


--AND cpd.typeofstudent= ''INTERNATIONAL'' 
)as RowCountQuery;
  end
  IF (@flag = 103)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

    WITH VisaDetails AS (
        SELECT 
            Candidate_Id, 
            Visa_Expiry, 
            Visa_Type, 
            Visa_Status, 
            Expiry_Status, 
            Del_Status, 
            Duration,
            ROW_NUMBER() OVER (
                PARTITION BY Candidate_Id 
                ORDER BY Applied_Date DESC
            ) AS rn
        FROM Tbl_Visa_ISSO 
        WHERE Expiry_Status = 0 
            AND Del_Status = 0 
            AND Visa_Status = ''Approved''
    ),
    FinalCandidates AS (
        SELECT
            CPD.Candidate_Id AS ID,
            CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
            CPD.AdharNumber,
            CPD.IDMatrixNo,
            Case when CPD.PassportDate is null then ''-''
      when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
            COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
            CPD.Candidate_Gender,
            N.Nationality,
            D.Department_Name,
            CBD.Batch_Code,
            CCD.Candidate_Mob1,
            CCD.Candidate_Email,
            CPD.TypeOfStudent,
            ROW_NUMBER() OVER (
                PARTITION BY CPD.Candidate_Id 
               ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

            ) AS rn
        FROM Tbl_Candidate_Personal_Det CPD 
        LEFT JOIN VisaDetails VI 
            ON CPD.Candidate_Id = VI.Candidate_Id 
            AND VI.rn = 1
        LEFT JOIN Tbl_Candidate_NopassportList CNO 
            ON CNO.Candidate_id = CPD.Candidate_Id
        LEFT JOIN Tbl_Candidate_ContactDetails CCD 
            ON CCD.Candidate_Id = CPD.Candidate_Id
        LEFT JOIN Tbl_Nationality N 
            ON N.Nationality_Id = CPD.Candidate_Nationality
        LEFT JOIN tbl_New_Admission NA 
            ON NA.New_Admission_Id = CPD.New_Admission_Id
        LEFT JOIN Tbl_Course_Batch_Duration CBD 
            ON CBD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_Department D 
            ON D.Department_Id = NA.Department_Id
        WHERE
         CPD.ApplicationStatus = ''Completed''
        AND CPD.active = 3
        AND CPD.Candidate_Nationality != 63
        AND VI.Visa_Status = ''Approved'' 
        AND VI.Expiry_Status = 0 
        AND VI.Del_Status = 0 
        AND CPD.PassportDate IS NOT NULL 
        AND CPD.PassportDate <> ''''
        AND CPD.PassportDate <= DATEADD(MONTH, 3, GETDATE())
    ),
    FinalCount AS (
        SELECT *, COUNT(*) OVER () AS TotalCount
        FROM FinalCandidates
        WHERE rn = 1
    )
    SELECT * 
    FROM FinalCount
    ORDER BY ID
    OFFSET @PageSize * (@CurrentPage - 1) ROWS 
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;

  
  if(@flag=104)
begin
                                     
                                                                         
  SET @LowerBand  = (@CurrentPage -                                                        
     1) * @PageSize                                                                            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1 

select
CPD.Candidate_Id as ID,
CONCAT(CPD.Candidate_Fname ,'' '', CPD.Candidate_Lname) as Candidate_Name,
CPD.AdharNumber,CPD.IDMatrixNo,Case when CPD.PassportDate is null then ''-''
when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
CASE When VI.Visa_Status is null then ''Pending''  else VI.Visa_Status end as Visa_Status
,
  CPD.Candidate_Gender,N.Nationality,
D.Department_Name,CBD.Batch_Code,
  CCD.Candidate_Mob1,CCD.Candidate_Email,CPD.TypeOfStudent,COUNT(*) OVER () AS TotalCount

from

Tbl_Candidate_Personal_Det CPD 
LEFT JOIN ( 
   SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id
LEFT JOIN Tbl_Candidate_NopassportList CNO on CNO.Candidate_id=CPD.Candidate_Id
LEFT JOIN Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=CPD.Candidate_Id
LEFT JOIN Tbl_Nationality N on N.Nationality_Id=CPD.Candidate_Nationality
LEFT JOIN tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=NA.Batch_Id
LEFT JOIN Tbl_Department D on D.Department_Id=NA.Department_Id

WHERE 
--EXISTS (
--    -- Ensure at least one approved visa exists
--    SELECT 1 FROM Tbl_Visa_ISSO V3
--    WHERE V3.Candidate_Id = CPD.Candidate_Id
--    AND V3.Visa_Status = ''Approved''
--    AND V3.Expiry_Status = 0 
--    AND V3.Del_Status = 0
--)and
cpd.typeofstudent= ''INTERNATIONAL'' and cpd.ApplicationStatus=''Completed''  
and vi.Expiry_Status=0 and vi.DEL_STATUS=0 
and  vi.Visa_Status=''Approved''
and cpd.active=3 
and  vi.Visa_Expiry IS NOT NULL 
AND vi.Visa_Expiry <> ''''
AND vi.Visa_Expiry <= DATEADD(MONTH, 3, GETDATE())


 ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

                            
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end
  
  IF (@flag = 105)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

    WITH VisaDetails AS (
        SELECT 
            Candidate_Id, 
            Visa_Expiry, 
            Visa_Type, 
            Visa_Status, 
            Expiry_Status, 
            Del_Status, 
            Duration,
            ROW_NUMBER() OVER (
                PARTITION BY Candidate_Id 
                ORDER BY Applied_Date DESC
            ) AS rn
        FROM Tbl_Visa_ISSO 
        WHERE Expiry_Status = 0 
            AND Del_Status = 0 
            AND Visa_Status = ''Approved''
    ),
    FinalCandidates AS (
        SELECT
            CPD.Candidate_Id AS ID,
            CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
            CPD.AdharNumber,
            CPD.IDMatrixNo,
            Case when CPD.PassportDate is null then ''-''
      when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
            COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
            CPD.Candidate_Gender,
            N.Nationality,
            D.Department_Name,
            CBD.Batch_Code,
            CCD.Candidate_Mob1,
            CCD.Candidate_Email,
            CPD.TypeOfStudent,
            ROW_NUMBER() OVER (
                PARTITION BY CPD.Candidate_Id 
                ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

            ) AS rn
        FROM Tbl_Candidate_Personal_Det CPD 
        LEFT JOIN VisaDetails VI 
            ON CPD.Candidate_Id = VI.Candidate_Id 
            AND VI.rn = 1
        LEFT JOIN Tbl_Candidate_NopassportList CNO 
            ON CNO.Candidate_id = CPD.Candidate_Id
        LEFT JOIN Tbl_Candidate_ContactDetails CCD 
            ON CCD.Candidate_Id = CPD.Candidate_Id
        LEFT JOIN Tbl_Nationality N 
            ON N.Nationality_Id = CPD.Candidate_Nationality
        LEFT JOIN tbl_New_Admission NA 
            ON NA.New_Admission_Id = CPD.New_Admission_Id
        LEFT JOIN Tbl_Course_Batch_Duration CBD 
            ON CBD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_Department D 
            ON D.Department_Id = NA.Department_Id
        WHERE
         CPD.ApplicationStatus = ''Completed''
        AND CPD.active = 3
        AND CPD.Candidate_Nationality != 63
        AND VI.Visa_Status = ''Approved'' 
        AND VI.Expiry_Status = 0 
        AND VI.Del_Status = 0 
        AND CPD.PassportDate IS NOT NULL 
        AND CPD.PassportDate <> ''''
        AND (CPD.PassportDate <= DATEADD(MONTH, 6, GETDATE()) and CPD.PassportDate > DATEADD(MONTH, 3, GETDATE()))
    ),
    FinalCount AS (
        SELECT *, COUNT(*) OVER () AS TotalCount
        FROM FinalCandidates
        WHERE rn = 1
    )
    SELECT * 
    FROM FinalCount
    ORDER BY ID
    OFFSET @PageSize * (@CurrentPage - 1) ROWS 
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;

  
  if(@flag=106)
begin
                                     
                                                                         
  SET @LowerBand  = (@CurrentPage -                                                        
     1) * @PageSize                                                                            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1 

select
CPD.Candidate_Id as ID,
CONCAT(CPD.Candidate_Fname ,'' '', CPD.Candidate_Lname) as Candidate_Name,
CPD.AdharNumber,CPD.IDMatrixNo,CPD.PassportDate,
CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp ,
CONVERT(VARCHAR(10), VI.Visa_Expiry, 23) AS Visa_Expiry

,VI.Visa_Type,

  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
CASE When VI.Visa_Status is null then ''Pending''  else VI.Visa_Status end as Visa_Status
,
  CPD.Candidate_Gender,N.Nationality,
D.Department_Name,CBD.Batch_Code,
  CCD.Candidate_Mob1,CCD.Candidate_Email,CPD.TypeOfStudent,COUNT(*) OVER () AS TotalCount

from

Tbl_Candidate_Personal_Det CPD 
LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id
LEFT JOIN Tbl_Candidate_NopassportList CNO on CNO.Candidate_id=CPD.Candidate_Id
LEFT JOIN Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=CPD.Candidate_Id
LEFT JOIN Tbl_Nationality N on N.Nationality_Id=CPD.Candidate_Nationality
LEFT JOIN tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=NA.Batch_Id
LEFT JOIN Tbl_Department D on D.Department_Id=NA.Department_Id

WHERE
--EXISTS (
--    -- Ensure at least one approved visa exists
--    SELECT 1 FROM Tbl_Visa_ISSO V3
--    WHERE V3.Candidate_Id = CPD.Candidate_Id
--    AND V3.Visa_Status = ''Approved''
--    AND V3.Expiry_Status = 0 
--    AND V3.Del_Status = 0
--)
--AND
cpd.typeofstudent= ''INTERNATIONAL'' and cpd.ApplicationStatus=''Completed''  and vi.Expiry_Status=0 and vi.DEL_STATUS=0 
and  vi.Visa_Status=''Approved'' and cpd.active=3 and  vi.Visa_Expiry IS NOT NULL 
AND vi.Visa_Expiry <> ''''
AND (vi.Visa_Expiry <= DATEADD(MONTH, 6, GETDATE()) and vi.Visa_Expiry > DATEADD(MONTH, 3, GETDATE()))


 ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

                            
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end
  
  IF (@flag = 107)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

    WITH VisaDetails AS (
        SELECT 
            Candidate_Id, 
            Visa_Expiry, 
            Visa_Type, 
            Visa_Status, 
            Expiry_Status, 
            Del_Status, 
            Duration,
            ROW_NUMBER() OVER (
                PARTITION BY Candidate_Id 
                ORDER BY Applied_Date DESC
            ) AS rn
        FROM Tbl_Visa_ISSO 
        WHERE Expiry_Status = 0 
            AND Del_Status = 0 
            AND Visa_Status = ''Approved''
    ),
    FinalCandidates AS (
        SELECT
            CPD.Candidate_Id AS ID,
            CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
            CPD.AdharNumber,
            CPD.IDMatrixNo,
            CPD.PassportDate,
            CASE 
                WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
                ELSE ''No'' 
            END AS Temp,
            CONVERT(VARCHAR(10), VI.Visa_Expiry, 23) AS Visa_Expiry,
            VI.Visa_Type,
            COALESCE(VI.Duration, ''-'') AS Duration,
            COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
            CPD.Candidate_Gender,
            N.Nationality,
            D.Department_Name,
            CBD.Batch_Code,
            CCD.Candidate_Mob1,
            CCD.Candidate_Email,
            CPD.TypeOfStudent,
            ROW_NUMBER() OVER (
                PARTITION BY CPD.Candidate_Id 
             ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

            ) AS rn
        FROM Tbl_Candidate_Personal_Det CPD 
        LEFT JOIN VisaDetails VI 
            ON CPD.Candidate_Id = VI.Candidate_Id 
            AND VI.rn = 1
        LEFT JOIN Tbl_Candidate_NopassportList CNO 
            ON CNO.Candidate_id = CPD.Candidate_Id
        LEFT JOIN Tbl_Candidate_ContactDetails CCD 
            ON CCD.Candidate_Id = CPD.Candidate_Id
        LEFT JOIN Tbl_Nationality N 
            ON N.Nationality_Id = CPD.Candidate_Nationality
        LEFT JOIN tbl_New_Admission NA 
            ON NA.New_Admission_Id = CPD.New_Admission_Id
        LEFT JOIN Tbl_Course_Batch_Duration CBD 
            ON CBD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_Department D 
            ON D.Department_Id = NA.Department_Id
        WHERE
         CPD.ApplicationStatus = ''Completed''
        AND CPD.active = 3
        AND CPD.Candidate_Nationality != 63
        AND VI.Visa_Status = ''Approved'' 
        AND VI.Expiry_Status = 0 
        AND VI.Del_Status = 0 
        AND CPD.PassportDate IS NOT NULL 
        AND CPD.PassportDate <> ''''
        AND (CPD.PassportDate <= DATEADD(MONTH, 9, GETDATE()) and CPD.PassportDate > DATEADD(MONTH, 6, GETDATE()))
    ),
    FinalCount AS (
        SELECT *, COUNT(*) OVER () AS TotalCount
        FROM FinalCandidates
        WHERE rn = 1
    )
    SELECT * 
    FROM FinalCount
    ORDER BY ID
    OFFSET @PageSize * (@CurrentPage - 1) ROWS 
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;

  
  if(@flag=108)
begin
                                     
                                                                         
  SET @LowerBand  = (@CurrentPage -                                                        
     1) * @PageSize                                                                            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1 

select
CPD.Candidate_Id as ID,
CONCAT(CPD.Candidate_Fname ,'' '', CPD.Candidate_Lname) as Candidate_Name,
CPD.AdharNumber,CPD.IDMatrixNo,CPD.PassportDate,
CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp ,
CONVERT(VARCHAR(10), VI.Visa_Expiry, 23) AS Visa_Expiry

,VI.Visa_Type,

  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
CASE When VI.Visa_Status is null then ''Pending''  else VI.Visa_Status end as Visa_Status
,
  CPD.Candidate_Gender,N.Nationality,
D.Department_Name,CBD.Batch_Code,
  CCD.Candidate_Mob1,CCD.Candidate_Email,CPD.TypeOfStudent,COUNT(*) OVER () AS TotalCount

from

Tbl_Candidate_Personal_Det CPD 
LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
)  VI ON CPD.Candidate_Id = VI.Candidate_Id
LEFT JOIN Tbl_Candidate_NopassportList CNO on CNO.Candidate_id=CPD.Candidate_Id
LEFT JOIN Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=CPD.Candidate_Id
LEFT JOIN Tbl_Nationality N on N.Nationality_Id=CPD.Candidate_Nationality
LEFT JOIN tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=NA.Batch_Id
LEFT JOIN Tbl_Department D on D.Department_Id=NA.Department_Id

WHERE 
--EXISTS (
--    -- Ensure at least one approved visa exists
--    SELECT 1 FROM Tbl_Visa_ISSO V3
--    WHERE V3.Candidate_Id = CPD.Candidate_Id
--    AND V3.Visa_Status = ''Approved''
--    AND V3.Expiry_Status = 0 
--    AND V3.Del_Status = 0
--)
--AND 
cpd.typeofstudent= ''INTERNATIONAL'' and cpd.ApplicationStatus=''Completed''  and vi.Expiry_Status=0 and vi.DEL_STATUS=0 
and  vi.Visa_Status=''Approved'' and cpd.active=3 and  vi.Visa_Expiry IS NOT NULL 
AND vi.Visa_Expiry <> ''''
AND (vi.Visa_Expiry <= DATEADD(MONTH, 9, GETDATE()) AND vi.Visa_Expiry > DATEADD(MONTH, 6, GETDATE()))

ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

                            
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end
  
  IF (@flag = 110)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

   WITH VisaDetails AS (
    SELECT 
        Candidate_Id, 
        Visa_Expiry, 
        Visa_Type, 
        Visa_Status, 
        Expiry_Status, 
        Del_Status, 
        Duration,
        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Applied_Date DESC) AS rn
    FROM Tbl_Visa_ISSO 
    WHERE Expiry_Status = 0 
        AND Del_Status = 0 
        AND Visa_Status = ''Approved''
),
FinalCandidates AS (
    SELECT 
        CPD.Candidate_Id AS ID,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        CPD.AdharNumber,
        CPD.IDMatrixNo,
        Case when CPD.PassportDate is null then ''-''
    when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
        COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
        CPD.Candidate_Gender,
        N.Nationality,
        D.Department_Name,
        CBD.Batch_Code,
        CCD.Candidate_Mob1,
        CCD.Candidate_Email,
        CPD.TypeOfStudent,
        ROW_NUMBER() OVER (
            PARTITION BY CPD.Candidate_Id 
            ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

        ) AS rn
    FROM Tbl_Candidate_Personal_Det CPD
    LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id  -- Ensures only the latest visa entry
    LEFT JOIN Tbl_Candidate_NopassportList CNO 
        ON CNO.Candidate_id = CPD.Candidate_Id
    LEFT JOIN Tbl_Candidate_ContactDetails CCD 
        ON CCD.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Nationality N 
        ON N.Nationality_Id = CPD.Candidate_Nationality
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration CBD 
        ON CBD.Batch_Id = NA.Batch_Id
    LEFT JOIN Tbl_Department D 
        ON D.Department_Id = NA.Department_Id
    WHERE 
  --EXISTS (
 --       -- Ensures only candidates with an approved visa appear
 --       SELECT 1 FROM Tbl_Visa_ISSO V3
 --       WHERE V3.Candidate_Id = CPD.Candidate_Id
 --           AND V3.Visa_Status = ''Approved''
 --           AND V3.Expiry_Status = 0 
 --           AND V3.Del_Status = 0
 --   ) 
  --AND 
  (
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
    AND CPD.ApplicationStatus = ''Completed''
    AND CPD.active = 15
  AND CPD.Candidate_Nationality!=63
    --AND CPD.TypeOfStudent = ''INTERNATIONAL''
   -- AND VI.Visa_Status = ''Approved'' 
    --AND VI.Expiry_Status = 0 
    --AND VI.Del_Status = 0 
),
FinalCount AS (
    SELECT *, COUNT(*) OVER () AS TotalCount
    FROM FinalCandidates
    WHERE rn = 1 -- Ensures only unique candidates
)
SELECT * FROM FinalCount
ORDER BY ID

    OFFSET @LowerBand ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;
IF (@flag = 111)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

   WITH VisaDetails AS (
    SELECT 
        Candidate_Id, 
        Visa_Expiry, 
        Visa_Type, 
        Visa_Status, 
        Expiry_Status, 
        Del_Status, 
        Duration,
        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Applied_Date DESC) AS rn
    FROM Tbl_Visa_ISSO 
    WHERE Expiry_Status = 0 
        AND Del_Status = 0 
        AND Visa_Status = ''Approved''
),
FinalCandidates AS (
    SELECT 
        CPD.Candidate_Id AS ID,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        CPD.AdharNumber,
        CPD.IDMatrixNo,
        Case when CPD.PassportDate is null then ''-''
    when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
        COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
        CPD.Candidate_Gender,
        N.Nationality,
        D.Department_Name,
        CBD.Batch_Code,
        CCD.Candidate_Mob1,
        CCD.Candidate_Email,
        CPD.TypeOfStudent,
        ROW_NUMBER() OVER (
            PARTITION BY CPD.Candidate_Id 
           ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

        ) AS rn
    FROM Tbl_Candidate_Personal_Det CPD
    LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id  -- Ensures only the latest visa entry
    LEFT JOIN Tbl_Candidate_NopassportList CNO 
        ON CNO.Candidate_id = CPD.Candidate_Id
    LEFT JOIN Tbl_Candidate_ContactDetails CCD 
        ON CCD.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Nationality N 
        ON N.Nationality_Id = CPD.Candidate_Nationality
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration CBD 
        ON CBD.Batch_Id = NA.Batch_Id
    LEFT JOIN Tbl_Department D 
        ON D.Department_Id = NA.Department_Id
    WHERE 
  --EXISTS (
 --       -- Ensures only candidates with an approved visa appear
 --       SELECT 1 FROM Tbl_Visa_ISSO V3
 --       WHERE V3.Candidate_Id = CPD.Candidate_Id
 --           AND V3.Visa_Status = ''Approved''
 --           AND V3.Expiry_Status = 0 
 --           AND V3.Del_Status = 0
 --   ) 
  --AND 
  (
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
    AND CPD.ApplicationStatus = ''Completed''
    AND CPD.active = 7
  AND CPD.Candidate_Nationality!=63
    --AND CPD.TypeOfStudent = ''INTERNATIONAL''
  --  AND VI.Visa_Status = ''Approved'' 
    --AND VI.Expiry_Status = 0 
    --AND VI.Del_Status = 0 
),
FinalCount AS (
    SELECT *, COUNT(*) OVER () AS TotalCount
    FROM FinalCandidates
    WHERE rn = 1 -- Ensures only unique candidates
)
SELECT * FROM FinalCount
ORDER BY ID

    OFFSET @LowerBand ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;
IF (@flag = 112)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

   WITH VisaDetails AS (
    SELECT 
        Candidate_Id, 
        Visa_Expiry, 
        Visa_Type, 
        Visa_Status, 
        Expiry_Status, 
        Del_Status, 
        Duration,
        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Applied_Date DESC) AS rn
    FROM Tbl_Visa_ISSO 
    WHERE Expiry_Status = 0 
        AND Del_Status = 0 
        AND Visa_Status = ''Approved''
),
FinalCandidates AS (
    SELECT 
        CPD.Candidate_Id AS ID,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        CPD.AdharNumber,
        CPD.IDMatrixNo,
        Case when CPD.PassportDate is null then ''-''
    when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
        COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
        CPD.Candidate_Gender,
        N.Nationality,
        D.Department_Name,
        CBD.Batch_Code,
        CCD.Candidate_Mob1,
        CCD.Candidate_Email,
        CPD.TypeOfStudent,
        ROW_NUMBER() OVER (
            PARTITION BY CPD.Candidate_Id 
            ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

        ) AS rn
    FROM Tbl_Candidate_Personal_Det CPD
    LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id  -- Ensures only the latest visa entry
    LEFT JOIN Tbl_Candidate_NopassportList CNO 
        ON CNO.Candidate_id = CPD.Candidate_Id
    LEFT JOIN Tbl_Candidate_ContactDetails CCD 
        ON CCD.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Nationality N 
        ON N.Nationality_Id = CPD.Candidate_Nationality
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration CBD 
        ON CBD.Batch_Id = NA.Batch_Id
    LEFT JOIN Tbl_Department D 
        ON D.Department_Id = NA.Department_Id
    WHERE 
  --EXISTS (
 --       -- Ensures only candidates with an approved visa appear
 --       SELECT 1 FROM Tbl_Visa_ISSO V3
 --       WHERE V3.Candidate_Id = CPD.Candidate_Id
 --           AND V3.Visa_Status = ''Approved''
 --           AND V3.Expiry_Status = 0 
 --           AND V3.Del_Status = 0
 --   ) 
  --AND 
  (
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
    AND CPD.ApplicationStatus = ''Completed''
    AND CPD.active = 6
  AND CPD.Candidate_Nationality!=63
    --AND CPD.TypeOfStudent = ''INTERNATIONAL''
   -- AND VI.Visa_Status = ''Approved'' 
    --AND VI.Expiry_Status = 0 
    --AND VI.Del_Status = 0 
),
FinalCount AS (
    SELECT *, COUNT(*) OVER () AS TotalCount
    FROM FinalCandidates
    WHERE rn = 1 -- Ensures only unique candidates
)
SELECT * FROM FinalCount
ORDER BY ID

    OFFSET @LowerBand ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;
IF (@flag = 113)
BEGIN
    SET @LowerBand = (@CurrentPage - 1) * @PageSize;
    SET @UpperBand = (@CurrentPage * @PageSize) + 1;

   WITH VisaDetails AS (
    SELECT 
        Candidate_Id, 
        Visa_Expiry, 
        Visa_Type, 
        Visa_Status, 
        Expiry_Status, 
        Del_Status, 
        Duration,
        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Applied_Date DESC) AS rn
    FROM Tbl_Visa_ISSO 
    WHERE Expiry_Status = 0 
        AND Del_Status = 0 
        AND Visa_Status = ''Approved''
),
FinalCandidates AS (
    SELECT 
        CPD.Candidate_Id AS ID,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        CPD.AdharNumber,
        CPD.IDMatrixNo,
        Case when CPD.PassportDate is null then ''-''
    when PassportDate ='''' then ''-''
   else CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103)  end as PassportDate,

    CASE 
        WHEN CNO.Candidate_id IS NOT NULL THEN ''Yes'' 
        ELSE ''No'' 
    END AS Temp,
    case when VI.Visa_Expiry is null  then ''-''
  else CONVERT(VARCHAR(10), VI.Visa_Expiry, 103) end AS Visa_Expiry,
    case when VI.Visa_Type is null then ''-''
  else VI.Visa_Type end as Visa_Type,
  case when VI.Duration is null then ''-''
  else VI.Duration end as Duration,
        COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
        CPD.Candidate_Gender,
        N.Nationality,
        D.Department_Name,
        CBD.Batch_Code,
        CCD.Candidate_Mob1,
        CCD.Candidate_Email,
        CPD.TypeOfStudent,
        ROW_NUMBER() OVER (
            PARTITION BY CPD.Candidate_Id 
            ORDER BY 
    CASE 
        WHEN (CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''') 
         AND (VI.Visa_Expiry IS NULL) THEN 1  -- NULL or empty PassportDate and NULL Visa_Expiry last
        ELSE 0  -- Non-null/non-empty values first
    END ASC,
    CASE 
        WHEN CPD.PassportDate IS NOT NULL AND LTRIM(RTRIM(CPD.PassportDate)) <> '''' 
             AND VI.Visa_Expiry IS NOT NULL 
        THEN CASE 
                 WHEN CPD.PassportDate < VI.Visa_Expiry THEN CPD.PassportDate 
                 ELSE VI.Visa_Expiry 
             END
        ELSE COALESCE(NULLIF(LTRIM(RTRIM(CPD.PassportDate)), ''''), VI.Visa_Expiry) 
    END ASC

        ) AS rn
    FROM Tbl_Candidate_Personal_Det CPD
    LEFT JOIN (
    -- Fetch the latest visa record based on MAX Visa_ID
    SELECT V1.*
    FROM Tbl_Visa_ISSO V1
    WHERE V1.Visa_Id = (
        SELECT MAX(V2.Visa_Id)
        FROM Tbl_Visa_ISSO V2
        WHERE V2.Candidate_Id = V1.Candidate_Id
        
    )
) VI ON CPD.Candidate_Id = VI.Candidate_Id  -- Ensures only the latest visa entry
    LEFT JOIN Tbl_Candidate_NopassportList CNO 
        ON CNO.Candidate_id = CPD.Candidate_Id
    LEFT JOIN Tbl_Candidate_ContactDetails CCD 
        ON CCD.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Nationality N 
        ON N.Nationality_Id = CPD.Candidate_Nationality
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration CBD 
        ON CBD.Batch_Id = NA.Batch_Id
    LEFT JOIN Tbl_Department D 
        ON D.Department_Id = NA.Department_Id
    WHERE 
  --EXISTS (
 --       -- Ensures only candidates with an approved visa appear
 --       SELECT 1 FROM Tbl_Visa_ISSO V3
 --       WHERE V3.Candidate_Id = CPD.Candidate_Id
 --           AND V3.Visa_Status = ''Approved''
 --           AND V3.Expiry_Status = 0 
 --           AND V3.Del_Status = 0
 --   ) 
  --AND 
  (
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE CONCAT(''%'', LTRIM(RTRIM(@SearchTerm)), ''%'')
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR (CPD.AdharNumber LIKE REPLACE(CONCAT(''%'', @SearchTerm, ''%''), ''-'', ''''))
    OR LTRIM(RTRIM(CCD.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CCD.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
  OR LTRIM(RTRIM(CPD.IDMatrixNo)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(CBD.Batch_Code)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''
    OR LTRIM(RTRIM(@SearchTerm)) = ''''
)
AND (CPD.Candidate_Gender = @Gender OR @Gender = '''' OR @Gender = ''0'')
AND (N.Nationality_Id = @Nationality OR @Nationality = 0)
AND (D.Department_Id = @Department OR @Department = 0)
AND (VI.Visa_Type = @visatype OR @visatype = '''')
AND (
    (@visafrom = '''' AND @visato = '''')              
    OR (@visafrom = '''' AND @visato <> '''' AND VI.Visa_Expiry < @visato)              
    OR (@visafrom <> '''' AND @visato = '''' AND VI.Visa_Expiry > @visafrom)              
    OR (VI.Visa_Expiry BETWEEN @visafrom AND @visato)              
)
AND (
    (@passportfrom = '''' AND @passportto = '''')              
    OR (@passportfrom = '''' AND @passportto <> '''' AND CPD.PassportDate < @passportto)              
    OR (@passportfrom <> '''' AND @passportto = '''' AND CPD.PassportDate > @visafrom)              
    OR (CPD.PassportDate BETWEEN @passportfrom AND @passportto)              
)
    AND CPD.ApplicationStatus = ''Completed''
    AND CPD.active = 5
  AND CPD.Candidate_Nationality!=63
    --AND CPD.TypeOfStudent = ''INTERNATIONAL''
    --AND VI.Visa_Status = ''Approved'' 
    --AND VI.Expiry_Status = 0 
    --AND VI.Del_Status = 0 
),
FinalCount AS (
    SELECT *, COUNT(*) OVER () AS TotalCount
    FROM FinalCandidates
    WHERE rn = 1 -- Ensures only unique candidates
)
SELECT * FROM FinalCount
ORDER BY ID

    OFFSET @LowerBand ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;

end
    ')
END
