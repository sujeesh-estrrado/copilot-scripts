IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_PR_YEARS]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_PR_YEARS]
AS
BEGIN
   WITH YearSequence AS (
        SELECT YEAR(GETDATE()) AS Year  
        UNION ALL
        SELECT Year - 1
        FROM YearSequence
        WHERE Year > YEAR(GETDATE()) - 5 
    )
    SELECT Year
    FROM YearSequence
    OPTION (MAXRECURSION 100); 
END
    ')
END;
