IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Insert_Candidate_Englishtest_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Insert_Candidate_Englishtest_Details]
(
@English_Text_Id bigint,
@Grade varchar(MAX),
@Type varchar(MAX),
@cand_Id bigint,
@flag bigint=0,
@year varchar(10)=''''
)  
as  
begin   
if not exists(select * from Tbl_Candidate_Englishtest  where  Delete_Status=0 and Type=@Type and English_Text_Id=@English_Text_Id and cand_Id=@cand_Id)
begin

insert into Tbl_Candidate_Englishtest(English_Text_Id,Grade,Type,cand_Id,created_Date,Delete_Status,TestYear)
 values(@English_Text_Id,@Grade,@Type,@cand_Id,getdate(),0,@year) 
end
else
begin
update Tbl_Candidate_Englishtest set Grade=@Grade where Type=@Type and cand_Id=@cand_Id and English_Text_Id=@English_Text_Id
end
if(@flag=1)
begin
Delete from Tbl_Candidate_Englishtest where cand_Id=@cand_Id
end
end

    ')
END
