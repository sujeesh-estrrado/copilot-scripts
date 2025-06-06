IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ALL_INTAKE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_GET_ALL_INTAKE]      
      
AS BEGIN      
--select CBD.Batch_Id,CBD.Batch_Code,CBD.Batch_DelStatus,  
--D.Course_Code+''-''+CBD.Batch_Code as Department  
-- from dbo.Tbl_Course_Batch_Duration CBD    
--inner join dbo.Tbl_Department D on D.Department_Id=CBD.Duration_Id    
--where CBD.Batch_DelStatus=0     
  
select CBD.Batch_Id,CBD.Batch_Code,CBD.Batch_DelStatus,  
CBD.Batch_Code as Department  ,im.intake_no
 from dbo.Tbl_Course_Batch_Duration CBD    left join Tbl_intakemaster im on im.id=CBD.intakemasterid
where CBD.Batch_DelStatus=0       
      
END 
    ')
END
