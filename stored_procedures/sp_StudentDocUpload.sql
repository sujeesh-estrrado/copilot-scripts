IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentDocUpload]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[sp_StudentDocUpload]
(
@Flag bigint =0,
@id bigint =0,
@StudentId  bigint=0,
@DocType    varchar(50)='''',
@DocumentName   varchar(200)='''',
@DocumentLoc    varchar(MAX)='''',
@DeleteStatus   bit=0,
@IsInternal BIT = 0 
)
as 
begin
    if(@Flag =1)--Insert
    begin 
        INSERT INTO [dbo].[tbl_StudentDocUpload]
           ([StudentId],[DocType],[DocumentName],[DocumentLoc],[CreatedDateDate],[LastUpdated],[DeleteStatus],[IsInternal])
     VALUES
           (@StudentId,@DocType,@DocumentName,@DocumentLoc,Getdate(),Getdate(),0,@IsInternal)
    end
    if(@Flag =2)--Select
    begin 
        SELECT [id],[StudentId],[DocType],[DocumentName],[DocumentLoc],[DeleteStatus]
        FROM [dbo].[tbl_StudentDocUpload]
        where [DeleteStatus] =0 and ([StudentId] = @StudentId or @StudentId=0) and ([DocType] = @DocType or @DocType = '''')and ([id] = @id or @id=0) 
        and [IsInternal]=0
    end
    if(@Flag =3)--Delete
    begin 
        update [tbl_StudentDocUpload] set [DeleteStatus] = 1 where [id]= @id
    end
    if(@Flag =4)--Check DocName Existance
    begin 
        select count(*) from [tbl_StudentDocUpload] where [DocumentName] = @DocumentName and [StudentId] = StudentId and [DeleteStatus] = 0
    end
    if(@Flag=5)--marketing reject check status
    begin
    select * from [tbl_StudentDocUpload] where DocType=@DocType and MarketingVerify!=1 and StudentId=@StudentId ;
    end
if(@Flag=6)--Admission reject check status
    begin
    select * from [tbl_StudentDocUpload] where DocType=@DocType and AdmissionVerify!=1 and StudentId=@StudentId ;
    end


end
    ')
END
