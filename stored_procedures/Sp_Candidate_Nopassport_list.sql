IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Candidate_Nopassport_list]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Candidate_Nopassport_list] 
(
@flag bigint=0,
@candidate_Id Bigint=0,
@passportNo varchar(Max)=''''
)   
AS
BEGIN
if(@flag=0)
begin
select PassportNo as Nopassport,Candidate_id from Tbl_Candidate_NopassportList where Delete_status=0 and Candidate_id=@candidate_Id
End
if(@flag=1)
begin
Insert into Tbl_Candidate_NopassportList (Candidate_id,PassportNo,Created_date,Delete_status)
values(@candidate_Id,@passportNo,getdate(),0)
End
if(@flag=2)
begin
update Tbl_Candidate_NopassportList set Updated_date=getdate()
End
END
    ')
END
