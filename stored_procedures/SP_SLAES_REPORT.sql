IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SLAES_REPORT]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_SLAES_REPORT]
(
    @Target_Year INT = NULL,
    @Currentpage INT = NULL,
    @PageSize INT = NULL
)
AS
BEGIN
    -- Set NOCOUNT to ON to prevent extra result sets for affected rows
    SET NOCOUNT ON;

    -- If pagination parameters are not provided, set them to default values
    IF @PageSize IS NULL OR @Currentpage IS NULL OR @PageSize <= 0 OR @Currentpage <= 0
    BEGIN
        -- Main query without pagination logic
        SELECT 
            ROW_NUMBER() OVER (ORDER BY E.Employee_FName, E.Employee_LName) AS SlNo,
            CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS Counsellor,
            F.Yearly_Target,
            F.Monthly_Target,
            COUNT(CASE 
                    WHEN @Target_Year IS NULL OR YEAR(CPD.RegDate) = @Target_Year THEN 
                        CPD.ApplicationStatus 
                 END) AS Registered,
            CASE 
                WHEN F.Yearly_Target > 0 THEN 
                    CAST(
                        CAST(COUNT(CASE 
                                    WHEN @Target_Year IS NULL OR YEAR(CPD.RegDate) = @Target_Year THEN 
                                        CPD.ApplicationStatus 
                                 END) AS FLOAT) / F.Yearly_Target * 100 AS decimal(10,2)
                    )
                ELSE 
                    0 
            END AS [Registration],
            CASE 
        WHEN F.Yearly_Target < 
            COUNT(CASE 
                WHEN @Target_Year IS NULL OR YEAR(CPD.RegDate) = @Target_Year THEN 
                    CPD.ApplicationStatus 
                END)
        THEN 0
        ELSE F.Yearly_Target - 
            COUNT(CASE 
                WHEN @Target_Year IS NULL OR YEAR(CPD.RegDate) = @Target_Year THEN 
                    CPD.ApplicationStatus 
                END)
    END AS Shortfall
        FROM 
            tbl_Sales_Target F
        INNER JOIN 
            Tbl_Employee E ON F.Councelor_Employee = E.Employee_Id
        LEFT JOIN 
            Tbl_Candidate_Personal_Det CPD ON F.Councelor_Employee = CPD.CounselorEmployee_id 
            AND CPD.ApplicationStatus = ''completed''
        WHERE 
            F.DelStatus = 0 
            AND E.Employee_Status IN (1, 0)
            AND (@Target_Year IS NULL OR F.Target_Year = @Target_Year)
        GROUP BY 
            E.Employee_FName, E.Employee_LName, F.Yearly_Target, F.Monthly_Target
        ORDER BY 
            E.Employee_FName, E.Employee_LName;
    END
    ELSE
    BEGIN
        -- Pagination logic when parameters are provided
        DECLARE @Offset INT;
        SET @Offset = @PageSize * (@Currentpage - 1); -- Calculate the offset for pagination

        -- Main query with pagination logic
        SELECT 
            ROW_NUMBER() OVER (ORDER BY E.Employee_FName, E.Employee_LName) AS SlNo,
            CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS Counsellor,
            F.Yearly_Target,
            F.Monthly_Target,
            COUNT(CASE 
                    WHEN @Target_Year IS NULL OR YEAR(CPD.RegDate) = @Target_Year THEN 
                        CPD.ApplicationStatus 
                 END) AS Registered,
            CASE 
                WHEN F.Yearly_Target > 0 THEN 
                    CAST(
                        CAST(COUNT(CASE 
                                    WHEN @Target_Year IS NULL OR YEAR(CPD.RegDate) = @Target_Year THEN 
                                        CPD.ApplicationStatus 
                                 END) AS FLOAT) / F.Yearly_Target * 100 AS decimal(10,2)
                    )
                ELSE 
                    0 
            END AS [Registration],
            F.Yearly_Target - COUNT(CASE 
                                        WHEN @Target_Year IS NULL OR YEAR(CPD.RegDate) = @Target_Year THEN 
                                            CPD.ApplicationStatus 
                                     END) AS Shortfall
        FROM 
            tbl_Sales_Target F
        INNER JOIN 
            Tbl_Employee E ON F.Councelor_Employee = E.Employee_Id
        LEFT JOIN 
            Tbl_Candidate_Personal_Det CPD ON F.Councelor_Employee = CPD.CounselorEmployee_id 
            AND CPD.ApplicationStatus = ''completed''
        WHERE 
            F.DelStatus = 0 
            AND E.Employee_Status IN (1, 0)
            AND (@Target_Year IS NULL OR F.Target_Year = @Target_Year)
        GROUP BY 
            E.Employee_FName, E.Employee_LName, F.Yearly_Target, F.Monthly_Target
        ORDER BY 
            E.Employee_FName, E.Employee_LName
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END

    -- Set NOCOUNT OFF before returning the results
    SET NOCOUNT OFF;
END;
    ')
END
