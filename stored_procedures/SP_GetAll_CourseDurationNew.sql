IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_CourseDurationNew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_CourseDurationNew]          
AS          
BEGIN          
          
SELECT Tbl_Course_Duration.Duration_Id as ID,Tbl_Course_Duration.Course_Category_Id as CourseCatID,          
Tbl_Course_Duration.Course_Duration_Type as DurationType,          
Tbl_Course_Duration.Course_Duration_Year as [Year],Tbl_Course_Duration.Course_Duration_Sem as [Sem],          
Tbl_Course_Duration.Course_Duration_Month as [Month],Tbl_Course_Duration.Course_Duration_Days as [Days],          
dbo.Tbl_Department.Department_Name as CategoryName ,  
 dbo.Tbl_Department.Course_Code       
          
FROM  dbo.Tbl_Course_Duration           
--INNER JOIN Tbl_Course_Category on Tbl_Course_Duration.Course_Category_Id=Tbl_Course_Category.Course_Category_Id       
left join   dbo.Tbl_Department on Tbl_Department.Department_Id=Tbl_Course_Duration.Course_Category_Id      
WHERE Tbl_Course_Duration.Course_Duration_DelStatus=0  and   Department_Status=0      
order by CategoryName        
          
          
END
');
END;