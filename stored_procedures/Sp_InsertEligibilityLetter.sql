IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertEligibilityLetter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_InsertEligibilityLetter](@candidate_id bigint=0,@user bigint=0,@path varchar(max)='''',@flag bigint=0)
as
begin 
if(@flag=1)
begin 
	if not exists (select * from Tbl_Eligibilty_letter where candidate_id=@candidate_id and Letter_path=@path and Delete_status=0)
		begin
			insert into Tbl_Eligibilty_letter(candidate_id,Created_by,Create_date,Letter_path,delete_status) values(@candidate_id,@user,getdate(),@path,0);
		end
end
	if(@flag=2)
		begin
			select * from Tbl_Eligibilty_letter where candidate_id=@candidate_id and Delete_status=0;
		end
if(@flag=3)
		begin
			Update Tbl_Eligibilty_letter set Delete_status=1 where candidate_id=@candidate_id
		end
end
    ')
END;
