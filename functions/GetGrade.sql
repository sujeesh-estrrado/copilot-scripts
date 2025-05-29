
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetGrade]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[GetGrade] 
(
    @Mark float,
    @TotalMark float
)
RETURNS varchar(100)
AS
BEGIN
    DECLARE @Grade varchar(100);

SELECT @Grade = (SELECT Grade_Name From LMS_Tbl_Grade Where (@Mark/@TotalMark)*100 between From_Perc and  To_Perc)


    RETURN @Grade
END
    ')
END
