IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Secondery_Course_Inquery]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Secondery_Course_Inquery]
(@candidate_id bigint=0,@course_id bigint=0)
as
begin
if not exists (select * from Tbl_Secondery_Course_Inquery where Candidate_id=@candidate_id and Course_id=@course_id and delete_status=0)
begin
insert into Tbl_Secondery_Course_Inquery(Candidate_id,Course_id,Create_date,delete_status)values(@candidate_id,@course_id,getdate(),0);
end
else
begin
update Tbl_Secondery_Course_Inquery set
Course_id=@course_id,
Update_date=getdate() where Candidate_id=@candidate_id and delete_status=0
end
end
    ')
END;
