IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_SLAES_REPORT_totcount]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_SLAES_REPORT_totcount]
        (
            @Target_Year INT = NULL,
            @Currentpage INT = NULL,
            @PageSize INT = NULL
        )
        AS
        BEGIN
            -- Query to fetch data with year filtering
            SELECT 
                COUNT(CombinedData.Counsellor) AS Total_Counsellors, -- Total number of counselors
                SUM(CAST(CombinedData.Yearly_Target AS INT)) AS Total_Yearly_Target, -- Total yearly targets
                SUM(CAST(CombinedData.Monthly_Target AS INT)) AS Total_Monthly_Target, -- Total monthly targets
                SUM(CombinedData.Registered) AS Total_Registered, -- Total registered applications
                AVG(CombinedData.Registration) AS Average_Registration_Percentage, -- Average registration percentage
                SUM(CombinedData.Shortfall) AS Total_Shortfall -- Total shortfall
            FROM (
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
            ) AS CombinedData
        END
    ')
END
