IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ICpassportExist]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Get_ICpassportExist]  
(
@PassportNo varchar(MAX)
)
AS
BEGIN
    Select * from Tbl_Candidate_Personal_Det where AdharNumber=@PassportNo and Candidate_DelStatus=0
END

    ')
END
