IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_EmployeebyStaffPersonalParticular]') 
    AND type = N'P'
)
BEGIN
    EXEC('CREATE procedure [dbo].[SP_Insert_EmployeebyStaffPersonalParticular]  
@StaffPersonal_Id bigint  
AS  
DECLARE @EmpID BIGINT  
DECLARE @Job_Id BIGINT  
BEGIN  
--Personal Details  
SET @Job_Id=(SELECT [Job_Id] FROM [dbo].[Tbl_StaffPersonalParticular] WHERE [StaffPersonal_Id]=@StaffPersonal_Id)  
 INSERT INTO Tbl_Employee                              
( [Employee_FName] ,[Employee_LName] ,[Employee_DOB] ,[Employee_Gender] ,[Employee_Permanent_Address]                              
           ,[Employee_Present_Address] ,[Employee_Phone] ,[Employee_Mail] ,[Employee_Mobile]                              
           ,[Employee_Martial_Status] ,[Employee_Nationality]               
       ,[Employee_Father_Name]             
           ,[Employee_Status] ,[Employee_Type] ,    
     Spouse_FName, Spouse_LName, Spouse_IC_No,NoofChildren,Spouse_MobileNo,Emergency_Name,  
  Emergency_Number                        
)                              
   ( SELECT J.[Applicant_Name],'''', J.[Date_of_Birth],J.[Gender],J.[Applicant_Address]  
   , S.[EmergencyAddress] ,J.[Applicant_Contact_Number],J.[Aplicant_Email_Address],J.[Applicat_Mobile_Number]  
   ,J.[Merital_Status],J.[Country],S.[FatherName],0,J.[Type_Of_Position],  
J.[Married_Spouse_Name],'''',S.[SpouseICNo],J.[Number_of_Children],J.[Married_Spouse_Contact_No],J.[Emergency_Contact_Name]  
,J.[Emergency_Contact_Number]  
FROM    [dbo].[Tbl_StaffPersonalParticular] S  
LEFT JOIN   [dbo].[Tbl_JobApplication_Deatils]   J ON S.[Job_Id] =J.[Job_Id]  
WHERE S.[StaffPersonal_Id]=@StaffPersonal_Id  
   )  
   SET @EmpID=@@IDENTITY  
 --Attachments  
 INSERT INTO [Tbl_Employee_Certificates]    
           ([Employee_Id]    
   -- ,[Title]    
           ,[Image_Path])    
     VALUES(@EmpID,(SELECT [Academic_Transcripts_URL] FROM [dbo].[Tbl_JobApp_Academic_Transcripts_Attachment]  
     WHERE [Job_Id]=@Job_Id))  
 INSERT INTO [Tbl_Employee_Certificates]    
           ([Employee_Id]    
   -- ,[Title]    
           ,[Image_Path])    
     VALUES(@EmpID,(SELECT [Resume_Url] FROM [dbo].[Tbl_JobApp_Attachments]  
     WHERE [Job_Id]=@Job_Id ))   
     INSERT INTO [Tbl_Employee_Certificates]    
           ([Employee_Id]    
   -- ,[Title]    
           ,[Image_Path])    
     VALUES(@EmpID,(SELECT [Passport_Url] FROM  [dbo].[Tbl_JobApp_Attachments]  
     WHERE [Job_Id]=@Job_Id))       
  INSERT INTO [Tbl_Employee_Certificates]    
           ([Employee_Id]    
   -- ,[Title]    
           ,[Image_Path])    
     VALUES(@EmpID,(SELECT [Teaching_Permit_Url] FROM  [dbo].[Tbl_JobApp_Attachments]  
     WHERE [Job_Id]=@Job_Id))      
      INSERT INTO [Tbl_Employee_Certificates]    
           ([Employee_Id]    
   -- ,[Title]    
           ,[Image_Path])    
     VALUES(@EmpID,(SELECT [Driving_License_Url] FROM  [dbo].[Tbl_JobApp_Attachments]  
     WHERE [Job_Id]=@Job_Id))    
       
 insert into dbo.Tbl_Employee_Experience(Employee_Duration_From,  
 Employee_Duration_To,Employee_Desigination,Employee_Experience_Status)      
  ((SELECT [Period_of_Employee_From_Date],[Period_of_Employee_To_Date],[Position],''0''   
 FROM [dbo].[Tbl_JobApp_Employment_Background]  
 WHERE [Job_Id]=@Job_Id))    
 SELECT @EmpID  
END')
   end
