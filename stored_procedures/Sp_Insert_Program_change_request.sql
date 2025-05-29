IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Program_change_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Program_change_request](@candidate_id bigint,@pgmid bigint,@faculty bigint,@intake bigint)
as
begin
--if not exists (select * from tbl_New_Admission NA inner join Tbl_Candidate_Personal_Det CPD on CPD.New_Admission_Id=NA.New_Admission_Id where Candidate_Id=@candidate_id)
--if not exists (select * from Tbl_Program_change_request  where Candidate_Id=@candidate_id)
--begin 
--insert into Tbl_Program_change_request(Candidate_id,Course_level_id,Department_id,batchid,create_date,delete_status,Application_status)
--values(@candidate_id,@faculty,@pgmid,@intake,GETDATE(),0,''Submitted'');
--end
IF EXISTS (SELECT 1 FROM Tbl_Program_change_request WHERE Candidate_Id = @candidate_id)
BEGIN
    -- Update the existing record
    UPDATE Tbl_Program_change_request
    SET 
        Course_level_id = @faculty,
        Department_id = @pgmid,
        batchid = @intake,
        create_date = GETDATE(),
        delete_status = 0,
        Application_status = ''Submitted''
    WHERE Candidate_Id = @candidate_id;
END
ELSE
BEGIN
    -- Insert a new record if it does not exist
    INSERT INTO Tbl_Program_change_request
    (Candidate_id, Course_level_id, Department_id, batchid, create_date, delete_status, Application_status)
    VALUES
    (@candidate_id, @faculty, @pgmid, @intake, GETDATE(), 0, ''Submitted'');
END

end
   ');
END;
