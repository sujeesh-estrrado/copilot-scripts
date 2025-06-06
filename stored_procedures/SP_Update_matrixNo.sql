IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_matrixNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Update_matrixNo](
@flag bigint=0,
@candidate_id bigint,
@matrix varchar(50),
@batchid bigint=0)
as
begin
    if(@flag=0)
        
        if not exists (SELECT 1 FROM Tbl_Candidate_Personal_Det  WHERE Candidate_Id = @candidate_id AND IDMatrixNo IS NOT NULL) 
        begin
            update Tbl_Candidate_Personal_Det set IDMatrixNo=@matrix,ApplicationStatus=''Completed'',active=3 where Candidate_Id=@candidate_id;
            update Tbl_IntakeMaster set lastnumber=(lastnumber+1) where id=(select IntakeMasterID from Tbl_Course_Batch_Duration where Batch_Id=@batchid)
        end 
            else 
       begin
            update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'',active=3 where Candidate_Id=@candidate_id;
            update Tbl_IntakeMaster set lastnumber=(lastnumber+1) where id=(select IntakeMasterID from Tbl_Course_Batch_Duration where Batch_Id=@batchid)

        end

    if(@flag=1)
        begin
            update Tbl_Student_NewApplication set IDMatrixNo=@matrix,ApplicationStatus=''Completed'',active=3 where Candidate_Id=@candidate_id;
            update Tbl_IntakeMaster set lastnumber=(lastnumber+1) where id=(select IntakeMasterID from Tbl_Course_Batch_Duration where Batch_Id=@batchid)

        end
end
    ')
END;
