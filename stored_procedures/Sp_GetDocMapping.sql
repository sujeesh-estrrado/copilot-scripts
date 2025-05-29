IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetDocMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_GetDocMapping] --0,4,''INTERNATIONAL'',0,2
(@certificate_id int=0,@program_code varchar(MAX),@Student_Type  varchar(MAX)='''',@Status  bit=0, @flag int,@IsMandatory bit=0)
as
begin
    if @flag=1
    begin
        SELECT       dbo.tbl_certificate_maping.Certificate_id,  dbo.tbl_certificate_maping.program_code, dbo.tbl_certificate_master.Document_Name, dbo.tbl_certificate_master.Type_of_student, 
                                 dbo.tbl_certificate_maping.status, isnull(dbo.tbl_certificate_maping.IsMandatory,0) IsMandatory
        FROM            dbo.tbl_certificate_maping INNER JOIN
                                 dbo.tbl_certificate_master ON dbo.tbl_certificate_maping.Certificate_id = dbo.tbl_certificate_master.id
        where Certificate_id=@Certificate_id and program_code=@program_code and dbo.tbl_certificate_master.Delete_Status=0 ORDER BY dbo.tbl_certificate_master.Document_Name asc
    end
    if @flag=2
    begin
        SELECT       dbo.tbl_certificate_maping.Certificate_id,  dbo.tbl_certificate_maping.program_code, dbo.tbl_certificate_master.Document_Name, dbo.tbl_certificate_master.Type_of_student, 
                                 dbo.tbl_certificate_maping.status, isnull(dbo.tbl_certificate_maping.IsMandatory,0) IsMandatory
        FROM            dbo.tbl_certificate_maping INNER JOIN
                                 dbo.tbl_certificate_master ON dbo.tbl_certificate_maping.Certificate_id = dbo.tbl_certificate_master.id
        where Type_of_student=@Student_Type and program_code=@program_code and dbo.tbl_certificate_master.Delete_Status=0 ORDER BY dbo.tbl_certificate_master.Document_Name asc
    end
    if @flag=3
    begin
        update tbl_certificate_maping set status = @Status, IsMandatory=@IsMandatory where program_code = @program_code and Certificate_id = @Certificate_id
    end
end');
END;
