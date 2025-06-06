IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_chart1_View_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_chart1_View_All]
            @Flag INT = 0,
            @FromDate DATETIME = NULL,
            @ToDate DATETIME = NULL,
            @employee_ID BIGINT
        AS
        BEGIN
            DECLARE @Month INT
            DECLARE @Year INT
            DECLARE @from DATETIME
            DECLARE @to DATETIME
            
            SET @Month = MONTH(GETDATE());
            SET @Year = YEAR(GETDATE());

            -- Set the @from to the first day of the current month if @FromDate is NULL
            SET @from = DATEADD(MONTH, @Month - 1, DATEADD(YEAR, @Year - 1900, 0)); /* First day of the previous month */
            
            -- Set @to to the last day of the current month if @ToDate is NULL
            SET @to = DATEADD(DAY, -1, DATEADD(MONTH, @Month, DATEADD(YEAR, @Year - 1900, 0)));

            -- If @FromDate is not NULL, use it for the date range filter
            IF @FromDate IS NOT NULL 
            BEGIN
                SET @from = @FromDate;
            END

            -- If @ToDate is not NULL, use it for the date range filter
            IF @ToDate IS NOT NULL 
            BEGIN
                SET @to = @ToDate;
            END

            -- Main query for counting candidates based on course category
            SELECT 
                COUNT(cpd.Candidate_Id) AS COUNT, 
                ISNULL(CC.Course_Category_Name, ''Others'') AS Course_Category_Name
            FROM Tbl_Candidate_Personal_Det cpd 
            LEFT JOIN tbl_New_Admission na ON na.new_admission_id = cpd.new_admission_id
            LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.batch_id = na.batch_id
            LEFT JOIN tbl_department d ON d.department_id = cbd.duration_id
            LEFT JOIN Tbl_Course_Category cc ON cc.Course_Category_Id = d.Program_Type_Id
            WHERE cpd.RegDate >= @from 
                AND cpd.RegDate <= @to
                AND cpd.CounselorEmployee_id = @employee_ID
            GROUP BY ISNULL(cc.Course_Category_Name, ''Others'')
            ORDER BY ISNULL(cc.Course_Category_Name, ''Others'')
        END
    ')
END
