IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Max_New_Admission_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Max_New_Admission_ID]       
--@Course_Level_Id bigint,                
--@Course_Category_Id bigint,                
@Department_Id bigint,             
@Batch_Id bigint               
              
AS      
BEGIN      
select isnull(max(New_Admission_Id),0) as Admission_Id from tbl_New_Admission where   Department_Id=@Department_Id and Batch_Id=@Batch_Id      
--Course_Category_Id=@Course_Category_Id and
END');
END