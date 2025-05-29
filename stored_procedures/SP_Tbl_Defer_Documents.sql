IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Defer_Documents]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Defer_Documents](@flag bigint=0,@candidate_id bigint=0,@Docname varchar(max)='''',@path varchar(max)='''',@docid bigint =0,@requestid bigint=0)
as
begin
if(@flag=1)--insert new documents 
begin

insert into Tbl_Defer_Documents(Candidate_id,Docname,Path,create_date,delete_status,Defer_Request_id) values(@candidate_id,@Docname,@path,GETDATE(),0,@requestid);

end
if(@flag=2)--Get all documents with candidate id
begin
select * from Tbl_Defer_Documents where Candidate_id=@candidate_id and delete_status=0 and Defer_Request_id=@requestid
end
if(@flag=3)-- delete by doc_id
begin

update Tbl_Defer_Documents set delete_status=1 where Doc_id=@docid;


end

end
    ')
END;
