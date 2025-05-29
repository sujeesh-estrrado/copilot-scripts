IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Candidate_Additionalqualification_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Candidate_Additionalqualification_Details]
(

@Candidate_Id bigint,
@QualificationLevel	varchar(MAX),
@Qualification	varchar(MAX),
@InstitutionName	varchar(MAX),
@YearofPass	varchar(MAX),
@Result	varchar(MAX),
@ResultAttachment	varchar(MAX)
)  
as  
begin   
if not exists(select * from Tbl_Candidate_Additionalqualification  where  Delete_Status=0 and Candidate_Id=@Candidate_Id and QualificationLevel=@QualificationLevel)
begin

insert into Tbl_Candidate_Additionalqualification(Candidate_Id,QualificationLevel,Qualification,InstitutionName,YearofPass,Result,
ResultAttachment,created_Date,Delete_Status)
 values(@Candidate_Id,@QualificationLevel,@Qualification,@InstitutionName,@YearofPass,@Result,@ResultAttachment,getdate(),0) 
end
else
begin
update Tbl_Candidate_Additionalqualification set Qualification=@Qualification,
InstitutionName=@InstitutionName ,YearofPass=@YearofPass,Result=@Result,ResultAttachment=@ResultAttachment
 where QualificationLevel=@QualificationLevel and Candidate_Id=@Candidate_Id 
end
end');
END;
