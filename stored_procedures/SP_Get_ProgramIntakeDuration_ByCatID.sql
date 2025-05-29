IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ProgramIntakeDuration_ByCatID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_ProgramIntakeDuration_ByCatID] (@Category_Id bigint)            
AS            
BEGIN            
            
SELECT Tbl_Course_Batch_Duration.Duration_Id as DurationID,Tbl_Course_Batch_Duration.Batch_Id as ID,            
Tbl_Course_Batch_Duration.Batch_Code as BatchCode,            
Tbl_Course_Batch_Duration.Batch_From,Tbl_Course_Batch_Duration.Batch_To,      
Tbl_Department.Department_Id,      
Tbl_Department.Department_Name as CategoryName,           
--Tbl_Course_Category.Course_Category_Id ,          
--Tbl_Course_Category.Course_Category_Name as CategoryName ,        
Tbl_Course_Batch_Duration.Study_Mode           
            
FROM dbo.Tbl_Course_Batch_Duration            
INNER JOIN Tbl_Program_Duration on Tbl_Course_Batch_Duration.Duration_Id=Tbl_Program_Duration.Duration_Id       
INNER JOIN Tbl_Department on Tbl_Department.Department_Id=Tbl_Program_Duration.Program_Category_Id          
--INNER JOIN Tbl_Course_Category on Tbl_Course_Duration.Course_Category_Id=Tbl_Course_Category.Course_Category_Id            
WHERE Batch_DelStatus=0 and Tbl_Department.Department_Id=@Category_Id       
    
    
    
                 

            
            
END      
');
END;
