IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_LMS_TempReview_TblDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_LMS_TempReview_TblDetails]  --45,''2017/02/21''        
         
AS            
BEGIN 
select * from LMS_TempReview_Tbl  
END
    ')
END
