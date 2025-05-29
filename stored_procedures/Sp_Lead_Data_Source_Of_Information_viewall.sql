IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Lead_Data_Source_Of_Information_viewall]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Lead_Data_Source_Of_Information_viewall]
    @Flag INT = 1,
    @FromDate DATETIME = NULL,
    @ToDate DATETIME = NULL,
	@employee_ID BIGINT
AS
BEGIN
DECLARE @Month int
DECLARE @Year int
declare @from datetime;
declare @to datetime;
set @Month = month(getdate());
set @Year = year(getdate());

IF @FromDate IS NULL
    BEGIN
        SET @FromDate = DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0)) /*First*/
END
IF @ToDate IS NULL
    BEGIN
        SET @ToDate= DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0)))
  END
 
 
     SELECT COUNT(SourceofInformation) AS COUNT, SourceofInformation  as Cateogries
FROM Tbl_Candidate_Personal_Det 
WHERE SourceofInformation IS NOT NULL 
  AND SourceofInformation <> '' 
  AND SourceofInformation <> ''--select--'' 
 AND  CAST(RegDate AS DATE) >= @FromDate 
AND CAST(RegDate AS DATE) <= @ToDate
   AND (@employee_ID = 0 OR CounselorEmployee_id = @employee_ID) 
GROUP BY SourceofInformation  order by Cateogries desc
 
END
');
END;
