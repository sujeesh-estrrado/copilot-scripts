IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Update_Candidate_BtnStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Update_Candidate_BtnStatus] --20034,1
(
@ButtonStatus varchar(MAX),
@Candidate_Id   bigint)
as
Begin
    if not exists(select * from Tbl_CheckStatus where Candidate_Id=@Candidate_Id)
    begin 
        Insert into Tbl_CheckStatus(ButtonStatus,Candidate_Id,Created_date,Delete_status) values(@ButtonStatus,@Candidate_Id,getdate(),0)
    end
    else
    begin
        Update Tbl_CheckStatus set Updated_date=getdate(),
                ButtonStatus=@ButtonStatus
        where Candidate_Id=@Candidate_Id
    end
End
    ')
END
