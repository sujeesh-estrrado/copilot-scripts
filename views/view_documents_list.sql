IF NOT EXISTS (
    SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[view_documents_list]')
)
BEGIN
    EXEC('
        CREATE VIEW [dbo].[view_documents_list] AS
        SELECT 
            dbo.tbl_certificate_master.Document_Name, 
            dbo.tbl_document_list.certificate_id, 
            dbo.tbl_document_list.programe_code, 
            dbo.tbl_document_list.student_type, 
            dbo.tbl_certificate_master.id
        FROM dbo.tbl_certificate_master
        INNER JOIN dbo.tbl_document_list 
            ON dbo.tbl_certificate_master.id = dbo.tbl_document_list.certificate_master_id
    ')
END
