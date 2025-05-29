IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetBatch_ByCategory]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetBatch_ByCategory](@Category_Id bigint)       
      
AS        
BEGIN        
SELECT    
   CBD.Batch_Id as BatchID,CBD.Batch_Code as Batch  
     
     
FROM Tbl_Course_Batch_Duration CBD   
INNER JOIN Tbl_Course_Duration CD On CD.Duration_Id=CBD.Duration_Id  
INNER JOIN Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id  
  
Where CC.Course_Category_Id=@Category_Id  
order by Batch
END ')
END;
