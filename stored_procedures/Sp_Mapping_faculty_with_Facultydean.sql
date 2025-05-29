IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Mapping_faculty_with_Facultydean]') 
    AND type = N'P'
)
BEGIN
    EXEC ('  
CREATE procedure [dbo].[Sp_Mapping_faculty_with_Facultydean] --7,5,1
(@employeeid bigint,@facultyid bigint,@flag bigint)
as
begin
if(@flag=1)
begin 
if not exists (select * from Tbl_Course_Level where Course_Level_Id=@facultyid and Faculty_dean_id=@employeeid)
begin
update Tbl_Course_Level set Faculty_dean_id=@employeeid where Course_Level_Id=@facultyid;
end 
end
if(@flag=2)
if exists (select * from Tbl_Course_Level where Course_Level_Id=@facultyid)
begin
update Tbl_Course_Level set Faculty_dean_id=null where Course_Level_Id=@facultyid and Faculty_dean_id=@employeeid;
end
if(@flag=3)
begin
select * from Tbl_Course_Level where Faculty_dean_id=@employeeid;
end
if(@flag=4)--get dean id from faculty id 
begin
select Faculty_dean_id from Tbl_Course_Level where Course_Level_Id=@facultyid
end
end
  ')
END;
