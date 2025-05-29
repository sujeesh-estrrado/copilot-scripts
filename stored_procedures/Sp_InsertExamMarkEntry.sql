IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertExamMarkEntry]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_InsertExamMarkEntry]    
(    
  @courseCode varchar(100),    
  @Intake_Code varchar(100),    
  @semnumber varchar(100),    
  @IC varchar(50),    
  @Name varchar(50),    
  @Marks decimal(18,2),    
  @ActualMark decimal(18,2),    
  @grade varchar(50),    
  @pass_Fail varchar(50),    
  @Marker varchar(50),    
  @cadidateId bigint,    
  @ExamCode varchar(100)    
)    
as     
begin    
 Declare @Id bigint    
 Declare @count bigint    
 set @count=(select Count(Exam_Mark_Entry_Child_Id) Exam_Mark_Entry_Child_Id  from Tbl_Exam_Mark_Entry_Child     
 where ExamCode=@ExamCode and Candidate_Id=@cadidateId and Marker=@Marker)     
  if (@count>0)    
   begin    
    set @Id=(select Exam_Mark_Entry_Child_Id Exam_Mark_Entry_Child_Id  from Tbl_Exam_Mark_Entry_Child     
    where ExamCode=@ExamCode and Candidate_Id=@cadidateId and Marker=@Marker)    
   end     
  else    
   begin    
    set @Id=0    
   end    
  if (@Id>0)    
   begin    
    update Tbl_Exam_Mark_Entry_Child     
    set Course_Code=@courseCode,    
    Intake_Number=@Intake_Code,    
    Sem_Number=@semnumber,    
    IC_Passport=@IC,    
    Name=@Name,    
    Marks=@Marks,    
    
    Actual_Marks=@ActualMark,    
    Grade=@grade,    
    Pass_Fail=@pass_Fail    
    where Exam_Mark_Entry_Child_Id=@Id    
   end    
  else    
   begin    
    insert into Tbl_Exam_Mark_Entry_Child    
    (    
     Course_Code,    
     Intake_Number,    
     Sem_Number,    
     IC_Passport,    
     Name,    
     Marks,    
     Actual_Marks,    
     Grade,    
     Pass_Fail,    
     Marker,    
     Candidate_Id,    
     ExamCode    
    )    
    values    
    (    
     @courseCode,    
     @Intake_Code,    
     @semnumber ,    
     @IC ,    
     @Name ,    
     @Marks ,    
     @ActualMark,    
     @grade,    
     @pass_Fail,    
     @Marker,    
     @cadidateId,    
     @ExamCode     
    )    
   end    
  end
  
  --select * from Tbl_Exam_Mark_Entry_Child
    ')
END;
