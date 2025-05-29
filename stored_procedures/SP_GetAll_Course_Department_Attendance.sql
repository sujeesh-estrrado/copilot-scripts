IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Department_Attendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Department_Attendance]                                
        @Employee_Id BIGINT =0                       
AS                                
                                
BEGIN                         
                        
                         
                                
--SELECT       dbo.Tbl_Course_Category.Course_Category_Name,Tbl_Department.Department_Id, --dbo.Tbl_Course_Department.Course_Department_Id,  
-- dbo.Tbl_Course_Department.Department_Id as Course_Department_Id,                                 
--                      dbo.Tbl_Course_Department.Course_Category_Id, dbo.Tbl_Course_Department.Course_Department_Description,                                 
--                      dbo.Tbl_Course_Department.Course_Department_Date, dbo.Tbl_Department.Department_Name                                
--FROM         dbo.Tbl_Department INNER JOIN                                
--                      dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN                                
--                      dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id                              
--                      -- dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Department_Id = dbo.Tbl_Course_Category.Course_Category_Id                                  
                                
                                
--       where Tbl_Course_Department.Course_Department_Status=0 and                                
--                 Tbl_Course_Category.Course_Category_Status=0 and                                
--                 Tbl_Department.Department_Status=0                              
--order by dbo.Tbl_Course_Category.Course_Category_Name   
if(@Employee_Id=0)
begin
SELECT distinct  D.Department_Id as Course_Department_Id,D.Department_Name AS Course_Department_Name, D.Department_Name
FROM                         
 dbo.Tbl_Department D 
inner join Tbl_Class_TimeTable   CT  ON D.Department_Id=CT.Department_Id   
order by D.Department_Name  
end
else
begin
SELECT distinct  D.Department_Id as Course_Department_Id,D.Department_Name AS Course_Department_Name, D.Department_Name
FROM                         
 dbo.Tbl_Department D 
inner join Tbl_Class_TimeTable   CT  ON D.Department_Id=CT.Department_Id   
where ct.Employee_Id=@Employee_Id
order by D.Department_Name  
end
                                   
END


');
END;