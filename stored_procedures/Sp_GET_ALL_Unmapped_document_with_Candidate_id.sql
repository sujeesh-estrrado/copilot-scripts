IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GET_ALL_Unmapped_document_with_Candidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_GET_ALL_Unmapped_document_with_Candidate_id]
(@Candidateid bigint,
@flag BIGINT)
as
begin

if(@flag=0)
BEGIN
--select id,Document_Name from tbl_certificate_master  where 
--id not in (select Certificate_Id from Tbl_Candidate_Document  where Candidate_Id=@Candidateid)
select id,Document_Name from tbl_certificate_master where Type_Of_Student is null and Delete_Status=0
and id not in (select Certificate_Id from Tbl_Candidate_Document  where Candidate_Id=@Candidateid) 

Union all 

select id,Document_Name from tbl_certificate_master CM
left join Tbl_Candidate_Personal_Det PD on PD.TypeOfStudent=CM.Type_of_student
 where 
id not in (select Certificate_Id from Tbl_Candidate_Document  where Candidate_Id=@Candidateid) 
and PD.Candidate_Id=@Candidateid
and Delete_Status=0
END 
 IF (@flag = 10)
    BEGIN
        DECLARE @CategoryId INT

        -- Check if ''Modular Course'' already exists
        IF NOT EXISTS (
            SELECT 1 
            FROM tbl_certificate_category 
            WHERE category = ''Modular Course'' AND delete_status = 0
        )
        BEGIN
            INSERT INTO tbl_certificate_category (category, delete_status, create_date, update_date)
            VALUES (''Modular Course'', 0, GETDATE(), '''')

            -- Get the newly inserted CategoryId
            SET @CategoryId = SCOPE_IDENTITY()
        END
        ELSE
        BEGIN
            -- Fetch existing CategoryId
            SELECT @CategoryId = id 
            FROM tbl_certificate_category 
            WHERE category = ''Modular Course'' AND delete_status = 0
        END

        -- Insert ''Invoice'' for INTERNATIONAL if not exists
        IF NOT EXISTS (
            SELECT 1 
            FROM tbl_certificate_master 
            WHERE Document_Name = ''Invoice'' 
              AND Type_of_student = ''INTERNATIONAL'' 
              AND Category_id = @CategoryId
        )
        BEGIN
            INSERT INTO tbl_certificate_master 
            (Document_Name, Type_of_student, Category_id, Delete_Status, StaticDoc)
            VALUES (''Invoice'', ''INTERNATIONAL'', @CategoryId, 0, 0)
        END

        -- Insert ''Invoice'' for LOCAL if not exists
        IF NOT EXISTS (
            SELECT 1 
            FROM tbl_certificate_master 
            WHERE Document_Name = ''Invoice'' 
              AND Type_of_student = ''LOCAL'' 
              AND Category_id = @CategoryId
        )
        BEGIN
            INSERT INTO tbl_certificate_master 
            (Document_Name, Type_of_student, Category_id, Delete_Status, StaticDoc)
            VALUES (''Invoice'', ''LOCAL'', @CategoryId, 0, 0)
        END

        -- Finally return the required document list
       SELECT CM.id, CM.Document_Name
        FROM tbl_certificate_master CM
        JOIN Tbl_Modular_Candidate_Details MD 
            ON CM.Type_of_student COLLATE SQL_Latin1_General_CP1_CI_AS = MD.Type COLLATE SQL_Latin1_General_CP1_CI_AS
        WHERE (@Candidateid = MD.Modular_Candidate_Id OR @Candidateid = MD.Candidate_Id) 
          AND CM.Document_Name = ''Invoice''
          AND CM.Delete_Status = 0
          AND MD.Delete_Status = 0

    END
end
    ')
END
