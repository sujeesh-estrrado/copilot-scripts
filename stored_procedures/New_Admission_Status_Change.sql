IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[New_Admission_Status_Change]') 
    AND type = N'P'
)
BEGIN
    EXEC('
           
CREATE procedure [dbo].[New_Admission_Status_Change](@Course_Level_Id bigint,            
           @Course_Category_Id bigint,            
           @Department_Id bigint,@Batch_Id bigint,@FromDate datetime,@EndDate datetime)            
AS    
if exists (Select New_Admission_Id from  dbo.tbl_New_Admission where Course_Level_Id=@Course_Level_Id and Course_Category_Id=@Course_Category_Id and     
Batch_Id=@Batch_Id and Department_Id=@Department_Id and Admission_Status=1)            
BEGIN            
 UPDATE  dbo.tbl_New_Admission SET Admission_Status=0 WHERE             
 New_Admission_Id IN (Select n.New_Admission_Id            
 from  dbo.tbl_New_Admission n INNER join dbo.Tbl_Course_Level l on l.Course_Level_Id=n.Course_Level_Id            
            
 INNER join dbo.Tbl_Course_Category c on c.Course_Category_Id=n.Course_Category_Id             
 INNER join dbo.Tbl_Department d on d.Department_Id=n.Department_Id                
INNER Join   dbo.Tbl_Course_Batch_Duration cbd on cbd.Batch_Id=n.Batch_Id          
            
 WHERE n.Course_Level_Id=@Course_Level_Id AND  n.Course_Category_Id=@Course_Category_Id             
 and n.Department_Id=@Department_Id and n.Batch_Id=@Batch_Id AND n.Admission_Status=1 )            
            
END     
--else     
--BEGIN            
-- UPDATE  dbo.tbl_New_Admission SET Admission_Status=0 WHERE             
-- New_Admission_Id IN (Select n.New_Admission_Id            
-- from  dbo.tbl_New_Admission n INNER join dbo.Tbl_Course_Level l on l.Course_Level_Id=n.Course_Level_Id            
--            
-- INNER join dbo.Tbl_Course_Category c on c.Course_Category_Id=n.Course_Category_Id             
--            
----INNER join dbo.Tbl_Department d on d.Department_Id=n.Department_Id          
--INNER Join   dbo.Tbl_Course_Batch_Duration cbd on cbd.Batch_Id=n.Batch_Id          
--            
-- WHERE n.Course_Level_Id=@Course_Level_Id AND  n.Course_Category_Id=@Course_Category_Id             
-- AND  n.Batch_Id=@Batch_Id AND n.Admission_Status=1 )            
--            
--END
    ')
END;
