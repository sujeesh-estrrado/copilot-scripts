IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Student_Semester]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_Update_Student_Semester]                  
@Candidate_Id bigint=0,                  
@Old_SemesterName varchar(100)='''' ,           
@semesterno bigint=0,
@SemesterId   bigint=0
                   
AS                  
BEGIN            
          
              
UPDATE Tbl_Student_Semester SET Student_Semester_Current_Status=1,PromoteTo_Date=getdate() ,
Updated_Date=getdate() ,
Old_SemesterName=@Old_SemesterName,
SEMESTER_NO=@semesterno  ,
SemesterId=@SemesterId                    
WHERE Candidate_Id=@Candidate_Id 

--select * from Tbl_Student_Semester where Candidate_Id=44028    

end
    ')
END;
