IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Lead_ContactDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Lead_ContactDet](@Candidate_Id bigint,              
@Candidate_Mob1 varchar(50),@Candidate_Email varchar(50),
@FatherName varchar(100)='''', @MotherName varchar(100)='''', @Address varchar(500)=''''
,@FatherMobile varchar(20)='''', @MotherMobile varchar(100)='''',@State varchar(100)='''', @City varchar(100)='''', @PostCode varchar(10)='''',@address2 varchar(500)='''',
@telephone varchar(100)=''''

)                
                  
                   
AS                  
BEGIN                  
BEGIN TRAN       
if not exists(select * from Tbl_Lead_ContactDetails where Candidate_Id=@Candidate_Id)      
Begin                 
INSERT INTO dbo.Tbl_Lead_ContactDetails(Candidate_Id,Candidate_Mob1,                  
Candidate_Email  ,Candidate_PermAddress_Country,Candidate_FatherName,Candidate_MotherName,Candidate_PermAddress,Candidate_ContAddress
,FatherMobileNo,MotherMobileNo,Candidate_PermAddress_postCode,Candidate_PermAddress_Line2,Candidate_PermAddress_State,Candidate_PermAddress_City,Candidate_Telephone)                  
VALUES                  
(@Candidate_Id,@Candidate_Mob1,@Candidate_Email   ,(select Residing_Country from Tbl_Lead_Personal_Det where Candidate_Id=@Candidate_Id)              
  ,@FatherName,@MotherName, @Address,@Address,@FatherMobile,@MotherMobile,@PostCode , @address2,@State,@City,@telephone )      
select Scope_identity()          
End              
COMMIT TRAN                   
                  
END
    ');
END;
