IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_candidate_CheckStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Insert_candidate_CheckStatus] --20034,1
(
@Secondary_status Bit ,
@HigherSecondary_status	bit,
@AdditionalCheck_status	bit,
@EnglishTest_status	bit,
@ButtonStatus varchar(MAX),
@Candidate_Id	bigint)
as
Begin
	if not exists(select * from Tbl_CheckStatus where Candidate_Id=@Candidate_Id)
	begin 
		Insert into Tbl_CheckStatus(Secondary_status,HigherSecondary_status,AdditionalCheck_status,
			EnglishTest_status,ButtonStatus,Candidate_Id,Created_date,Delete_status) values(@Secondary_status,
			@HigherSecondary_status,
			@AdditionalCheck_status,
			@EnglishTest_status,@ButtonStatus,
			@Candidate_Id,getdate(),0)
	end
	else
	begin
		Update Tbl_CheckStatus set Secondary_status=@Secondary_status,
			HigherSecondary_status=@HigherSecondary_status,
			AdditionalCheck_status=@AdditionalCheck_status,
			EnglishTest_status=@EnglishTest_status,Updated_date=getdate()
		where Candidate_Id=@Candidate_Id
	end
End');
END;
