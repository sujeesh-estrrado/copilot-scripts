IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_AnnualPracticingCertification]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_AnnualPracticingCertification]                      
 (
@Candidate_Id   bigint,
@Filename   varchar(MAX),
@Documentdate   datetime
 )
AS                    
declare @DepartId bigint;                   
IF not EXISTS(SELECT * FROM Tbl_AnnualPracticingCertificate Where Candidate_Id=@Candidate_Id )                    
  begin
   insert into Tbl_AnnualPracticingCertificate(Candidate_Id,Filename,Documentdate,Created_Date,Delete_Status)                    
  values(@Candidate_Id,@Filename,@Documentdate,Getdate(),0)                    
       
          
  end                 
ELSE   
BEGIN                  
    update   Tbl_AnnualPracticingCertificate set  Filename=@Filename  ,Documentdate=@Documentdate,Updated_date=getdate()
    where    Candidate_Id=@Candidate_Id                      
         
END
    ')
END;
