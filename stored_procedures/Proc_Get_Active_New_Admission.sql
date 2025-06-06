IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Active_New_Admission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Active_New_Admission]     
     
AS    
     
BEGIN     
     
  Select n.*,l.Course_Level_Name,c.Course_Category_Name,d.Department_Name,cbd.Batch_Code ,   
    
Status=case when n.Admission_Status=1 then ''Active'' else ''Inactive'' end    
    
    
from  dbo.tbl_New_Admission n left join dbo.Tbl_Course_Level l on l.Course_Level_Id=n.Course_Level_Id    
    
left join dbo.Tbl_Course_Category c on c.Course_Category_Id=n.Course_Category_Id     
    
left join dbo.Tbl_Department d on d.Department_Id=n.Department_Id   
left join dbo.Tbl_Course_Batch_Duration cbd on cbd.Batch_Id=n.Batch_Id  
where n.Admission_Status=1    
    
      
    
    
END

    ')
END
