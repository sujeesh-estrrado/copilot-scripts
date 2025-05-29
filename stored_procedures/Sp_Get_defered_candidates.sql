IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_defered_candidates]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[Sp_Get_defered_candidates]  
as  
begin  
select CPD.candidate_id,concat(CPD.candidate_fname,'' '',CPD.candidate_Lname) as student_name,D.department_name,CBD.Batch_Code,CPD.idmatrixno,Ds.date_of_return, 
convert(varchar(50),Ds.date_of_return,103)as dateofreturn,
SSS.user_id  
 from Tbl_Candidate_Personal_Det CPD inner join Tbl_Defer_Status Ds on Ds.candidate_id=CPD.candidate_id   
left join tbl_new_admission N on N.new_admission_id=CPD.new_admission_id  
left join tbl_course_batch_duration CBD on CBD.batch_id=N.batch_id  
left join Tbl_department D on D.department_id=N.department_id  
left join tbl_student_semester SS on SS.candidate_id=CPD.candidate_id  
left join tbl_student_user SSS on SSS.candidate_id=CPD.candidate_id  
where CPD.active=5   
  
end');
END;
