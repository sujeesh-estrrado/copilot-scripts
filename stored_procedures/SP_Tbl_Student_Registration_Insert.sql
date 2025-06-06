IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Registration_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Student_Registration_Insert]      
@Candidate_Id bigint,      
@Course_Category_Id bigint,      
@Department_Id bigint      
AS      
BEGIN      
DECLARE @Class_Id AS BIGINT;      
DECLARE @RegNo AS BIGINT;      
   
Declare @CourseCode varchar(50),@Student_Reg_No varchar(200)      
Set @CourseCode=(Select Top 1 Course_Department_Code From Tbl_Course_Department Where Department_Id=@Department_Id and Course_Category_Id=@Course_Category_Id and Course_Department_Status=0)      
--Set @Student_Reg_No=(Select cast (year(getdate())as varchar(10)) +''''-''''+@CourseCode+''''-''''+cast(@Candidate_Id as varchar(10)))      
Set @RegNo=Isnull((Select CONVERT(bigint,(Select top 1 Student_Reg_No From Tbl_Student_Registration Order By Student_Reg_Id Desc))),0)
Set @Student_Reg_No=(Select CONVERT(Varchar(100),(@RegNo+1)))
      
INSERT INTO [Tbl_Student_Registration]      
           ([Candidate_Id]      
           ,[Course_Category_Id]      
           ,[Department_Id]      
           ,[Student_Reg_No]      
   )      
     VALUES      
           (@Candidate_Id      
           ,@Course_Category_Id      
           ,@Department_Id      
           ,@Student_Reg_No)      
  
 SET @Class_Id=(SELECT Class_Id FROM LMS_Tbl_Class WHERE Type=''College'')   
   
    
--LMS INSERT STUDENT CLASS     
INSERT INTO LMS_Tbl_Student_Class(Class_Id,Student_id,Approval_Status)      
VALUES(@Class_Id,@Candidate_Id,1)     
  
SET @Class_Id=(SELECT Class_Id FROM LMS_Tbl_Class WHERE Type=''Department'' and Type_Id=    
(Select Course_Department_Id FROM Tbl_Course_Department Where Course_Category_Id=@Course_Category_Id and Department_Id=@Department_Id))      
  
INSERT INTO LMS_Tbl_Student_Class(Class_Id,Student_id,Approval_Status)      
VALUES(@Class_Id,@Candidate_Id,1)     
    
END
    ')
END
