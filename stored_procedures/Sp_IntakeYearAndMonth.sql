IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_IntakeYearAndMonth]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_IntakeYearAndMonth]
    @StudyMode VARCHAR(50) = ''0''
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentYear INT
    DECLARE @CurrentMonth INT

    -- Get current year and month
    SELECT @CurrentYear = YEAR(GETDATE())
    SELECT @CurrentMonth = MONTH(GETDATE())

    -- Select distinct intake numbers where Intro_Date is >= current month and year
    SELECT DISTINCT IM.Batch_Code,IM.Id
    FROM Tbl_IntakeMaster IM
   WHERE GETDATE() between IM.Intro_Date and IM.Close_Date
   --YEAR(IM.Intro_Date) = @CurrentYear 
  --      AND YEAR(IM.Close_Date) = @CurrentYear 
  --      AND MONTH(IM.Close_Date) >= @CurrentMonth
        --AND Day(IM.Close_Date)+1>= Day(GETDATE())
        AND (IM.Study_Mode = @StudyMode OR @StudyMode = ''0'');
END
    ')
END;
