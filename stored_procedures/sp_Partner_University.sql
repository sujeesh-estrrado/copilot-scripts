IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Partner_University]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[sp_Partner_University](@flag bigint=0,@name Varchar(max)='''',@code varchar(max)='''',@id bigint=0)
as
begin

 if(@flag=1)--for insert 
  begin
   insert into Tbl_Partner_University(University_Name,University_Code,delete_status,Create_date) values
   (@name,@code,0,getdate())
  end
  if(@flag=2)--for update
   begin
    update Tbl_Partner_University set University_Name=@name ,University_Code=@code where Partner_UniversityId=@id
   end
 if(@flag=3) --for select by id 
 begin
  select * from Tbl_Partner_University  where Partner_UniversityId=@id and delete_status=0;
 end

  if(@flag=4)--for select all 
 begin
  select * from Tbl_Partner_University  where delete_status=0;
 end

 end
  if(@flag=5)--for delete
   begin
    update Tbl_Partner_University set delete_status=1 where Partner_UniversityId=@id
   end
    ')
END
