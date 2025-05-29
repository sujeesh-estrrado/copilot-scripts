IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_Agent_Invoice]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_Insert_Agent_Invoice]
(
@flag bigint=0,
@Invoiceno varchar(MAX)='''',
@Agent_Id bigint=0,
@Candidate_Id bigint=0,
@Invoice_Date datetime='''',
@Upload varchar(MAX)='''',
@Remarks varchar(MAX)='''')

AS

BEGIN
if(@flag=0)
begin
    insert into Tbl_Agent_Invoice(Invoiceno,Agent_Id,Candidate_Id,Invoice_Date,Upload,Remarks,Created_Date,Delete_Status)
    values(@Invoiceno,@Agent_Id,@Candidate_Id,@Invoice_Date,@Upload,@Remarks,getdate(),0)
end
if(@flag=1)
begin
update Tbl_Agent_Invoice set Upload=@Upload, Updated_Date=GETDATE() where Invoiceno=@Invoiceno and Agent_Id=@Agent_Id
end
END');
END;
