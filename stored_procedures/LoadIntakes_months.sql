IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadIntakes_months]')
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[LoadIntakes_months]
@IntakeYear varchar(50)=''0'',
@Study_Mode varchar(50)=''''
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT distinct convert(int,IM.intake_month) intake_month
--,IM.intake_month
,(Select DateName( month , DateAdd( month , convert(int,IM.intake_month) , -1 ) )) month_name

 FROM Tbl_IntakeMaster IM
 WHERE 
 IM.Intro_Date <=GETDATE() AND IM.Close_Date>=GETDATE() and 
 year(getdate()) <= convert(int,IM.intake_year)
AND (intake_year = @IntakeYear OR @IntakeYear=''0'') AND (Study_Mode=@Study_Mode or @Study_Mode='''')
END
  
    ')
END
GO