IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_StudentApplicationStage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_Update_StudentApplicationStage]
(@Candidate_Id bigint=0,@ApplicationStage varchar(200)='''')
as
begin
update Tbl_Student_NewApplication set ApplicationStage=@ApplicationStage,Editable=null 
where Candidate_Id=@Candidate_Id;
end
    ')
END;
