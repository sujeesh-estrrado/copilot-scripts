IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Program_By_FaciltyID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_Program_By_FaciltyID] --3    
(@FacultyId bigint)            
            
AS            
            
BEGIN            
                 
 SELECT        D.Department_Id, D.Department_Name, D.Course_Code, D.Intro_Date, CL.Course_Level_Name, D.Org_Id, D.Expiry_Date, CL.Course_Level_Id, 
                         D.Delete_Status
FROM            dbo.Tbl_Department AS D LEFT OUTER JOIN
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId
WHERE        (CL.Course_Level_Id = @FacultyId)   
        
END
    ')
END
