IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Subject_Master]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Insert_Subject_Master]  
  
(@SubjectMasterCode varchar(50),  
@SubjectName varchar(50),  
@Core_Elective varchar(50),  
@ParentSubject varchar(100),  
@GradingScheme varchar(50),  
@SevereLine varchar(50),  
@Description varchar(max))  
  
AS BEGIN  

--IF EXISTS(SELECT Subject_Master_Code,Subject_Name FROM  Tbl_Subject_Master WHERE Subject_Master_Code=@SubjectMasterCode
-- AND Subject_Name=@SubjectName)  
--  BEGIN
--  SELECT 0
--  END
  
-- ELSE 
INSERT INTO dbo.Tbl_Subject_Master (Subject_Master_Code,Subject_Name,Core_Elective,Parent_Subject,  
Grading_Scheme,Severe_Line,[Description]) VALUES(@SubjectMasterCode,@SubjectName,@Core_Elective,@ParentSubject,@GradingScheme,  
@SevereLine,@Description)  
  
SELECT SCOPE_IDENTITY()  
  
END  
  
    ')
END
GO