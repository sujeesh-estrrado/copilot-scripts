IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Disciplinary_Hearing]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Disciplinary_Hearing]      
(      
@flag bigint=0,      
@Student_Id bigint=0,      
@Exam_Master_Id bigint=0,      
@DateofHearing datetime=null,      
@DecisionTaken bigint=0,      
@Decision_Remarks varchar(max)='''',      
@Pardoned bigint=0,      
@Attendance_Id bigint=0,      
@Created_By bigint=0      
)      
AS      
BEGIN      
if(@flag=0)      
begin      
if not exists(select * from Tbl_Disciplinary_Hearing where Student_Id=@Student_Id and Exam_Master_Id=@Exam_Master_Id and Delete_Status=0)    
begin    
 INSERT INTO Tbl_Disciplinary_Hearing      
      (Student_Id,Exam_Master_Id,DateofHearing ,DecisionTaken,Decision_Remarks,Pardoned,Attendance_Id,Created_By,Created_date,Delete_Status)      
   VALUES      
      (@Student_Id ,@Exam_Master_Id , @DateofHearing ,@DecisionTaken , @Decision_Remarks,@Pardoned ,@Attendance_Id ,@Created_By ,getdate(),0)      
    
  select SCOPE_IDENTITY()    
  end    
  else    
  begin    
  update Tbl_Disciplinary_Hearing    
  set DecisionTaken=@DecisionTaken,DateofHearing=@DateofHearing,Decision_Remarks=@Decision_Remarks,Pardoned=@Pardoned,Attendance_Id=@Attendance_Id,    
  Updated_Date=getdate()    
  where Student_Id=@Student_Id and Exam_Master_Id=@Exam_Master_Id and Delete_Status=0    
   select Attendance_Id  from Tbl_Disciplinary_Hearing  where Student_Id=@Student_Id and Exam_Master_Id=@Exam_Master_Id and Delete_Status=0    
  end    
end      
    
if(@flag=1)      
begin      
 select DH.Hearing_Id,DH.DateofHearing,DH.DecisionTaken,DH.Decision_Remarks,DH.Pardoned,DH.Student_Id    
 from Tbl_Disciplinary_Hearing DH  where Attendance_Id=@Attendance_Id  and Delete_Status=0    
               
end     
END
   ')
END;
