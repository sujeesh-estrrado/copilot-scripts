IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[PROC_UPDATE_Subject_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[PROC_UPDATE_Subject_New]      
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
@AssessmentCode bigint ,  
@Course_Id bigint,  
@Minimum_Students bigint  ,
@resitGrade bigint,
@flag bigint=0
)      
AS      
      
   
                     
BEGIN    

if(@flag =0) 
begin
      
 UPDATE Tbl_New_Course SET   
Org_Id=@Org_Id,  
Faculty_Id=@Faculty_Id,  
Course_Name=@Course_Name,  
Course_code=@Course_code,  
Course_credit=@Course_credit,  
ContactHours=@ContactHours,  
SubjectTotalHours=@SubjectTotalHours,  
Course_GPS=@Course_GPS,  
Grade_Id=@Grade_Id,  
Course_Type=@Course_Type,  
Course_Prequisite=@Course_Prequisite,  
AssessmentCode=@AssessmentCode,  
Minimum_Students=@Minimum_Students, 
ResitGrade=@resitGrade,
Updated_Date=getdate()  
WHERE   
--Active_Status=''Active'' and   
Course_Id=@Course_Id  
      
 SELECT SCOPE_IDENTITY()    
   end   

   if(@flag =1) 

IF EXISTS(SELECT Course_Name FROM Tbl_New_Course    Where Course_code=@Course_code and Delete_Status=0 and Faculty_Id=@Faculty_Id)            
begin
      
 UPDATE Tbl_New_Course SET   
Org_Id=@Org_Id,  
Faculty_Id=@Faculty_Id,  
Course_Name=@Course_Name,  
Course_code=@Course_code,  
Course_credit=@Course_credit,  
ContactHours=@ContactHours,  
SubjectTotalHours=@SubjectTotalHours,  
Course_GPS=@Course_GPS,  
Grade_Id=@Grade_Id,  
Course_Type=@Course_Type,  
Course_Prequisite=@Course_Prequisite,  
AssessmentCode=@AssessmentCode,  
Minimum_Students=@Minimum_Students, 
ResitGrade=@resitGrade,
Updated_Date=getdate()  
--WHERE   
--Active_Status=''Active'' and   
Where Course_code=@Course_code and Delete_Status=0 and Faculty_Id=@Faculty_Id
      
 SELECT SCOPE_IDENTITY()    
end 

 else 
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

   end   
   
 END  
    ')
END
