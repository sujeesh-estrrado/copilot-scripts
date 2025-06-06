IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Class_Student_Join]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_All_Class_Student_Join]   
 @Student_Id bigint         
AS          
          
BEGIN          
          
SELECT         
Distinct  C.Class_Id,        
C.Class_Name,          
C.Active_Status             
FROM LMS_Tbl_Class C        
where       
--C.Active_Status=0 and      
Is_Existing_Class=0 and    
 C.Class_Id NOT IN        
(Select Class_Id From LMS_Tbl_Student_Class Where Student_id=@Student_Id)         
          
            
END
    ')
END
