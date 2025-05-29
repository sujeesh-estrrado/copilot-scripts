IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Promote_candidate_to_student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Promote_candidate_to_student]
(
@flag bigint=0,
@candidate_id bigint=0,
@uid bigint=0
)
as
begin
if(@flag=0)
	begin
		update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'',PromoteDate=GETDATE() where Candidate_Id=@candidate_id;
		update Tbl_User set role_Id=5 where user_Id=(select user_Id from Tbl_Student_User where Candidate_Id=@candidate_id);
		insert into Tbl_PromotionLog(Promotedby,Promotion_date) values(@uid,GETDATE());
	end

if(@flag=1)
	begin
		update Tbl_Student_NewApplication set ApplicationStatus=''Completed'' where Candidate_Id=@candidate_id;
		
		insert into Tbl_PromotionLog(Promotedby,Promotion_date) values(@uid,GETDATE());
	end
end
');
END;