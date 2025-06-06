-- Check if the procedure 'get_batchid' exists before creating
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[get_batchid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[get_batchid]               
AS                
BEGIN                
--SELECT                 
             
--distinct cdp.Duration_Period_Id as BatchID,Batch_Code+''-''+Semester_Name as BatchName            
            
--FROM Tbl_Course_Duration_Mapping cdm                 
--INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                
--INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                 
--INNER JOIN dbo.Tbl_Course_Department CD ON CD.Department_Id=CDM.Course_Department_Id        
--INNER JOIN  Tbl_Department D ON D.Department_Id = CD.Department_Id        
--INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id      
          
--WHERE   cbd.Batch_DelStatus=0   
  
  
    
SELECT Tbl_Course_Batch_Duration.Duration_Id as DurationID,Tbl_Course_Batch_Duration.Batch_Id as BatchID,                
Tbl_Department.Course_Code+''-''+Tbl_Course_Batch_Duration.Batch_Code as BatchName,                
Tbl_Course_Batch_Duration.Batch_From,Tbl_Course_Batch_Duration.Batch_To,          
Tbl_Department.Department_Id,Tbl_Department.Course_Code,          
Tbl_Department.Department_Name as CategoryName,               
--Tbl_Course_Category.Course_Category_Id ,              
--Tbl_Course_Category.Course_Category_Name as CategoryName ,            
Tbl_Course_Batch_Duration.Study_Mode               
                
FROM dbo.Tbl_Course_Batch_Duration                
INNER JOIN Tbl_Course_Duration on Tbl_Course_Batch_Duration.Duration_Id=Tbl_Course_Duration.Duration_Id           
INNER JOIN Tbl_Department on Tbl_Department.Department_Id=Tbl_Course_Duration.Course_Category_Id              
--INNER JOIN Tbl_Course_Category on Tbl_Course_Duration.Course_Category_Id=Tbl_Course_Category.Course_Category_Id                
WHERE Batch_DelStatus=0           
END   
  
  
  
  
--select * from Tbl_Course_Duration_PeriodDetails  
--select * from Tbl_Course_Semester  
--select * from tbl_Course_Batch_Duration  
  
--select * from dbo.Tbl_Course_Duration_Mapping  
--select * from tbl_fee_entry
    ')
END;
GO
