IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectallAssesmentcode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_SelectallAssesmentcode]       
as        
begin        
SELECT  * from Tbl_Assessment_Code_Master
ORDER BY Assessment_Code_Id DESC

end
    ')
END
