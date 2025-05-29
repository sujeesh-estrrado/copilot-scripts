IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Student_Registration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Insert_Student_Registration]         
 @Candidate_Id bigint,        
    @Course_Category_Id bigint,        
    @Department_Id bigint,        
         
    @Student_Reg_Status bit ,  
 @UserId bigint      
          
AS        
BEGIN  
DECLARE @RegNo AS BIGINT;
Declare @Student_Reg_No varchar(200)
Set @RegNo=Isnull((Select CONVERT(bigint,(Select top 1 Student_Reg_No From Tbl_Student_Registration Order By Student_Reg_Id Desc))),0) 
Set @Student_Reg_No=(Select CONVERT(Varchar(100),(@RegNo+1)))        
IF NOT EXISTS(Select * from Tbl_Student_Registration Where Candidate_Id=@Candidate_Id)    
         
  insert into Tbl_Student_Registration (Candidate_Id,Course_Category_Id,Department_Id,Student_Reg_No,Student_Reg_Status,UserId,Created_Date,Delete_Status)        
        
  values(@Candidate_Id,@Course_Category_Id,@Department_Id ,@Student_Reg_No,@Student_Reg_Status,@UserId,getdate(),0)     
Else    
update Tbl_Student_Registration    
               
 set    
              
  Course_Category_Id=@Course_Category_Id,    
  Department_Id=@Department_Id,    
--  Student_Reg_No=@Student_Reg_No,    
  Student_Reg_Status=@Student_Reg_Status,  
  UserId=@UserId  ,
  Updated_date=getdate()
where Candidate_Id = @Candidate_Id     
       
        
END
    ')
END;
