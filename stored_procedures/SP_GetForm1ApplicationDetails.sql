IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetForm1ApplicationDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetForm1ApplicationDetails] --1  
 @Job_Id bigint    
AS    
BEGIN    
 SELECT    
  J.[Application_No],J.[Application_Date],J.[Revision_No],J.[Position_Applied],J.[Type_Of_Position],    
  J.[Date_Of_Availability],J.[Notice_Period],J.[Applicant_Name],isnull(J.[Applicant_Img],'''') as Applicant_Img,J.[Ic_Passport_No],    
  J.[Country],J.[Employment_Pass_No],J.[Date_of_Birth],J.[Gender],J.[Merital_Status],J.[Applicant_Address],    
  J.[Applicant_Mailing_Address],J.[Aplicant_Email_Address],J.[Applicant_Contact_Number],J.[Applicat_Mobile_Number],    
  J.[Emergency_Contact_Name],J.[Emergency_RelationShip],J.[Emergency_Contact_Number],J.[Married_Spouse_Name],    
  J.[Married_Spouse_Country],J.[Married_Spouse_Occupation],J.[Married_Spouse_Contact_No],J.[Number_of_Children],J.Department_Id,    
 J.[Hired_On_Date],  
  E.Dept_Designation_Name,C.Course_Level_Name,N.[Nationality],N1.[Nationality] AS SpouseCountry  
  ,CONVERT(int,ROUND(DATEDIFF(hour,J.[Date_of_Birth],GETDATE())/8766.0,0)) AS EmployeeAge  
 FROM    
 [dbo].[Tbl_JobApplication_Deatils] J  
 LEFT JOIN Tbl_Emp_DeptDesignation E ON J.Position_Applied=E.Dept_Designation_Id  
 LEFT JOIN [Tbl_Course_Level] C ON J.Department_Id=C.Course_Level_Id  
 LEFT JOIN [dbo].[Tbl_Nationality] N ON J.Country=N.Nationality_Id  
 LEFT JOIN [dbo].[Tbl_Nationality] N1 ON J.[Married_Spouse_Country]=N.Nationality_Id  
 WHERE     
  [Job_Id]=@Job_Id    
END

');
END;