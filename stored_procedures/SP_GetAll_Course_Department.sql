IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Department]                                
                                
AS                                
                                
BEGIN                         
                        
                        
--SELECT distinct D.Department_Name,D.Department_Id, D.Department_Id as Course_Department_Id, CDP.Course_Department_Description,CDP.Course_Department_Date,CBD.Batch_Code,CBD.Batch_Id,CDP.Course_Department_Id,CC.Course_Category_Id,                    
--CC.Course_Category_Name,D.Course_Code FROM                         
-- dbo.Tbl_Department D inner join dbo.Tbl_Course_Duration CD on CD.Course_Category_Id=D.Department_Id                        
--inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Duration_Id=CD.Duration_Id                      
--inner join Tbl_Course_Department CDP on CDP.Department_Id=D.Department_Id                     
--inner join Tbl_Course_Category CC on CC.Course_Category_Id=CDP.Course_Category_Id  where D.Department_Status=0                       
--order by D.Department_Name                       
                        
--END                        
                                
SELECT       dbo.Tbl_Course_Category.Course_Category_Name,Tbl_Department.Department_Id, --dbo.Tbl_Course_Department.Course_Department_Id,  
 dbo.Tbl_Course_Department.Department_Id as Course_Department_Id,                                 
                      dbo.Tbl_Course_Department.Course_Category_Id, dbo.Tbl_Course_Department.Course_Department_Description,                                 
                      dbo.Tbl_Course_Department.Course_Department_Date, dbo.Tbl_Department.Department_Name                                
FROM         dbo.Tbl_Department INNER JOIN                                
                      dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN                                
                      dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id                              
                      -- dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Department_Id = dbo.Tbl_Course_Category.Course_Category_Id                                  
                                
                                
       where Tbl_Course_Department.Course_Department_Status=0 and                                
                 Tbl_Course_Category.Course_Category_Status=0 and                                
                 Tbl_Department.Department_Status=0                              
order by dbo.Tbl_Course_Category.Course_Category_Name                              
                                   
END 


');
END;