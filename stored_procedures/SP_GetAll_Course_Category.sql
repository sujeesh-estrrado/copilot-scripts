IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Category]                
  (@flag bigint=0)              
AS                
                
BEGIN                
 if(@flag=0)         
 begin    
SELECT      dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Category.Course_level_Id,                 
                      dbo.Tbl_Course_Category.Course_Category_Name, dbo.Tbl_Course_Category.Course_Category_Descripition,                 
                      dbo.Tbl_Course_Category.Course_Category_Date, dbo.Tbl_Course_Category.Course_Category_Status,          
                      Tbl_Course_Category.Program_Code,Tbl_Course_Category.Program_Email,dbo.Tbl_Course_Category.Program_Director          
                                      
FROM        Tbl_Course_Category   --INNER JOIN                
--                      dbo.Tbl_Course_Category ON dbo.Tbl_Course_Level.Course_Level_Id = dbo.Tbl_Course_Category.Course_level_Id                
                
where Tbl_Course_Category.Course_Category_Status=0              
order by dbo.Tbl_Course_Category.Course_Category_Name asc       
end    
  if(@flag=1)         
 begin    
 SELECT    distinct    CL.Course_Category_Id, CL.Course_Category_Name,D.Online_checkstatus        
                                      
 FROM        Tbl_Course_Category CL  left Join Tbl_Department D on D.Program_Type_Id=CL.Course_Category_Id              
                
 where CL.Course_Category_Status=0  and D.Online_checkstatus=1            
 order by CL.Course_Category_Name asc       
end                  
END      

');
END;