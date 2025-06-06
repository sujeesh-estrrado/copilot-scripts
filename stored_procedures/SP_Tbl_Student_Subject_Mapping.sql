IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Subject_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_Student_Subject_Mapping] --1, 152026  
(@flag bigint=0,@student_id bigint=0,@semesterid bigint=0)  
as  
declare @intakeid bigint=0,@periodid bigint =0;  
begin  
 if(@flag=1)  
  begin  
   set @intakeid=(select N.Batch_Id from Tbl_Candidate_Personal_Det P inner join tbl_New_Admission N On N.New_Admission_Id=P.New_Admission_Id  where Candidate_Id=@student_id and P.Candidate_DelStatus=0)  
  
  set @periodid =(select top 1 Duration_Period_Id from Tbl_Course_Duration_PeriodDetails where Batch_Id=@intakeid and Semester_Id=@semesterid)  
 --set @intakeid=( select Batch_Id from Tbl_Course_Duration_PeriodDetails WHERE Duration_Period_Id=@periodid)  
 select * into #ControlTable from Tbl_Semester_Subjects where Duration_Mapping_Id=@periodid and Semester_Subjects_Status=0;  
 while exists(select * from #ControlTable)  
    begin  
       declare @tableid bigint =(select top 1 semester_subject_id from #ControlTable);  
    insert into  Tbl_Student_Subject_Mapping(Subject_id,Subject_status,Student_id,create_date,delete_status) values  
    ((select Department_Subjects_Id from #ControlTable where Semester_Subject_Id=@tableid),2,@student_id,getdate(),0)   
    delete from #ControlTable where Semester_Subject_Id=@tableid  
  end  
  drop table #ControlTable  
end  
end  
    ')
END;
