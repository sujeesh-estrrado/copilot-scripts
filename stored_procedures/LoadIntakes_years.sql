IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadIntakes_years]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[LoadIntakes_years]
@StudyMode varchar(50)=''0''
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT distinct IM.intake_year
--,IM.intake_month
--,(Select DateName( month , DateAdd( month , convert(int,IM.intake_month) , -1 ) )) month_name

 FROM Tbl_IntakeMaster 

IM WHERE 
--IM.Intro_Date <=GETDATE() AND IM.Close_Date>=GETDATE() and 
--year(getdate()) <= convert(int,IM.intake_year)
 (Study_Mode = @StudyMode OR @StudyMode=''0'')
END
  
    ')
END
GO