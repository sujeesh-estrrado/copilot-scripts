IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_New_Course]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_New_Course]            
(            
  
@Org_Id bigint,  
@Faculty_Id bigint,  
@Course_Name varchar(MAX),  
@Course_code varchar(MAX),  
@Course_credit varchar(MAX),  
@ContactHours DECIMAL(10,3),  
@SubjectTotalHours DECIMAL(10,3),  
@Course_GPS varchar(100),  
@Grade_Id bigint,  
@Course_Type varchar(100),  
@Course_Prequisite bigint,  
@AssessmentCode bigint,  
@Minimum_Students bigint=0  ,
@resitGrade bigint=0
)            
AS            
 --IF EXISTS(SELECT Course_Name FROM Tbl_New_Course    Where Course_Name = @Course_Name and Course_code=@Course_code and Delete_Status=0)            
   IF EXISTS(SELECT Course_Name FROM Tbl_New_Course    Where Course_Name = @Course_Name and Course_code=@Course_code and Delete_Status=0 and Faculty_Id=@Faculty_Id)            
  
BEGIN        
--select 0        
      
RAISERROR (''Data Already Exists.'', -- Message text.                      
               16, -- Severity.                      
               1 -- State.                      
               );                      
END                      
ELSE                      
                       
BEGIN               
            
INSERT INTO dbo.Tbl_New_Course(Org_Id,Faculty_Id,Course_Name,Course_code,  
Course_credit,ContactHours,SubjectTotalHours,Course_GPS,Grade_Id,Course_Type,  
Course_Prequisite,AssessmentCode,Minimum_Students,Active_Status,Created_Date,Delete_Status,ResitGrade)            
            
VALUES (@Org_Id,@Faculty_Id,  
@Course_Name,  
@Course_code,  
@Course_credit,  
@ContactHours,  
@SubjectTotalHours,  
@Course_GPS,  
@Grade_Id,  
@Course_Type,  
@Course_Prequisite,  
@AssessmentCode,  
@Minimum_Students,''Active'',getdate(),0,@resitGrade)            
            
 SELECT SCOPE_IDENTITY()            
             
 END  
    ');
END;
