IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Test]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Test]  
As  
  
Begin  
DECLARE @INSTR as VARCHAR(MAX)  
SET @INSTR = ''1,2,3,4,5,''  
DECLARE @SEPERATOR as VARCHAR(1)  
DECLARE @SP INT  
DECLARE @VALUE VARCHAR(1000)  
SET @SEPERATOR = '',''  
CREATE TABLE #tempTab (id int not null)  
WHILE PATINDEX(''%'' + @SEPERATOR + ''%'', @INSTR ) <> 0   
BEGIN  
   SELECT  @SP = PATINDEX(''%'' + @SEPERATOR + ''%'',@INSTR)  
   SELECT  @VALUE = LEFT(@INSTR , @SP - 1)  
   SELECT  @INSTR = STUFF(@INSTR, 1, @SP, '''')  
   INSERT INTO #tempTab (id) VALUES (@VALUE)  
  
--SELECT * from  #tempTab  
END  
SELECT * FROM Tbl_Course_Trend WHERE Trend_Id IN (SELECT id FROM #tempTab)  
DROP TABLE #tempTab  
  
  
End
    ')
END;
GO
