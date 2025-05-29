IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Noticeid_Empid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Noticeid_Empid]     

(@Noticeid bigint, @Userid bigint)
as
begin
insert into Noticeid_By_Emp(Notice_Ic,User_Id)
values(@Noticeid,@Userid)
end

');
END;
