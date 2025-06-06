IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Program_By_LevelId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_Program_By_LevelId] --3    
(@LevelId bigint)            
            
AS            
            
BEGIN            
                 
 SELECT        D.Department_Id, D.Department_Name, D.Course_Code, D.Intro_Date, CL.Course_Category_Name, D.Org_Id, D.Expiry_Date, CL.Course_Level_Id, 
                         D.Delete_Status
FROM            dbo.Tbl_Department AS D 

left outer join Tbl_Course_Department CD on CD.Department_Id=D.Department_Id 
LEFT OUTER JOIN  dbo.Tbl_Course_Category AS CL on CD.Course_Category_Id=CL.Course_Category_Id
WHERE        (CL.Course_Category_Id = @LevelId)   
        
END
    ')
END
