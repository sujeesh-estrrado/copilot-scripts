IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Semester_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Student_Semester_Insert]                    
@Candidate_Id bigint=0,                    
@Duration_Mapping_Id bigint=0,                    
@Student_Semester_Current_Status bit=0,  
@Old_SemesterName varchar(100)='''',      
@FirstPromote varchar(100)='''',@semesterno nvarchar(50)=''''                     
AS                    
BEGIN              
DECLARE @Class_Id AS BIGINT;              
DECLARE @rc AS INT;                
DECLARE @Semester_Subject_Id AS BIGINT;             
                 
IF NOT EXISTS(SELECT * FROM Tbl_Student_Semester WHERE Candidate_Id=@Candidate_Id AND Duration_Mapping_Id=@Duration_Mapping_Id AND Student_Semester_Current_Status=1 )              
BEGIN                
UPDATE Tbl_Student_Semester SET Student_Semester_Current_Status=0,PromoteTo_Date=getdate() ,SEMESTER_NO=@semesterno                        
WHERE Candidate_Id=@Candidate_Id and Student_Semester_Current_Status=1      
--and Duration_Mapping_Id=@Duration_Mapping_Id                
                
--INSERT INTO Tbl_Student_Semester(Candidate_Id,Duration_Mapping_Id,Student_Semester_Current_Status)                    
--VALUES(@Candidate_Id,@Duration_Mapping_Id,@Student_Semester_Current_Status)     
  
  
INSERT INTO Tbl_Student_Semester(Candidate_Id,Duration_Mapping_Id,Student_Semester_Current_Status,PromoteFrom_Date,Old_SemesterName,SEMESTER_NO,Duration_Period_Id)                            
VALUES(@Candidate_Id,@Duration_Mapping_Id,@Student_Semester_Current_Status,getdate(),@Old_SemesterName,@semesterno,@Duration_Mapping_Id)                       
            
Delete from dbo.Tbl_Candidate_RollNumber where  Candidate_Id = @Candidate_Id       
--LMS INSERT STUDENT CLASS        
--commanted by arun       
-- UPDATE LMS_Tbl_Student_Class SET Status=1 WHERE Student_id=@Candidate_Id and Class_Id IN           
--(SELECT Class_Id FROM LMS_Tbl_Class WHERE Type=''Subject'')          
          
     SELECT               
  Semester_Subject_Id            
     INTO #Tbl_Stud_Sub                 
     From Tbl_Semester_Subjects                
     Where Duration_Mapping_Id=@Duration_Mapping_Id and Semester_Subjects_Status=0                
              
   SET @rc =(Select count(Semester_Subject_Id) FROM #Tbl_Stud_Sub)              
              
   WHILE @rc > 0                
   Begin                
   SET @Semester_Subject_Id=(SELECT TOP (1) Semester_Subject_Id from #Tbl_Stud_Sub)                
   SET @Class_Id=0            
              
            
   --INSERT INTO LMS_Tbl_Student_Class(Class_Id,Student_id,Approval_Status)              
   --VALUES(@Class_Id,@Candidate_Id,1)            
              
   Delete top(1) From #Tbl_Stud_Sub                 
   Set @rc=@rc-1                
   End              
              
END              
else  
begin  
UPDATE Tbl_Student_Semester SET Student_Semester_Current_Status=0,PromoteTo_Date=getdate() ,SEMESTER_NO=@semesterno                        
WHERE Candidate_Id=@Candidate_Id and Student_Semester_Current_Status=1    
end            
END
    ')
END;
