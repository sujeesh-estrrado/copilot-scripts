IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_SSLC_Rules]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_SSLC_Rules]

AS

BEGIN

    SELECT  SSLC_Rules_Id as ID,TotalMark_Cutoff ,Subject_1_CutOff,Subject_2_CutOff,Subject_3_CutOff,
                Category_Type ,[Type]=1,[Year]
        FROM [dbo].[Tbl_SSLC_Rules]  
        WHERE SSLC_Rules_Status=0
            
END




   ')
END;
