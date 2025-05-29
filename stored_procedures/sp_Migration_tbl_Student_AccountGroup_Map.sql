IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migration_tbl_Student_AccountGroup_Map]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migration_tbl_Student_AccountGroup_Map](@studentid bigint,@groupid bigint,@groupname varchar(max),@courseid bigint,@ictype varchar(50))
as begin
insert into tbl_Student_AccountGroup_Map(StudentID,FeeGroupID,FeeGroupCode,ProgrmID,StudType,deleteStatus) values(@studentid,@groupid,@groupname,@courseid,@ictype,0);
end


');
END