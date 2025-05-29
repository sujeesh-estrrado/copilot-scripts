IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateApplicationStage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_UpdateApplicationStage](@Candidate_Id bigint=0,@ApplicationStage varchar(200)='''')
as
begin
update Tbl_Candidate_Personal_Det set ApplicationStage=@ApplicationStage,Editable=null where Candidate_Id=@Candidate_Id;
end
    ')
END
