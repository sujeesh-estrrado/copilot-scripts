IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_Student_Class]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_Student_CLass]      
  @Student_id bigint      
AS        
        
BEGIN        
        
SELECT 
Distinct       
C.Class_Id,      
C.Class_Name,      
S.Approval_Status             
FROM LMS_Tbl_Class C      
inner join LMS_Tbl_Student_Class S      
on C.Class_Id = S.Class_Id      
where S.Student_id = @Student_id and Delete_Status = 0     
and Approval_Status IS NOT null      
  
Order by C.Class_Id desc    
      
END
    ')
END
