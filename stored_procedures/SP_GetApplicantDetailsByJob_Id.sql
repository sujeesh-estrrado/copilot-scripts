IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetApplicantDetailsByJob_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetApplicantDetailsByJob_Id]     
 @Job_Id bigint    
AS    
BEGIN    
 SELECT    
  J.[Job_Id],J.[Applicant_Name],J.[Date_of_Birth],N.[Nationality] as CountryName,J.[Department_Id],    
  J.[Position_Applied],D.[Department_Name],E.[Dept_Designation_Name] AS Position,    
  CONVERT(int,ROUND(DATEDIFF(hour,J.[Date_of_Birth],GETDATE())/8766.0,0)) AS EmployeeAge,  
  CONVERT(int,ROUND(DATEDIFF(hour,B.[Period_of_Employee_From_Date],B.[Period_of_Employee_To_Date])/8766.0,0))   
  AS EmployeeExperience  
 FROM    
  [dbo].[Tbl_JobApplication_Deatils] J    
  INNER JOIN [dbo].[Tbl_Nationality] N ON N.Nationality_Id=J.[Country]    
  INNER JOIN [dbo].[Tbl_Department] D ON D.[Department_Id]=J.[Department_Id]    
  INNER JOIN [dbo].[Tbl_Emp_DeptDesignation] E ON E.[Dept_Designation_Id]=J.[Position_Applied]  
  INNER JOIN [dbo].[Tbl_JobApp_Employment_Background] B ON B.[Job_Id]=J.[Job_Id]  
 WHERE    
  J.[Job_Id]=@Job_Id    
END ')
END;
