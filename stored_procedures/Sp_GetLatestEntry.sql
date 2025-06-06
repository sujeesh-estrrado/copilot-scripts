IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetLatestEntry]') 
    AND type = N'P'
)
BEGIN
    EXEC('
Create procedure [dbo].[Sp_GetLatestEntry]
--@Course_Id bigint=0,
@Exam_Id bigint = 0
as
begin
WITH RankedEntries AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Student_Id, Course_Id ORDER BY Create_date DESC) AS rn
    FROM Tbl_MarkEntryMaster
    WHERE Exam_Id = @Exam_Id -- filter by Exam_Id
      --AND Course_Id = @Course_Id -- filter by Course_Id
)
SELECT *
FROM RankedEntries
WHERE rn = 1
end

   ')
END;
